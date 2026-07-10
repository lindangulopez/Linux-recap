# Amazon S3 Staging Area

All data should land in a centralized Amazon S3 staging area and be organized using a medallion architecture to separate raw ingestion, cleaned data, and analytics-ready datasets.

## Recommended S3 Organization

├── Bronze (Raw Data)
│   ├── postgresql/
│   │   └── customer_data/
│   ├── kafka/
│   │   └── user_events/
│   └── api/
│       └── pricing_data/
│
├── Silver (Standardized Data)
│   ├── customer/
│   ├── events/
│   └── pricing/
│
└── Gold (Analytics-Ready Data)
    ├── customer_360/
    ├── marketing_segments/
    └── business_reports/

### Organization Principles

**Bronze layer**: Store data exactly as extracted from PostgreSQL, Kafka, and REST APIs to preserve source history and enable replay.
**Silver layer**: Clean, validate, and standardize schemas across sources.
**Gold layer**: Create business-ready datasets for analytics, reporting, and personalization.

### Additional Best Practices
Organize data by source type, date, and ingestion time for easier querying and retention management.
Maintain data lineage to track where data originated and how it was transformed.
Apply access controls and encryption to protect sensitive customer information.

This structure gives GlobalRetail Corp a unified staging platform while keeping raw data available, processed data consistent, and analytics data easy to consume.
