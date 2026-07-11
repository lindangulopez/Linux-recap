Below is a complete setup guide for a **Linux GIS workstation** with:

* **PostgreSQL** — database server
* **PostGIS** — spatial vector support
* **PostGIS Raster (pgraster)** — raster storage and analysis
* **GDAL tools** — importing/exporting raster and vector data
* **pgAdmin 4** — main graphical database administration tool
* **psql** — command-line access
* **QGIS-ready configuration** — for mapping and visualization

These instructions assume **Ubuntu/Debian Linux**. If you use another distribution, I can adapt them.

---

# 1. Update Linux

Open a terminal:

```bash
sudo apt update
sudo apt upgrade -y
```

Install basic tools:

```bash
sudo apt install curl wget gnupg ca-certificates lsb-release software-properties-common -y
```

---

# 2. Install PostgreSQL

Install PostgreSQL:

```bash
sudo apt install postgresql postgresql-contrib -y
```

Check that PostgreSQL is running:

```bash
sudo systemctl status postgresql
```

You should see:

```
active (running)
```

Enable it at startup:

```bash
sudo systemctl enable postgresql
```

Check your PostgreSQL version:

```bash
psql --version
```

Example:

```
psql (PostgreSQL) 16.x
```

---

# 3. Create your PostgreSQL user

PostgreSQL creates an administrative Linux user called `postgres`.

Switch to it:

```bash
sudo -u postgres -i
```

Open PostgreSQL:

```bash
psql
```

Create your personal database user:

```sql
CREATE USER gisuser WITH PASSWORD 'choose_a_strong_password';
```

Allow the user to create databases:

```sql
ALTER USER gisuser CREATEDB;
```

Exit PostgreSQL:

```sql
\q
```

Return to your normal Linux account:

```bash
exit
```

---

# 4. Install PostGIS + Raster Support

Install PostGIS:

```bash
sudo apt install postgis postgresql-postgis -y
```

For PostgreSQL 16, you may also install:

```bash
sudo apt install postgresql-16-postgis-3 -y
```

(Change `16` if you have another PostgreSQL version.)

Restart PostgreSQL:

```bash
sudo systemctl restart postgresql
```

---

# 5. Create a GIS Database

Create a database:

```bash
createdb -U postgres gis_database
```

Give your user ownership:

```bash
psql -U postgres
```

Inside PostgreSQL:

```sql
ALTER DATABASE gis_database OWNER TO gisuser;
```

Exit:

```sql
\q
```

---

# 6. Enable PostGIS Extensions

Connect to your GIS database:

```bash
psql -U gisuser -d gis_database
```

Enable spatial extensions:

```sql
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;
CREATE EXTENSION postgis_raster;
```

Check installation:

```sql
SELECT postgis_full_version();
```

You should see something similar to:

```
POSTGIS="3.x.x"
GEOS
PROJ
GDAL
RASTER
```

Check raster support:

```sql
SELECT postgis_raster_lib_version();
```

Exit:

```sql
\q
```

---

# 7. Install GDAL Raster and GIS Tools

Install GDAL:

```bash
sudo apt install gdal-bin python3-gdal -y
```

Check:

```bash
gdalinfo --version
```

Example:

```
GDAL 3.x.x
```

Check raster import tools:

```bash
raster2pgsql -G
```

You should see supported raster drivers.

---

# 8. Install pgAdmin 4

Install pgAdmin repository key:

```bash
curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | \
sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg
```

Add repository:

```bash
echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" | \
sudo tee /etc/apt/sources.list.d/pgadmin4.list
```

Install pgAdmin desktop:

```bash
sudo apt update
sudo apt install pgadmin4-desktop -y
```

Start:

```bash
pgadmin4
```

---

# 9. Connect pgAdmin to PostgreSQL

Open pgAdmin.

Choose:

```
Servers
 └── Register
      └── Server
```

## General tab

Name:

```
Local GIS PostgreSQL
```

## Connection tab

Host:

```
localhost
```

Port:

```
5432
```

Maintenance database:

```
postgres
```

Username:

```
gisuser
```

Password:

```
your_password
```

Save.

You should now see:

```
Servers
 └── Local GIS PostgreSQL
      └── Databases
           └── gis_database
```

---

# 10. Configure PostgreSQL for Local GIS Work

Edit PostgreSQL configuration:

```bash
sudo nano /etc/postgresql/*/main/postgresql.conf
```

Recommended settings for a workstation:

Find:

```
shared_buffers
```

Set:

```
shared_buffers = 2GB
```

(For computers with 16GB+ RAM.)

Find:

```
work_mem
```

Set:

```
work_mem = 64MB
```

Find:

```
maintenance_work_mem
```

Set:

```
maintenance_work_mem = 512MB
```

Save:

```
CTRL + O
ENTER
CTRL + X
```

Restart:

```bash
sudo systemctl restart postgresql
```

---

# 11. Test PostGIS

Connect:

```bash
psql -U gisuser -d gis_database
```

Test geometry:

```sql
SELECT ST_AsText(
ST_SetSRID(ST_Point(2.3522,48.8566),4326)
);
```

Result:

```
POINT(2.3522 48.8566)
```

Test raster:

```sql
SELECT postgis_raster_lib_version();
```

---

# 12. Import Vector Data

Example: import a shapefile.

Install tools:

```bash
sudo apt install shp2pgsql -y
```

Import:

```bash
shp2pgsql -I -s 4326 roads.shp public.roads | \
psql -U gisuser -d gis_database
```

---

# 13. Import Raster Data

Example GeoTIFF:

```
elevation.tif
```

Import:

```bash
raster2pgsql \
-s 4326 \
-I \
-C \
-M \
elevation.tif \
public.elevation \
| psql -U gisuser -d gis_database
```

Options:

| Option    | Purpose            |
| --------- | ------------------ |
| `-s 4326` | Coordinate system  |
| `-I`      | Spatial index      |
| `-C`      | Raster constraints |
| `-M`      | Analyze table      |

---

# 14. Install QGIS (Recommended)

For viewing and editing GIS data:

```bash
sudo apt install qgis -y
```

Connect QGIS:

```
Layer
 → Add Layer
 → Add PostgreSQL Layer
```

Connection:

```
Name:
Local GIS

Host:
localhost

Port:
5432

Database:
gis_database

Username:
gisuser
```

---

# 15. Useful psql Commands

Connect:

```bash
psql -U gisuser -d gis_database
```

List databases:

```sql
\l
```

List tables:

```sql
\dt
```

Describe table:

```sql
\d table_name
```

List extensions:

```sql
\dx
```

Quit:

```sql
\q
```

---

# Final GIS Stack

Your final setup will be:

```
                 QGIS
                   |
                   |
               PostgreSQL
                   |
        ---------------------
        |                   |
     PostGIS            PostGIS Raster
        |                   |
   Vector data        GeoTIFF / DEM
        |
      pgAdmin
        |
       psql
```

This is a professional GIS database setup suitable for:

* GeoPackage/shapefile migration
* OpenStreetMap data
* satellite imagery
* DEM/elevation models
* remote sensing workflows
* spatial SQL analysis
* QGIS projects

If you are setting this up for **large raster datasets (Sentinel/Landsat/DEM)**, the next useful step would be tuning PostgreSQL specifically for raster performance and adding extensions like `pgRouting` and `timescaledb`.
