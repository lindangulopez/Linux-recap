# Manifest should work with:

```scheme id="skgmvt"
(specifications->manifest
 (list

  ;; Python
  "python"
  "python-pip"
  "python-ipykernel"

  ;; Jupyter
  "jupyter"

  ;; Python GIS
  "python-numpy"
  "python-pandas"
  "python-geopandas"
  "python-rasterio"
  "python-matplotlib"
  "python-scipy"

  ;; GIS libs
  "gdal"
  "proj"
  "geos"

  ;; R
  "r"
  "r-irkernel"
  "r-ggplot2"
  "r-dplyr"
  "r-tidyr"
  "r-readr"
  "r-stringr"
  "r-purrr"
  "r-lubridate"
  "r-sf"

  ;; Julia
  "julia"

  ;; QGIS
  "qgis"

  ;; Database
  "postgresql"
  "postgis"))
```

Then:

```bash id="ln8ks4"
guix shell -m manifest.scm
```

Inside the shell, check what commands exist:

```bash id="2u6j7w"
which jupyter
```

Then try:

```bash id="67s4gm"
jupyter notebook
```

and:

```bash id="7mbt1f"
jupyter lab
```

If `jupyter lab` fails but notebook works, your Guix revision bundles only classic notebook UI.

---

You can also inspect available packages:

```bash id="g9m2wi"
guix search jupyter
```

This will show the exact package names available in your channels.

---

I also strongly recommend updating your Guix channels before building scientific environments:

```bash id="n9b9cz"
guix pull
```

Then restart your shell:

```bash id="9ljy93"
hash guix
```

or log out/in.

Older Guix revisions often lack newer notebook package splits.
