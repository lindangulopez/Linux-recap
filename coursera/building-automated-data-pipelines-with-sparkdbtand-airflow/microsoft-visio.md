# Microsoft Visio: 

Imagine you want to show how information moves through a system, like how a package travels from a customer to a delivery center and then to the recipient. A Data Flow Diagram (DFD) does just that but for data instead of packages. It uses simple shapes to represent where data comes from (like website visitors), what happens to it (processing engines), and where it ends up (data stores or dashboards).

Using Microsoft Visio, you can easily create these diagrams with ready-made shapes. For example, you drag a shape for "Website Visitors" to show the data source, then add a "Stream Processing" shape to represent the system that handles the data, and finally a "Dashboard" shape where the processed data is stored. You connect these shapes with arrows to show the flow of data, and add labels like "JSON events, 1000 per sec" to explain what kind of data is moving and how often. This visual map helps teams understand and work with complex data systems clearly and quickly.

In a Data Flow Diagram (DFD), the standard symbols represent different components of data movement and processing. Here are the key symbols:

**External Entity (Source or Sink)**: Usually shown as a rectangle or square. Represents outside systems or users that send or receive data (e.g., Website Visitors).

**Process**: Shown as a rounded rectangle or circle. Represents a function or operation that transforms data (e.g., Stream Processing engine).

**Data Store**: Depicted as an open-ended rectangle or two parallel lines. Represents where data is stored (e.g., a database or dashboard).

**Data Flow**: Arrows that show the direction of data movement between entities, processes, and data stores. They are labeled to describe the data being transferred.

These symbols help create clear, standardized diagrams that everyone on the team can understand easily.

To improve a data flow diagram (DFD) for more complex systems, consider these approaches:

**Modularize the Diagram**: Break the system into smaller, manageable sub-processes or modules. Create separate DFDs for each module to keep diagrams clear and focused.

**Use Hierarchical Levels**: Start with a high-level overview (Level 0) showing major processes, then create detailed diagrams (Level 1, Level 2, etc.) that drill down into each process.

**Add Clear Annotations**: Include labels for data formats, volumes, and timing (e.g., "JSON events, 1000 per sec") to provide context and clarify data characteristics.

**Standardize Symbols and Naming**: Consistently use standard DFD symbols and clear, descriptive names for processes, data stores, and flows to avoid confusion.

**Incorporate Error Handling and Exceptions**: Show how the system handles errors or exceptions in data flow to make the diagram more robust.
These techniques help maintain clarity and usefulness as system complexity grows.

## Applying it to PEPR SolsVivants

In a federated ecosystem like PEPR SolsVivants, many systems act as both producers and consumers of data. For example, Data Terra or THEIA may provide environmental datasets while also receiving enriched metadata or references to new datasets. Rather than treating systems as simple sources or destinations, I model them as interconnected nodes within a data ecosystem.

My approach is to document three separate layers: the systems involved, the data flows between them, and the transformations that occur along the way.

### 1. System layer – What exists?

First, I identify every system and its role.

For each system, I document:

* Purpose and owner
* Types of data stored
* Interfaces (API, database, file exchange)
* Standards used (e.g., ISO 19115, Darwin Core, MIxS)
* Whether it is authoritative for specific datasets

This creates an application and data inventory.

### 2. Data flow layer – How does data move?

Next, I map the direction of every flow.

For each flow, I document:

* Source system
* Destination system
* Data exchanged
* Trigger (manual, scheduled, event-driven)
* Frequency
* Responsible stakeholder
* Authentication and permissions

Even if two systems exchange data in both directions, I represent these as **two distinct flows**, because they often involve different datasets, business rules, and responsibilities.

### 3. Transformation layer – What changes?

This is often the most important layer.

For every integration, I ask:

* Is the data copied, transformed, or simply referenced?
* Are metadata enriched?
* Are identifiers harmonized?
* Are ontologies or vocabularies mapped?
* Is quality control performed?
* Are derived indicators calculated?
* Is provenance recorded?

I document these transformations explicitly so the lineage of each dataset is transparent.


### Validation

Finally, I validate the architecture with both technical teams and researchers.

Researchers confirm whether the scientific meaning is preserved, while IT teams verify that the documented integrations reflect the actual implementation.

### For example, a microbiome dataset might be:

* Generated in a laboratory,
* Processed through a standardized multi-omics pipeline,
* Annotated with MIxS metadata,
* Linked to GIS Sol identifiers,
* Enriched with environmental variables from THEIA,
* Published through the PEPR platform,
* Exposed via APIs,
* Indexed by Data Terra,
* And referenced by GBIF when appropriate.

Although several platforms are involved, I wouldn't see this as one complex flow. I would break it into a sequence of smaller, well-defined integrations, each with clear ownership, metadata mappings, transformation rules, and provenance. That makes the architecture easier to understand, maintain, and evolve.

### A concise interview version (60–90 seconds)

> "I model complex systems at three levels: systems, data flows, and transformations.

First, I inventory each system and its role. Then I map every data exchange as a separate flow, even when two systems communicate bidirectionally, because each direction usually has different business rules. 

Finally, I document what happens to the data at each integration point—metadata enrichment, format conversion, ontology mapping, quality checks, identifier harmonization, or derived calculations. 

This gives complete data lineage and makes the architecture easier to maintain. In a federated project like PEPR SolsVivants, where platforms such as Data Terra, THEIA, and GIS Sol both consume and provide data, this layered approach supports interoperability while keeping responsibilities and transformations explicit."
