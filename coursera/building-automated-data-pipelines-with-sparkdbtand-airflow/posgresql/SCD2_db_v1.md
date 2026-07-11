# Create the SCD2 database

Since you are on **Linux**, you can create the SCD2 database entirely from the terminal using PostgreSQL CLI (`psql`).

## 1. Check if PostgreSQL is installed

Open Terminal:

```bash
psql --version
```

Example output:

```text
psql (PostgreSQL) 16.2
```

If it is not installed (Ubuntu/Debian):

```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
```

Start PostgreSQL:

```bash
sudo systemctl start postgresql
```

Enable it at boot:

```bash
sudo systemctl enable postgresql
```

---

## 2. Switch to the PostgreSQL user

On Linux, PostgreSQL normally creates a system user called `postgres`.

```bash
sudo -i -u postgres
```

Now enter PostgreSQL:

```bash
psql
```

You should see:

```text
postgres=#
```

---

## 3. Create the SCD2 Database

Inside `psql`:

```sql
CREATE DATABASE ecommerce_dw;
```

Connect:

```sql
\c ecommerce_dw
```

Your prompt changes:

```text
ecommerce_dw=#
```

---

## 4. Create the Staging Table

Run:

```sql
CREATE TABLE staging_customer (
    customer_id VARCHAR(50),
    customer_name VARCHAR(255),
    email_address VARCHAR(255),
    shipping_address VARCHAR(500),
    customer_segment VARCHAR(50),
    load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 5. Create the SCD2 Dimension Table

```sql
CREATE TABLE dim_customer_scd2 (

    customer_sk SERIAL PRIMARY KEY,

    customer_id VARCHAR(50) NOT NULL,

    customer_name VARCHAR(255),

    email_address VARCHAR(255),

    shipping_address VARCHAR(500),

    customer_segment VARCHAR(50),

    record_hash TEXT,

    valid_from TIMESTAMP NOT NULL,

    valid_to TIMESTAMP,

    is_current BOOLEAN DEFAULT TRUE,

    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 6. Load Initial Customer Data

Insert into staging:

```sql
INSERT INTO staging_customer
(
customer_id,
customer_name,
email_address,
shipping_address,
customer_segment
)
VALUES
(
'CUST001',
'John Smith',
'john@gmail.com',
'Paris',
'Premium'
);
```

Load into SCD2:

```sql
INSERT INTO dim_customer_scd2
(
customer_id,
customer_name,
email_address,
shipping_address,
customer_segment,
record_hash,
valid_from
)

SELECT
customer_id,
customer_name,
email_address,
shipping_address,
customer_segment,

md5(
customer_name ||
email_address ||
shipping_address ||
customer_segment
),

CURRENT_TIMESTAMP

FROM staging_customer;
```

Check:

```sql
SELECT * FROM dim_customer_scd2;
```

---

## 7. Test a Historical Change

Change the customer's address:

```sql
TRUNCATE staging_customer;
```

Insert new data:

```sql
INSERT INTO staging_customer
VALUES
(
'CUST001',
'John Smith',
'john@gmail.com',
'Berlin',
'Premium',
CURRENT_TIMESTAMP
);
```

---

## 8. Close the Old Record

```sql
UPDATE dim_customer_scd2

SET
valid_to=CURRENT_TIMESTAMP,
is_current=false

WHERE customer_id='CUST001'
AND is_current=true;
```

---

## 9. Insert the New Version

```sql
INSERT INTO dim_customer_scd2
(
customer_id,
customer_name,
email_address,
shipping_address,
customer_segment,
record_hash,
valid_from,
is_current
)

SELECT

customer_id,
customer_name,
email_address,
shipping_address,
customer_segment,

md5(
customer_name ||
email_address ||
shipping_address ||
customer_segment
),

CURRENT_TIMESTAMP,
TRUE

FROM staging_customer;
```

---

## 10. Verify Your SCD2 History

```sql
SELECT
customer_sk,
customer_id,
shipping_address,
valid_from,
valid_to,
is_current
FROM dim_customer_scd2
ORDER BY customer_sk;
```

Expected:

```text
 customer_sk | customer_id | shipping_address | is_current
-------------+-------------+------------------+-----------
 1           | CUST001     | Paris            | f
 2           | CUST001     | Berlin           | t
```

---

## Useful Linux + PostgreSQL Commands

Exit PostgreSQL:

```sql
\q
```

Exit the postgres Linux user:

```bash
exit
```

Connect later:

```bash
sudo -u postgres psql -d ecommerce_dw
```

Backup your database:

```bash
pg_dump ecommerce_dw > ecommerce_dw_backup.sql
```

Restore:

```bash
psql ecommerce_dw < ecommerce_dw_backup.sql
```

At this point you have a working SCD2 data warehouse foundation running locally on Linux. You can extend it with `dim_product_scd2`, `fact_sales`, ETL scripts (Python/Airflow/dbt), and automated change detection.
