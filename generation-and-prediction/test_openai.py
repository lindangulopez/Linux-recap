# ====================================================
# GeoAI + LIFE EU Proposal CrewAI Pipeline
# Greater Côa Valley Rewilding Project
# ====================================================

from crewai import Agent, Task, Crew, Process
from crewai_tools import SerperDevTool
from langchain_openai import OpenAI

from pathlib import Path
from datetime import datetime
import os


# ====================================================
# CONFIGURATION
# ====================================================

os.environ["OPENAI_MODEL_NAME"] = "GPT-4o-mini"


llm = OpenAI(
    model_name="GPT-4o-mini",
    temperature=0.2
)


search_tool = SerperDevTool()


# ====================================================
# MARKDOWN STORAGE
# ====================================================

RUN_DATE = datetime.now().strftime("%Y%m%d_%H%M")

OUTPUT_DIR = Path(
    f"crew_outputs/run_{RUN_DATE}"
)

OUTPUT_DIR.mkdir(
    parents=True,
    exist_ok=True
)


def save_markdown(filename, content):

    filepath = OUTPUT_DIR / filename

    with open(
        filepath,
        "w",
        encoding="utf-8"
    ) as file:

        file.write(str(content))

    print(f"Saved: {filepath}")



# ====================================================
# AGENTS
# ====================================================


literature_agent = Agent(
    role="Scientific Literature Researcher in GeoAI and Ecology",

    goal=(
        "Research scientific knowledge about GeoAI applications "
        "for ecological connectivity, biodiversity conservation "
        "and rewilding."
    ),

    backstory=(
        "A conservation scientist specialising in GIS, "
        "ecological modelling, biodiversity research "
        "and peer-reviewed literature analysis."
    ),

    tools=[search_tool],

    verbose=True,

    allow_delegation=False,

    llm=llm
)



data_agent = Agent(
    role="Remote Sensing and Environmental Data Specialist",

    goal=(
        "Identify geospatial datasets, satellite products "
        "and AI technologies useful for ecological connectivity "
        "monitoring in the Greater Côa Valley."
    ),

    backstory=(
        "A GIS and Earth Observation expert specialising "
        "in Sentinel, Copernicus, biodiversity datasets "
        "and spatial artificial intelligence workflows."
    ),

    tools=[search_tool],

    verbose=True,

    allow_delegation=False,

    llm=llm
)



connectivity_agent = Agent(
    role="Landscape Ecology and Connectivity Modelling Expert",

    goal=(
        "Design a GeoAI methodology for ecological connectivity "
        "analysis and restoration planning."
    ),

    backstory=(
        "A landscape ecologist experienced in habitat modelling, "
        "species distribution models, wildlife corridors "
        "and conservation planning."
    ),

    tools=[],

    verbose=True,

    allow_delegation=False,

    llm=llm
)



life_agent = Agent(
    role="LIFE EU Programme Funding Specialist",

    goal=(
        "Develop a LIFE EU funding strategy for a GeoAI-driven "
        "rewilding and ecological connectivity project."
    ),

    backstory=(
        "An EU funding consultant experienced in LIFE Nature, "
        "Biodiversity and Climate projects."
    ),

    tools=[search_tool],

    verbose=True,

    allow_delegation=False,

    llm=llm
)



proposal_agent = Agent(
    role="Senior LIFE EU Proposal Writer",

    goal=(
        "Transform scientific research into a competitive "
        "LIFE EU project proposal."
    ),

    backstory=(
        "An expert EU proposal writer experienced in integrating "
        "science, innovation, impacts and policy alignment."
    ),

    tools=[],

    verbose=True,

    allow_delegation=False,

    llm=llm
)



review_agent = Agent(
    role="LIFE EU Proposal Evaluator",

    goal=(
        "Evaluate and improve the LIFE proposal according "
        "to EU evaluation criteria."
    ),

    backstory=(
        "A former LIFE programme evaluator specialising "
        "in environmental innovation proposals."
    ),

    tools=[],

    verbose=True,

    allow_delegation=False,

    llm=llm
)



# ====================================================
# TASKS
# ====================================================


literature_task = Task(

    description="""
Research the scientific literature related to:

- GeoAI in biodiversity conservation
- Artificial intelligence for habitat mapping
- Ecological connectivity modelling
- Rewilding science
- Landscape restoration

Focus on Portugal and the Greater Côa Valley.

Identify:
- important publications
- methodologies
- research gaps
- opportunities for innovation
""",

    expected_output="""
A scientific literature review containing:

- key references
- methods
- lessons learned
- research opportunities
""",

    agent=literature_agent
)



data_task = Task(

    description="""
Identify datasets and technologies required for a GeoAI
ecological connectivity project.

Analyse:

- Sentinel satellite imagery
- Copernicus products
- LiDAR
- Land cover datasets
- Biodiversity databases
- Climate datasets
- AI platforms

Explain their role in connectivity monitoring.
""",

    expected_output="""
A technical data inventory including:

- dataset description
- provider
- resolution
- accessibility
- AI applications
- limitations
""",

    agent=data_agent
)



connectivity_task = Task(

    description="""
Develop a complete ecological connectivity methodology.

Include:

- habitat suitability modelling
- species distribution modelling
- resistance landscapes
- wildlife corridor identification
- graph theory approaches
- validation strategies
- monitoring indicators

Adapt everything to the Greater Côa Valley.
""",

    expected_output="""
A GeoAI methodological framework describing:

- workflow
- algorithms
- indicators
- validation
- implementation strategy
""",

    agent=connectivity_agent
)



life_task = Task(

    description="""
Analyse LIFE EU funding opportunities.

Study:

- LIFE Nature and Biodiversity priorities
- ecosystem restoration objectives
- ecological connectivity objectives
- digital innovation opportunities

Identify successful LIFE projects and lessons.
""",

    expected_output="""
A LIFE funding strategy containing:

- programme alignment
- innovation argument
- expected impacts
- project positioning
""",

    agent=life_agent
)



proposal_task = Task(

    description="""
Create a LIFE EU concept proposal using all previous reports.

The proposal must include:

- project title
- objectives
- innovation
- methodology
- work packages
- timeline
- partners
- deliverables
- KPIs
- risks
- budget structure
- LIFE alignment

The project supports Rewilding Portugal
and the Greater Côa Valley.
""",

    expected_output="""
A complete LIFE EU proposal concept document.
""",

    context=[

        literature_task,
        data_task,
        connectivity_task,
        life_task

    ],

    agent=proposal_agent
)



review_task = Task(

    description="""
Act as a LIFE EU evaluator.

Review the proposal for:

- scientific quality
- innovation
- feasibility
- European added value
- measurable impacts
- weaknesses
- risks

Provide improvement recommendations.
""",

    expected_output="""
A detailed evaluator report.
""",

    context=[proposal_task],

    agent=review_agent
)



# ====================================================
# CREW EXECUTION
# ====================================================


def main():

    crew = Crew(

        agents=[

            literature_agent,
            data_agent,
            connectivity_agent,
            life_agent,
            proposal_agent,
            review_agent

        ],

        tasks=[

            literature_task,
            data_task,
            connectivity_task,
            life_task,
            proposal_task,
            review_task

        ],

        process=Process.sequential,

        verbose=True,

        memory=True
    )


    result = crew.kickoff()



    # -----------------------------
    # Save final result
    # -----------------------------

    save_markdown(

        "00_FINAL_LIFE_PROPOSAL.md",

        result

    )


    # -----------------------------
    # Save individual outputs
    # -----------------------------

    outputs = {

        "01_LITERATURE_REVIEW.md":
            literature_task.output,

        "02_DATA_INVENTORY.md":
            data_task.output,

        "03_CONNECTIVITY_FRAMEWORK.md":
            connectivity_task.output,

        "04_LIFE_FUNDING_STRATEGY.md":
            life_task.output,

        "05_PROPOSAL_DRAFT.md":
            proposal_task.output,

        "06_REVIEW_REPORT.md":
            review_task.output

    }



    for filename, content in outputs.items():

        save_markdown(
            filename,
            content
        )


    print("\n==============================")
    print("CREW COMPLETED")
    print("==============================")

    print(
        f"Files saved in: {OUTPUT_DIR}"
    )



if __name__ == "__main__":

    main()
