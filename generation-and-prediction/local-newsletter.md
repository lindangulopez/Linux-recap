# Local Setup Instructions — Create and Run Newsletter CrewAI Crew

## 1. Go to the project folder

```bash
cd ~/Documents/myData/crewai_agents/crewai
```

Your folder should contain:

```
newsletter_file.py
research_file.py
README.md
requirements.txt
.env
bin/
```

---

## 2. Activate the CrewAI virtual environment

```bash
source bin/activate
```

You should see:

```bash
(crewai) linda@...
```

Check Python:

```bash
which python
```

Expected:

```
/home/linda/Documents/myData/crewai_agents/crewai/bin/python
```

Always use `python`, **not** `/usr/bin/python3`.

---

## 3. Install dependencies

If not already installed:

```bash
pip install -r requirements.txt
```

Required packages:

```
crewai
crewai-tools
python-dotenv
openai
```

If missing:

```bash
pip install python-dotenv
```

---

## 4. Create your `.env` file

Inside:

```
~/Documents/myData/crewai_agents/crewai/.env
```

Add:

```env
OPENAI_API_KEY=your_openai_key_here
SERPER_API_KEY=your_serper_key_here
```

Check that it loads:

```bash
python
```

Then:

```python
from dotenv import load_dotenv
import os

load_dotenv()

print(os.getenv("OPENAI_API_KEY"))
print(os.getenv("SERPER_API_KEY"))
```

Exit:

```python
exit()
```

---

## 5. Create the newsletter crew file

Create:

```bash
touch newsletter_file.py
```

Add the CrewAI pipeline containing:

### Agents

```
Research Agent
        |
        v
Trend Analysis Agent
        |
        v
Newsletter Writer Agent
        |
        v
Audience Optimisation Agent
        |
        v
Editor Agent
```

### Functions

The file should include:

* environment loading
* OpenAI LLM configuration
* Serper search tool
* agent definitions
* task definitions
* Crew execution
* Markdown output saving

---

## 6. Run the newsletter crew

From the project folder:

```bash
python newsletter_file.py
```

Do **not** run:

```bash
/usr/bin/python3 newsletter_file.py
```

because it uses the wrong Python environment.

---

## 7. Check generated outputs

After completion:

```bash
ls crew_outputs
```

You should see:

```
newsletter_YYYYMMDD_HHMM/
```

Inside:

```
00_FINAL_NEWSLETTER.md
01_RESEARCH_BRIEF.md
02_NEWSLETTER_STRATEGY.md
03_NEWSLETTER_DRAFT.md
04_AUDIENCE_OPTIMISATION.md
05_FINAL_NEWSLETTER.md
```

---

## 8. Daily workflow

Every time you want to run it:

```bash
cd ~/Documents/myData/crewai_agents/crewai

source bin/activate

python newsletter_file.py
```

The system stays completely local:

* no Git required
* no deployment required
* outputs saved locally
* only external calls are OpenAI + Serper APIs.
