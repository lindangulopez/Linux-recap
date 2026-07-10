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
