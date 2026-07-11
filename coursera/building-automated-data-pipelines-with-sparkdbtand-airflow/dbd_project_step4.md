# [4 additional production practices](https://www.coursera.org/learn/building-automated-data-pipelines-with-sparkdbtand-airflow/lecture/fZs8k/building-complete-dbt-scd2-model-with-validity-periods)

You are actually **exactly at the point where this lesson wants you to be**. You already implemented the core part of the lesson:

✅ PostgreSQL source table (`staging_customer`)
✅ dbt project
✅ dbt snapshot
✅ SCD2 historical tracking
✅ Change detection
✅ Validity periods (`dbt_valid_from`, `dbt_valid_to`)

The lesson you pasted has **4 additional production practices** that you should implement next.

Your current project:

```
staging_customer
        |
        |
        v
customer_snapshot
        |
        |
        v
historical SCD2 records
```

will become:

```
                 PostgreSQL

              raw customer data
                    |
                    |
                    v

          stg_customers.sql
          (clean + hash)

                    |
                    |
                    v

          customer_snapshot
          (SCD2 history)

             /             \
            /               \

 dim_customer_current     customer_history
(current customers)       (all versions)

            |
            |
            v

       dbt tests
```

---

# Next Step 1 — Create a staging model

The lesson starts with:

> "create our staging model that prepares customer data for SED2 tracking"

You currently snapshot directly from:

```sql
public.staging_customer
```

Instead, create:

```
models/staging/stg_customers.sql
```

Your structure:

```
ecommerce_dbt/

models/
 └── staging/
      └── stg_customers.sql

snapshots/
 └── customer_snapshot.sql
```

Create the file:

```bash
mkdir -p models/staging

nano models/staging/stg_customers.sql
```

Add:

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

This creates a hash:

Example:

Before:

```
John Smith
Paris
Premium
```

hash:

```
6b9f9584afb311e2ecd5a448dea45f19
```

After:

```
John Smith
London
Premium
```

hash changes:

```
341724ac6dab7b63539c892926551f83
```

dbt can detect the change efficiently.

---

# Step 2 — Update your snapshot

Your current snapshot:

```
snapshots/customer_snapshot.sql
```

probably has:

```sql
FROM public.staging_customer
```

Change it to:

```sql
FROM {{ ref('stg_customers') }}
```

Example:

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
     ]
 )
}}

select *

from {{ ref('stg_customers') }}

{% endsnapshot %}
```

Now dbt knows the dependency:

```
stg_customers
       |
       v
customer_snapshot
```

---

# Step 3 — Run the staging model

Run:

```bash
dbt run --select stg_customers
```

Expected:

```
OK created model stg_customers
```

Check:

```bash
psql -h localhost -U postgres -d ecommerce_dw
```

Then:

```sql
select *
from public.stg_customers;
```

You should see:

```
customer_id
customer_name
shipping_address
record_hash
```

---

# Step 4 — Run snapshot again

Exit psql:

```sql
\q
```

Activate environment if needed:

```bash
source ../dbt-env/bin/activate
```

Run:

```bash
dbt snapshot
```

---

# Step 5 — Create current customer view

The lesson says:

> "build current record views for analytic consumption"

Your analysts normally do NOT query:

```
customer_snapshot
```

because it contains history.

Create:

```
models/dim_customer_current.sql
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

This gives:

| customer | address |
| -------- | ------- |
| CUST001  | London  |

Only active customers.

Run:

```bash
dbt run --select dim_customer_current
```

---

# Step 6 — Add dbt tests

The lesson mentions:

> "schema.yaml file test"

Create:

```
models/schema.yml
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

Now run:

```bash
dbt test
```

Expected:

```
PASS unique_customer_id
PASS not_null_customer_id
```

---

# Step 7 — Simulate a real customer change

This is the exercise from the lesson.

Open PostgreSQL:

```bash
psql -h localhost -U postgres -d ecommerce_dw
```

Change:

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

Now query:

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

You should get:

```
CUST001 | Berlin          | 17:42 | 17:46
CUST001 | London          | 17:46 | 18:00
CUST001 | 456 Oak Street  | 18:00 | NULL
```

That is a complete SCD2 lifecycle.

---

# After finishing this lesson, your next learning sequence should be:

## Lesson 2 — Multiple dimensions

Add:

```
dim_product
dim_customer
dim_store
```

Practice:

```
staging tables
      |
      |
      v
snapshots
      |
      |
      v
dimensions
```

---

## Lesson 3 — Build a fact table

Create:

```
fact_orders
```

with:

```
order_id
customer_sk
product_sk
quantity
sales_amount
order_date
```

Learn:

* surrogate keys
* joins
* star schema

---

## Lesson 4 — dbt production features

Add:

```
dbt docs generate
dbt docs serve
```

Learn:

* lineage graphs
* documentation
* metadata

---

## Lesson 5 — [Orchestration](https://www.coursera.org/learn/building-automated-data-pipelines-with-sparkdbtand-airflow/lecture/fZs8k/building-complete-dbt-scd2-model-with-validity-periods)

Connect:

```
Airflow
   |
   |
   v
dbt run
dbt snapshot
dbt test
```

