# Graph Database

- Using northwind dataset <https://neo4j.com/developer/guide-importing-data-and-etl/>, benchmark Neo4j and Janusgraph
- <https://tinkerpop.apache.org/docs/3.4.6/tutorials/getting-started/#_loading_data>
- <https://stackoverflow.com/questions/42061258/gremlin-query-to-load-csv-file-with-selected-column>
- <https://medium.com/@BGuigal/janusgraph-python-9e8d6988c36c>

- [Graph Database](#graph-database)
  - [Neo4j Execution](#neo4j-execution)
  - [JanusGraph Execution](#janusgraph-execution)
  - [Tigergraph Execution](#tigergraph-execution)
  - [Dgraph Execution](#dgraph-execution)

## Neo4j Execution

```bash
# docker start shell
docker exec -i --tty musing_tu cypher-shell -u neo4j

# check neo4j status
./neo4j-community-4.2.3/bin/neo4j status
# neo4j start
./neo4j-community-4.2.3/bin/neo4j start
# login cypher-shell
./neo4j-community-4.2.3/bin/cypher-shell
# total number of nodes
MATCH (n) RETURN COUNT(n);
# empty database
MATCH (n) DETACH DELETE (n);

# run benchmark dataset categories.csv
./neo4j-community-4.2.3/bin/cypher-shell -f neo4j-categories.cypher
# run benchmark dataset employees.csv
./neo4j-community-4.2.3/bin/cypher-shell -f neo4j-employees.cypher
# run benchmark dataset suppliers.csv
./neo4j-community-4.2.3/bin/cypher-shell -f neo4j-suppliers.cypher
# run benchmark dataset products.csv
./neo4j-community-4.2.3/bin/cypher-shell -f neo4j-products.cypher
# run benchmark dataset orders.csv
./neo4j-community-4.2.3/bin/cypher-shell -f neo4j-orders.cypher
# run benchmark dataset Wiki-Vote.csv
./neo4j-community-4.2.3/bin/cypher-shell -f neo4j-wiki-vote.cypher
```

## JanusGraph Execution

```bash
# docker start shell
docker exec -it nostalgic_mayer bash
./bin/gremlin.sh

# run benchmark dataset categories.csv
./janusgraph-full-0.5.3/bin/gremlin.sh -e janusgraph-categories.csv
# run benchmark dataset employees.csv
./janusgraph-full-0.5.3/bin/gremlin.sh -e janusgraph-employees.csv
# run benchmark dataset suppliers.csv
./janusgraph-full-0.5.3/bin/gremlin.sh -e janusgraph-suppliers.csv
# run benchmark dataset products.csv
./janusgraph-full-0.5.3/bin/gremlin.sh -e janusgraph-products.csv
# run benchmark dataset orders.csv
./janusgraph-full-0.5.3/bin/gremlin.sh -e janusgraph-orders.csv
# run benchmark dataset Wiki-Vote.csv
./janusgraph-full-0.5.3/bin/gremlin.sh -e janusgraph-wiki-vote.csv
```

## Tigergraph Execution

```bash
# run benchmark dataset Wiki-Vote.csv
./gsql tigergraph-wiki-vote.gsql
```

## Dgraph Execution

```bash
# drop all
curl -X POST localhost:8080/alter -d '{"drop_all": true}'

# query specific uid
curl -H "Content-Type: application/dql" localhost:8080/query -XPOST -d '
{
  node(func: uid(0x01)) {
    uid
    ProductName
		SupplierID
		CategoryID
		QuantityPerUnit
		UnitPrice
		UnitsInStock
		UnitsOnOrder
		ReorderLevel
		Discontinued
  }
}' | python -m json.tool | less

# run benchmark dataset categories.csv
./dgraph-categories.sh
# run benchmark dataset employees.csv
./dgraph-employees.sh
# run benchmark dataset suppliers.csv
./dgraph-suppliers.sh
# run benchmark dataset products.csv
./dgraph-products.sh
# run benchmark dataset orders.csv
./dgraph-orders.sh
# run benchmark dataset Wiki-Vote.csv
./dgraph-wiki-vote.sh
```
