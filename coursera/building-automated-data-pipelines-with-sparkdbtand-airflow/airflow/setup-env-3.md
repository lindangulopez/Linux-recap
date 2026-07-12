 **Airflow 3.3.0 difference**. 
 
Previous command was for older Airflow versions. In Airflow 3.3, `airflow dags list` no longer accepts `--subdir`.

Your environment is behaving correctly.

Now let's debug using Airflow 3.3 commands.

---

## 1. Confirm the DAG folder Airflow is using

You already ran:

```bash
airflow config get-value core dags_folder
```

and got:

```text
/home/linda/Documents/myData/airflow-learning/airflow-home/dags
```

Your file is there:

```text
sales_analytics_dag.py
```

✅ Folder is correct.

---

## 2. Check if Airflow sees the DAG file

Run:

```bash
airflow dags list
```

then search:

```bash
airflow dags list | grep sales_analytics_pipeline
```

---

## 3. Force a DAG re-parse

Airflow 3.3 uses the DAG processor. Start it manually:

Open a new terminal:

```bash
cd ~/Documents/myData/airflow-learning

source airflow-env/bin/activate

export AIRFLOW_HOME=~/Documents/myData/airflow-learning/airflow-home

airflow dag-processor
```

Leave it running for about 30 seconds.

You should see messages about parsing:

```text
Processing file sales_analytics_dag.py
```

Then in another terminal:

```bash
airflow dags list | grep sales_analytics_pipeline
```

---

## 4. Check your scheduler is using the same environment

Your scheduler terminal should show:

```text
(airflow-env)
```

before the command:

```bash
airflow scheduler
```

If you started it before activating the environment, it may be using another Airflow installation.

Stop it:

```text
CTRL + C
```

Restart:

```bash
cd ~/Documents/myData/airflow-learning
source airflow-env/bin/activate
export AIRFLOW_HOME=~/Documents/myData/airflow-learning/airflow-home

airflow scheduler
```

---

## 5. Check Airflow database state

Run:

```bash
airflow dags list-import-errors
```

You already did this and got:

```text
No data found
```

✅ No Python errors.

---

At this point the most likely issue is that the **DAG processor has not parsed your new file yet**.

Run this next:

```bash
airflow dag-processor
```

and paste the first 20–30 lines of output.
