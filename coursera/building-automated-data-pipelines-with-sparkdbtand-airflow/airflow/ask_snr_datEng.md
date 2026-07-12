# Senior Data Engineer Apache Airflow Interview Tips

## Section 1 — Airflow Fundamentals

---

## 1. What is Apache Airflow?

### Answer

Apache Airflow is a workflow orchestration platform used to define, schedule, monitor, and manage data pipelines.

Airflow focuses on:

* Workflow dependencies
* Scheduling
* Task execution
* Monitoring
* Retry handling

Airflow does not replace processing engines like Spark or Snowflake.

Example:

```
Airflow
   |
   +--> Extract data
   |
   +--> Run Spark job
   |
   +--> Execute SQL transformation
   |
   +--> Validate output
```

---

# 2. Explain Airflow architecture.

### Answer

Main components:

| Component   | Responsibility                  |
| ----------- | ------------------------------- |
| Scheduler   | Creates and schedules task runs |
| Executor    | Determines how tasks execute    |
| Worker      | Runs task code                  |
| Metadata DB | Stores workflow state           |
| Web Server  | Provides UI                     |
| DAG Files   | Define workflows                |

Flow:

```
DAG
 |
Scheduler
 |
Executor
 |
Worker
 |
External Systems
```

---

# 3. What is a DAG?

### Answer

A Directed Acyclic Graph represents a workflow where:

* Nodes = tasks
* Edges = dependencies
* No circular dependencies

Example:

```
Extract
   |
Transform
   |
Load
```

---

# 4. Why must DAGs be acyclic?

### Answer

Airflow needs deterministic execution order.

A cycle creates ambiguity:

```
Task A → Task B → Task A
```

The scheduler cannot determine completion.

---

# 5. Difference between DAG and task?

### Answer

DAG:

* Entire workflow

Task:

* Individual unit of execution

Example:

```
DAG:
Customer Pipeline

Tasks:
- Extract customers
- Clean data
- Load warehouse
```

---

# Section 2 — Scheduling

---

# 6. How does Airflow scheduling work?

### Answer

The scheduler:

1. Parses DAG files
2. Checks schedules
3. Creates DAG runs
4. Determines runnable tasks
5. Sends tasks to executor

---

# 7. What happens when a DAG run fails?

### Answer

Depends on configuration:

1. Retry task
2. Wait using backoff
3. Mark failed
4. Trigger callbacks
5. Alert engineers

---

# 8. Explain catchup.

### Answer

Catchup determines whether Airflow runs missed historical schedules.

Example:

DAG:

```
Daily schedule
```

Airflow was offline:

```
July 1
July 2
July 3
```

Catchup=True:

Runs missing dates.

Catchup=False:

Only runs current schedule.

---

# 9. Difference between execution date and actual runtime?

### Answer

Execution date represents the data interval being processed.

Example:

A DAG running July 10 may process:

```
July 9 data
```

because the execution date represents the logical period.

---

# 10. How do you prevent too many DAG runs?

### Answer

Use:

* max_active_runs
* concurrency limits
* pools

Example:

```python
max_active_runs=1
```

---

# Section 3 — Operators and Tasks

---

# 11. What is an Operator?

### Answer

An Operator defines a task action.

Examples:

* PythonOperator
* BashOperator
* SQL operators
* KubernetesPodOperator

---

# 12. PythonOperator vs KubernetesPodOperator?

### Answer

PythonOperator:

Good for:

* Small Python logic
* API calls
* Metadata operations

KubernetesPodOperator:

Good for:

* Heavy workloads
* Containerized jobs
* Different dependencies

---

# 13. Should business logic live inside DAG files?

### Answer

No.

Better:

```
DAG
 |
Calls
 |
Python Package
 |
Business Logic
```

Benefits:

* Testing
* Reuse
* Maintainability

---

# 14. What is XCom?

### Answer

XCom allows tasks to exchange small amounts of metadata.

Example:

Task A:

```
returns file location
```

Task B:

```
uses file location
```

Avoid storing:

* Large datasets
* Dataframes
* Files

---

# 15. How do you pass large data between tasks?

### Answer

Do not use XCom.

Use:

* S3
* Data warehouse tables
* Object storage
* Database tables

---

# Section 4 — Reliability

---

# 16. How do you design reliable Airflow pipelines?

### Answer

Use:

✅ Retries
✅ Backoff
✅ Idempotency
✅ Validation
✅ Monitoring
✅ Alerts

---

# 17. Explain idempotency.

### Answer

A task produces the same result when executed multiple times.

Example:

Good:

```
Replace partition for date
```

Bad:

```
Insert duplicate rows every retry
```

---

# 18. How do you handle API failures?

### Answer

Use:

* Retry
* Exponential backoff
* Timeout
* Rate limiting
* Circuit breaker pattern

---

# 19. How do you handle schema changes?

### Answer

Options:

* Schema validation
* Versioned schemas
* Compatibility checks
* Data contracts

---

# 20. How do you recover from failed pipelines?

### Answer

Process:

```
Identify failure
      |
Fix issue
      |
Clear failed tasks
      |
Rerun
      |
Validate output
```

---

# Section 5 — Scaling Airflow

---

# 21. How do you scale Airflow?

### Answer

Scale:

* Scheduler
* Workers
* Database
* Executor

Architecture:

```
Scheduler

   |

Executor

   |

Many Workers
```

---

# 22. CeleryExecutor vs KubernetesExecutor?

### Answer

Celery:

* Persistent workers
* Message queue based

Kubernetes:

* Dynamic pods
* Better isolation
* Cloud native

---

# 23. When would you use KubernetesExecutor?

### Answer

Use when:

* Cloud deployment
* Different resource requirements
* Large workloads
* Need auto scaling

---

# 24. How do you optimize scheduler performance?

### Answer

Improve:

* DAG parsing
* Database queries
* Number of DAG files
* Task creation

Avoid:

* Heavy code during DAG parsing

---

# 25. What are Airflow pools?

### Answer

Pools limit resource usage.

Example:

Database supports:

```
20 connections
```

Create pool:

```
database_pool = 20
```

---

# Section 6 — Data Engineering Design

---

# 26. How would you design a daily ETL pipeline?

### Answer

Architecture:

```
Sources

 |

Extract

 |

Validation

 |

Transform

 |

Warehouse

 |

Quality Checks

 |

Alerts
```

---

# 27. How do you process billions of records?

### Answer

Airflow should orchestrate:

```
Airflow

 |

Spark

 |

Distributed Processing

 |

Warehouse
```

Do not process billions of rows inside PythonOperator.

---

# 28. How do you handle incremental loading?

### Answer

Use:

* Watermarks
* Updated timestamps
* Change data capture
* Partition filters

Example:

```
WHERE updated_at > last_success_time
```

---

# 29. How do you handle late arriving data?

### Answer

Use:

* Sliding windows
* Reprocessing
* Backfills

Example:

```
Process yesterday

+

Reprocess previous 7 days
```

---

# 30. How do you ensure data quality?

### Answer

Validate:

Before:

* Schema
* Availability

During:

* Null checks
* Business rules

After:

* Counts
* Reconciliation

---

# Section 7 — Monitoring and Operations

---

# 31. What should you monitor?

### Answer

Pipeline metrics:

* Duration
* Failures
* SLA misses

Data metrics:

* Freshness
* Volume
* Accuracy

---

# 32. How do you avoid alert fatigue?

### Answer

Use:

* Severity levels
* Deduplication
* Ownership
* Actionable alerts

---

# 33. What should a good alert contain?

### Answer

Include:

* DAG name
* Task name
* Error message
* Execution date
* Owner
* Retry status

---

# 34. How do you monitor Airflow itself?

### Answer

Monitor:

* Scheduler health
* Worker availability
* Metadata DB performance
* Queue size

---

# 35. How do you debug a slow DAG?

### Answer

Check:

1. Task duration
2. Worker resources
3. External dependencies
4. Database performance
5. Scheduler delays

---

# Section 8 — Security

---

# 36. How do you manage secrets?

### Answer

Use:

* Airflow Connections
* AWS Secrets Manager
* Vault
* Cloud secret stores

Never:

```
password="abc123"
```

---

# 37. How do you secure Airflow?

### Answer

Implement:

* RBAC
* Authentication
* Encryption
* Network security
* Audit logging

---

# Section 9 — Advanced Scenarios

---

# 38. A DAG takes 10 hours instead of 1 hour. What do you do?

### Answer

Investigate:

1. Task duration changes
2. Data volume increase
3. External systems
4. Worker resources
5. Parallelism

---

# 39. A task keeps retrying forever. Solution?

### Answer

Check:

* Retry configuration
* Failure type
* Logs
* Dependency failures

Add:

* Retry limits
* Failure alerts

---

# 40. Scheduler is slow. What do you check?

### Answer

Check:

* DAG parsing time
* Metadata database
* Number of DAGs
* Scheduler CPU

---

# Section 10 — Senior-Level Design Answers

---

# 41. How would you design a multi-team Airflow platform?

### Answer

Provide:

* Shared Airflow cluster
* Team ownership
* RBAC
* Separate DAG folders
* Monitoring standards
* Deployment pipelines

---

# 42. How do you handle hundreds of DAGs?

### Answer

Use:

* DAG standards
* Templates
* CI/CD
* Testing
* Ownership metadata

---

# 43. How do you deploy Airflow changes?

### Answer

Pipeline:

```
Git

 |

Tests

 |

Build

 |

Deploy

 |

Validate
```

---

# 44. How do you test Airflow DAGs?

### Answer

Test:

* DAG loading
* Dependencies
* Operators
* Business logic

---

# 45. How do you manage DAG versioning?

### Answer

Use:

* Git
* Code review
* Release tags
* Deployment pipelines

---

# 46. How do you reduce Airflow costs?

### Answer

Optimize:

* Worker scaling
* Task duration
* Compute allocation
* Scheduling frequency

---

# 47. What makes a bad Airflow design?

### Answer

Examples:

❌ Huge Python tasks
❌ No retries
❌ Hard-coded configs
❌ No monitoring
❌ No data validation
❌ Processing data inside scheduler

---

# 48. What makes a good production DAG?

### Answer

A good DAG is:

* Small
* Testable
* Observable
* Idempotent
* Configurable
* Recoverable

---

# 49. Senior engineer design framework

When answering:

Always cover:

```
Architecture

+

Reliability

+

Scalability

+

Monitoring

+

Security

+

Operations
```

---

# 50. Final Interview Answer

Question:

"How do you design enterprise Airflow pipelines?"

Answer:

> I design Airflow as an orchestration layer. Tasks should be modular and idempotent, heavy processing should happen in distributed compute systems, failures should recover through retries and backoff, deployments should separate code from configuration, and monitoring should provide proactive visibility through SLAs and actionable alerts.

---

# Final Mental Model

```
                 Enterprise Data Platform


                       Airflow

                         |

 ------------------------------------------------

 Scheduling | Execution | Monitoring | Recovery


                         |

 ------------------------------------------------

 Spark | SQL Engine | Warehouse | Data Lake


                         |

              Trusted Business Data
```

**Senior Data Engineer principle:**

> Airflow coordinates data movement and computation; it should not become the computation engine itself.

