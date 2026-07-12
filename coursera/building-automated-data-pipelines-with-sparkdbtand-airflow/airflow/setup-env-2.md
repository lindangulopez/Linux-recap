# updated for **Apache Airflow 3.3.0**. 

The main changes are:

* Remove `airflow users create` and `airflow users reset-password` (Airflow 3.3 does not use that CLI).
* Use `simple_auth_manager_users` in `airflow.cfg` for login credentials.
* Keep `airflow api-server` instead of `airflow webserver`.

Here is the corrected version:

````markdown
# Activate Airflow & Configure Login Password

## 1. Move into the Airflow project folder

Use `cd` to move into the project:

```bash
cd ~/Documents/myData/airflow-learning
```

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

Airflow 3.3.0 uses two processes:

- Scheduler → runs DAG scheduling and tasks
- API Server → provides the Airflow web interface

---

## Terminal 1: Start Scheduler

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

## Terminal 2: Start Airflow UI

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

Airflow 3.3.0 uses the **Simple Auth Manager** for development environments.

You will see:

> Simple auth manager enabled

The username and password are configured in:

```text
airflow-home/airflow.cfg
```

---

## Check Login Credentials

Open the configuration:

```bash
nano ~/Documents/myData/airflow-learning/airflow-home/airflow.cfg
```

Find:

```ini
simple_auth_manager_users =
```

Example:

```ini
simple_auth_manager_users = admin:admin
```

This means:

```text
Username:
admin

Password:
admin
```

---

## Create Your Own Login

Change:

```ini
simple_auth_manager_users = admin:admin
```

to:

```ini
simple_auth_manager_users = lindangulopez:YourPassword
```

Example:

```ini
simple_auth_manager_users = lindangulopez:Airflow123!
```

Save:

```text
CTRL + O
ENTER
CTRL + X
```

---

## Restart Airflow API Server

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
Airflow123!
```

(use the password configured in `airflow.cfg`)

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

| Airflow 2.x | Airflow 3.3.0 |
|---|---|
| `airflow webserver` | `airflow api-server` |
| `airflow users create` | `simple_auth_manager_users` |
| `airflow users reset-password` | Edit `airflow.cfg` |
| `airflow db init` | `airflow db migrate` |

Your project uses:

```text
Apache Airflow 3.3.0
Python virtual environment
Simple Auth Manager
LocalExecutor
```

This setup is suitable for learning Airflow orchestration and later connecting it with your dbt project.
````

This version now matches the environment you actually installed and avoids the Airflow 2.x commands that caused the login confusion.
