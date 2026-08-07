# **CrewAI multi-agent research pipeline**. 

To run it, you need:

1. Python environment
2. Python packages
3. API keys (OpenAI + Serper search)
4. Project folder setup
5. A few code adjustments (there are some compatibility issues)

Below is a complete setup guide.

---

## 1. Install Python

Use **Python 3.10–3.12** (recommended).

Check:

```bash
python --version
```

or

```bash
python3 --version
```

Create a virtual environment:

```bash
python -m venv geoai-life-env
```

Activate it.

### Windows

```bash
geoai-life-env\Scripts\activate
```

### Linux / macOS

```bash
source geoai-life-env/bin/activate
```

---

# 2. Install required packages

Create:

```
requirements.txt
```

with:

```txt
crewai
crewai-tools
langchain-openai
python-dotenv
openai
```

Install:

```bash
pip install -r requirements.txt
```

You may also need:

```bash
pip install langchain-community
```

---

# 3. Get API keys

Your script needs two external services:

---

# A) OpenAI API key

You need an OpenAI developer API account.

Create an API key from:

[OpenAI Platform API Keys](https://platform.openai.com/api-keys?utm_source=chatgpt.com)

Create a key.

It will look like:

```
sk-proj-xxxxxxxxxxxxxxxx
```

---

# B) Serper Search API key

`SerperDevTool()` uses Google search through Serper.

Create an account:

[Serper API](https://serper.dev/?utm_source=chatgpt.com)

Get your key.

It looks like:

```
xxxxxxxxxxxxxxxxxxxxxxxx
```

---

# 4. Create environment file

In your project folder:

```
GeoAI_LIFE_Crew/
│
├── main.py
├── .env
├── requirements.txt
└── crew_outputs/
```

Create:

```
.env
```

Add:

```env
OPENAI_API_KEY=sk-proj-your-key-here

SERPER_API_KEY=your-serper-key-here
```

---

# 5. Modify your Python script

At the top add:

```python
from dotenv import load_dotenv

load_dotenv()
```

So the beginning becomes:

```python
from crewai import Agent, Task, Crew, Process
from crewai_tools import SerperDevTool
from langchain_openai import ChatOpenAI

from dotenv import load_dotenv

from pathlib import Path
from datetime import datetime
import os


load_dotenv()
```

---

# 6. Fix the OpenAI model setup

Your code currently uses:

```python
from langchain_openai import OpenAI
```

For GPT models use:

```python
from langchain_openai import ChatOpenAI
```

Replace:

```python
llm = OpenAI(
    model_name="GPT-4o-mini",
    temperature=0.2
)
```

with:

```python
llm = ChatOpenAI(
    model="gpt-4o-mini",
    temperature=0.2
)
```

---

# 7. Configure Serper

Replace:

```python
search_tool = SerperDevTool()
```

with:

```python
search_tool = SerperDevTool(
    api_key=os.getenv("SERPER_API_KEY")
)
```

---

# 8. Check your folder

You should have:

```
GeoAI_LIFE_Crew/

│
├── main.py
│
├── .env
│
├── requirements.txt
│
└── crew_outputs/
```

---

# 9. Run the pipeline

Activate your environment:

```bash
source geoai-life-env/bin/activate
```

Run:

```bash
python main.py
```

You should see:

```
## Agent: Scientific Literature Researcher
Starting task...

## Agent: Remote Sensing Specialist
Starting task...

...

CREW COMPLETED

Files saved in:
crew_outputs/run_20260802_1801
```

---

# 10. Output structure

The script creates:

```
crew_outputs/

└── run_20260802_1801/

    ├── 00_FINAL_LIFE_PROPOSAL.md

    ├── 01_LITERATURE_REVIEW.md

    ├── 02_DATA_INVENTORY.md

    ├── 03_CONNECTIVITY_FRAMEWORK.md

    ├── 04_LIFE_FUNDING_STRATEGY.md

    ├── 05_PROPOSAL_DRAFT.md

    └── 06_REVIEW_REPORT.md
```

You can open these in:

* VS Code
* Obsidian
* Typora
* GitHub Markdown viewer

---

# 11. Recommended additional packages for a scientific project

For a serious GeoAI/LIFE proposal workflow, I would add:

```bash
pip install pandas geopandas rasterio shapely pyproj
```

for GIS processing.

For notebooks:

```bash
pip install jupyterlab matplotlib seaborn
```

For literature:

```bash
pip install scholarly arxiv
```

For PDFs:

```bash
pip install pypdf pymupdf
```

---

# 12. Recommended project upgrade

Your current pipeline generates text proposals, but it does not actually process geospatial data.

A stronger architecture would add:

```
                 User
                  |
                  |
              CrewAI Manager
                  |
 ------------------------------------------------
 |              |              |                 |
Literature   EO Data       Ecology          LIFE EU
Agent        Agent         Agent            Agent
 |
 |
GIS Processing Layer
 |
 ------------------------------------------------
 |
Sentinel-2
Copernicus
LiDAR
GBIF
CORINE
Climate Data
 |
 |
GeoAI Models
 |
 |
Connectivity Maps
 |
 |
LIFE Proposal
```

Useful additions:

* Sentinel-2 access:

  * Copernicus Data Space API
* Biodiversity:

  * GBIF API
* Land cover:

  * CORINE Land Cover
* Species:

  * GBIF occurrence data
* Climate:

  * ERA5 / Copernicus Climate Data Store

---

# 13. Possible problems with your current code

### Problem 1 — GPT-4o-mini naming

Use:

```python
model="gpt-4o-mini"
```

not:

```python
GPT-4o-mini
```

---

### Problem 2 — CrewAI versions change

Install latest:

```bash
pip install --upgrade crewai crewai-tools
```

If you get import errors:

```bash
pip show crewai
```

Check the installed version.

---

### Problem 3 — API cost

Your workflow calls the model many times.

Approximate usage:

* Literature agent: medium
* Data agent: medium
* Connectivity agent: medium
* LIFE agent: medium
* Proposal writer: high
* Reviewer: medium

A full run may consume thousands of tokens.

For testing:

change:

```python
model="gpt-4o-mini"
```

which is the right choice.

---

# 14. Recommended first test

Before running the full LIFE pipeline, test APIs:

Create:

```python
from langchain_openai import ChatOpenAI

llm = ChatOpenAI(
    model="gpt-4o-mini"
)

print(
    llm.invoke(
        "Explain ecological corridors in one sentence"
    )
)
```

Run:

```bash
python test_openai.py
```

If it answers, your OpenAI API works.

---

After this setup your CrewAI pipeline should run and generate a complete GeoAI + LIFE EU proposal package automatically.
