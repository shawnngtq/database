-- List tables
select
    tablename
from
    pg_catalog.pg_tables
where
    schemaname not in ('pg_catalog', 'information_schema');
-- List tables pgSQL
do $$
declare r record;

query text;

begin query := 'SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname NOT IN (''pg_catalog'', ''information_schema'')';

for r in execute query loop raise notice 'tablename: %',
r.tablename;
end loop;
end;

$$;
-- Count of all tables
-- Search for column name
select
    t.table_schema,
    t.table_name
from
    information_schema.tables t
inner join information_schema.columns c on
    c.table_name = t.table_name
    and c.table_schema = t.table_schema
where
    c.column_name like '%column_name%'
    and t.table_schema not in ('information_schema', 'pg_catalog')
    and t.table_type = 'BASE TABLE'
order by
    t.table_schema;

/* FULL-TEXT SEARCH */
select
    to_tsvector('The quick brown fox jumped over the lazy dog.');

select
    to_tsvector('The quick brown fox jumped over the lazy dog') @@ to_tsquery('fox');

select
    to_tsvector('The quick brown fox jumped over the lazy dog') @@ to_tsquery('foxes');

select
    to_tsvector('The quick brown fox jumped over the lazy dog') @@ to_tsquery('foxtrot');

select
    to_tsvector('The quick brown fox jumped over the lazy dog') @@ to_tsquery('jumping');

select
    to_tsvector('The quick brown fox jumped over the lazy dog') @@ to_tsquery('fox & dog');

select
    to_tsvector('The quick brown fox jumped over the lazy dog') @@ to_tsquery('fox | clown');

select
    to_tsvector('The quick brown fox jumped over the lazy dog') @@ to_tsquery('!clown');

select
    to_tsvector('The quick brown fox jumped over the lazy dog') @@ to_tsquery('fox & (dog | clown) & !queen');