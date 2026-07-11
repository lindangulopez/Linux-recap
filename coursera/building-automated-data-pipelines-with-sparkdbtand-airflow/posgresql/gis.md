# Linux GIS Workstation Setup Guide

This guide installs and configures:

* **PostgreSQL 16** — database server
* **PostGIS 3** — spatial vector support
* **PostGIS Raster** — raster storage and analysis
* **GDAL tools** — raster/vector import and export
* **pgAdmin 4** — graphical database administration
* **psql** — command-line access
* **QGIS-ready configuration** — GIS visualization and editing

These instructions are for **Ubuntu/Debian Linux**.

---

# 1. Update Linux

Open a terminal:

```bash
sudo apt update
sudo apt upgrade -y
```

Install required tools:

```bash
sudo apt install curl wget gnupg ca-certificates lsb-release software-properties-common -y
```

---

# 2. Install PostgreSQL

Install PostgreSQL:

```bash
sudo apt install postgresql postgresql-contrib -y
```

Check PostgreSQL status:

```bash
sudo systemctl status postgresql
```

Expected:

```
active (running)
```

Enable PostgreSQL at startup:

```bash
sudo systemctl enable postgresql
```

Check the version:

```bash
psql --version
```

Example:

```
psql (PostgreSQL) 16.x
```

---

# 3. Install PostGIS and Raster Support

Install PostGIS:

```bash
sudo apt install postgis postgresql-postgis -y
```

For PostgreSQL 16:

```bash
sudo apt install postgresql-16-postgis-3 -y
```

If it says:

```
postgresql-16-postgis-3 is already the newest version
```

then PostGIS is already installed.

Restart PostgreSQL:

```bash
sudo systemctl restart postgresql
```

---

# 4. Create the GIS Database User

Ubuntu uses **peer authentication**, so administrative PostgreSQL commands must be run as the Linux `postgres` user.

Switch to the PostgreSQL administrator:

```bash
sudo -u postgres -i
```

Open PostgreSQL:

```bash
psql
```

Create your GIS user:

```sql
CREATE USER gisuser WITH PASSWORD 'choose_a_strong_password';
```

Allow database creation:

```sql
ALTER USER gisuser CREATEDB;
```

Check users:

```sql
\du
```

Exit PostgreSQL:

```sql
\q
```

Return to your normal Linux user:

```bash
exit
```

---

# 5. Create the GIS Database

Create the database using the PostgreSQL administrator:

```bash
sudo -u postgres createdb gis_database
```

Set ownership to your GIS user:

```bash
sudo -u postgres psql
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

Connect using your GIS user:

```bash
psql -U gisuser -d gis_database -W
```

Enable extensions:

```sql
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;
CREATE EXTENSION postgis_raster;
```

Check PostGIS:

```sql
SELECT postgis_full_version();
```

Expected output contains:

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

# 7. Install GDAL GIS Tools

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

Check raster import:

```bash
raster2pgsql -G
```

---

# 8. Install pgAdmin 4

Add pgAdmin repository key:

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

Launch:

```bash
pgadmin4
```

---

# 9. Connect pgAdmin 4

Open:

```
Servers
 └── Register
      └── Server
```

## General

Name:

```
Local GIS PostgreSQL
```

## Connection

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

You should see:

```
Servers
 └── Local GIS PostgreSQL
      └── Databases
           └── gis_database
```

---

# 10. PostgreSQL Performance Tuning for GIS

Edit configuration:

```bash
sudo nano /etc/postgresql/16/main/postgresql.conf
```

For a workstation with 16GB+ RAM:

Set:

```
shared_buffers = 2GB
```

Set:

```
work_mem = 64MB
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
psql -U gisuser -d gis_database -W
```

Test geometry:

```sql
SELECT ST_AsText(
ST_SetSRID(ST_Point(2.3522,48.8566),4326)
);
```

Expected:

```
POINT(2.3522 48.8566)
```

Test raster:

```sql
SELECT postgis_raster_lib_version();
```

---

# 12. Import Vector Data

Install Shapefile tools:

```bash
sudo apt install postgis -y
```

Example shapefile:

```
roads.shp
```

Import:

```bash
shp2pgsql -I -s 4326 roads.shp public.roads | \
psql -U gisuser -d gis_database
```

---

# 13. Import Raster Data

Example raster:

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

| Option    | Purpose                     |
| --------- | --------------------------- |
| `-s 4326` | Coordinate reference system |
| `-I`      | Create spatial index        |
| `-C`      | Add raster constraints      |
| `-M`      | Analyze table               |

---

# 14. Install QGIS

Install:

```bash
sudo apt install qgis -y
```

Connect:

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

Describe a table:

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

# Final GIS Architecture

```
                         QGIS
                           |
                           |
                     PostgreSQL 16
                           |
          --------------------------------
          |                              |
       PostGIS                    PostGIS Raster
          |                              |
   Vector datasets              GeoTIFF / DEM data
          |
       pgAdmin 4
          |
        psql
```

This setup supports:

* Shapefiles and GeoPackages
* OpenStreetMap databases
* Satellite imagery
* DEM/elevation models
* Raster analysis
* Spatial SQL
* QGIS projects
* Remote sensing workflows
