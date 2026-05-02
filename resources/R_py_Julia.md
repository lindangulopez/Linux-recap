### `notebooks/02_gbif_processing.ipynb` — **R kernel**
The processing notebook, structured in 8 cells:

| Cell | What it does |
|---|---|
| 0 | Loads `rgbif`, `sf`, `CoordinateCleaner`, `janitor`, etc. |
| 1 | Resolves paths relative to project root — works from any CWD |
| 2 | **Species manifest** — maps ZIP stems to metadata; auto-warns on undeclared ZIPs |
| 3 | Three helper functions: `read_dwca_zip()`, `normalise_columns()`, `apply_quality_filters()`, `to_sf_3035()`, `write_species_gpkg()` |
| 4 | **Main loop** — reads each ZIP, normalises, filters, reprojects to EPSG:3035, writes `.gpkg` |
| 5 | QA summary table → `_qa_filter_summary.csv` alongside the GeoPackages |
| 6 | Verification pass — reads back every GPKG, prints count/CRS/type |
| 7 | Diagnostic `ggplot2` map of all species combined |
| 8 | Documents the hand-off contract to `03_resistance_surface` |

**Filter stack applied per species:** no coords → invalid WGS-84 range → 0,0 records → absence records → fossils/living specimens → introduced individuals → uncertainty > 5 km → pre-1950 → future records → `CoordinateCleaner` spatial outliers (capitals, centroids, GBIF HQ, institutions, seas).

---

### `src/io/read_gbif.py` — updated Python loader
- `load_species_occurrences("Canis_lupus")` — loads one GPKG, validates CRS + columns, reprojects if needed
- `load_all_occurrences(groups=["apex_predator"])` — merges all species, optional group filter
- `list_available_species()` — returns stems for GeoPackages on disk
- `occurrence_summary()` — reads the QA CSV from the R notebook

---

### `src/io/paths.py` — updated path constants
Added `INTERIM_GBIF_DIR` and helpers `interim_gbif_gpkg(stem)`, `resistance_raster(stem)`, `connectivity_rasters(stem)`, plus `ensure_dirs()` to bootstrap the full directory tree in one call.

---

### `src/config/ecosystem.py` — updated config
Each `Species` dataclass now carries `dispersal_km`, `resistance_null/max`, `taxon_key`, and optional per-species Omniscape overrides. The new `omniscape_radius_pixels(sp, pixel_size_m)` helper feeds directly into `04_omniscape.ipynb` — it computes radius from dispersal distance and caps it at `radius_max_pixels` to avoid runaway Julia jobs.
