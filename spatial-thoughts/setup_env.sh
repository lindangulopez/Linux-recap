#!/usr/bin/env bash
# =============================================================================
# setup_env.sh
# Côa Valley Connectivity — full environment bootstrap
#
# Creates a conda environment with:
#   - Python (geopandas, pygbif, rasterio, juliacall …)
#   - R + IRkernel (registered with Jupyter)
#   - All R packages (rgbif, sf, CoordinateCleaner …)
#   - Julia + Omniscape.jl
#
# Usage:
#   chmod +x setup_env.sh
#   ./setup_env.sh              # creates env "coa" (default)
#   ENV_NAME=myenv ./setup_env.sh
# =============================================================================

set -euo pipefail

# ── Config ────────────────────────────────────────────────────────────────────
ENV_NAME="${ENV_NAME:-coa}"
PYTHON_VERSION="3.11"
R_VERSION="4.3"
JULIA_VERSION="1.10"
CRAN_MIRROR="https://cloud.r-project.org"

# Colour helpers
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()    { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
section() { echo -e "\n${GREEN}══ $* ══${NC}"; }

# ── 0. Preflight ─────────────────────────────────────────────────────────────
section "Preflight checks"

if ! command -v conda &>/dev/null; then
  echo -e "${RED}[ERROR]${NC} conda not found. Install Miniforge first:"
  echo "  https://github.com/conda-forge/miniforge#download"
  exit 1
fi

info "conda   : $(conda --version)"
info "env name: ${ENV_NAME}"

# ── 1. Create conda environment ───────────────────────────────────────────────
section "Creating conda environment '${ENV_NAME}'"

if conda env list | grep -q "^${ENV_NAME} "; then
  warn "Environment '${ENV_NAME}' already exists — skipping creation."
  warn "To rebuild from scratch: conda env remove -n ${ENV_NAME}"
else
  conda create -y -n "${ENV_NAME}" \
    -c conda-forge \
    python="${PYTHON_VERSION}" \
    r-base="${R_VERSION}.*" \
    r-essentials \
    jupyter \
    jupyterlab \
    notebook
  info "Conda environment created."
fi

# Activate for the rest of this script
# (conda run is used so we don't need 'conda activate' in a non-interactive shell)
RUN="conda run -n ${ENV_NAME} --no-capture-output"

# ── 2. Python packages ────────────────────────────────────────────────────────
section "Installing Python packages"

$RUN pip install --quiet --upgrade pip

$RUN pip install --quiet \
  geopandas \
  pygbif \
  rasterio \
  rasterstats \
  fiona \
  shapely \
  pyproj \
  numpy \
  pandas \
  matplotlib \
  scipy \
  juliacall \
  python-dotenv \
  tqdm \
  rich

info "Python packages installed."

# ── 3. R packages ─────────────────────────────────────────────────────────────
section "Installing R packages (this takes a few minutes)"

$RUN Rscript - <<EOF
options(repos = c(CRAN = "${CRAN_MIRROR}"))

pkgs <- c(
  # GBIF
  "rgbif",
  # Spatial
  "sf",
  "terra",
  # Data wrangling
  "dplyr",
  "readr",
  "tidyr",
  "stringr",
  "lubridate",
  "purrr",
  # Utilities
  "fs",
  "glue",
  "janitor",
  # Spatial QA
  "CoordinateCleaner",
  # Visualisation
  "ggplot2",
  # Jupyter / IRkernel
  "IRkernel"
)

missing <- pkgs[!pkgs %in% rownames(installed.packages())]

if (length(missing) == 0) {
  cat("All R packages already installed.\n")
} else {
  cat("Installing:", paste(missing, collapse = ", "), "\n")
  install.packages(missing, quiet = TRUE)
}

# Register R kernel with the Jupyter in this environment
IRkernel::installspec(name = "ir", displayname = "R ${R_VERSION}")
cat("IRkernel registered.\n")
EOF

info "R packages installed and IRkernel registered."

# ── 4. Julia + Omniscape.jl ──────────────────────────────────────────────────
section "Installing Julia ${JULIA_VERSION}"

JULIA_BIN=""

if command -v julia &>/dev/null; then
  JULIA_BIN="julia"
  info "julia already on PATH: $($JULIA_BIN --version)"
else
  # Install via juliaup (cross-platform Julia version manager)
  if ! command -v juliaup &>/dev/null; then
    info "Installing juliaup …"
    curl -fsSL https://install.julialang.org | sh -s -- --yes
    export PATH="$HOME/.juliaup/bin:$PATH"
  fi
  juliaup add "${JULIA_VERSION}"
  juliaup default "${JULIA_VERSION}"
  JULIA_BIN="julia"
  info "Julia installed: $($JULIA_BIN --version)"
fi

section "Installing Omniscape.jl"

$JULIA_BIN --project=@. -e '
  using Pkg
  pkgs = ["Omniscape", "Rasters", "ArchGDAL"]
  for p in pkgs
    if !haskey(Pkg.project().dependencies, p)
      Pkg.add(p)
    end
  end
  Pkg.instantiate()
  println("Omniscape.jl ready: ", pkgs)
'

info "Omniscape.jl installed."

# ── 5. Write .env ─────────────────────────────────────────────────────────────
section "Writing .env"

ENV_FILE=".env"

if [[ -f "${ENV_FILE}" ]]; then
  warn ".env already exists — skipping (delete it to regenerate)."
else
cat > "${ENV_FILE}" <<'DOTENV'
# =============================================================================
# .env  —  Côa Valley Connectivity project
# Copy this file to your project root. Never commit it to git.
# =============================================================================

# ── GBIF credentials (required for occ_download()) ───────────────────────────
GBIF_USER=your_gbif_username
GBIF_PWD=your_gbif_password
GBIF_EMAIL=your_email@example.com

# ── Julia ────────────────────────────────────────────────────────────────────
# Number of threads for Omniscape.jl parallel runs
# Set to the number of physical cores on your machine
JULIA_NUM_THREADS=4

# ── Python paths (auto-resolved by src/io/paths.py — override if needed) ────
# PROJECT_ROOT=/absolute/path/to/data-management

# ── QGIS (optional — only needed if scripting QGIS from Python) ─────────────
# QGIS_PREFIX_PATH=/usr/share/qgis

# ── Logging level ────────────────────────────────────────────────────────────
LOG_LEVEL=INFO
DOTENV

  info ".env written."
fi

# ── 6. Write .gitignore additions ─────────────────────────────────────────────
section "Updating .gitignore"

GITIGNORE=".gitignore"
MARKER="# === setup_env additions ==="

if ! grep -q "${MARKER}" "${GITIGNORE}" 2>/dev/null; then
cat >> "${GITIGNORE}" <<'GITBLOCK'

# === setup_env additions ===
.env
*.zip
*.tif
*.gpkg
*.nc
__pycache__/
*.py[cod]
.Rhistory
.RData
.Ruserdata
data/raw/
data/interim/
data/processed/
outputs/maps/
outputs/figures/
GITBLOCK
  info ".gitignore updated."
else
  warn ".gitignore already has setup_env additions — skipping."
fi

# ── 7. Verify ─────────────────────────────────────────────────────────────────
section "Verification"

echo ""
info "Jupyter kernels registered:"
$RUN jupyter kernelspec list

echo ""
info "Python check:"
$RUN python -c "
import geopandas, pygbif, rasterio, juliacall
print(f'  geopandas {geopandas.__version__}')
print(f'  pygbif    {pygbif.__version__}')
print(f'  rasterio  {rasterio.__version__}')
print(f'  juliacall {juliacall.__version__}')
"

echo ""
info "R check:"
$RUN Rscript -e '
pkgs <- c("rgbif","sf","CoordinateCleaner","IRkernel")
for (p in pkgs) cat(sprintf("  %-22s %s\n", p, packageVersion(p)))
'

echo ""
info "Julia / Omniscape check:"
$JULIA_BIN -e 'using Omniscape; println("  Omniscape.jl OK")'

# ── Done ──────────────────────────────────────────────────────────────────────
section "Setup complete"
echo ""
echo -e "  Activate environment : ${YELLOW}conda activate ${ENV_NAME}${NC}"
echo -e "  Launch JupyterLab    : ${YELLOW}jupyter lab${NC}"
echo -e "  Open notebook        : ${YELLOW}notebooks/02_gbif_processing.ipynb${NC}"
echo -e "  Switch kernel to     : ${YELLOW}R${NC}  (top-right kernel picker)"
echo ""
echo -e "  Fill in ${YELLOW}.env${NC} with your GBIF credentials before running the notebook."
echo ""
