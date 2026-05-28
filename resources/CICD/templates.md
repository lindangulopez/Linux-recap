# Reusable CI Templates

Create reusable templates for common ArgoCD operations:

```ymal
# templates/argocd.yml
.argocd-base:
  image: alpine:3.19
  before_script:
    - apk add --no-cache curl jq
    - curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
    - chmod +x /usr/local/bin/argocd
    - argocd login $ARGOCD_SERVER --auth-token $ARGOCD_TOKEN --grpc-web

.argocd-sync:
  extends: .argocd-base
  script:
    - argocd app sync $APP_NAME --grpc-web
    - argocd app wait $APP_NAME --sync --health --timeout $SYNC_TIMEOUT --grpc-web
  variables:
    SYNC_TIMEOUT: "300"

.argocd-verify:
  extends: .argocd-base
  script:
    - |
      STATUS=$(argocd app get $APP_NAME -o json --grpc-web)
      HEALTH=$(echo $STATUS | jq -r '.status.health.status')
      if [ "$HEALTH" != "Healthy" ]; then
        echo "Application $APP_NAME is not healthy: $HEALTH"
        exit 1
      fi
```

```ymal
include:
  - local: templates/argocd.yml

sync-staging:
  extends: .argocd-sync
  variables:
    APP_NAME: my-app-staging
  stage: deploy-staging

verify-staging:
  extends: .argocd-verify
  variables:
    APP_NAME: my-app-staging
  stage: verify-staging
```


## Troubleshooting
Pipeline hangs on argocd app wait: The sync might be stuck. Add a timeout and check ArgoCD logs for errors.

Authentication failures: Verify the token is not expired and the account is enabled in argocd-cm.

Manifest update not detected: If ArgoCD does not pick up changes, configure a webhook or reduce the polling interval. The default polling interval is 3 minutes.

GRPC errors: If ArgoCD is behind an ingress that does not support gRPC, use --grpc-web flag on all CLI commands.


## Conclusion
GitLab CI and ArgoCD complement each other perfectly in a GitOps workflow. 
The image tag update pattern is the cleanest approach, keeping CI and CD fully decoupled. 
For teams that need tighter integration, the ArgoCD CLI can be used directly in pipelines for sync triggering and verification. 
For other CI system integrations, see our guides on [GitHub Actions integration](https://oneuptime.com/blog/post/2026-02-26-argocd-github-actions-integration/view) and [Jenkins pipeline integration](https://oneuptime.com/blog/post/2026-02-26-argocd-jenkins-pipeline-integration/view).
