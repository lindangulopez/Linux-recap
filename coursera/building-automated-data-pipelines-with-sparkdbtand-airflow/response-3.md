# Sync Frequency

For GlobalRetail Corp, sync frequency should be based on the **business value of freshness**, the **characteristics of each source**, and the **impact on source systems**.

| Data Source                  | Recommended Sync Frequency      | Reasoning                                                                                                                                                                                              |
| ---------------------------- | ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **PostgreSQL Database**      | **Every 6 hours**               | Customer and transactional database data usually does not require second-by-second updates. A 6-hour incremental sync provides reasonably fresh data while minimizing load on the production database. |
| **Kafka Streaming Platform** | **Continuous / Real-time sync** | Kafka is designed for event-driven workloads. Continuous ingestion ensures customer events, activity streams, and operational events are available with minimal delay.                                 |
| **REST API**                 | **Hourly sync**                 | API data often has freshness requirements but is limited by API quotas, rate limits, and request costs. Hourly synchronization provides a balance between freshness and resource usage.                |

### Recommended Connection Schedule

```text
PostgreSQL → Amazon S3
Sync: Every 6 hours
Example:
02:00, 08:00, 14:00, 20:00

Kafka → Amazon S3
Sync: Continuous streaming

REST API → Amazon S3
Sync: Every hour
```

### Why Different Schedules Are Appropriate

**PostgreSQL**

* Use incremental extraction where possible.
* Avoid unnecessary queries against operational databases.
* Provides updated customer and business records within acceptable latency.

**Kafka**

* Events lose value when delayed.
* Continuous processing supports real-time analytics and monitoring.
* Offset tracking ensures processing resumes correctly after interruptions.

**REST API**

* Avoid excessive API calls.
* Respect provider rate limits.
* Maintain enough freshness for use cases such as pricing, inventory, or external data updates.

### Final Recommendation

* **PostgreSQL:** 6-hour incremental sync
* **Kafka:** Continuous streaming sync
* **REST API:** Hourly scheduled sync

This combination gives GlobalRetail Corp a balance of **data freshness, reliability, cost control, and source-system protection**.
