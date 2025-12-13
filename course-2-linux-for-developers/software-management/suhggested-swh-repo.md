# 1️⃣ One-shot Setup Script

##  What This Setup Supports

✔ Software Heritage services
✔ GitHub & GitLab workflows
✔ Hugo documentation
✔ COAR Notify integrations
✔ CodeMeta metadata pipelines
✔ Local + containerized development

### Suggested Repo Structure

```text
.
├── README.md
├── setup-ubuntu24-swh.sh
├── docker/
│   ├── docker-compose.yml
├── docs/        # Hugo
├── backend/
├── metadata/    # CodeMeta / COAR Notify
└── venv/
```

**`setup-ubuntu24-swh.sh`**

```bash
#!/usr/bin/env bash
set -e

echo "=== Software Heritage Dev Environment (Ubuntu 24) ==="

# --- System update ---
sudo apt update
sudo apt upgrade -y

# --- Core tooling ---
sudo apt install -y \
  build-essential \
  git \
  git-lfs \
  curl \
  wget \
  pkg-config \
  ca-certificates \
  software-properties-common \
  python3 \
  python3-venv \
  python3-pip

# --- Hugo ---
sudo apt install -y hugo

# --- PostgreSQL ---
sudo apt install -y postgresql postgresql-contrib
sudo systemctl enable postgresql
sudo systemctl start postgresql

# --- Java (for Cassandra) ---
sudo apt install -y openjdk-11-jdk

# --- Cassandra ---
sudo apt install -y cassandra
sudo systemctl enable cassandra
sudo systemctl start cassandra

# --- Rust (via rustup) ---
if ! command -v rustc >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# --- Rust environment ---
if [ -f "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
fi

# --- Python virtual environment ---
if [ ! -d "venv" ]; then
  python3 -m venv venv
fi

echo "=== Setup complete ==="
echo "Next steps:"
echo "  source venv/bin/activate"
echo "  rustc --version"
echo "  psql --version"
echo "  nodetool status"
```

Make executable:

```bash
chmod +x setup-ubuntu24-swh.sh
```

---

# 2️⃣ Developer README (GitHub / GitLab Ready)

**`README.md`**

````markdown
# Software Heritage Development Environment (Ubuntu 24)

This repository documents a local development environment suitable for
Software Heritage–style services and tooling.

## Components

- Ubuntu 24.04 LTS
- Git / Git LFS (GitHub, GitLab)
- Hugo (documentation & sites)
- Rust (via rustup)
- PostgreSQL (relational storage)
- Cassandra (distributed storage)
- Python (CodeMeta, COAR Notify)

## Quick Start

```bash
./setup-ubuntu24-swh.sh
source venv/bin/activate
````

## PostgreSQL

Create a development user and database:

```bash
sudo -u postgres createuser swh
sudo -u postgres createdb swh_dev -O swh
```

Connect:

```bash
psql -U swh -d swh_dev
```

## Cassandra

Check status:

```bash
nodetool status
```

Default port: `9042`

## Rust

```bash
rustc --version
cargo --version
```

Toolchains are managed via `rustup`.

## Python Tooling

Recommended workflow:

```bash
source venv/bin/activate
pip install --upgrade pip
pip install codemeta-py
```

Used for:

* CodeMeta metadata generation
* COAR Notify clients/services
* Software Heritage APIs

## Hugo

```bash
hugo version
hugo server
```

Used for documentation and project websites.

## Best Practices

* Use `apt` for system services
* Use language-native tools (`rustup`, `pip`)
* Keep versions documented
* Prefer containers for CI parity

## License

Apache-2.0 (or project-specific)

````

---

# 3️⃣ Docker / Podman Alternatives (Recommended for CI & Isolation)

If you prefer **containers instead of system services**:

## PostgreSQL (Docker / Podman)

```bash
docker run -d \
  --name postgres-swh \
  -e POSTGRES_USER=swh \
  -e POSTGRES_PASSWORD=swh \
  -e POSTGRES_DB=swh_dev \
  -p 5432:5432 \
  postgres:16
````

## Cassandra (Docker / Podman)

```bash
docker run -d \
  --name cassandra-swh \
  -p 9042:9042 \
  cassandra:4.1
```

Check:

```bash
docker exec -it cassandra-swh nodetool status
```

💡 **Strongly recommended** for:

* CI pipelines
* Multi-developer consistency
* Fast teardown/rebuild

---

# 4️⃣ Versioning & Reproducibility Notes

### Pin Versions Where Possible

* Rust: `rust-toolchain.toml`
* Python: `requirements.txt`
* Hugo: document version in README
* DB schemas: migrations only



