# Key points about SCD2:

Slowly Changing Dimension Type 2 (SCD2) for historical data tracking in data pipelines.

Key Components of SCD2

Business keys identify real-world entities like customer IDs but do not uniquely distinguish historical versions.
Surrogate keys are system-generated unique identifiers for each record version, enabling accurate history tracking.
Validity Periods and Current Status

Each record has VALID_FROM and VALID_TO timestamps marking its active period.
The ISCURRENT flag indicates the latest active record, simplifying queries for current data.
Change Detection and Implementation

Change detection logic compares incoming data with existing records to identify changes.
New records are created for changes, preserving historical data instead of overwriting.
Tools like dbt automate this process by defining change criteria declaratively.
Practical Application

### SCD2 preserves the full history of entities such as customers or products.

It supports both trend analysis and point-in-time reporting by maintaining all versions of data over time.

Slowly Changing Dimension Type 2 (SCD2) is a data management technique used in data warehousing to preserve the full history of changes in dimension data over time.

Instead of overwriting old data when a change occurs (like a customer address update), SCD2 creates a new record to capture the change.
This approach maintains a complete audit trail of historical data.
It allows analysts to answer questions about past states, such as "What was the customer's address at the time of a specific purchase?"
SCD2 is essential for accurate trend analysis and regulatory compliance in enterprise analytics.

### To implement SCD2 for tracking customer address changes, you typically follow these steps:

Add columns for tracking history, such as:

A unique surrogate key for each record.
Effective start date (when the record became valid).
Effective end date (when the record was superseded).
A current flag to indicate the active record.
When a customer's address changes:

Mark the existing record's end date as the day before the change.
Set its current flag to false.
Insert a new record with the updated address, a new surrogate key, the new start date, and current flag set to true.
This way, you preserve all previous addresses with their valid time periods, enabling historical analysis.
