# Kafka connector failure

You would detect a Kafka connector failure through **monitoring metrics, alerts, and data freshness checks**.

### How to Detect the Problem

* **Monitor Kafka consumer lag**

  * A growing lag means the connector is not keeping up with incoming events or has stopped consuming.
* **Check connector status**

  * Look for failed, paused, or stopped connector states.
* **Monitor event throughput**

  * A sudden drop to zero processed messages indicates a potential issue.
* **Set data freshness alerts**

  * Alert when expected event data stops arriving in the staging layer.
* **Review logs**

  * Look for authentication failures, network errors, offset errors, or schema issues.

### Immediate Response Steps

1. **Confirm the failure**

   * Check connector health status and recent logs.
   * Verify whether the issue is with the connector, Kafka broker, or source event production.

2. **Check common causes**

   * Expired SASL/SCRAM credentials
   * Kafka broker connectivity issues
   * Topic permission changes
   * Consumer group problems
   * Schema compatibility failures
   * Resource exhaustion

3. **Restart or recover the connector**

   * Restart the connector if it is stuck.
   * Confirm it resumes from the last committed offset to avoid data loss.

4. **Validate event recovery**

   * Check that consumer lag is decreasing.
   * Confirm events are landing correctly in the S3 staging area.

5. **Prevent recurrence**

   * Update alerts if detection was delayed.
   * Fix root causes (credential rotation, resource scaling, schema handling).
   * Document the incident and recovery steps.

### Example Monitoring Flow

```text
Kafka Topics
     |
     ↓
Kafka Connector
     |
     ↓
S3 Bronze Layer

Monitor:
- Connector status
- Consumer lag
- Events processed/minute
- Failed records
- Data freshness
```

The key indicator is usually **consumer lag**: if lag continues increasing while new events are being produced, the connector is not processing data fast enough or has stopped entirely.

When a pricing REST API rate-limits requests, the connector may receive responses such as **HTTP 429 (Too Many Requests)**. If not handled properly, data freshness will decrease, sync jobs may fail, and the API provider could temporarily block access.

### What Happens During Rate Limiting

* API requests are rejected or delayed.
* Pricing data may become stale in the staging area.
* Repeated retries without control can increase the problem.
* Scheduled sync jobs may fail or overlap with the next run.

### Connector Design for Graceful Handling

**1. Implement exponential backoff retries**

* Wait progressively longer between retry attempts.

Example:

```
Retry 1: Wait 30 seconds
Retry 2: Wait 2 minutes
Retry 3: Wait 10 minutes
```

This prevents overwhelming the API.

**2. Respect API rate-limit headers**

* Monitor headers such as:

  * Remaining request quota
  * Retry-after duration
  * Reset time

The connector should adjust its request rate automatically.

**3. Use pagination efficiently**

* Retrieve data in manageable batches.
* Avoid requesting unnecessary records.
* Store the last successful page/checkpoint so processing can resume.

**4. Schedule intelligently**

* Avoid running large sync jobs during peak API usage periods.
* Use hourly syncs or incremental updates instead of frequent full refreshes.

**5. Add monitoring and alerts**
Track:

* Number of API failures
* Rate-limit events
* Sync delays
* Data freshness

Alert when pricing data becomes outdated beyond an acceptable threshold.

**6. Cache or stage previously retrieved data**

* Keep the last successful pricing snapshot.
* Continue serving valid data while waiting for the API limit to reset.

### Example Flow

```text
REST API
    |
    ↓
Connector checks rate limits
    |
    ├── Available quota → Fetch data
    |
    └── Rate limited → Wait + Retry with backoff
                         |
                         ↓
                  Resume from checkpoint
                         |
                         ↓
                    S3 Bronze Layer
```

The goal is to make the connector **resilient rather than aggressive**: respect the API provider’s limits, avoid unnecessary failures, and ensure GlobalRetail Corp continues receiving reliable pricing data even during periods of high API usage.

