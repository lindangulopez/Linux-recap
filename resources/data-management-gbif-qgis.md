# 🧱 1. Go to your project (or create it)

```bash id="c1"
cd ~/Documents/myData/data-management
```

---

# 📁 2. Create the correct architecture

```bash id="c2"
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

# 📦 3. THIS is where GBIF ZIPs go (important)

You will put them here:

```bash id="c3"
data/raw/gbif/
```

So for example:

```bash id="c4"
mv wolf.zip data/raw/gbif/
mv Red_Deer.zip data/raw/gbif/
mv nase.zip data/raw/gbif/
```

If they are not yet downloaded, just remember this path for later.

---

# 📄 4. Create clean Python structure

```bash id="c5"
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

# 📓 5. Create notebooks (clean workflow only)

```bash id="c6"
touch \
notebooks/01_data_preparation.ipynb \
notebooks/02_gbif_processing.ipynb \
notebooks/03_analysis.ipynb
```

---

# 📜 6. Create scripts

```bash id="c7"
touch \
scripts/run_pipeline.py \
scripts/download_gbif.py
```

---

# 📚 7. Docs + repo files

```bash id="c8"
touch \
README.md \
docs/methodology.md \
docs/data_sources.md \
.gitignore
```

---

# 🧹 8. Add a correct `.gitignore`

```bash id="c9"
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

# ✅ 9. Commit clean structure

```bash id="c10"
git add .
git commit -m "Initialize clean research architecture (GBIF + GIS pipeline)"
```

---

# 🚀 Summary (important rule)

👉 GBIF ZIP files ALWAYS go here:

```text
data/raw/gbif/
```


