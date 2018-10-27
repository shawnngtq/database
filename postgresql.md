# PostgreSQL

## Use pg_dump, pg_restore or psql to backup and restore db or schema
1. Dump a schema to sql and retore
```sql
#dump a schema from a db
pg_dump -h host_ip -p port_number -U user_name -n schema_name db_name > tmp.sql;
#create a db
createdb -h host_ip -p port_number -U user_name target_db;
#restore the schema to the db, no need to specify schema
psql -h host_ip -p port_number -U user_name -d target_db < tmp.sql;
```

2. Dump a schema to binary file and restore
```sql
#dump a schema from a db
pg_dump -h host_ip -p port_number -U user_name -n schema_name db_name -b -F c -f tmp.bin ;
#create a db, no need to create schema
createdb -h host_ip -p port_number -U user_name target_db;
#no need to specify schema, else need to create the schema first
pg_restore -h host_ip -p port_number -U user_name -F c -C -d target_db tmp.bin ;
```

3. Dump a db to binary file and restore only a schema
```sql
#dump an entire db
pg_dump -h host_ip -p port_number -U user_name db_name -b -F c -f tmp.bin ;
#create a db
createdb -h host_ip -p port_number -U user_name target_db;
#create a schema, a must if restoring one schema from an entire db dump
psql -h host_ip -p port_number -U user_name target_db -c "create schema schema_name";
#must specify the schema name
pg_restore -h host_ip -p port_number -U user_name -F c -C -d target_db -n schema_name tmp.bin ;
```

