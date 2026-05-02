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

# ── Step 3a: IRkernel dependencies first (explicit, never skipped) ───────────
irkernel_deps <- c("repr", "IRdisplay", "IRkernel", "uuid", "digest", "jsonlite", "crayon")
for (p in irkernel_deps) {
  if (!requireNamespace(p, quietly = TRUE)) {
    cat("Installing IRkernel dep:", p, "\n")
    install.packages(p, quiet = FALSE)
  }
}

# ── Step 3b: All other project packages ──────────────────────────────────────
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
  "ggplot2"
)

missing <- pkgs[!pkgs %in% rownames(installed.packages())]
if (length(missing) == 0) {
  cat("All project R packages already installed.\n")
} else {
  cat("Installing:", paste(missing, collapse = ", "), "\n")
  install.packages(missing, quiet = FALSE)
}

# ── Step 3c: Register R kernel ───────────────────────────────────────────────
if (!requireNamespace("IRkernel", quietly = TRUE)) {
  stop("IRkernel failed to install — check CRAN mirror and internet connection.")
}
IRkernel::installspec(user = TRUE, name = "ir", displayname = "R ${R_VERSION}")
cat("IRkernel registered successfully.\n")
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
    # juliaup installs to ~/.juliaup/bin — add to PATH for this session
    export PATH="$HOME/.juliaup/bin:$PATH"
    # Persist across future shells
    if ! grep -q '\.juliaup/bin' "$HOME/.bashrc" 2>/dev/null; then
      echo 'export PATH="$HOME/.juliaup/bin:$PATH"' >> "$HOME/.bashrc"
      info "Added ~/.juliaup/bin to ~/.bashrc"
    fi
  fi
  juliaup add "${JULIA_VERSION}"
  juliaup default "${JULIA_VERSION}"
  # juliaup symlinks julia into ~/.juliaup/bin
  export PATH="$HOME/.juliaup/bin:$PATH"
  JULIA_BIN="$(command -v julia || echo "$HOME/.juliaup/bin/julia")"
  info "Julia installed: $($JULIA_BIN --version)"
fi

section "Installing Omniscape.jl + IJulia kernel"

$JULIA_BIN -e '
  using Pkg
  pkgs = ["Omniscape", "Rasters", "ArchGDAL", "IJulia"]
  for p in pkgs
    if Base.find_package(p) === nothing
      Pkg.add(p)
    end
  end
  Pkg.instantiate()
  # Register Julia kernel with the Jupyter inside the conda env
  using IJulia
  installkernel("Julia")
  println("Omniscape.jl + IJulia ready")
'

info "Omniscape.jl installed and Julia kernel registered."

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

# ── 8. Kernel repair (run automatically; also callable manually) ──────────────
# If kernels are missing after setup — e.g. because the script was run
# before Julia was on PATH — source this file and call: repair_kernels
repair_kernels() {
  section "Repairing / re-registering Jupyter kernels"

  # ── R kernel ────────────────────────────────────────────────────────────────
  info "Installing IRkernel package + registering R kernel …"
  conda run -n "${ENV_NAME}" --no-capture-output \
    Rscript -e "
      options(repos = c(CRAN = '${CRAN_MIRROR}'))
      deps <- c('repr', 'IRdisplay', 'IRkernel', 'uuid', 'digest', 'jsonlite', 'crayon')
      for (p in deps) {
        if (!requireNamespace(p, quietly = TRUE)) install.packages(p)
      }
      IRkernel::installspec(user = TRUE, name = 'ir', displayname = 'R')
      cat('R kernel registered.\n')
    "
  info "R kernel registered."

  # ── Julia kernel ────────────────────────────────────────────────────────────
  JULIA_BIN_LOCAL="$(command -v julia || echo "$HOME/.juliaup/bin/julia")"
  if [[ -x "$JULIA_BIN_LOCAL" ]]; then
    info "Re-registering IJulia kernel …"
    "$JULIA_BIN_LOCAL" -e '
      using Pkg
      Base.find_package("IJulia") === nothing && Pkg.add("IJulia")
      using IJulia
      installkernel("Julia")
      println("Julia kernel registered.")
    '
    info "Julia kernel registered."
  else
    warn "julia not found on PATH — skipping Julia kernel registration."
    warn "After installing Julia, run:  julia -e 'using IJulia; installkernel(\"Julia\")'"
  fi

  info "Current kernels:"
  conda run -n "${ENV_NAME}" --no-capture-output jupyter kernelspec list
}

# Run repair automatically at end of setup to catch any PATH timing issues
repair_kernels

# ── Done ──────────────────────────────────────────────────────────────────────
section "Setup complete"
echo ""
echo -e "  Activate environment  : ${YELLOW}conda activate ${ENV_NAME}${NC}"
echo -e "  Launch JupyterLab     : ${YELLOW}jupyter lab${NC}"
echo -e "  Open notebook         : ${YELLOW}notebooks/02_gbif_processing.ipynb${NC}"
echo -e "  Switch kernel (R)     : top-right kernel picker → R"
echo -e "  Switch kernel (Julia) : top-right kernel picker → Julia"
echo ""
echo -e "  Fill in ${YELLOW}.env${NC} with your GBIF credentials before running the notebook."
echo ""
echo -e "${YELLOW}══ If kernels are still missing ══${NC}"
echo -e "  Run these three commands manually:"
echo ""
echo -e "  ${YELLOW}conda activate ${ENV_NAME}${NC}"
echo -e "  ${YELLOW}Rscript -e 'IRkernel::installspec(user = TRUE)'${NC}"
echo -e "  ${YELLOW}julia -e 'using IJulia; installkernel(\"Julia\")'${NC}"
echo -e "  ${YELLOW}jupyter kernelspec list${NC}   ← verify ir + julia appear"
echo ""
echo -e "  Then relaunch: ${YELLOW}jupyter lab${NC}"
echo ""
