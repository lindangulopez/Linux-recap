Guix propagated dependency conflict.

Jupyter already pulls its own compatible version of `python-ipykernel` through `python-qtconsole`.

You added another newer `python-ipykernel` manually:

* `jupyter` wants:

  * `python-ipykernel@6.29.5`
* your manifest requests:

  * `python-ipykernel@7.1.0`

Guix refuses because both would install conflicting files into the same profile.

Remove this line from your manifest:

```scheme id="rv7iw3"
"python-ipykernel"
```

Your manifest should become:

```scheme id="s7l7ni"
(specifications->manifest
 (list

  ;; Python
  "python"
  "python-pip"

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

Then run:

```bash id="9r5jz6"
guix package -m manifest.scm
```

or better (ephemeral/reproducible):

```bash id="m4o4we"
guix shell -m manifest.scm
```

---

Then inside the shell:

```bash id="4v38y6"
jupyter notebook
```

or try:

```bash id="s9hptn"
jupyter lab
```

---

Then register kernels.

# R

```bash id="iq4je6"
R
```

```r id="vxx8dw"
IRkernel::installspec()
```

# Julia

```bash id="5y8o7q"
julia
```

```julia id="khv6kc"
using Pkg
Pkg.add("IJulia")
using IJulia
installkernel("Julia")
```

---

Verify:

```bash id="zyz6h0"
jupyter kernelspec list
```

You should then have:

```text id="q4p1dc"
python3
ir
julia-*
```
