# Install and use dbt

The natural next step is to move from **procedural SCD2** (your SQL `UPDATE` + `INSERT` workflow) to **automated SCD2 with dbt snapshots**.

A good progression would be:

### 1. Install dbt locally (Linux)

Install dbt for PostgreSQL:

```bash
python3 -m pip install dbt-postgres
```

Check:

```bash
dbt --version
```

---

### 2. Create a dbt project

Move to your working directory:

```bash
cd ~/Documents/myData
```

Create project:

```bash
dbt init ecommerce_dw_dbt
```

You will get:

```
ecommerce_dw_dbt/
├── models/
├── snapshots/
├── tests/
├── dbt_project.yml
└── profiles.yml
```

---

### 3. Connect dbt to your PostgreSQL database

Create:

```bash
~/.dbt/profiles.yml
```

Example:

```yaml
ecommerce_dw_dbt:
  target: dev
  outputs:
    dev:
      type: postgres
      host: localhost
      user: postgres
      password: your_password
      port: 5432
      dbname: ecommerce_dw
      schema: public
```

Test:

```bash
dbt debug
```

You want:

```
Connection test: OK
```

---

### 4. Move your staging table into dbt

Create:

```
models/staging/stg_customer.sql
```

with:

```sql
SELECT
    customer_id,
    customer_name,
    email_address,
    shipping_address,
    customer_segment,
    load_date
FROM staging_customer
```

This replaces manual staging SQL.

---

### 5. Create your first dbt SCD2 snapshot

Create:

```
snapshots/customer_snapshot.sql
```

Add:

```sql
{% snapshot customer_snapshot %}

{{
config(
    target_schema='snapshots',
    unique_key='customer_id',
    strategy='check',
    check_cols=[
        'customer_name',
        'email_address',
        'shipping_address',
        'customer_segment'
    ]
)
}}

SELECT *
FROM {{ ref('stg_customer') }}

{% endsnapshot %}
```

This replaces your manual:

```sql
UPDATE dim_customer_scd2
SET valid_to=...
```

and:

```sql
INSERT INTO dim_customer_scd2
```

---

### 6. Run your first snapshot

From the dbt project folder:

```bash
dbt snapshot
```

dbt will automatically create:

```
snapshots.customer_snapshot
```

with fields like:

```
dbt_valid_from
dbt_valid_to
```

Example:

| customer_id | address | dbt_valid_from | dbt_valid_to |
| ----------- | ------- | -------------- | ------------ |
| CUST001     | Paris   | 2026-07-11     | 2026-07-12   |
| CUST001     | Berlin  | 2026-07-12     | null         |

This is your SCD2 history.

---

### 7. Test the automation

Change your staging data:

```sql
UPDATE staging_customer
SET shipping_address='Lisbon'
WHERE customer_id='CUST001';
```

Run:

```bash
dbt snapshot
```

Check:

```sql
SELECT *
FROM snapshots.customer_snapshot;
```

You should now have:

```
Paris     old version
Berlin    old version
Lisbon    current version
```

No manual updates.

---

### 8. Apply the same pattern to your ecological connectivity project

Your customer example becomes:

| Ecommerce         | Wildcat connectivity      |
| ----------------- | ------------------------- |
| customer_id       | habitat_patch_id          |
| address           | land-cover type           |
| customer_segment  | habitat suitability class |
| customer history  | landscape evolution       |
| customer snapshot | ecosystem snapshot        |

Example:

```
snapshots/habitat_patch_snapshot.sql
```

Tracks:

* forest → agriculture conversion
* restoration activities
* corridor status changes
* resistance score changes
* protected area changes

---

Your learning path is:

```
PostgreSQL manual SCD2
          ↓
dbt snapshots
          ↓
dbt models + tests
          ↓
data warehouse design
          ↓
ecological connectivity data platform
```


