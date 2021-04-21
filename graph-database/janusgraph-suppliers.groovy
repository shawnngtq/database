graph = TinkerGraph.open()
g = graph.traversal()

// Create suppliers
getOrCreate = { supplierId, CompanyName ->
  g.V().has('supplier','supplierId', supplierId).
    fold().
    coalesce(unfold(), addV('supplier').property('supplierId', supplierId)).property('CompanyName', CompanyName).next()
}
timestart = System.currentTimeMillis()
new File('suppliers.csv').eachLine { line, number ->
    if (number == 1)
        return
    row = line.split(',')
    getOrCreate(row[0],row[1])
    // println 'getOrCreate:'
    // println System.currentTimeMillis()
}
timeend = System.currentTimeMillis()
println(timeend - timestart)println(timeend - timestart)