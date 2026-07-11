# Step 1 — Create a `sources.yml` file

From your project root:

```text
ecommerce_dbt/
```

go to the `models/staging` folder:

```bash
cd ~/Documents/myData/ecommerce_dbt_demo/ecommerce_dbt
```

Create the file:

```bash
nano models/staging/sources.yml
```

---

# Step 2 — Define your source

Paste the following:

```yaml
version: 2

sources:
  - name: ecommerce
    description: "Raw customer data loaded into PostgreSQL."

    database: ecommerce_dw
    schema: public

    tables:
      - name: staging_customer
        description: "Raw customer staging table."
```

Save:

* **Ctrl + O**
* **Enter**
* **Ctrl + X**

---

# Step 3 — Update `stg_customers.sql`

Open your staging model:

```bash
nano models/staging/stg_customers.sql
```

You probably have something like:

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

Replace only the last line:

```sql
from public.staging_customer
```

with:

```sql
from {{ source('ecommerce', 'staging_customer') }}
```

Your model becomes:

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

from {{ source('ecommerce', 'staging_customer') }}
```

Save and exit.

---

# Step 4 — Verify your snapshot

Open:

```bash
nano snapshots/customer_snapshot.sql
```

The end of the file should still be:

```sql
select *

from {{ ref('stg_customers') }}

{% endsnapshot %}
```

Notice the dependency chain:

* `stg_customers` reads from a **source**.
* `customer_snapshot` reads from a **model**.

---

# Step 5 — Run the staging model

Execute:

```bash
dbt run --select stg_customers
```

Expected output:

```text
1 of 1 OK created sql model stg_customers
```

---

# Step 6 — Test the source configuration

Run:

```bash
dbt source freshness
```

Since you haven't configured freshness settings yet, dbt may simply report that there are no freshness criteria. That's normal—the important thing is that it recognizes the source without errors.

---

# Step 7 — Run the snapshot

```bash
dbt snapshot
```

Expected:

```text
1 of 1 OK snapshotted customer_snapshot
```

---

# Step 8 — Generate documentation

Run:

```bash
dbt docs generate
```

Expected:

```text
Catalog written successfully
Manifest written successfully
```

---

# Step 9 — View the lineage graph

Start the documentation server:

```bash
dbt docs serve
```

By default, it will display a local URL such as:

```text
http://127.0.0.1:8080
```

Open that address in your web browser.

You should see a lineage graph similar to:

```text
staging_customer (Source)
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

This graph is one of dbt's most valuable features because it automatically documents how data flows through your project.

---

## Your project after this change

Your directory should look like this:

```text
ecommerce_dbt/
├── models/
│   ├── staging/
│   │   ├── sources.yml
│   │   └── stg_customers.sql
│   ├── dim_customer_current.sql
│   └── schema.yml
├── snapshots/
│   └── customer_snapshot.sql
└── dbt_project.yml
```

At this point, your project follows the standard dbt architecture:

```text
PostgreSQL table
        │
        ▼
source('ecommerce', 'staging_customer')
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

This is the same pattern you'll encounter in many real-world analytics engineering projects.
