# Data analysts as users

Data analysts should typically **query the Silver and Gold layers rather than directly querying Bronze**. The unified staging area should provide different levels of access depending on the user's needs and technical expertise.

### Query Approach by Layer

| Layer                     | Purpose                                                    | Who Uses It                                 | Query Approach                                                              |
| ------------------------- | ---------------------------------------------------------- | ------------------------------------------- | --------------------------------------------------------------------------- |
| **Bronze (Raw)**          | Stores original data from PostgreSQL, Kafka, and REST APIs | Data engineers, auditors                    | Used for troubleshooting, replaying data, and validating source information |
| **Silver (Cleaned)**      | Standardized schemas, cleaned data, quality rules applied  | Analysts, data scientists                   | Used for exploration, joining data sources, and detailed analysis           |
| **Gold (Business-ready)** | Aggregated datasets designed for reporting and analytics   | Business users, dashboards, marketing teams | Used for fast queries, KPIs, customer insights, and reporting               |

---

### Example Analyst Workflow

A marketing analyst wants to understand customer behavior:

1. **Kafka events** provide real-time browsing and interaction activity.
2. **PostgreSQL data** provides customer profiles and transaction history.
3. **REST API data** provides external information such as pricing.

The data pipeline creates a unified Gold dataset:

```
Kafka user_events
        |
        ↓
PostgreSQL customer_data
        |
        ↓
REST API pricing_data
        |
        ↓
Silver: standardized_customer_activity
        |
        ↓
Gold: customer_360
```

The analyst queries:

```sql
SELECT
    customer_id,
    purchase_history,
    recent_events,
    product_preferences
FROM gold.customer_360
WHERE customer_segment = 'high_value';
```

---

### Handling Different Data Origins

To simplify analysis:

* Apply consistent naming conventions across sources.
* Standardize schemas in the Silver layer.
* Maintain metadata showing the original source.
* Create business-friendly views in the Gold layer.

Example:

| Source     | Raw Field | Standardized Field |
| ---------- | --------- | ------------------ |
| PostgreSQL | cust_id   | customer_id        |
| Kafka      | userId    | customer_id        |
| REST API   | client_id | customer_id        |

---

### Recommended Access Model

* **Data engineers:** Full access to Bronze and Silver.
* **Data analysts:** Primarily Silver and Gold access.
* **Business users:** Gold datasets only.
* **Auditors:** Controlled access with lineage and metadata visibility.

This approach allows analysts to work with a consistent view of customer data without needing to understand the complexity of each individual source system.
