# Update Folder & add files

```
data-management/
├── .github/
│   └── workflows/
│       ├── ci.yml
│       ├── conda.yml
│       └── slsa.yml
├── notebooks/
├── src/
└── ... (everything else)
```

The only thing to add to your notebooks is the small guard in notebook 04 (the Omniscape one) so the CI runner knows to skip Julia — it can't install Julia in ~5 minutes. Everything else should work without changes to your existing code.

Once you push, the **Actions** tab on GitHub becomes your dashboard — green ticks mean your code is healthy, red crosses tell you exactly which cell or function broke. Want me to walk through what to do if the first run fails?

## For CI to work
The CI workflow skips the Julia/Omniscape step automatically. For that to work, open notebook 04 and add this at the top of the Julia cell:
```
import os
if os.getenv("SKIP_OMNISCAPE"):
    print("Skipping Omniscape in CI")
else:
    # your existing Julia code here
```

Commit and push to GitHub

Push the .github/ folder and the updated notebook. GitHub will detect the workflow files automatically.
git add .github/
git add notebooks/04_omniscape.ipynb
git commit -m "Add GitHub Actions workflows"
git push

## Check it worked

Go to your repo on GitHub and click the Actions tab. You should see a workflow running (orange spinner = in progress, green tick = passed, red cross = something to fix).
The first run takes ~5–8 minutes because it installs GDAL and the full GIS stack from scratch. Subsequent runs are faster.

The SLSA workflow (security provenance) only runs when you create a GitHub Release — not on every push. You can ignore it for now and set it up later when you're ready to share processed outputs publicly.
