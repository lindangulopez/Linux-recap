# Create dbt Snapshots logic
Yes, your setup looks good. You already have:

✅ PostgreSQL 16 running
✅ `ecommerce_dw` database
✅ `staging_customer` source table
✅ `dim_customer_scd2` manually implemented SCD2 table
✅ Python virtual environment
✅ dbt Core + dbt-postgres installed

Now the next step is to **replace your manual SCD2 logic with dbt Snapshots**.

Your current flow:

```
staging_customer
        |
        | (manual UPDATE + INSERT)
        ↓
dim_customer_scd2
```

will become:

```
PostgreSQL staging_customer
        |
        |
        ↓
      dbt snapshot
        |
        |
        ↓
snapshots.customer_snapshot
        |
        |
        ↓
Automatic SCD2 history
```

---

## Step 1 — Create your dbt project

You are already here:

```bash
~/Documents/myData/ecommerce_dbt_demo
```

Inside your activated environment:

```bash
dbt init ecommerce_dbt
```

Choose:

```
postgres
```

Your structure should become:

```
ecommerce_dbt_demo/

├── ecommerce_dbt/
│
├── snapshots/
├── models/
├── seeds/
├── dbt_project.yml
│
└── dbt-env/
```

Enter:

```bash
cd ecommerce_dbt
```

---

# Step 2 — Configure PostgreSQL connection

Create:

```
~/.dbt/profiles.yml
```

Edit:

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

# Step 3 — Test dbt connection

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

# Step 4 — Create your first dbt snapshot

Create folder:

```bash
mkdir snapshots
```

Create file:

```bash
nano snapshots/customer_snapshot.sql
```

Paste:

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

# What this replaces

Your manual code:

```sql
UPDATE dim_customer_scd2
SET valid_to=current_timestamp,
is_current=false;
```

and:

```sql
INSERT INTO dim_customer_scd2(...)
```

are now handled automatically by dbt.

---

# Step 5 — Run the snapshot

Execute:

```bash
dbt snapshot
```

You should see:

```
1 of 1 START snapshot customer_snapshot
1 of 1 OK created snapshot
```

---

# Step 6 — Check the generated table

Connect:

```bash
sudo -u postgres psql -d ecommerce_dw
```

Run:

```sql
\dt
```

You should see:

```
public.customer_snapshot
```

Query:

```sql
SELECT *
FROM customer_snapshot;
```

dbt automatically creates:

```
dbt_scd_id
dbt_updated_at
dbt_valid_from
dbt_valid_to
```

Example:

| customer_id | address | dbt_valid_from | dbt_valid_to     |
| ----------- | ------- | -------------- | ---------------- |
| CUST001     | Paris   | 2026-07-11     | 2026-07-11 15:00 |
| CUST001     | Berlin  | 2026-07-11     | null             |

---

# Step 7 — Test a change

Your current data:

```
CUST001
John Smith
Berlin
Premium
```

Change staging:

```sql
UPDATE staging_customer
SET shipping_address='London'
WHERE customer_id='CUST001';
```

Exit:

```sql
\q
```

Run again:

```bash
dbt snapshot
```

dbt detects:

```
Berlin → London
```

and automatically creates:

```
Old record:
Berlin
valid_to = timestamp

New record:
London
valid_to = NULL
```

---

# Step 8 — Add a dbt model

Create:

```
models/customer_dimension.sql
```

Example:

```sql
SELECT

customer_id,
customer_name,
email_address,
shipping_address,
customer_segment,

dbt_valid_from,
dbt_valid_to

FROM {{ source('public','customer_snapshot') }}

WHERE dbt_valid_to IS NULL
```

This gives your current customer dimension.

---

# Step 9 — Add tests

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

## Your final architecture becomes:

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
      ------------------
      |                |
Historical        Current
records           records


Paris             London
Berlin            Active
```

---

## Your learning path after this

You are currently at a very good point. The next professional steps would be:

1. ✅ dbt snapshot SCD2 (you are starting here)
2. Add `dim_product_scd2`
3. Add `fact_sales`
4. Add dbt tests
5. Add documentation (`dbt docs generate`)
6. Schedule with Airflow
7. Add Git + CI/CD

This project is now moving from a **manual PostgreSQL SCD2 exercise** into a realistic **analytics engineering project**.
