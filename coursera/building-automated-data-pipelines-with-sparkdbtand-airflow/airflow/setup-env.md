Since you are on **Ubuntu Linux**, follow these steps.

You already created:

```bash
python3 -m venv dbt-env
```

Activate it:

```bash
source dbt-env/bin/activate
```

Your terminal should change to something like:

```bash
(dbt-env) user@ubuntu:~$
```

---

## 1. Upgrade pip and install required packages

First upgrade packaging tools:

```bash
python -m pip install --upgrade pip setuptools wheel
```

Airflow requires some system dependencies. Install them:

```bash
sudo apt update

sudo apt install -y \
    python3-dev \
    build-essential \
    libssl-dev \
    libffi-dev
```

---

## 2. Install Apache Airflow

Inside your activated environment:

```bash
pip install apache-airflow
```

This may take several minutes.

---

## 3. Verify Airflow installation

Check the version:

```bash
airflow version
```

Example output:

```text
3.0.x
```

or

```text
2.x.x
```

Test your imports:

```bash
python -c "
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.models import Variable
print('Airflow imports OK')
"
```

Expected:

```text
Airflow imports OK
```

---

## 4. Configure Airflow

Set the Airflow home directory:

```bash
export AIRFLOW_HOME=~/airflow
```

To make it permanent:

```bash
echo 'export AIRFLOW_HOME=~/airflow' >> ~/.bashrc

source ~/.bashrc
```

---

## 5. Initialize Airflow database

Run:

```bash
airflow db migrate
```

(For older Airflow versions you may see `airflow db init` in tutorials.)

---

## 6. Create an Airflow user

For Airflow 2.x:

```bash
airflow users create \
    --username admin \
    --firstname Admin \
    --lastname User \
    --role Admin \
    --email admin@example.com
```

---

## 7. Start Airflow

Open terminal 1:

```bash
airflow scheduler
```

Open terminal 2:

```bash
airflow webserver --port 8080
```

Open your browser:

```
http://localhost:8080
```

---

## 8. Fix VS Code import warnings

If your code still shows:

```python
from airflow import DAG
```

with a yellow underline:

1. Open VS Code.
2. Press:

```
CTRL + SHIFT + P
```

3. Select:

```
Python: Select Interpreter
```

4. Choose:

```
./dbt-env/bin/python
```

5. Restart VS Code.

---

## Quick check

Run this:

```bash
which python
```

You should see:

```text
/home/<your-user>/dbt-env/bin/python
```

and:

```bash
which airflow
```

should show:

```text
/home/<your-user>/dbt-env/bin/airflow
```

If `which airflow` returns nothing, Airflow is not installed in your active virtual environment.
