# PostgreSQL Up & Running

1. The Basics
2. Database Administration
3. psql

## 1. The Basics
| Component | Description |
| --- | --- |
| service | More than 1 service can run on a physical server when they listen on different ports and data storage |
| database | Each service houses many individual DBs |
| schema | Part of ANSI SQL standard, immediate next level of organization within each DB. PSQL puts everything you create into `public` schema by default unless you change `search_path` |
| catalog | System schemas that store PSQL built-in functions and metadata. 2 catalogs: `pg_catalog` and `information_schema` |
| variable | They are various options that can be set at service/DB/other level. (such as `search_path`) |
| extension | Allow devs to package functions, data types, casts, custom index types, tables etc for installation/removal as a unit |
| table | Citizens of their respective schemas |
| foreign table | Virtual tables linked to external data source such as csv/psql/sql/oracle/nosql | 
| tablespace | Physical location that stores data |
| view | Abstracting queries and allow for updating data view a view |
| function | You can write functions to manipulate data | 
| language | PSQL supports SQL, PL/pgSQL and C by default |
| operator | Symbolic, named functions (e.g., =, &&) |
| data type | Integers, characters, arrays, composite type |
| cast | For converting data from 1 data type to another |
| sequence | Controls the autoincrementation of a serial data type | 
| row | Rows can be treated independently from their respective tables | 
| trigger | Detect data-change events |
| rule | Instructions to substitute 1 action for another |

## 2. Database Administration

### Configuration Files
| Files | Description |
| --- | --- |
| postgresql.conf | Controls general settings |
| pg_hba.conf | Controls security |
| pg_ident.conf | Maps an authenticated OS login to a PSQL user |

Find the location of config files:
```sql
SELECT name, setting FROM pg_settings WHERE category='File Locations';
```

### postgresql.conf
Find the key settings:
```sql
/* 
unit
    Tells you the measurement unit reported by the settings
setting
    Is the current setting
    `boot_val`: default setting
    `reset_val`: the new setting if you restart/reload the server
*/
SELECT name, context, unit, setting, boot_val, reset_val 
FROM pg_settings 
WHERE name IN ('listen_addresses','max_connections','shared_buffers','effective_cache_size','work_mem','maintenance_work_mem') 
ORDER BY context, name;
```

| Network settings | Description |
| --- | --- |
| listen_address | Inform IP address (default: localhost/local) |
| port | default: 5432 |
| max_connections | The max. # of concurrent connections allowed |
| shared_buffers | Defines the amount of memory shared among all connections to store recently accessed pages |
| effective_cache_size | An estimate of how much memory you expect to be available |
| work_mem | Controls the maximum amount of memory allocated for operations such as sorting, hash join, and table scans |
| maintenance_work_mem | The total memory allocated for housekeeping activities such as vacuuming |

To restart service:
```sql
SELECT pg_reload_conf()
```

### pg_hba.conf
#### Authentication Methods
| Methods | Description |
| --- | --- |
| trust | The least secure of the authentication schemes. It allows people to self-identify and doesn’t ask for a password |
| md5 | Very common, requiring an md5-encrypted password to connect |
| password | Uses clear-text password authentication |
| ident | Uses pg_ident.conf to see whether the OS account of the user trying to connect has a mapping to a PostgreSQL account |
| peer | Uses the client’s OS name from the kernel | 

### Managing Connections
Typical sequence to cancel running queries and terminate connections:

1. Retrieve a listing of recent connections and process IDs: `SELECT * FROM pg_stat_activity;`
2. Cancel all active queries on a connection: `SELECT pg_cancel_backend(procid)`
3. Kill connection: `SELECT pg_terminate_backend(procid)`

Kill all connections belonging to a role:
```sql
SELECT pg_terminate_backend(pid) 
FROM pg_stat_activity 
WHERE usename = 'some_role';
```

### Roles
#### Creating Login Rules
```sql
-- Creating login roles
CREATE ROLE leo LOGIN PASSWORD 'king' CREATEDB VALID UNTIL 'infinity';

-- Creating superuser roles
CREATE ROLE regina LOGIN PASSWORD 'queen' SUPERUSER VALID UNTIL '2020-1-1 00:00';
```

#### Creating Group Roles
```sql
-- Creating a group role
CREATE ROLE royalty INHERIT;

-- Add roles to the group role
GRANT royalty TO leo;
GRANT royalty TO regina;

-- Inherit rights from group roles
SET ROLE royalty;
```

### Database Creation
```sql
CREATE DATABASE mydb;
```

### Template Databases
```sql
-- Create a database modeled after a template
CREATE DATABASE my_db TEMPLATE my_template_db;

-- To make database a template
UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'mydb';
```

### Using Schemas
Default search path:
```sql
search_path = "$user", public;
```

```sql
-- Create new schema
CREATE SCHEMA my_extensions;
-- Add new schema to the search path
ALTER DATABASE mydb SET search_path='"$user", public, my_extensions';
```

### Privileges
```sql
-- Create a role that will own the DB and can login
CREATE ROLE mydb_admin LOGIN PASSWORD 'something';
-- Create the DB and set the owner
CREATE DATABASE mydb WITH OWNER = mydb_admin;
```

#### Grant
```sql
-- The grantee can grant onwards
GRANT ALL ON ALL TABLES IN SCHEMA public TO mydb_admin WITH GRANT OPTION;
-- Grant all relevant privileges on an object use ALL instead of specific privilege
GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA my_schema TO PUBLIC;
-- ALL can be used to grant for all objects within a DB/schema
GRANT SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA my_schema TO PUBLIC;
-- Grant privileges to all roles, use PUBLIC
GRANT USAGE ON SCHEMA my_schema TO PUBLIC;
-- Revoke some defaults privileges
REVOKE EXECUTE ON ALL FUNCTIONS IN SCHEMA my_schema FROM PUBLIC;
```

#### Default Privileges
```sql
GRANT USAGE ON SCHEMA my_schema TO PUBLIC;
ALTER DEFAULT PRIVILEGES IN SCHEMA my_schema GRANT SELECT, REFERENCES ON TABLES TO PUBLIC;

ALTER DEFAULT PRIVILEGES IN SCHEMA my_schema GRANT ALL ON TABLES TO mydb_admin WITH GRANT OPTION;

ALTER DEFAULT PRIVILEGES IN SCHEMA my_schema GRANT SELECT, UPDATE ON SEQUENCES TO PUBLIC;

ALTER DEFAULT PRIVILEGES IN SCHEMA my_schema GRANT ALL ON FUNCTIONS TO mydb_admin WITH GRANT OPTION;

ALTER DEFAULT PRIVILEGES IN SCHEMA my_schema GRANT USAGE ON TYPES TO PUBLIC;
```

Being the owner of a PSQL DB doesn't give you access to all objects in the DB. But it grants you privileges to whatever object your create and allows you to drop the DB.

### Extensions
They are add-ons you can install.

```sql
-- Extensions installed
SELECT name, default_version, installed_version, left(comment,30) AS comment
FROM pg_available_extensions
WHERE installed_version IS NOT NULL
ORDER BY name;

-- Details about particular extension \dx+ <extensions name>
SELECT pg_catalog.pg_describe_object(d.classid, d.objid, 0) AS description
FROM pg_catalog.pg_depend AS D INNER JOIN pg_catalog.pg_extension AS E
ON D.refobjid = E.oid
WHERE D.refclassid = 'pg_catalog.pg_extension'::pg_catalog.regclass AND deptype = 'e' AND E.extname = 'fuzzystrmatch';
```

#### Installing Extensions

1. Download binary files & libraries and copy to right location. View available extensions

`SELECT * FROM pg_available_extensions;`

2. Install extension to DB: 
```sql
-- Install fuzzystrmatch using query
CREATE EXTENSION fuzzystrmatch;
-- Install using psql
psql -p 5432 -d mydb -c "CREATE EXTENSION fuzzystrmatch;"
-- Create schema to house extensions
CREATE EXTENSION fuzzystrmatch SCHEME my_extensions;
```

#### Common Extensions
| Extension | Description |
| --- | --- |
| btree_gist | Provides GiST index-operator classes that implement B-Tree equivalent behavior for common B-Tree services data types |
| btree_gin | Provides GIN index-operator classes that implement B-Tree equivalent behavior for common B-Tree serviced data types |
| postgis | Elevates PostgreSQL to a PostGIS in Action state-of-the-art spatial database out‐rivaling all commercial options |
| fuzzystrmatch | With functions such as soundex, levenshtein, and meta phone for fuzzy string matching |
| hstore | An extension that adds key-value pair storage and index support, well-suited for storing pseudonormalized data |
| pg_trgm | Another fuzzy string search library, used in conjunction with fuzzystrmatch |
| dblink | Allows you to query a PostgreSQL database on another server |
| pgcrypto | Provides encryption tools, including the popular PGP |

### Backup and Restore
```sql
-- Create a compressed, single DB backup
pg_dump -h localhost -p 5432 -U someuser -F c -b -v -f mydb.backup mydb
-- Create a plain-text single DB backup
pg_dump -h localhost -p 5432 -U someuser -C -F p -b -v -f mydb.backup mydb
-- Create a compressed backup of tables starting with "pay"
pg_dump -h localhost -p 5432 -U someuser -F c -b -v -t *.pay* -f pay.backup mydb
-- Create a compressed backup of all objects in the hr & payroll schemas
pg_dump -h localhost -p 5432 -U someuser -F c -b -v -n hr -n payroll -f hr.backup mydb
-- Create a compressed backup of all objects in all schemas, exclude public schema
pg_dump -h localhost -p 5432 -U someuser -F c -b -v -N public -f all_sch_except_pub.backup mydb

-- Create a plain-text SQL backup
pg_dump -h localhost -p 5432 -U someuser -F p --column-inserts -f select_tables.backup mydb

-- Create directory format backup
pg_dump -h localhost -p 5432 -U someuser -F d -f /somepath/a_directory mydb
-- Create directory format parallel backup
pg_dump -h localhost -p 5432 -U someuser -j 3 -Fd -f /somepath/a_directory mydb

-- Backup all DB roles and tablespaces
pg_dumpall -h localhost -U postgres --port=5432 -f myglobals.sql --globals-only
-- Backup all DB roles
pg_dumpall -h localhost -U postgres --port=5432 -f myroles.sql --roles-only





-- To restore a full backup and ignore errors:
psql -U postgres -f myglobals.sql
-- To restore, stopping if any error is found:
psql -U postgres --set ON_ERROR_STOP=on -f myglobals.sql
-- To restore to a specific database:
psql -U postgres -d mydb -f select_objects.sql

-- Restore
pg_restore --dbname=mydb --jobs=4 --verbose mydb.backup
-- Restore just the structure without the data
pg_restore --dbname=mydb2 --section=pre-data --jobs=4 mydb.backup
```

### Managing Disk Storage with Tablespaces
```sql
-- Creating tablespaces
CREATE TABLESPACE secondary LOCATION '/usr/data/pgdata94_secondary';
-- Moving all objects in DB to secondary tablespace
ALTER DATABASE mydb SET TABLESPACE secondary;
-- Moving just 1 table
ALTER TABLE mytable SET TABLESPACE secondary;
-- To move all objects from default tablespace to secondary
ALTER TABLESPACE pg_default MOVE ALL TO secondary;
```

## 3. psql
```sql
-- To execute a file
psql -f some_script_file
-- To execute SQL on the fly
psql -d postgresql_book -c "DROP TABLE IF EXISTS dross; CREATE SCHEMA staging;"

```