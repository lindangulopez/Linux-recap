# Review

I found that the virtual environment has **Apache Airflow 3.3.0** installed (`apache_airflow-3.3.0.dist-info`, `apache_airflow_core-3.3.0.dist-info`), not Airflow 2.8.x, which the DAG was originally built against. Airflow 3 introduces several changes that affect this project, so I fixed both the **"DAGs not showing"** issue and updated the DAG for Airflow 3 compatibility.

Looking at the project structure, I identified the root cause:

```text
├── airflow-home/              ← this is the real AIRFLOW_HOME
│   ├── airflow.cfg
│   ├── airflow.db
│   ├── dags/
│   │   └── sales_analytics_dag.py    ← Airflow reads DAGs from HERE
│   └── logs/dag_processor/.../dags-folder/
│       └── sales_analytics_dag.py.log   ← only this file has ever been scanned
├── dags/                       ← this is where I had been saving files
│   ├── production_dag.py       ← never scanned, no log anywhere
│   └── sales_analytics_dag.py  ← a second copy, also never scanned
```

The problem is that Airflow's configured `dags_folder` points to `airflow-home/dags/`, but I had been saving and editing `production_dag.py` and `sales_analytics_dag.py` in the top-level `dags/` directory, which Airflow never scans.

As a result:

* `production_dag.py` has never been processed by the DAG processor (there are no logs for it).
* The only DAG Airflow has scanned is an older copy of `sales_analytics_dag.py` located in `airflow-home/dags/`, not the version I was editing.

## Fix — choose one

### Option A (fastest)

Copy the DAG files into the configured Airflow DAG directory:

```bash
cp /home/linda/Documents/myData/airflow-learning/dags/production_dag.py \
   /home/linda/Documents/myData/airflow-learning/airflow-home/dags/

cp /home/linda/Documents/myData/airflow-learning/dags/sales_analytics_dag.py \
   /home/linda/Documents/myData/airflow-learning/airflow-home/dags/
```

### Option B (recommended)

Configure Airflow to use the directory where I want to keep the DAGs.

Edit `airflow-home/airflow.cfg`:

```ini
[core]
dags_folder = /home/linda/Documents/myData/airflow-learning/dags
```

Then restart the scheduler or `airflow standalone` so the new configuration is loaded.

After either option, I would verify the configuration with:

```bash
export AIRFLOW_HOME=/home/linda/Documents/myData/airflow-learning/airflow-home

airflow config get-value core dags_folder
airflow dags list-import-errors
airflow dags list
```

If the DAGs still do not appear, I would restart the scheduler (or run `airflow dags reserialize`) instead of waiting for the default 5-minute scan interval.

## Airflow version compatibility

I also confirmed that the virtual environment is running **Airflow 3.3.0**, while the original DAG targeted Airflow 2.8.x.

The original DAG used two APIs that changed in Airflow 3:

* `schedule_interval=` → `schedule=`
* `context["execution_date"]` → `context["logical_date"]`

Without these changes, the DAG would raise a `KeyError` when a task executed under Airflow 3.

To fully align the project with Airflow 3, I also:

* Updated `dags/airflow_dag.py` for Airflow 3 compatibility.
* Rewrote the Airflow section of `setup_and_run.sh` to use the correct Airflow 3 workflow and avoid future `dags_folder` mismatches.
* Added a new diagnostic section (Section 10) that prints the configured DAG folder, its contents, import errors, and the DAGs currently detected by Airflow.
* Updated the runner's menu and case statement to include the new diagnostic option.
* Added a README note documenting this common `dags_folder` pitfall.
* Cleaned up the project, reran the test suite, and repackaged everything.

## Root cause

The root cause was that I had two different `dags/` directories:

* `airflow-home/dags/` is the directory Airflow actually monitors because it is inside `AIRFLOW_HOME`.
* The top-level `dags/` directory is where I had been editing my files, but Airflow never scanned it.

Because of this configuration mismatch, Airflow never reported an error—it simply never discovered the DAGs I was modifying.

## Quickest fix

```bash
cp /home/linda/Documents/myData/airflow-learning/dags/production_dag.py \
   /home/linda/Documents/myData/airflow-learning/airflow-home/dags/

cp /home/linda/Documents/myData/airflow-learning/dags/sales_analytics_dag.py \
   /home/linda/Documents/myData/airflow-learning/airflow-home/dags/
```

Then verify:

```bash
export AIRFLOW_HOME=/home/linda/Documents/myData/airflow-learning/airflow-home

airflow config get-value core dags_folder
airflow dags list-import-errors
airflow dags list
```

Alternatively, I can configure `dags_folder` to point to the top-level `dags/` directory if that is where I want to manage my DAGs.

## Summary of updates

I updated the following:

* `dags/airflow_dag.py` — made fully compatible with Airflow 3.
* `setup_and_run.sh` — rewrote the Airflow setup for Airflow 3, corrected `AIRFLOW_HOME`/`dags_folder` handling, and added **Section 10**, a one-command diagnostic (`bash setup_and_run.sh 10`) that reports the configured DAG folder, its contents, import errors, and the DAGs currently detected by Airflow.
* `README` — added documentation describing the `dags_folder` mismatch and how to avoid it in the future.
