# Root folder
mkdir -p data-management && cd data-management

# -------------------------
# DATA LAYERS
# -------------------------

mkdir -p data/raw/gbif
mkdir -p data/raw/eea/natura2000

mkdir -p data/interim/gbif
mkdir -p data/interim/eea

mkdir -p data/processed/base_layers
mkdir -p data/processed/species
mkdir -p data/processed/groups
mkdir -p data/processed/connectivity

# -------------------------
# NOTEBOOKS (pipeline)
# -------------------------

mkdir -p notebooks

touch notebooks/01_data_preparation.ipynb
touch notebooks/02_gbif_processing.ipynb
touch notebooks/03_analysis.ipynb
touch notebooks/04_qgis_geopandas_bridge.ipynb
touch notebooks/05_connectivity.ipynb

# -------------------------
# SOURCE CODE
# -------------------------

mkdir -p src/config
mkdir -p src/io
mkdir -p src/processing

touch src/config/ecosystem.py

touch src/io/read_gpkg.py
touch src/io/read_eea.py
touch src/io/paths.py

touch src/processing/clean.py
touch src/processing/clip.py
touch src/processing/buffer.py
touch src/processing/aggregate.py

# -------------------------
# QGIS PROJECT
# -------------------------

mkdir -p qgis/layers
mkdir -p qgis/styles

touch qgis/coa_connectivity.qgz

# -------------------------
# OUTPUTS
# -------------------------

mkdir -p outputs/maps
mkdir -p outputs/figures
mkdir -p outputs/tables

# -------------------------
# ROOT FILES
# -------------------------

touch README.md
touch .gitignore
