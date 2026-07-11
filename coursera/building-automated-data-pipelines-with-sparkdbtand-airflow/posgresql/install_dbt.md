# Recommended next steps for you

Given where you are now:

1. ✅ PostgreSQL SCD2 working
2. ✅ Backup created
3. ⬜ Install dbt-postgres
4. ⬜ Create dbt project
5. ⬜ Move `staging_customer` into a dbt model
6. ⬜ Replace manual SCD2 SQL with a snapshot
7. ⬜ Add tests
8. ⬜ Apply the same architecture to ecological connectivity data

Your current project is actually a good training example because you already built the hard part manually; dbt will now automate th

You already have a working **manual SCD2 implementation in PostgreSQL** (`ecommerce_dw`). The next step is to move the responsibility for detecting changes and creating history from your SQL scripts into **dbt snapshots**.

The migration path is:

```
Current workflow:

staging_customer
        |
        ↓
Manual comparison
        |
        ↓
UPDATE old record
        |
        ↓
INSERT new record
        |
        ↓
dim_customer_scd2


dbt workflow:

staging_customer
        |
        ↓
dbt snapshot
        |
        ↓
customer_snapshot (automatic SCD2 history)
```

---

# Step 1 — Install dbt PostgreSQL adapter

In your Linux terminal:

```bash
pip install dbt-postgres
```

Check:

```bash
dbt --version
```

You should see something like:

```
Core:
  - installed: 1.x.x

Plugins:
  - postgres: 1.x.x
```

---

# Step 2 — Create a dbt project

Go to your data-management folder:

```bash
cd ~/Documents/myData/ecommerce_dw
```

Create project:

```bash
dbt init ecommerce_dbt
```

Your structure becomes:

```
ecommerce_dbt/

├── models/
├── snapshots/
├── tests/
├── dbt_project.yml
└── README.md
```

---

# Step 3 — Configure PostgreSQL connection

Find your dbt profile:

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
      password: YOUR_PASSWORD
      port: 5432
      dbname: ecommerce_dw
      schema: public
      threads: 4
```

Test:

```bash
dbt debug
```

Expected:

```
Connection test: OK
```

---

# Step 4 — Create a staging model

dbt works best when data flows:

```
raw data
   ↓
staging model
   ↓
snapshot
   ↓
analytics tables
```

Create:

```
models/staging/stg_customer.sql
```

Add:

```sql
SELECT

customer_id,
customer_name,
email_address,
shipping_address,
customer_segment,
load_date

FROM public.staging_customer
```

This replaces directly reading your table.

---

# Step 5 — Create the SCD2 snapshot

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
    ],

    invalidate_hard_deletes=true

)

}}


SELECT *

FROM {{ ref('stg_customer') }}


{% endsnapshot %}
```

This replaces your manual SQL:

```sql
UPDATE dim_customer_scd2
SET valid_to=CURRENT_TIMESTAMP
```

and:

```sql
INSERT INTO dim_customer_scd2
```

dbt does both automatically.

---

# Step 6 — Run your first snapshot

From the dbt project:

```bash
dbt snapshot
```

dbt creates:

```
snapshots.customer_snapshot
```

with fields:

| Column         | Purpose          |
| -------------- | ---------------- |
| customer_id    | business key     |
| dbt_scd_id     | surrogate key    |
| dbt_updated_at | change timestamp |
| dbt_valid_from | record start     |
| dbt_valid_to   | record end       |

Example result:

| customer_id | address | valid_from | valid_to   |
| ----------- | ------- | ---------- | ---------- |
| CUST001     | Paris   | 2026-07-11 | 2026-07-12 |
| CUST001     | Berlin  | 2026-07-12 | NULL       |

---

# Step 7 — Test a change

Return to PostgreSQL:

```bash
sudo -u postgres psql -d ecommerce_dw
```

Change the customer:

```sql
UPDATE staging_customer

SET shipping_address='Lisbon'

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
Old:
Paris

New:
Lisbon
```

and creates:

```
CUST001 | Paris  | valid_to = today
CUST001 | Lisbon | valid_to = NULL
```

No manual update.
No manual insert.

---

# Step 8 — Add tests

Create:

```
models/schema.yml
```

Add:

```yaml
version: 2

models:

  - name: stg_customer

    columns:

      - name: customer_id

        tests:

          - not_null
```

Run:

```bash
dbt test
```

---

# Step 9 — Connect this to your ecological connectivity project

Your customer table becomes a model for ecological dimensions.

For example:

## Species habitat history

```
dim_species_habitat_scd2
```

Tracks:

| Field         | Example          |
| ------------- | ---------------- |
| species_id    | Felis_silvestris |
| habitat_score | 0.82             |
| landcover     | forest           |
| resistance    | 15               |
| valid_from    | 2026             |
| valid_to      | NULL             |

---

## Landscape change tracking

```
dim_landscape_resistance_scd2
```

Tracks:

```
2024:
forest = suitable

2025:
road expansion increases resistance

2026:
restoration decreases resistance
```

---

## Corridor history

```
dim_connectivity_corridor_scd2
```

Tracks:

```
corridor A:
priority = high

after restoration:
priority = medium
```

---

e parts you wrote yourself.
