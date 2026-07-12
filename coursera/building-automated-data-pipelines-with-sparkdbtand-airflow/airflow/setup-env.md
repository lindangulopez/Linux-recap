# Set up Airflow

Create a **separate Airflow environment** instead of installing Airflow into your existing `dbt-env`. Airflow has many dependencies and can conflict with dbt packages.

Your current structure:

```text
~/Documents/myData/
│
└── dbt-learning/
    ├── dbt-env/
    ├── dbt_project.yml
    ├── models/
    └── profiles.yml
```

Create a separate Airflow project:

```bash
cd ~/Documents/myData

mkdir airflow-learning

cd airflow-learning
```

Your structure will become:

```text
~/Documents/myData/
│
├── dbt-learning/
│   ├── dbt-env/
│   ├── dbt_project.yml
│   └── models/
│
└── airflow-learning/
    ├── airflow-env/
    └── dags/
```

---

## 1. Create Airflow virtual environment

Inside `airflow-learning`:

```bash
python3 -m venv airflow-env
```

Activate it:

```bash
source airflow-env/bin/activate
```

You should see:

```bash
(airflow-env) linda@linda-HP-EliteBook:~/Documents/myData/airflow-learning$
```

Verify:

```bash
which python
```

Expected:

```text
/home/linda/Documents/myData/airflow-learning/airflow-env/bin/python
```

---

## 2. Install Airflow dependencies

Upgrade tools:

```bash
pip install --upgrade pip setuptools wheel
```

Install system packages if needed:

```bash
sudo apt update

sudo apt install -y \
python3-dev \
build-essential \
libssl-dev \
libffi-dev
```

---

## 3. Install Apache Airflow

Install Airflow:

```bash
pip install apache-airflow
```

This can take several minutes.

Verify:

```bash
airflow version
```

Example:

```text
3.x.x
```

---

## 4. Configure Airflow Home

Set the Airflow directory:

```bash
export AIRFLOW_HOME=~/Documents/myData/airflow-learning/airflow-home
```

Make it permanent:

```bash
echo 'export AIRFLOW_HOME=~/Documents/myData/airflow-learning/airflow-home' >> ~/.bashrc

source ~/.bashrc
```

---

## 5. Initialize Airflow database

Run:

```bash
airflow db migrate
```

You should get:

```text
Database migrating done
```

---

## 6. Create Airflow folders

Create the DAG folder:

```bash
mkdir -p dags
mkdir -p logs
mkdir -p plugins
```

Final structure:

```text
airflow-learning/
│
├── airflow-env/
│
├── airflow-home/
│   ├── airflow.cfg
│   └── airflow.db
│
├── dags/
│   └── sales_analytics_dag.py
│
├── logs/
│
└── plugins/
```

---

## 7. Create an Airflow user

For Airflow 2.x:

```bash
airflow users create \
--username linda \
--firstname Linda \
--lastname Admin \
--role Admin \
--email linda@example.com
```

---

## 8. Create your first DAG

Create:

```bash
nano dags/sales_analytics_dag.py
```

Paste:

```python
from airflow import DAG
from airflow.operators.python import PythonOperator

from datetime import datetime, timedelta


def extract_data():
    print("Extracting sales data")


def transform_data():
    print("Transforming sales data")


def load_data():
    print("Loading analytics data")


default_args = {

    "owner": "data_engineering",

    "retries": 3,

    "retry_delay": timedelta(minutes=5)

}


with DAG(

    dag_id="sales_analytics_pipeline",

    default_args=default_args,

    start_date=datetime(2026,1,1),

    schedule="0 6 * * *",

    catchup=False

) as dag:


    extract = PythonOperator(
        task_id="extract_sales",
        python_callable=extract_data
    )


    transform = PythonOperator(
        task_id="transform_sales",
        python_callable=transform_data
    )


    load = PythonOperator(
        task_id="load_analytics",
        python_callable=load_data
    )


    extract >> transform >> load
```

Save:

```
CTRL + O
ENTER
CTRL + X
```

---

## 9. Start Airflow

Terminal 1:

```bash
airflow scheduler
```

Terminal 2:

```bash
airflow webserver --port 8080
```

Open:

```
http://localhost:8080
```

---

## 10. Connect Airflow with dbt later

Your final architecture will look like:

```text
PostgreSQL
    |
    |
staging_customer
    |
    |
Airflow DAG
    |
    |
dbt snapshot
    |
    |
customer_snapshot
    |
    |
dim_customer
```

Airflow will orchestrate:

* extract jobs
* dbt snapshot runs
* dbt models
* data quality checks
* notifications

This keeps your dbt project clean and gives you a production-style data platform setup.
