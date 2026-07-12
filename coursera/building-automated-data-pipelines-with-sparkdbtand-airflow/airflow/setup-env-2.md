# Activate Airflow & create pwd

Use `cd` to move into the folder:

```bash
cd ~/Documents/myData/airflow-learning
```

Your prompt should then become:

```text
linda@...:~/Documents/myData/airflow-learning$
```

Now continue:

### Activate Airflow environment

```bash
source airflow-env/bin/activate
```

You should see:

```text
(airflow-env) linda@...:~/Documents/myData/airflow-learning$
```

### Set Airflow Home

```bash
export AIRFLOW_HOME=~/Documents/myData/airflow-learning/airflow-home
```

### Start scheduler (Terminal 1)

```bash
airflow scheduler
```

Leave it running.

Then open another terminal and repeat:

```bash
cd ~/Documents/myData/airflow-learning
source airflow-env/bin/activate
export AIRFLOW_HOME=~/Documents/myData/airflow-learning/airflow-home
airflow api-server --port 8082
```

Then open:

```text
http://localhost:8082
```

You are in the right place now — the only issue was missing `cd`.

You are using **Airflow 3.x with the Simple Auth Manager**, which is why you see:

> Simple auth manager enabled

In this setup, the username is usually the one you configured, but the password is **not displayed anywhere after creation**.

Your username is likely:

```text
lindangulopez
```

The password is the one you set when the user was created. If you do not remember it, reset it.

---

### 1. Stop the Airflow API server temporarily

In the terminal running:

```bash
airflow api-server --port 8082
```

press:

```text
CTRL + C
```

---

### 2. Reset the password

From your Airflow project:

```bash
cd ~/Documents/myData/airflow-learning

source airflow-env/bin/activate

export AIRFLOW_HOME=~/Documents/myData/airflow-learning/airflow-home
```

Run:

```bash
airflow users reset-password --username lindangulopez
```

It will ask:

```text
Password:
Repeat for confirmation:
```

Enter a new password.

---

### 3. Restart the API server

Run:

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
<the new password you just created>
```

---

### If the user does not exist

Check users:

```bash
airflow users list
```

If you see no `lindangulopez`, create it:

```bash
airflow users create \
--username lindangulopez \
--firstname Linda \
--lastname Lopez \
--role Admin \
--email linda@example.com
```

Then set the password when prompted.

---

For your GitHub project, I would also update your README because the original instructions used the older Airflow 2.x user flow. Airflow 3.x changed authentication and the UI startup commands.

