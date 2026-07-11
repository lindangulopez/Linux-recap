# Connector Architecture

## The key components of connector architecture are:

* **Source Definition**: Specifies the type of data source (database, streaming platform, API), required connection details, and authentication methods.

* **Connection Configuration**: Defines how the connector establishes and maintains the connection, including retry policies, timeouts, and credential management.

* **Stream Configuration**: Determines which data streams or tables to extract, how to handle incremental updates, and any filtering or transformation rules.

* **Destination Mapping**: Specifies where the extracted data should be loaded, such as data warehouses or cloud storage, to create a unified staging area.

These components work together to enable reliable, secure, and standardized data integration from multiple sources.

## Streaming Connector Configuration

Streaming connectors require bootstrap server details instead of database hosts and use secure authentication methods.

Topic subscriptions replace table selections, and message position tracking ensures no data duplication or gaps.
API Connector Configuration

API connectors use base URLs and endpoints instead of database hosts, with diverse authentication methods like API keys or OAuth 2.0.

Pagination handles limited API response sizes by requesting data in pages to avoid overwhelming endpoints.
Unified Staging and Configuration Consistency

Data from databases, streams, and APIs can be staged uniformly with raw, standardized, and analytics layers.
The configuration workflow—defining connection details, authentication, stream selection, and sync modes—is consistent across all connector types, simplifying multisource integration.

