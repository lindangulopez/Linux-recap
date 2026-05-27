from pathlib import Path
import zipfile

GBIF_DIR = Path('/home/linda/Documents/myData/data-management/data/raw/gbif')

# automatically find the first ZIP file in the directory
zip_files = list(GBIF_DIR.glob('*.zip'))

if not zip_files:
    raise FileNotFoundError(f'No ZIP files found in: {GBIF_DIR}')

ZIP_PATH = zip_files[0]

# create extraction directory based on ZIP filename
EXTRACT_DIR = GBIF_DIR / ZIP_PATH.stem
EXTRACT_DIR.mkdir(parents=True, exist_ok=True)

print(f'Using ZIP file: {ZIP_PATH}')
print(f'Extracting to : {EXTRACT_DIR}')

with zipfile.ZipFile(ZIP_PATH, 'r') as zip_ref:
    zip_ref.extractall(EXTRACT_DIR)

print('Archive extracted successfully.')
