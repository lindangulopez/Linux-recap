#learn [django on coursera](https://www.coursera.org/learn/codio-advanced-django-building-blog/home/module/1)

Here's a complete set of instructions using **`django`** as the name of your virtual environment.

## 1. Clone your repository

```bash
git clone git@github.com:lindangulopez/codio-django.git
cd codio-django
```

---

## 2. Create a virtual environment named `django`

```bash
python3 -m venv django
```

If you get an error saying `venv` is missing, install it first:

```bash
sudo apt update
sudo apt install python3-venv
```

Then run:

```bash
python3 -m venv django
```

---

## 3. Activate the virtual environment

```bash
source django/bin/activate
```

Your prompt should now begin with:

```text
(django) linda@...
```

---

## 4. Upgrade `pip`

```bash
python -m pip install --upgrade pip
```

Verify Python is coming from your virtual environment:

```bash
python --version
pip --version
```

---

## 5. Install Django

```bash
pip install django
```

Verify the installation:

```bash
django-admin --version
```

---

## 6. Create a Django project

Since you're already inside the `codio-django` folder, run:

```bash
django-admin startproject config .
```

Notice the final `.` — it tells Django to create the project in the current directory.

Your folder should now look something like:

```text
codio-django/
├── config/
├── django/
├── manage.py
```

---

## 7. Create a `.gitignore`

Create a file named `.gitignore` with the following contents:

```gitignore
# Virtual environment
django/

# Python cache
__pycache__/
*.py[cod]

# SQLite database
db.sqlite3

# Environment variables
.env

# VS Code
.vscode/

# macOS
.DS_Store
```

---

## 8. Initialize the database

```bash
python manage.py migrate
```

---

## 9. Run the development server

```bash
python manage.py runserver
```

Open your browser and visit:

```text
http://127.0.0.1:8000
```

You should see Django's welcome page.

Stop the server with:

```text
Ctrl + C
```

---

## 10. Save your work to GitHub

Check what files have been created:

```bash
git status
```

Stage them:

```bash
git add .
```

Commit:

```bash
git commit -m "Create initial Django project"
```

Push to GitHub:

```bash
git push origin main
```

---

## 11. Verify your repository

Refresh your GitHub repository page. You should now see files such as:

```text
config/
manage.py
.gitignore
README.md (optional)
```

---

## 12. Next steps

Once this is working, you can continue learning Django by:

1. Creating your first app:

   ```bash
   python manage.py startapp blog
   ```

2. Registering the app in `config/settings.py`.

3. Creating your first model.

4. Creating a view and URL.

5. Building a template.

6. Using the Django admin.

These are the same core skills you'll need to understand and contribute to the `swh-osporadar` project later.
