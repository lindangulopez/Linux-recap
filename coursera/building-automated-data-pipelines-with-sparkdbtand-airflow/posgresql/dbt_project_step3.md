# Successfully implemented first **dbt SCD Type 2 snapshot**. 🎉

Your output proves it worked:

```text
customer_id | shipping_address | dbt_valid_from          | dbt_valid_to
------------+------------------+-------------------------+-------------------------
CUST001     | Berlin           | 2026-07-11 17:42:52     | 2026-07-11 17:46:30
CUST001     | London           | 2026-07-11 17:46:30     |
```

This is exactly what SCD2 does.

---

## What happened step by step

Before dbt:

Your source table:

```
staging_customer
```

contained:

| customer_id | shipping_address |
| ----------- | ---------------- |
| CUST001     | Berlin           |

You ran:

```sql
UPDATE staging_customer
SET shipping_address='London'
WHERE customer_id='CUST001';
```

Then you ran:

```bash
dbt snapshot
```

dbt compared:

### Previous snapshot:

```
CUST001
Berlin
```

against:

### Current staging:

```
CUST001
London
```

It detected a change.

Then dbt automatically did the SCD2 logic:

### Closed old version:

```
CUST001
Berlin

dbt_valid_from = 17:42:52
dbt_valid_to   = 17:46:30
```

Meaning:

> This version was valid until 17:46:30.

---

### Created new version:

```
CUST001
London

dbt_valid_from = 17:46:30
dbt_valid_to   = NULL
```

Meaning:

> This is the current active record.

---

# Important: you replaced your manual table

Remember your original table:

```
dim_customer_scd2
```

You manually maintained:

```sql
valid_from
valid_to
is_current
record_hash
```

Now dbt manages this:

```
customer_snapshot
```

with:

```
dbt_scd_id
dbt_updated_at
dbt_valid_from
dbt_valid_to
```

You no longer need:

```sql
UPDATE dim_customer_scd2
SET valid_to = ...
```

or:

```sql
INSERT INTO dim_customer_scd2
```

dbt does it.

---

# One small thing: reactivate your Python environment

You saw:

```
La commande « dbt » n'a pas été trouvée
```

because your virtual environment was closed.

Your prompt changed from:

```
(dbt-env) linda@...
```

to:

```
linda@...
```

The `(dbt-env)` disappeared.

Activate it again:

```bash
cd ~/Documents/myData/ecommerce_dbt_demo
source dbt-env/bin/activate
```

You should see:

```
(dbt-env) linda@...
```

Then:

```bash
cd ecommerce_dbt
dbt snapshot
```

will work again.

---

# Your current architecture

You now have:

```
                PostgreSQL
                    |
                    |
                    v

          staging_customer
          
          CUST001
          London
          
                    |
                    |
                    v

             dbt snapshot

          customer_snapshot


     --------------------------------

     Historical        Current

     Berlin            London
     closed            active

```

This is a real analytics engineering pattern.

---

# Next improvement: create a clean dimension model

Right now:

```
customer_snapshot
```

contains history.

Usually we create two models:

## 1. Current customer dimension

`models/dim_customer.sql`

```sql
SELECT
    customer_id,
    customer_name,
    email_address,
    shipping_address,
    customer_segment

FROM {{ ref('customer_snapshot') }}

WHERE dbt_valid_to IS NULL
```

Result:

| customer_id | address |
| ----------- | ------- |
| CUST001     | London  |

---

## 2. Customer history table

`models/customer_history.sql`

```sql
SELECT
    customer_id,
    customer_name,
    shipping_address,
    dbt_valid_from,
    dbt_valid_to

FROM {{ ref('customer_snapshot') }}
```

Result:

| customer | address | valid_to |
| -------- | ------- | -------- |
| CUST001  | Berlin  | 17:46    |
| CUST001  | London  | NULL     |

---

# Your next command

From inside:

```
~/Documents/myData/ecommerce_dbt_demo/ecommerce_dbt
```

run:

```bash
dbt ls
```

You should see something like:

```
model.ecommerce_dbt.example
snapshot.ecommerce_dbt.customer_snapshot
```

Then we can clean the starter models and build your proper ecommerce warehouse:

```
staging_customer
        |
        |
        v
customer_snapshot
        |
        |
        +---- dim_customer
        |
        +---- customer_history
```

You have completed the hardest part: **dbt connection + first SCD2 snapshot + change detection.**
