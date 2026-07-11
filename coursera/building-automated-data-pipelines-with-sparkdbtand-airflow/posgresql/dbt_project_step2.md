# 🎉 dbt environment is now fully working.

You have completed the setup phase:

✅ Python virtual environment active
✅ dbt Core installed
✅ dbt-postgres adapter installed
✅ dbt project created
✅ `profiles.yml` configured
✅ PostgreSQL connection verified
✅ Database `ecommerce_dw` reachable

Now we move to the actual goal: **replace your manual SCD2 implementation with dbt Snapshots**.

Your current database:

```
ecommerce_dw

public.staging_customer
        |
        |
        ↓
public.dim_customer_scd2   (manual SCD2)
```

We will create:

```
ecommerce_dw

public.staging_customer
        |
        |
        ↓
dbt snapshot
        |
        |
        ↓
public.customer_snapshot   (automatic SCD2)
```

---

## Step 1 — Check your current dbt project

You are here:

```bash
~/Documents/myData/ecommerce_dbt_demo/ecommerce_dbt
```

Run:

```bash
ls
```

You should see:

```
dbt_project.yml
models
macros
seeds
snapshots
tests
```

If `snapshots` does not exist:

```bash
mkdir snapshots
```

---

## Step 2 — Create your customer SCD2 snapshot

Create:

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

Save:

```
CTRL + O
ENTER
CTRL + X
```

---

## Step 3 — Run your first dbt snapshot

Execute:

```bash
dbt snapshot
```

Expected:

```
Running with dbt=1.12.0

1 of 1 START snapshot customer_snapshot
1 of 1 OK created snapshot

Finished successfully
```

---

## Step 4 — Verify the SCD2 table

Connect:

```bash
psql -h localhost -U postgres -d ecommerce_dw
```

Then:

```sql
\dt
```

You should now see:

```
public.customer_snapshot
```

Query:

```sql
SELECT *
FROM public.customer_snapshot;
```

dbt automatically adds:

```
dbt_scd_id
dbt_updated_at
dbt_valid_from
dbt_valid_to
```

Your result will look like:

| customer_id | shipping_address | dbt_valid_from   | dbt_valid_to |
| ----------- | ---------------- | ---------------- | ------------ |
| CUST001     | Berlin           | 2026-07-11 14:57 | NULL         |

---

## Step 5 — Test SCD2 change tracking

Now simulate a customer change.

Enter PostgreSQL:

```bash
psql -h localhost -U postgres -d ecommerce_dw
```

Run:

```sql
UPDATE staging_customer
SET shipping_address='London'
WHERE customer_id='CUST001';
```

Exit:

```sql
\q
```

Run snapshot again:

```bash
dbt snapshot
```

dbt will:

1. Detect:

```
Berlin → London
```

2. Close old record:

```
Berlin
dbt_valid_to = current timestamp
```

3. Create new version:

```
London
dbt_valid_to = NULL
```

---

## Step 6 — View the history

Run:

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

Expected:

```
CUST001 | Berlin  | 2026-07-11 14:57 | 2026-07-11 15:xx
CUST001 | London  | 2026-07-11 15:xx | NULL
```

This is your automated SCD Type 2 history.

---

### One important note about your existing `dim_customer_scd2`

Do **not** connect dbt snapshots directly to that table.

Your current table:

```
dim_customer_scd2
```

is the result of your old ETL approach.

The dbt approach creates its own history table:

```
customer_snapshot
```

After you validate it works, we can build a model:

```
customer_snapshot
        |
        ↓
dim_customer
```

and replace your old SCD2 table.

---

Your next command should be:

```bash
mkdir -p snapshots
nano snapshots/customer_snapshot.sql
```

Then we create the first real dbt SCD2 pipeline.
