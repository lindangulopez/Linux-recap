# **GitHub Actions workflows**

> automated CI/CD pipelines that run on your repo. 

## How to Add GitHub Actions Workflows

### Step 1: Navigate to your repo's Actions tab
Go to `https://github.com/coa-connectivity-lab/data-management/actions` and click **"New workflow"** — or manually create files in `.github/workflows/`.

---

### 1. 🔒 SLSA Generic Generator
Generates cryptographic provenance for your releases (supply chain security).

Create `.github/workflows/slsa.yml`:
```yaml
name: SLSA Generic Generator
on:
  release:
    types: [created]

jobs:
  build:
    runs-on: ubuntu-latest
    outputs:
      digests: ${{ steps.hash.outputs.digests }}
    steps:
      - uses: actions/checkout@v4
      - name: Build artifacts
        run: |
          # Replace with your actual build command
          make build
      - name: Generate hashes
        id: hash
        run: |
          sha256sum your-artifact > checksums.txt
          echo "digests=$(base64 -w0 checksums.txt)" >> $GITHUB_OUTPUT

  provenance:
    needs: [build]
    permissions:
      actions: read
      id-token: write
      contents: write
    uses: slsa-framework/slsa-github-generator/.github/workflows/generator_generic_slsa3.yml@v1.10.0
    with:
      base64-subjects: "${{ needs.build.outputs.digests }}"
```

---

### 2. 🐍 Django — Build & Test
Create `.github/workflows/django.yml`:
```yaml
name: Django CI
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.12'
      - name: Install dependencies
        run: |
          pip install -r requirements.txt
      - name: Run tests
        run: |
          python manage.py test
```

---

### 3. 🐍 Python Package with Anaconda
Create `.github/workflows/conda.yml`:
```yaml
name: Python Package (Anaconda)
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ['3.10', '3.11', '3.12']
    steps:
      - uses: actions/checkout@v4
      - name: Set up Conda
        uses: conda-incubator/setup-miniconda@v3
        with:
          python-version: ${{ matrix.python-version }}
          auto-activate-base: false
      - name: Install dependencies
        shell: bash -el {0}
        run: |
          conda install --file requirements.txt
      - name: Run tests
        shell: bash -el {0}
        run: |
          pytest
```

---

## Quickest Way to Add Them

1. Go to your repo on GitHub
2. Click **"Actions"** tab → **"New workflow"** → **"set up a workflow yourself"**
3. Paste the relevant YAML above
4. Commit to `main`

> **Note:** For the SLSA workflow, replace `make build` and `your-artifact` with your actual build command and output file. For Django/Conda, make sure `requirements.txt` exists at the repo root.
