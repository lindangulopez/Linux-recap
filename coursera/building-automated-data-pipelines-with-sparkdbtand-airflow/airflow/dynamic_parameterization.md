# dynamic parameterization

For a payment system deployed across multiple geographical regions, I would use **dynamic parameterization** to separate **workflow logic** from **environment-specific configuration**. The goal is to have **one Airflow DAG** that can run globally while injecting regional differences at runtime.

The principle is:

> **The DAG defines what happens. Configuration defines where and how it runs.**

---

# 1. Separate Code From Configuration

A common mistake is creating separate DAGs:

```text
payment_us_dag.py
payment_eu_dag.py
payment_asia_dag.py
```

with hard-coded values:

```python
API_ENDPOINT = "https://us.payment.com"
DATABASE = "us_payment_db"
```

Problems:

* Duplicate code
* Difficult maintenance
* Regional fixes require multiple deployments
* Higher risk of inconsistent behavior

Instead:

```text
                  Payment DAG

                       |

          ----------------------------

          Workflow Logic (Same)

                       +

          Regional Configuration

          ----------------------------

          US Config
          EU Config
          Asia Config
```

---

# 2. Use Airflow Variables for Environment Configuration

Airflow Variables are useful for non-sensitive configuration.

Example:

## Production US

```json
{
  "region": "us-east",
  "payment_api": "https://us.api.payment.com",
  "batch_size": 10000
}
```

## Production Europe

```json
{
  "region": "eu-west",
  "payment_api": "https://eu.api.payment.com",
  "batch_size": 8000
}
```

The DAG remains unchanged.

---

# 3. Create a Region Configuration Map

Example:

```python
from airflow.models import Variable


REGION_CONFIG = {

    "us-east": {
        "api_endpoint": "https://us.payment.com",
        "database": "payments_us",
        "batch_size": 10000
    },

    "eu-west": {
        "api_endpoint": "https://eu.payment.com",
        "database": "payments_eu",
        "batch_size": 8000
    },

    "ap-south": {
        "api_endpoint": "https://asia.payment.com",
        "database": "payments_asia",
        "batch_size": 5000
    }
}


region = Variable.get(
    "deployment_region",
    default_var="us-east"
)


config = REGION_CONFIG[region]
```

Now the task uses:

```python
config["api_endpoint"]

config["database"]

config["batch_size"]
```

instead of hard-coded values.

---

# 4. Use Airflow Connections for Credentials

API endpoints and database names are configuration.

Credentials are secrets.

Do not store:

```python
password="myPassword123"
```

Instead:

```python
payment_connection = BaseHook.get_connection(
    "payment_api_connection"
)
```

Airflow Connections can point to:

* AWS Secrets Manager
* HashiCorp Vault
* Cloud secret managers
* Kubernetes secrets

Example:

```text
Connection ID:

payment_api_eu

Host:

https://eu.payment.com

Password:

stored securely
```

---

# 5. Use Runtime Parameters for Flexible Execution

Sometimes the region should be selected when triggering a DAG.

Example:

Trigger:

```json
{
    "region": "eu-west",
    "payment_date": "2026-07-12"
}
```

Access in Airflow:

```python
region = "{{ dag_run.conf['region'] }}"
```

Now the same DAG can process:

```text
US payments
EU payments
Asia payments
```

without code changes.

---

# 6. Example Parameterized Payment Task

```python
from airflow.models import Variable


def process_payments(**context):

    region = context["params"]["region"]

    config = REGION_CONFIG[region]

    api = config["api_endpoint"]

    database = config["database"]

    batch_size = config["batch_size"]


    print(
        f"""
        Processing payments

        Region:
        {region}

        API:
        {api}

        Database:
        {database}

        Batch:
        {batch_size}
        """
    )


payment_task = PythonOperator(

    task_id="process_payments",

    python_callable=process_payments,

    params={
        "region": "us-east"
    }
)
```

The workflow stays identical.

Only parameters change.

---

# 7. Handle Regional Differences Beyond Configuration

Some differences may require feature flags.

Example:

Europe requires additional compliance checks:

```json
{
    "region": "eu-west",
    "enable_gdpr_validation": true
}
```

Code:

```python
if config["enable_gdpr_validation"]:
    run_compliance_checks()
```

This avoids creating a separate workflow.

---

# 8. Recommended Enterprise Pattern

A mature payment platform usually uses three configuration layers:

```text
                Airflow DAG

                    |

          Runtime Parameters

                    |

          Environment Config

                    |

          Secret Management

                    |

       Regional Payment Infrastructure
```

---

# 9. Production Configuration Strategy

| Configuration Type   | Recommended Tool               |
| -------------------- | ------------------------------ |
| Region name          | Airflow Variable               |
| API endpoint         | Airflow Variable / Config file |
| Database connection  | Airflow Connection             |
| Password/token       | Secret Manager                 |
| Execution date       | Airflow macros                 |
| User-selected region | dag_run.conf                   |
| Feature flags        | Variables                      |

---

# 10. Additional Considerations for Payment Systems

Because this is a financial workflow, I would also consider:

### Data Residency

Example:

```text
EU transactions
      ↓
EU database only
```

The configuration should prevent accidental cross-region writes.

---

### Regional Failover

Example:

```text
Primary API:
EU Payment Gateway

Fallback API:
EU Backup Gateway
```

---

### Compliance Differences

Different regions may have:

* Tax rules
* Currency handling
* Data retention requirements
* Regulatory reporting

These should be configuration-driven.

---

# Senior-Level Interview Answer

> "I would design the payment workflow as a single parameterized DAG and externalize regional differences into configuration. Airflow Variables would manage environment-specific settings such as endpoints and batch sizes, Airflow Connections or a secret manager would handle credentials, and runtime parameters could allow operators to select regions dynamically. This keeps the workflow code consistent while allowing regional customization, improves maintainability, and reduces deployment risk."

---

## Key Principle

**Never duplicate workflows because configuration changes.**

A production-grade Airflow design should look like:

```text
One Workflow

        +

Many Configurations

        =

Global Payment Platform
```

This is the pattern used for scalable enterprise deployments.
