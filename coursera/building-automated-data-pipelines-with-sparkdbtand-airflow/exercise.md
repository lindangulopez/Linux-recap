# Exercise: Multi-Source Data Integration with Database, Streaming, and API Connectors

## Overview

Modern data platforms require integrating data from multiple sources, including databases, streaming platforms, and REST APIs, into a unified staging environment.

In this exercise, you will design and configure production-ready multi-source pipelines using standardized connector patterns, secure authentication practices, and a medallion architecture.

You will work with:

- PostgreSQL database sources
- Kafka streaming sources
- REST API sources
- Amazon S3 staging destinations

---

# Learning Objectives

By completing this exercise, you will be able to:

- Configure database, streaming, and API connectors
- Apply standardized connector configuration patterns
- Establish a unified staging layer using medallion architecture
- Select appropriate synchronization schedules
- Implement secure credential management practices
- Monitor and troubleshoot data pipelines

---

# Exercise Scenario

Your organization needs to integrate three data sources into an Amazon S3 staging area:

1. Customer data stored in PostgreSQL
2. Real-time events from Kafka
3. Pricing information from a REST API

Your goal is to configure reliable ingestion pipelines that follow production best practices.

---

# Exercise 1: Understand the Standardized Connector Pattern

## Background

All connectors follow a common framework:

```
Source Configuration
        ↓
Authentication
        ↓
Stream Selection
        ↓
Sync Pattern
        ↓
Destination
```

Although the workflow is consistent, each source type has unique configuration requirements.

## Task

Complete the source-specific configuration requirements.

| Source Type | Required Configuration |
|-------------|------------------------|
| Database | Host, database name, port, table selection |
| Streaming | Bootstrap servers, topic subscriptions, consumer groups |
| API | Base URL, endpoints, pagination, rate limits |

## Checkpoint

Answer:

1. What connector framework is shared across all source types?
2. Which parameters are specific to each source?

---

# Exercise 2: Configure a PostgreSQL Connector

## Scenario

Customer information is stored in PostgreSQL.

## Connection Details

Configure the database connection:

```
Host: db.company.internal:5432

Database: customer_data

SSL/TLS: Enabled
```

## Authentication Requirements

Configure secure authentication:

- Use IAM roles or secure password management
- Do not store passwords in configuration files
- Use secret management tools where possible

## Stream Selection

Configure extraction:

- Identify required tables
- Select sync strategy:
  - Incremental sync for ongoing updates
  - Full sync for complete refreshes

## Sync Schedule

Configure:

```
Frequency: Every 6 hours

Example Schedule:
2 AM
8 AM
2 PM
8 PM
```

## Validation Tasks

Verify:

- [ ] Connection succeeds
- [ ] Credentials are valid
- [ ] Required tables are accessible
- [ ] Initial sync completes successfully
- [ ] Errors are monitored for 24 hours

---

# Exercise 3: Configure a Kafka Streaming Connector

## Scenario

Customer events are generated continuously through Kafka.

## Bootstrap Server Configuration

Configure:

```
Bootstrap Server:

kafka-cluster.company.com:9092
```

## Authentication

Configure secure access:

- Use SASL/SCRAM authentication
- Avoid basic authentication in production

## Topic Subscription

Configure topic selection:

```
Topic Pattern:

user_events.*
```

## Offset Management

Configure event tracking:

- Kafka maintains partition offsets
- Connector resumes from the last processed offset after restart
- Prevents duplicate processing and data loss

## Sync Pattern

Configure:

```
Mode:

Continuous streaming
```

## Validation Tasks

Verify:

- [ ] Connector connects to Kafka
- [ ] Topics are discovered
- [ ] Events are consumed successfully
- [ ] Restart behavior resumes from the correct offset

---

# Exercise 4: Configure a REST API Connector

## Scenario

Product pricing data is available through a REST API.

## API Configuration

Configure:

```
Base URL:

https://api.pricing-service.com/v1


Endpoint:

/products/prices
```

Full endpoint:

```
https://api.pricing-service.com/v1/products/prices
```

## Authentication

Configure one of:

- API key authentication
- OAuth 2.0
- JWT token authentication

Requirements:

- Store credentials securely
- Never hardcode tokens

## Pagination

Configure pagination handling.

Example:

```
API response limit:

100 records per request
```

The connector must retrieve all pages until the dataset is complete.

## Rate Limiting

Configure:

- Request limits
- Backoff strategies
- Rate limit header handling

Example:

```
Limit:

100 requests/hour
```

## Sync Schedule

Configure:

```
Frequency:

Hourly
```

## Validation Tasks

Verify:

- [ ] Authentication works
- [ ] Pagination retrieves complete datasets
- [ ] Rate limits are respected
- [ ] Data freshness meets requirements

---

# Exercise 5: Design the Unified Staging Architecture

## Task

Create a medallion architecture in Amazon S3.

## Required Layers

### Bronze Layer

Purpose:

- Store raw extracted data
- Preserve original source format

Example:

```
s3://staging/bronze/postgresql/

s3://staging/bronze/kafka/

s3://staging/bronze/api/
```

---

### Silver Layer

Purpose:

- Standardize schemas
- Apply validation rules
- Clean and transform data

---

### Gold Layer

Purpose:

- Provide analytics-ready datasets
- Support reporting and business applications

---

## Validation Questions

Explain how this architecture provides:

- Data lineage
- Query efficiency
- Retention management
- Data provenance

---

# Exercise 6: Implement Secure Credential Management

## Task

Configure secure credential handling.

## Secrets Management

Store:

- Database passwords
- API keys
- Kafka credentials

Do not:

- Store credentials in configuration files
- Commit secrets to source control

---

## Dynamic Credential Retrieval

Configure connectors to:

- Retrieve credentials during runtime
- Avoid local credential storage
- Support credential rotation

---

## IAM Roles

Configure:

- S3 access using IAM roles
- Temporary credentials
- Least-privilege permissions
- Audit logging

---

## SSL/TLS Requirements

Enable encryption:

Database:

```
ssl=true
```

API:

```
https://
```

Kafka:

```
SSL certificate configuration
```

---

# Exercise 7: Configure Connections and Sync Schedules

## Required Connections

Create:

| Source | Destination | Sync Schedule |
|--------|-------------|---------------|
| PostgreSQL | S3 | Every 6 hours |
| Kafka | S3 | Continuous |
| REST API | S3 | Hourly |

---

## Scheduling Decisions

Explain why:

### PostgreSQL

6-hour sync:

- Meets business requirements
- Reduces source database load

### Kafka

Continuous sync:

- Provides real-time event availability

### REST API

Hourly sync:

- Balances freshness
- Respects API limits
- Controls costs

---

## Monitoring Tasks

Configure monitoring for:

- Connection status
- Sync success rate
- Data volume
- Sync duration
- Failed runs
- Error alerts

---

# Exercise 8: Execute a Phased Deployment

## Phase 1: Database Integration

Complete:

- PostgreSQL connector setup
- Data quality validation
- Monitoring configuration

Duration:

```
1 week testing period
```

---

## Phase 2: Streaming Integration

Complete:

- Kafka connector setup
- Offset validation
- Event flow monitoring

---

## Phase 3: API Integration

Complete:

- REST API connector setup
- Pagination testing
- Rate limit validation

---

# Final Deployment Checklist

Before production release:

- [ ] All connectors are operational
- [ ] Monitoring dashboards are configured
- [ ] Alerts are enabled
- [ ] Documentation is complete
- [ ] Teams understand support procedures

---

# Key Takeaways

## Standardized Connector Pattern

Database, Kafka, and API connectors use the same high-level workflow while requiring source-specific settings.

## Secure Authentication

Never hardcode credentials.

Use:

- Secrets managers
- IAM roles
- SSL/TLS encryption

## Unified Staging

Organize data by:

- Source
- Date
- Medallion layer

## Appropriate Sync Frequency

Match schedules to source behavior:

- Databases: every 6 hours
- Streaming: continuous
- APIs: hourly

## Incremental Implementation

Deploy one connector at a time:

1. Database
2. Streaming
3. API

This reduces risk and simplifies troubleshooting.

## Monitoring

Reliable pipelines require:

- Visibility
- Alerts
- Error tracking
- Data quality checks

## Data Lineage

Maintain documentation showing:

- Data origin
- Transformations applied
- Destination location

---

# Final Implementation Workflow

Complete the following sequence:

1. Configure database connector pattern
2. Validate database extraction
3. Add Kafka streaming connector
4. Validate event processing
5. Add REST API connector
6. Build medallion staging architecture
7. Configure credential management
8. Create sync schedules
9. Monitor and optimize pipelines

---

## Success Criteria

You have completed the exercise when:

- PostgreSQL, Kafka, and REST API data successfully land in S3
- Credentials are securely managed
- Sync schedules match source requirements
- Monitoring and alerting are operational
- Data lineage is documented

Multi-source integration enables organizations to manage unified, reliable data pipelines instead of maintaining isolated systems.
