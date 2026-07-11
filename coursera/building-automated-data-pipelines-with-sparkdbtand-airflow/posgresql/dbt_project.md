# Create dbt Snapshots SCD2 Tracking Workflow

## Current Environment

Your setup:

✅ PostgreSQL 16 running
✅ PostgreSQL database: `ecommerce_dw`
✅ Source table: `staging_customer`
✅ Existing manual SCD2 table: `dim_customer_scd2`
✅ Python virtual environment: `dbt-env`
✅ dbt Core installed
✅ dbt-postgres adapter installed

Verify:

```bash
dbt --version
```

Expected:

```
Core:
  installed: 1.12.x

Plugins:
  postgres: 1.10.x
```

---

# Goal

Replace this manual process:

```
staging_customer

      |
      |
      ↓

Manual SQL

UPDATE old record
INSERT new record

      |
      ↓

dim_customer_scd2
```

with:

```
PostgreSQL

staging_customer

        |
        |
        ↓

      dbt snapshot

        |
        |
        ↓

customer_snapshot

        |
        |
        ↓

Automatic SCD2 history
```

---

# Step 1 — Activate Python Environment

Go to your project folder:

```bash
cd ~/Documents/myData/ecommerce_dbt_demo
```

Activate:

```bash
source dbt-env/bin/activate
```

You should see:

```
(dbt-env) linda@...
```

---

# Step 2 — Create dbt Project

Create the project:

```bash
dbt init ecommerce_dbt
```

Choose:

```
[1] postgres
```

Enter:

```
host: localhost
port: 5432
user: postgres
password: YOUR_PASSWORD
dbname: ecommerce_dw
schema: public
threads: 4
```

---

## If you already created the project

If you see:

```
A project called ecommerce_dbt already exists here.
```

Do not run `dbt init` again.

Continue:

```bash
cd ecommerce_dbt
```

Your structure:

```
ecommerce_dbt_demo/

├── ecommerce_dbt/
│
├── dbt-env/
```

Inside dbt project:

```
ecommerce_dbt/

├── models/
├── snapshots/
├── seeds/
├── tests/
└── dbt_project.yml
```

---

# Step 3 — Configure PostgreSQL Connection

Create/edit:

```bash
nano ~/.dbt/profiles.yml
```

Add:

```yaml
ecommerce_dbt:

  target: dev

  outputs:

    dev:

      type: postgres

      host: localhost

      user: postgres

      password: YOUR_POSTGRES_PASSWORD

      port: 5432

      database: ecommerce_dw

      schema: public

      threads: 4
```

Save:

```
CTRL + O
ENTER
CTRL + X
```

---

# Step 4 — Fix PostgreSQL Password (if required)

If dbt returns:

```
password authentication failed for user "postgres"
```

Reset the password.

Enter PostgreSQL:

```bash
sudo -i -u postgres
```

Then:

```bash
psql
```

Run:

```sql
ALTER USER postgres WITH PASSWORD 'postgres123';
```

Exit:

```sql
\q
```

Then:

```bash
exit
```

Update:

```
~/.dbt/profiles.yml
```

with:

```yaml
password: postgres123
```

---

# Step 5 — Test dbt Connection

Inside your dbt project:

```bash
cd ~/Documents/myData/ecommerce_dbt_demo/ecommerce_dbt
```

Run:

```bash
dbt debug
```

Expected:

```
Connection test: OK

All checks passed!
```

---

# Step 6 — Create dbt Snapshot

Create folder:

```bash
mkdir snapshots
```

Create snapshot:

```bash
nano snapshots/customer_snapshot.sql
```

Add:

```sql
{% snapshot customer_snapshot %}

{{
    config(

        target_schema='public',

        unique_key='customer_id',

        strategy='check',

        check_cols=[
            'customer_name',
            'email_address',
            'shipping_address',
            'customer_segment'
        ],

        invalidate_hard_deletes=True

    )
}}

SELECT

    customer_id,

    customer_name,

    email_address,

    shipping_address,

    customer_segment,

    load_date


FROM public.staging_customer


{% endsnapshot %}
```

Save.

---

# What dbt now manages automatically

Your old logic:

```sql
UPDATE dim_customer_scd2

SET valid_to=current_timestamp,
is_current=false

WHERE customer_id='CUST001';
```

and:

```sql
INSERT INTO dim_customer_scd2(...)
```

is replaced by dbt snapshot logic.

dbt automatically creates:

```
dbt_scd_id
dbt_updated_at
dbt_valid_from
dbt_valid_to
```

---

# Step 7 — Run Snapshot

Execute:

```bash
dbt snapshot
```

Expected:

```
START snapshot customer_snapshot

OK created snapshot
```

---

# Step 8 — Verify Snapshot Table

Connect:

```bash
sudo -u postgres psql -d ecommerce_dw
```

List tables:

```sql
\dt
```

You should see:

```
customer_snapshot
```

Query:

```sql
SELECT *

FROM customer_snapshot;
```

Example:

| customer_id | shipping_address | dbt_valid_from | dbt_valid_to |
| ----------- | ---------------- | -------------- | ------------ |
| CUST001     | Paris            | timestamp      | timestamp    |
| CUST001     | Berlin           | timestamp      | NULL         |

The NULL `dbt_valid_to` means:

```
Current version
```

---

# Step 9 — Test Historical Tracking

Change the staging table:

```sql
UPDATE staging_customer

SET shipping_address='London'

WHERE customer_id='CUST001';
```

Exit:

```sql
\q
```

Run:

```bash
dbt snapshot
```

dbt detects:

```
Berlin → London
```

Automatically:

Old:

```
Berlin

dbt_valid_to = timestamp
```

New:

```
London

dbt_valid_to = NULL
```

---

# Step 10 — Create Current Customer Model

Create:

```
models/customer_dimension.sql
```

Add:

```sql
SELECT

customer_id,

customer_name,

email_address,

shipping_address,

customer_segment,

dbt_valid_from,

dbt_valid_to


FROM public.customer_snapshot


WHERE dbt_valid_to IS NULL
```

This creates your current customer view.

---

# Step 11 — Add Data Quality Tests

Create:

```
models/schema.yml
```

Add:

```yaml
version: 2

models:

  - name: customer_dimension

    columns:

      - name: customer_id

        tests:

          - unique

          - not_null
```

Run:

```bash
dbt test
```

---

# Final Architecture

```
                 PostgreSQL
                     |
                     |
                     ↓

             staging_customer

                     |
                     |
                     ↓

              dbt snapshot

                     |
                     |
                     ↓

          customer_snapshot table

          ----------------------
          |                    |
          ↓                    ↓

   Historical records     Current record


   Paris                 London
   Berlin                Active
```

---

# Next Professional Extensions

Your learning path:

1. ✅ PostgreSQL manual SCD2
2. ✅ dbt Snapshot SCD2
3. Add `dim_product_snapshot`
4. Add `fact_sales`
5. Add dbt sources + documentation
6. Add dbt tests
7. Add Git version control
8. Add Airflow scheduling
9. Deploy to cloud warehouse (Snowflake / BigQuery / Databricks)

At this point your project becomes a realistic **analytics engineering portfolio project**.
