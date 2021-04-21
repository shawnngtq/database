graph = TinkerGraph.open()
g = graph.traversal()
graph.createIndex('userId', Vertex.class)

// wikivote
println("Benchmark node creation")
getOrCreate = { id ->
  g.V().has('user','userId', id).
    fold().
    coalesce(unfold(),
             addV('user').property('userId', id)).next()
}
timestart = System.currentTimeMillis()
new File('Wiki-Vote.txt').eachLine {
  if (!it.startsWith("#")){
    (fromVertex, toVertex) = it.split('\t').collect(getOrCreate)
    g.addE('votesFor').from(fromVertex).to(toVertex).iterate()
  }
}
timeend = System.currentTimeMillis()
println(timeend - timestart)

println("Benchmark query")
timestart = System.currentTimeMillis()
g.V().has('user','userId','1629')
timeend = System.currentTimeMillis()
println(timeend - timestart)

println("Query relationship")
timestart = System.currentTimeMillis()
g.V().has('user','userId','30').out('votesFor').values().count()
timeend = System.currentTimeMillis()
println(timeend - timestart)

println("Query 2nd-degree relationship")
timestart = System.currentTimeMillis()
g.V().has('user','userId','30').out('votesFor').out('votesFor').values().count()
timeend = System.currentTimeMillis()
println(timeend - timestart)

println("Query 3rd-degree relationship")
timestart = System.currentTimeMillis()
g.V().has('user','userId','30').repeat(out('votesFor')).times(3).values().count()
timeend = System.currentTimeMillis()
println(timeend - timestart)