CREATE CONSTRAINT wiki_node_index IF NOT EXISTS ON (n:Node) ASSERT n.nodeID IS UNIQUE;

// wikivote
LOAD CSV WITH HEADERS FROM 'file:///Wiki-Vote.csv' AS row
FIELDTERMINATOR '\t'
MERGE (node:Node {nodeID: row.FromNodeId})
MERGE (node2:Node {nodeID: row.ToNodeId})
MERGE (node)-[r:votesFor]->(node2);

// query user
MATCH (n) WHERE n.nodeID='1629' RETURN n;

// query relationship
MATCH (n:Node {nodeID: '30'})-[r:votesFor]->(n2:Node) RETURN COUNT(n2);

// query 2nd-degree relationship
MATCH (n:Node {nodeID: '30'})-[r:votesFor]->(n2:Node)-[r2:votesFor]->(n3:Node) RETURN COUNT(n3);

// query 3rd-degree relationship
MATCH (n:Node {nodeID: '30'})-[r:votesFor*3..3]->(n2:Node) RETURN COUNT(n2);

// drop data
MATCH (n) DETACH DELETE (n);
// drop constraint
DROP CONSTRAINT wiki_node_index IF EXISTS;