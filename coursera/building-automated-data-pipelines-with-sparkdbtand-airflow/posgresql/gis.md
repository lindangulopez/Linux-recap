# Linux GIS Workstation Setup Guide

This guide installs and configures:

* **PostgreSQL 16** — database server
* **PostGIS 3.4** — spatial vector support
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

Check version:

```bash
psql --version
```

Example:

```
psql (PostgreSQL) 16.14
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

Example result:

```
postgresql-16-postgis-3 is already the newest version
```

Restart PostgreSQL:

```bash
sudo systemctl restart postgresql
```

---

# 4. Configure Password Authentication

Ubuntu PostgreSQL defaults to **peer authentication**.

This means:

```
Linux user = PostgreSQL user
```

For example:

```
Linux user: linda
PostgreSQL user: gisuser
```

will fail.

Edit:

```bash
sudo nano /etc/postgresql/16/main/pg_hba.conf
```

Find:

```
local   all             all                                     peer
```

Change to:

```
local   all             all                                     scram-sha-256
```

Keep:

```
local   all             postgres                                peer
```

The final section should look like:

```
local   all             postgres                                peer
local   all             all                                     scram-sha-256

host    all             all             127.0.0.1/32            scram-sha-256
host    all             all             ::1/128                 scram-sha-256
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

# 5. Create the GIS Database User

Enter PostgreSQL as administrator:

```bash
sudo -u postgres psql
```

Create GIS user:

```sql
CREATE USER gisuser WITH PASSWORD 'choose_a_strong_password';
```

Allow database creation:

```sql
ALTER USER gisuser CREATEDB;
```

Check:

```sql
\du
```

Exit:

```sql
\q
```

---

# 6. Create the GIS Database

Create database:

```bash
sudo -u postgres createdb gis_database
```

Set ownership:

```bash
sudo -u postgres psql
```

Run:

```sql
ALTER DATABASE gis_database OWNER TO gisuser;
```

Exit:

```sql
\q
```

---

# 7. Enable PostGIS Extensions

Important:

**Extensions must be created by the PostgreSQL administrator.**

Connect:

```bash
sudo -u postgres psql -d gis_database
```

Enable PostGIS:

```sql
CREATE EXTENSION postgis;
```

Enable topology:

```sql
CREATE EXTENSION postgis_topology;
```

Enable raster:

```sql
CREATE EXTENSION postgis_raster;
```

Expected:

```
CREATE EXTENSION
```

---

# 8. Verify PostGIS Installation

Run:

```sql
SELECT postgis_full_version();
```

Expected:

```
POSTGIS="3.4.2"
PGSQL="160"
GEOS="3.12.1"
PROJ="9.4.0"
GDAL="3.8.4"
TOPOLOGY
RASTER
```

Check extensions:

```sql
\dx
```

Expected:

```
Name              Version
--------------------------------
plpgsql           1.0
postgis           3.4.2
postgis_raster    3.4.2
postgis_topology  3.4.2
```

Test raster:

```sql
SELECT postgis_raster_lib_version();
```

Expected:

```
3.4.2 c19ce56
```

---

# 9. Test Spatial Functions

Geometry test:

```sql
SELECT ST_AsText(
ST_SetSRID(ST_Point(2.3522,48.8566),4326)
);
```

Result:

```
POINT(2.3522 48.8566)
```

This confirms spatial SQL is working.

---

# 10. Install GDAL GIS Tools

Install:

```bash
sudo apt install gdal-bin python3-gdal -y
```

Check:

```bash
gdalinfo --version
```

Example:

```
GDAL 3.8.4
```

Check raster import:

```bash
raster2pgsql -G
```

---

# 11. Install pgAdmin 4

Add repository key:

```bash
curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | \
sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg
```

Add repository:

```bash
echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" | \
sudo tee /etc/apt/sources.list.d/pgadmin4.list
```

Install:

```bash
sudo apt update
sudo apt install pgadmin4-desktop -y
```

Launch:

```bash
pgadmin4
```

---

# 12. Configure pgAdmin

Register server:

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

Database:

```
gis_database
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

---

# 13. Install QGIS

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

# 14. Import Vector Data

Example:

```
roads.shp
```

Import:

```bash
shp2pgsql \
-I \
-s 4326 \
roads.shp \
public.roads \
| psql -U gisuser -d gis_database
```

---

# 15. Import Raster Data

Example:

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

# 16. PostgreSQL GIS Performance Tuning

Edit:

```bash
sudo nano /etc/postgresql/16/main/postgresql.conf
```

For a workstation with 16GB+ RAM:

```
shared_buffers = 2GB
work_mem = 64MB
maintenance_work_mem = 512MB
```

Restart:

```bash
sudo systemctl restart postgresql
```

---

# 17. Useful psql Commands

Connect:

```bash
psql -U gisuser -d gis_database -W
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

Your completed system supports:

* Shapefiles
* GeoPackages
* OpenStreetMap databases
* GeoTIFF imagery
* DEM/elevation models
* Raster analysis
* Spatial SQL
* QGIS projects
* Remote sensing workflows

Your current installation has successfully completed the core GIS database stage. The next logical configuration step would be creating a GIS schema structure (`raw`, `working`, `analysis`, `published`) and setting up automatic backups.
