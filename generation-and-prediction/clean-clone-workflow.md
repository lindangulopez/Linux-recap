# clean clone workflow

---

## 1. Remove the Git repository you just created

From:

```bash
cd /home/linda/Documents/myData/crewai_agents/crewai
```

Remove only Git metadata:

```bash
rm -rf .git
```

Your files remain.

---

## 2. Go to your projects folder

```bash
cd /home/linda/Documents/myData
```

---

## 3. Clone the GitHub repository

```bash
git clone git@github.com:coa-connectivity-lab/crewai.git
```

Now you should have:

```text
/home/linda/Documents/myData/

├── crewai/                 <-- NEW GitHub clone
│   └── .git/
│
└── crewai_agents/
    └── crewai/             <-- your local CrewAI environment
```

---

## 4. Copy only your source files into the clone

Copy:

```bash
cp /home/linda/Documents/myData/crewai_agents/crewai/research_file.py \
/home/linda/Documents/myData/crewai/
```

Copy README:

First check its name:

```bash
ls /home/linda/Documents/myData/crewai_agents/crewai
```

You have:

```text
README.md
```

so:

```bash
cp /home/linda/Documents/myData/crewai_agents/crewai/README.md \
/home/linda/Documents/myData/crewai/
```

Copy requirements:

```bash
cp /home/linda/Documents/myData/crewai_agents/crewai/requirements.txt \
/home/linda/Documents/myData/crewai/
```

---

## 5. Create `.gitignore` in the clone

Go to:

```bash
cd /home/linda/Documents/myData/crewai
```

Create:

```bash
touch .gitignore
```

Put:

```gitignore
bin/
lib/
lib64/
include/
pyvenv.cfg

.venv/
venv/

.env
.env.*

crew_outputs/

__pycache__/
*.pyc

.vscode/
.idea/
```

---

## 6. Commit and push the clone

Check:

```bash
git status
```

You should see:

```text
README.md
research_file.py
requirements.txt
.gitignore
```

Then:

```bash
git add .
git commit -m "Initial GeoAI CrewAI pipeline"
git push -u origin main
```

---

Your final setup will be:

```text
myData/

├── crewai/                         <-- GitHub repository
│   ├── .git/
│   ├── README.md
│   ├── research_file.py
│   ├── requirements.txt
│   └── .gitignore
│
└── crewai_agents/
    └── crewai/                     <-- local runtime
        ├── bin/
        ├── lib/
        ├── .env
        └── crew_outputs/
```

This is the clean separation between **code repository** and **local AI environment**.
