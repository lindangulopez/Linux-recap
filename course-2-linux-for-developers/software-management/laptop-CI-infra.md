# Recommended Repo Layout

```text
.
├── .github/workflows/ci.yml
├── .gitlab-ci.yml
├── .pre-commit-config.yaml
├── docker-compose.yml
├── rust-toolchain.toml
├── requirements.txt
├── codemeta.json
├── setup-ubuntu24-swh.sh
├── docs/            # Hugo
├── backend/         # services
├── metadata/        # COAR Notify
└── README.md
```

## 1️⃣ `docker-compose.yml`

**PostgreSQL + Cassandra (dev-friendly, CI-ready)**

```yaml
version: "3.9"

services:
  postgres:
    image: postgres:16
    container_name: swh-postgres
    environment:
      POSTGRES_USER: swh
      POSTGRES_PASSWORD: swh
      POSTGRES_DB: swh_dev
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  cassandra:
    image: cassandra:4.1
    container_name: swh-cassandra
    ports:
      - "9042:9042"
    environment:
      CASSANDRA_CLUSTER_NAME: "swh-dev"
      MAX_HEAP_SIZE: 512M
      HEAP_NEWSIZE: 128M
    volumes:
      - cassandra_data:/var/lib/cassandra

volumes:
  postgres_data:
  cassandra_data:
```

Start:

```bash
docker compose up -d
```

---

## 2️⃣ Version Pinning

### Rust

**`rust-toolchain.toml`**

```toml
[toolchain]
channel = "stable"
components = ["rustfmt", "clippy"]
```

### Python

**`requirements.txt`**

```txt
codemeta-py
requests
pyyaml
```

Install:

```bash
pip install -r requirements.txt
```

---

## 3️⃣ Pre-commit Hooks

**`.pre-commit-config.yaml`**

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json

  - repo: https://github.com/psf/black
    rev: 24.4.2
    hooks:
      - id: black

  - repo: https://github.com/rust-lang/rustfmt
    rev: master
    hooks:
      - id: rustfmt

  - repo: https://github.com/citation-file-format/cffconvert
    rev: v2.0.0
    hooks:
      - id: cffconvert
```

Enable:

```bash
pip install pre-commit
pre-commit install
```

---

## 4️⃣ CodeMeta & COAR Notify

### CodeMeta

Generate metadata:

```bash
codemeta-py --validate codemeta.json
```

Minimal **`codemeta.json`**:

```json
{
  "@context": "https://doi.org/10.5063/schema/codemeta-2.0",
  "@type": "SoftwareSourceCode",
  "name": "swh-dev-environment",
  "license": "https://spdx.org/licenses/Apache-2.0.html",
  "programmingLanguage": ["Python", "Rust"],
  "codeRepository": "https://github.com/example/swh-dev"
}
```

### COAR Notify

* Use Python clients for emitting notifications
* JSON-LD compatible with SWH ingestion pipelines
* Integrates naturally with metadata workflows

---

## 5️⃣ Hugo Documentation

**Directory**

```text
docs/
├── config.toml
├── content/
└── themes/
```

Serve locally:

```bash
cd docs
hugo server
```

Used for:

* API docs
* Metadata policies
* Architecture diagrams

---

### 6️⃣ GitHub Actions CI

**`.github/workflows/ci.yml`**

```yaml
name: CI

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest

    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_USER: swh
          POSTGRES_PASSWORD: swh
          POSTGRES_DB: swh_dev
        ports: ["5432:5432"]

      cassandra:
        image: cassandra:4.1
        ports: ["9042:9042"]

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"

      - uses: actions-rs/toolchain@v1
        with:
          toolchain: stable
          override: true

      - run: |
          pip install -r requirements.txt
          codemeta-py --validate codemeta.json

      - run: cargo fmt --check
```

---

## 7️⃣ GitLab CI

**`.gitlab-ci.yml`**

```yaml
image: ubuntu:24.04

services:
  - name: postgres:16
    alias: postgres
  - name: cassandra:4.1
    alias: cassandra

variables:
  POSTGRES_DB: swh_dev
  POSTGRES_USER: swh
  POSTGRES_PASSWORD: swh

before_script:
  - apt update
  - apt install -y python3 python3-pip git curl
  - pip install -r requirements.txt

stages:
  - validate

validate:
  stage: validate
  script:
    - codemeta-py --validate codemeta.json
```





