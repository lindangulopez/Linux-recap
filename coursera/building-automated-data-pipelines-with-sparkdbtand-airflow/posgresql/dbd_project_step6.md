# server already in use

Your `dbt ls` output is actually very encouraging. It shows that dbt has successfully detected all the pieces needed for the lineage graph:

* ✅ Source: `source:ecommerce_dbt.ecommerce.staging_customer`
* ✅ Staging model: `ecommerce_dbt.staging.stg_customers`
* ✅ Snapshot: `ecommerce_dbt.customer_snapshot.customer_snapshot`
* ✅ Final model: `ecommerce_dbt.dim_customer_current`

That means your dependency chain has been built correctly.

The only issue you've shown so far is that the documentation server couldn't start because port 8080 was already in use.

### Next step

Try serving the docs on a different port:

```bash
dbt docs serve --port 8081
```

If that doesn't work:

```bash
dbt docs serve --port 9000
```

If the server starts, you'll see something like:

```text
Serving docs at http://127.0.0.1:8081
```

Open that address in your browser.

### If you still get "Address already in use"

Run:

```bash
lsof -i :8080
```

and also:

```bash
lsof -i :8081
```

Paste the output here, and we can identify what's occupying those ports.

### The warning is unrelated

You also have this warning:

```text
Configuration paths exist in your dbt_project.yml file which do not apply to any resources.
- models.ecommerce_dbt.example
```

This is common when starting from the default dbt project template. It doesn't affect your models or the lineage graph. You can remove the unused `example:` section from `dbt_project.yml` later if you want to eliminate the warning.

### One more check

Could you also run:

```bash
tree -L 3
```

or, if `tree` isn't installed:

```bash
find . -maxdepth 3 -type f
```

This will let me verify that your files are in the expected locations:

```
models/
├── staging/
│   ├── sources.yml
│   └── stg_customers.sql
├── dim_customer_current.sql
└── schema.yml

snapshots/
└── customer_snapshot.sql
```

From what you've shared, it appears your dbt project is configured correctly—the remaining task is simply getting the docs server running so you can view the generated documentation and lineage graph.
