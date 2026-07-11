# Completed the hardest conceptual part: **dbt snapshots implementing SCD2**.

Your current state:

```
PostgreSQL

staging_customer
       |
       |
       v

dbt snapshot

customer_snapshot
       |
       |
       v

SCD2 history
```

## [The lesson](https://www.coursera.org/learn/building-automated-data-pipelines-with-sparkdbtand-airflow/lecture/fZs8k/building-complete-dbt-scd2-model-with-validity-periods) wants you to evolve it into a more production-style dbt architecture:

```
PostgreSQL

staging_customer
       |
       |
       v

models/staging/stg_customers.sql
(clean + record_hash)

       |
       |
       v

snapshots/customer_snapshot.sql
(SCD2 tracking)

       |
       |
       +----------------+
       |                |
       v                v

dim_customer_current   customer_snapshot
(current records)      (history)

       |
       |
       v

dbt tests
```

You are ready for these five tasks:

---

## 1. Create `stg_customers.sql`

You are currently in:

```
~/Documents/myData/ecommerce_dbt_demo/ecommerce_dbt
```

Create the staging folder:

```bash
mkdir -p models/staging
```

Create the model:

```bash
nano models/staging/stg_customers.sql
```

Put this:

```sql
select

    customer_id,
    customer_name,
    email_address,
    shipping_address,
    customer_segment,
    load_date,

    md5(
        concat(
            customer_name,
            email_address,
            shipping_address,
            customer_segment
        )
    ) as record_hash

from public.staging_customer
```

Save.

---

## 2. Run the staging model

Now run:

```bash
dbt run --select stg_customers
```

You should see something like:

```
Completed successfully

PASS=1
```

Check the table:

```bash
psql -h localhost -U postgres -d ecommerce_dw
```

Inside PostgreSQL:

```sql
select *
from public.stg_customers;
```

Expected:

```
customer_id | customer_name | shipping_address | record_hash
------------+---------------+------------------+------------------
CUST001     | John Smith    | London           | xxxx1234
```

Exit:

```sql
\q
```

---

## 3. Change your snapshot to use `ref()`

Your current snapshot probably contains:

```sql
from public.staging_customer
```

Change it.

Open:

```bash
nano snapshots/customer_snapshot.sql
```

Replace the source part:

```sql
from public.staging_customer
```

with:

```sql
from {{ ref('stg_customers') }}
```

Your snapshot should become:

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

select *

from {{ ref('stg_customers') }}

{% endsnapshot %}
```

The advantage:

Before:

```
snapshot
   |
   |
staging_customer
```

After:

```
snapshot
   |
   |
stg_customers
   |
   |
staging_customer
```

Now dbt understands lineage.

---

## 4. Create `dim_customer_current`

The snapshot contains all history:

Example:

| customer | address | valid_to |
| -------- | ------- | -------- |
| CUST001  | Berlin  | 17:46    |
| CUST001  | London  | NULL     |

For analytics, you usually only want:

| customer | address |
| -------- | ------- |
| CUST001  | London  |

Create:

```bash
nano models/dim_customer_current.sql
```

Add:

```sql
select

    customer_id,
    customer_name,
    email_address,
    shipping_address,
    customer_segment

from {{ ref('customer_snapshot') }}

where dbt_valid_to is null
```

Run:

```bash
dbt run --select dim_customer_current
```

---

## 5. Add dbt tests

Create:

```bash
nano models/schema.yml
```

Add:

```yaml
version: 2

models:

  - name: dim_customer_current

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

Expected:

```
PASS unique_customer_id
PASS not_null_customer_id
```

---

## 6. Reproduce the lesson's change test

You already did:

```
Berlin
   |
   v
London
```

Now do another change.

Open PostgreSQL:

```bash
psql -h localhost -U postgres -d ecommerce_dw
```

Run:

```sql
UPDATE staging_customer
SET shipping_address='456 Oak Street'
WHERE customer_id='CUST001';
```

Exit:

```sql
\q
```

Run:

```bash
dbt run --select stg_customers
dbt snapshot
```

Then check:

```bash
psql -h localhost -U postgres -d ecommerce_dw
```

Query:

```sql
SELECT
    customer_id,
    shipping_address,
    dbt_valid_from,
    dbt_valid_to
FROM customer_snapshot
WHERE customer_id='CUST001'
ORDER BY dbt_valid_from;
```

You should see:

```
CUST001 | Berlin          | timestamp | timestamp
CUST001 | London          | timestamp | timestamp
CUST001 | 456 Oak Street  | timestamp | NULL
```

That is a complete SCD2 implementation.

---

## After this, your project will contain the core dbt patterns used professionally:

```
models/
 ├── staging/
 │     └── stg_customers.sql
 │
 └── dim_customer_current.sql

snapshots/
 └── customer_snapshot.sql

models/schema.yml
```

Then the next logical steps are:

1. Add `dim_product` snapshot
2. Build `fact_orders`
3. Add sources (`sources.yml`) instead of hardcoding `public.staging_customer`
4. Add documentation (`dbt docs generate`)
5. Add Git version control
6. Only then add Airflow scheduling

Your SCD2 implementation is working correctly. The next work is making it look like a real analytics engineering project.
