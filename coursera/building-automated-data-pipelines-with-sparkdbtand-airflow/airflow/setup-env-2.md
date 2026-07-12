# **Apache Airflow 3.3.0 Simple Auth Manager behavior**:

* `simple_auth_manager_users` uses **username:role**, not username:password.
* Passwords are auto-generated and stored in `simple_auth_manager_passwords.json.generated`.
* Removed incorrect password examples.
* Kept the Airflow 3.3 commands (`api-server`, `db migrate`).

````markdown
# Updated for Apache Airflow 3.3.0

The main changes from Airflow 2.x are:

* Remove `airflow users create` and `airflow users reset-password` (Airflow 3.3 does not use this CLI).
* Use `simple_auth_manager_users` in `airflow.cfg` to define users and roles.
* Passwords are automatically generated and stored in `simple_auth_manager_passwords.json.generated`.
* Use `airflow api-server` instead of `airflow webserver`.

---

# Activate Airflow & Configure Login

## 1. Move into the Airflow project folder

Use `cd` to move into the project:

```bash
cd ~/Documents/myData/airflow-learning
````

Your prompt should become:

```text
linda@...:~/Documents/myData/airflow-learning$
```

---

## 2. Activate Airflow environment

Activate the Python virtual environment:

```bash
source airflow-env/bin/activate
```

You should see:

```text
(airflow-env) linda@...:~/Documents/myData/airflow-learning$
```

---

## 3. Set Airflow Home

Set the Airflow working directory:

```bash
export AIRFLOW_HOME=~/Documents/myData/airflow-learning/airflow-home
```

Verify:

```bash
echo $AIRFLOW_HOME
```

Expected:

```text
/home/linda/Documents/myData/airflow-learning/airflow-home
```

---

# Start Airflow Services

Airflow 3.3.0 uses two main processes:

* Scheduler → schedules DAG runs and executes tasks
* API Server → provides the Airflow web interface

---

# Terminal 1: Start Scheduler

Run:

```bash
airflow scheduler
```

Leave this terminal running.

Expected output:

```text
Starting the scheduler
```

---

# Terminal 2: Start Airflow UI

Open a new terminal.

Go back to the project:

```bash
cd ~/Documents/myData/airflow-learning
```

Activate the environment:

```bash
source airflow-env/bin/activate
```

Set Airflow Home:

```bash
export AIRFLOW_HOME=~/Documents/myData/airflow-learning/airflow-home
```

Start the API server:

```bash
airflow api-server --port 8082
```

Open:

```text
http://localhost:8082
```

---

# Airflow 3.3.0 Authentication

Airflow 3.3.0 uses the **Simple Auth Manager** by default.

You will see:

> Simple auth manager enabled

Simple Auth Manager is intended for development and testing environments.

---

# Configure Users

Users are configured in:

```text
airflow-home/airflow.cfg
```

Open the configuration:

```bash
nano ~/Documents/myData/airflow-learning/airflow-home/airflow.cfg
```

Find:

```ini
[core]
simple_auth_manager_users =
```

The format is:

```ini
simple_auth_manager_users = username:role
```

Example:

```ini
simple_auth_manager_users = lindangulopez:admin
```

The available roles are:

```text
viewer
user
op
admin
```

For a learning environment, use:

```ini
simple_auth_manager_users = lindangulopez:admin
```

Save:

```text
CTRL + O
ENTER
CTRL + X
```

---

# Find the Generated Password

Airflow automatically creates passwords.

The password file is located at:

```text
$AIRFLOW_HOME/simple_auth_manager_passwords.json.generated
```

View the generated password:

```bash
cat ~/Documents/myData/airflow-learning/airflow-home/simple_auth_manager_passwords.json.generated
```

Example output:

```json
{
    "lindangulopez": "generated-password-here"
}
```

Use this generated password to log into Airflow.

---

# Restart Airflow API Server

Stop the API server:

```text
CTRL + C
```

Restart:

```bash
airflow api-server --port 8082
```

Open:

```text
http://localhost:8082
```

Login:

```text
Username:
lindangulopez

Password:
(use the password from simple_auth_manager_passwords.json.generated)
```

---

# Check DAGs

Verify Airflow detects your DAG:

```bash
airflow dags list
```

Expected:

```text
sales_analytics_pipeline
```

---

# Airflow 2.x vs Airflow 3.3.0 Changes

| Airflow 2.x                    | Airflow 3.3.0               |
| ------------------------------ | --------------------------- |
| `airflow webserver`            | `airflow api-server`        |
| `airflow users create`         | `simple_auth_manager_users` |
| `airflow users reset-password` | Generated passwords file    |
| `airflow db init`              | `airflow db migrate`        |

---

# Project Environment

Your project uses:

```text
Apache Airflow 3.3.0
Python virtual environment
Simple Auth Manager
LocalExecutor
```

This setup is suitable for learning:

* DAG development
* Workflow orchestration
* Scheduling pipelines
* dbt integration
* Production-style data engineering patterns

```

This version now matches your actual installation and the official Airflow 3.3.0 documentation.
```
