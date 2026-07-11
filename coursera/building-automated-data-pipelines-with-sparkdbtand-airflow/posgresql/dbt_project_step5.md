# remove **example project 

> `dbt init` created**, not from anything you built.

Notice the key part of the error:

```text
models/example/schema.yml
```

and

```text
relation "public.my_first_dbt_model" does not exist
```

Those are dbt's tutorial models (`my_first_dbt_model` and `my_second_dbt_model`), which you've never built (or have deleted), but their tests are still present.

### Step 1: Verify your project structure

Run:

```bash
tree -L 3
```

or

```bash
find models -maxdepth 2 -type f
```

You will probably see something like:

```text
models/
├── dim_customer_current.sql
├── schema.yml
├── example/
│   ├── my_first_dbt_model.sql
│   ├── my_second_dbt_model.sql
│   └── schema.yml
└── staging/
    └── stg_customers.sql
```

or perhaps:

```text
models/
├── example/
│   └── schema.yml
```

---

## Step 2: Remove the example project

If you're no longer using the example models, simply remove the example directory:

```bash
rm -r models/example
```

or, if you prefer to keep it, rename it:

```bash
mv models/example models/example_backup
```

---

## Step 3: Run the tests again

```bash
dbt test
```

Now you should only see your tests, for example:

```text
PASS unique_dim_customer_current_customer_id
PASS not_null_dim_customer_current_customer_id

Done. PASS=2 WARN=0 ERROR=0
```

---

## Step 4: Your project should look something like this

```
ecommerce_dbt/

models/
│
├── staging/
│   └── stg_customers.sql
│
├── dim_customer_current.sql
│
└── schema.yml

snapshots/
│
└── customer_snapshot.sql

dbt_project.yml
```

No `models/example/` folder is needed anymore.

---

## Where you are now

You've successfully implemented nearly everything from the lesson:

| Feature                                    | Status                                  |
| ------------------------------------------ | --------------------------------------- |
| PostgreSQL source table                    | ✅                                       |
| Staging model (`stg_customers`)            | ✅                                       |
| `record_hash`                              | ✅                                       |
| Snapshot with `ref()`                      | ✅                                       |
| SCD Type 2 history                         | ✅                                       |
| Current dimension (`dim_customer_current`) | ✅                                       |
| Snapshot rerun after updates               | ✅                                       |
| Data tests                                 | ✅ (only example tests remain to remove) |

---

### Next recommendation

Before moving on to another lesson, I recommend one final improvement that professional dbt projects use:

1. Create a **`sources.yml`** file to define `staging_customer` as a dbt source.
2. Replace this in `stg_customers.sql`:

```sql
from public.staging_customer
```

with:

```sql
from {{ source('ecommerce', 'staging_customer') }}
```

This is the standard dbt pattern and will complete your project's lineage:

```
PostgreSQL table
       │
       ▼
source()
       │
       ▼
stg_customers
       │
       ▼
customer_snapshot
       │
       ▼
dim_customer_current
```

That's the architecture you'll see in most production dbt projects.
