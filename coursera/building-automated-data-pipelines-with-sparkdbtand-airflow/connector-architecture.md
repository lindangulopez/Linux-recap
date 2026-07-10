# Connector Architecture

## The key components of connector architecture are:

* **Source Definition**: Specifies the type of data source (database, streaming platform, API), required connection details, and authentication methods.

* **Connection Configuration**: Defines how the connector establishes and maintains the connection, including retry policies, timeouts, and credential management.

* **Stream Configuration**: Determines which data streams or tables to extract, how to handle incremental updates, and any filtering or transformation rules.

* **Destination Mapping**: Specifies where the extracted data should be loaded, such as data warehouses or cloud storage, to create a unified staging area.

These components work together to enable reliable, secure, and standardized data integration from multiple sources.

