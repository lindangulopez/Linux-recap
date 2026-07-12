# multi-tier SLA monitoring

For a payment system, I would design **multi-tier SLA monitoring** around business impact, not just technical task duration. The goal is to detect degradation early, escalate critical issues quickly, and avoid unnecessary alerts for lower-impact problems.

A good approach is to define **multiple SLA tiers**, connect them to **severity-based alerting**, and integrate them with incident response workflows.

---

# 1. Classify Payment Workflows by Business Criticality

First, identify which workflows directly impact revenue, customers, or compliance.

Example:

| Workflow                        | Business Impact                   | SLA Tier |
| ------------------------------- | --------------------------------- | -------- |
| Real-time payment authorization | Customer checkout blocked         | Critical |
| Payment settlement processing   | Financial reconciliation affected | Critical |
| Fraud detection pipeline        | Risk exposure increases           | High     |
| Daily payment reporting         | Internal visibility affected      | Medium   |
| Historical analytics            | Low operational impact            | Low      |

---

# 2. Define Multi-Tier SLA Thresholds

Instead of one SLA, create warning and critical thresholds.

Example:

## Tier 1: Critical Payment Processing

Scenario:

> Payment authorization pipeline normally completes within 15 minutes.

SLA:

```text
Warning:
20 minutes

Critical:
30 minutes
```

Response:

```
20 min breach
      ↓
Notify payment engineering team

30 min breach
      ↓
Page on-call engineer
      ↓
Start incident response
```

---

## Tier 2: Settlement Processing

Scenario:

> Settlement must complete before banking deadlines.

SLA:

```text
Warning:
2 hours

Critical:
4 hours
```

Response:

* Warning → Slack/email notification
* Critical → PagerDuty + escalation

---

## Tier 3: Reporting Pipelines

Scenario:

> Business reports can tolerate delays.

SLA:

```text
Warning:
8 hours

Critical:
24 hours
```

Response:

* Create ticket
* Track trend
* No immediate paging

---

# 3. Implement SLA Monitoring in Airflow

Example:

```python
payment_task = PythonOperator(
    task_id="process_payment_transactions",
    python_callable=process_payments,
    sla=timedelta(minutes=30),
    on_failure_callback=payment_failure_alert
)
```

The SLA should represent the **business deadline**, not just average runtime.

---

# 4. Add SLA Miss Callbacks

When an SLA is missed:

```python
def sla_callback(
    dag,
    task_list,
    blocking_task_list,
    slas,
    blocking_tis
):

    for task in task_list:

        send_alert(
            severity="CRITICAL",
            message=f"""
            Payment SLA breach

            Task:
            {task.task_id}

            DAG:
            {dag.dag_id}
            """
        )
```

---

# 5. Connect SLA Severity to Incident Response

A mature payment platform should route alerts differently.

## Critical

Examples:

* Payment authorization unavailable
* Transaction processing delayed
* Settlement failure

Actions:

```
PagerDuty
    +
Incident Slack Channel
    +
On-call Engineer
    +
Incident Ticket
```

---

## Warning

Examples:

* Processing slowing down
* Increased API latency

Actions:

```
Engineering Slack Channel
        +
Monitoring Dashboard
```

---

## Informational

Examples:

* Slight performance degradation
* Historical trends

Actions:

```
Metrics Dashboard
        +
Weekly Review
```

---

# 6. Monitor More Than Task Completion Time

For payment systems, SLA monitoring should include business metrics.

## Technical Metrics

Monitor:

* DAG duration
* Task failures
* Retry counts
* Worker availability
* API latency

---

## Payment Metrics

Monitor:

* Successful transaction rate
* Failed payment percentage
* Authorization latency
* Settlement completion rate
* Duplicate transaction detection

Example:

A pipeline may finish on time but still have:

```
100,000 transactions processed

20% failed payments
```

The SLA is technically met, but the business is impacted.

---

# 7. Combine SLA Monitoring With Retry Strategy

Retries and SLAs must work together.

Example:

Payment API timeout:

```
Attempt 1
 |
Retry with exponential backoff
 |
Attempt 2
 |
Retry
 |
Attempt 3
 |
Still failing
 |
SLA approaching
 |
Escalate
```

Avoid:

```
Retry forever

↓

SLA breach discovered too late
```

---

# 8. Design an Escalation Policy

Example:

```
Payment Task Failure

        |
        ↓

Retry Automatically

        |
        ↓

Warning SLA Breach

        |
        ↓

Notify Team

        |
        ↓

Critical SLA Breach

        |
        ↓

Page On-call

        |
        ↓

Incident Management
```

---

# 9. Include Business Context in Alerts

A useful alert should contain:

```
ALERT: Payment Processing SLA Breach

Workflow:
payment_processing_daily

Impact:
Customer transactions delayed

Started:
10:15 UTC

Current Status:
Retry attempt 3/5

Failed Component:
Payment Gateway API

Owner:
Payments Engineering
```

Avoid alerts like:

```
Task failed.
```

They require investigation before action.

---

# Recommended Payment System SLA Design

| Component             | Warning SLA | Critical SLA | Action           |
| --------------------- | ----------: | -----------: | ---------------- |
| Payment authorization |      15 min |       30 min | Page immediately |
| Settlement pipeline   |       2 hrs |        4 hrs | Escalate         |
| Fraud detection       |      30 min |         1 hr | High priority    |
| Reporting             |       8 hrs |       24 hrs | Ticket           |

---

## Senior-Level Interview Answer

> "For a payment system, I would implement multi-tier SLA monitoring based on business criticality. Critical payment workflows would have aggressive SLAs with immediate paging, while reporting workflows would use longer thresholds and lower-severity notifications. I would combine Airflow SLA monitoring with business metrics such as transaction success rate and payment latency, because a pipeline can complete successfully while the payment system is still failing. Alerts would be routed by severity with clear ownership, escalation paths, and incident response procedures."

This demonstrates the key production concepts: **SLA design, observability, business impact analysis, and operational readiness.**
