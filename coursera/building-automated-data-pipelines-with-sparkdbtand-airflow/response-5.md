# Maintaining Data Lineage

GlobalRetail Corp should maintain data lineage by tracking the **origin, movement, and transformation history** of every dataset as it moves through the pipeline.

Key practices:

* **Capture source metadata**

  * Record where data came from (PostgreSQL tables, Kafka topics, REST API endpoints).
  * Store details such as source system, extraction time, and connector used.

* **Track transformations**

  * Document how data changes between layers:

    * Bronze → raw extracted data
    * Silver → cleaned and standardized data
    * Gold → business-ready datasets

* **Use metadata catalogs**

  * Maintain a searchable inventory of datasets, owners, schemas, and dependencies.

* **Add audit fields**

  * Include fields such as:

    * ingestion timestamp
    * source identifier
    * pipeline/job ID
    * transformation version

* **Monitor pipeline relationships**

  * Track which sources feed which downstream datasets, dashboards, and applications.

Example lineage:

```
PostgreSQL customer_data table
        |
        ↓
Bronze: raw/customer_data
        |
        ↓
Silver: standardized_customer
        |
        ↓
Gold: customer_360
        |
        ↓
Marketing personalization dashboard
```

### Why Data Lineage Is Important

* **Compliance:** Helps auditors understand where sensitive customer data originated and how it was processed (important for SOC 2 requirements).
* **Troubleshooting:** Makes it easier to identify the source of data quality issues or pipeline failures.
* **Data trust:** Allows users to understand how analytics results were created.
* **Impact analysis:** Shows which reports or applications are affected if a source schema changes.
* **Governance:** Supports ownership, access control, retention policies, and responsible data management.

In a multi-source environment, lineage is essential because PostgreSQL, Kafka, and REST API data may have different formats, update patterns, and owners. Clear lineage ensures the organization can reliably manage and trust its unified data platform.
