# Bash setup script

> create the redesigned repository structure exactly as proposed.

Run this from your repo root:

---

# 🧱 1. Go to your repo

```bash id="cd1"
cd ~/Documents/myData/data-management
```

---

# 📁 2. Create full folder structure

```bash id="mk1"
mkdir -p \
data/raw/gbif \
data/raw/natura2000 \
data/raw/other_sources \
data/interim \
data/processed \
\
notebooks \
src/config \
src/data \
src/processing \
src/utils \
\
outputs/figures \
outputs/maps \
outputs/tables \
\
scripts \
docs
```

---

# 📄 3. Create core Python modules

```bash id="mk2"
touch \
src/config/paths.py \
src/config/settings.py \
\
src/data/gbif.py \
src/data/natura.py \
src/data/io.py \
\
src/processing/clip.py \
src/processing/buffer.py \
src/processing/clean.py \
\
src/utils/geo.py \
src/utils/logging.py
```

---

# 📓 4. Create notebooks (clean workflow)

```bash id="mk3"
touch \
notebooks/01_data_preparation.ipynb \
notebooks/02_gbif_processing.ipynb \
notebooks/03_analysis.ipynb
```

---

# 📜 5. Create scripts

```bash id="mk4"
touch \
scripts/run_pipeline.py \
scripts/download_gbif.py
```

---

# 📚 6. Create documentation files

```bash id="mk5"
touch \
README.md \
docs/methodology.md \
docs/data_sources.md
```

---

# 🧹 7. Add basic `.gitignore`

```bash id="mk6"
cat << 'EOF' > .gitignore
data/raw/
data/interim/
outputs/
__pycache__/
*.pyc
.ipynb_checkpoints/
.DS_Store
EOF
```

---

# ✅ 8. Stage everything

```bash id="mk7"
git add .
```

---

# 💾 9. Commit structure

```bash id="mk8"
git commit -m "Initialize clean project structure for GBIF + GIS workflow"
```

---

# 🚀 Optional (if ready)

```bash id="mk9"
git push
```

---

If you want next step, I can:

* convert your current notebook into modular Python (`src/`)
* or build a simple `run_pipeline.py` that executes everything automatically
* or help you cleanly migrate your existing GBIF data into `data/raw/` without breaking anything
