# Enterprise Airflow Production Patterns — Evaluation & Selection Cheat Sheet

## Objective

When designing enterprise workflows, the goal is not simply to add retries, SLAs, or parameters. The goal is to **select the right production pattern based on failure behavior, business impact, and operational requirements**.

The three major decisions:

1. **How should failures recover?** → Retry strategy
2. **How quickly must problems be detected?** → SLA configuration
3. **How should workflows adapt across environments?** → Parameterization approach

---

# 1. Retry Strategy Selection

## Decision Framework

Before choosing retries, classify the failure.

| Failure Type                  | Example                    | Recommended Strategy        |
| ----------------------------- | -------------------------- | --------------------------- |
| Temporary failure             | API timeout, network issue | Retry + exponential backoff |
| Rate limiting                 | HTTP 429 response          | Retry with increasing delay |
| Database unavailable          | Connection failure         | Retry with backoff          |
| Data quality failure          | Invalid records            | No retry, alert immediately |
| Code bug                      | SQL syntax error           | No retry                    |
| Expensive computation failure | ML training crash          | Limited retries             |

---

# Retry Pattern #1: Simple Retry

## Use When

* Failures are rare
* Recovery is fast
* External dependency usually recovers quickly

Example:

```python
task = PythonOperator(
    task_id="extract_api_data",
    retries=3,
    retry_delay=timedelta(minutes=5)
)
```

Good for:

* Small API calls
* Lightweight jobs

---

# Retry Pattern #2: Exponential Backoff

## Use When

A dependency may need time to recover.

Example:

```text
Failure 1:
Wait 1 minute

Failure 2:
Wait 2 minutes

Failure 3:
Wait 4 minutes

Failure 4:
Wait 8 minutes
```

Airflow:

```python
default_args = {
    "retries": 5,
    "retry_delay": timedelta(minutes=2),
    "retry_exponential_backoff": True,
    "max_retry_delay": timedelta(hours=1)
}
```

Best for:

✅ APIs
✅ Cloud services
✅ Databases
✅ Distributed systems

---

# Retry Pattern #3: Exponential Backoff + Jitter

## Use When

Many tasks may fail simultaneously.

Problem:

```text
100 failed tasks

        ↓

100 retries at exactly 10:00

        ↓

Service overload
```

Solution:

Add random delay:

```text
Task A retries at 10:02:15

Task B retries at 10:02:43

Task C retries at 10:03:01
```

Best for:

* Large enterprise platforms
* Shared APIs
* Multi-team Airflow environments

---

# Retry Pattern #4: Task-Specific Retries

## Production Recommendation

Do not use one retry policy for every task.

Example:

## Critical Extraction

```python
retries=10
retry_delay=2 minutes
```

Reason:

Missing data blocks downstream systems.

---

## ML Training

```python
retries=1
retry_delay=1 hour
```

Reason:

GPU workloads are expensive.

---

## Payment Processing

```python
retries=0 or 1
```

Reason:

Avoid duplicate transactions.

---

# Retry Decision Matrix

| Task                  | Retry Count | Delay           |
| --------------------- | ----------- | --------------- |
| API ingestion         | High        | Minutes         |
| Warehouse load        | Medium      | Minutes         |
| Financial transaction | Low         | Conservative    |
| ML training           | Low         | Long            |
| Validation checks     | None        | Immediate alert |

---

# 2. SLA Configuration Selection

## What is an SLA?

A Service Level Agreement defines:

> "How long can this workflow/task take before the business considers it a problem?"

---

# SLA Design Principles

Do not choose SLAs based only on technical duration.

Consider:

* Business deadlines
* Customer impact
* Regulatory requirements
* Reporting schedules

---

# SLA Levels

## Tier 1 — Critical Workflows

Examples:

* Payments
* Regulatory reports
* Customer-facing systems

SLA:

```text
Completion required:
Within 1-2 hours
```

Alert:

```text
Immediate escalation
```

---

## Tier 2 — Important Business Workflows

Examples:

* Daily analytics
* Marketing reports
* Internal dashboards

SLA:

```text
Completion required:
Within 4-8 hours
```

Alert:

```text
Team notification
```

---

## Tier 3 — Non-Critical Workflows

Examples:

* Historical reports
* Experimental pipelines

SLA:

```text
24+ hours
```

Alert:

```text
Log only
```

---

# SLA Example

```python
PythonOperator(
    task_id="generate_financial_report",
    python_callable=create_report,
    sla=timedelta(hours=2)
)
```

---

# SLA Escalation Pattern

```text
SLA Warning

      ↓

Team Notification

      ↓

SLA Breach

      ↓

On-call Engineer

      ↓

Incident Management
```

---

# SLA Selection Matrix

| Workflow           | SLA      | Severity |
| ------------------ | -------- | -------- |
| Payment pipeline   | 1 hour   | Critical |
| Customer analytics | 4 hours  | High     |
| Internal dashboard | 12 hours | Medium   |
| Archive processing | 24 hours | Low      |

---

# 3. Parameterization Strategy Selection

## Goal

Create workflows that run in:

```text
Development

      ↓

Testing

      ↓

Production
```

without changing DAG code.

---

# Pattern #1: Airflow Variables

## Use For

Environment-specific configuration.

Examples:

* Batch size
* Feature flags
* Runtime options

Example:

```python
environment = Variable.get(
    "deployment_environment"
)
```

---

# Pattern #2: Airflow Connections

## Use For

External systems.

Examples:

* Databases
* APIs
* Cloud services

Avoid:

```python
password="production123"
```

Use:

```python
connection_id="prod_database"
```

---

# Pattern #3: Environment Configuration Files

Example:

Development:

```yaml
batch_size: 1000
monitoring: false
```

Production:

```yaml
batch_size: 100000
monitoring: true
```

---

# Pattern #4: Runtime Parameters

Use when users provide values during execution.

Example:

Run pipeline for:

```text
customer_id=12345

date=2026-07-01
```

Airflow:

```python
{{ dag_run.conf }}
```

---

# Parameterization Decision Matrix

| Requirement          | Best Approach       |
| -------------------- | ------------------- |
| Database credentials | Airflow Connections |
| Environment settings | Variables           |
| Secrets              | Secret Manager      |
| User inputs          | dag_run.conf        |
| Dates                | Airflow macros      |
| Feature toggles      | Variables           |

---

# Production Pattern Selection Examples

---

# Scenario 1

## API ingestion pipeline fails randomly

Symptoms:

* Network timeouts
* HTTP errors
* Temporary outages

Recommended:

```text
Retry:
Exponential backoff + jitter

SLA:
Medium priority

Parameters:
API endpoint via Connection
```

---

# Scenario 2

## Financial reporting pipeline

Requirements:

* Must complete before business opens
* Failure impacts compliance

Recommended:

```text
Retry:
Limited retries

SLA:
Critical (<2 hours)

Parameters:
Environment-based configs
+
Secure connections
```

---

# Scenario 3

## Machine learning training workflow

Requirements:

* GPU intensive
* Expensive execution

Recommended:

```text
Retry:
1 retry maximum

SLA:
Longer threshold

Parameters:
Model version
+
Training configuration
```

---

# Enterprise Decision Framework

When designing a production DAG, ask:

## 1. Failure Question

"What type of failure can happen?"

Choose:

* Retry
* Backoff
* No retry
* Alert

---

## 2. Business Question

"What happens if this is late?"

Choose:

* SLA duration
* Escalation level

---

## 3. Deployment Question

"What changes between environments?"

Choose:

* Variables
* Connections
* Secrets
* Runtime parameters

---

# Final Architecture Pattern

```text
                 Airflow DAG

                     |

       ---------------------------------

       Retry Strategy

       SLA Monitoring

       Parameter Management

       ---------------------------------

                     |

              Enterprise Systems

                     |

       Data Warehouse / APIs / ML / Apps
```

## Senior Engineer Rule of Thumb

**Retries protect systems from temporary failures.
SLAs protect businesses from delays.
Parameters protect workflows from environment changes.**

A production-grade Airflow design uses all three together.
