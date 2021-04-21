graph = TinkerGraph.open()
g = graph.traversal()

// Create orders
getOrCreate = { orderId, shipName ->
  g.V().has('order','orderId', orderId).
    fold().
    coalesce(unfold(), addV('order').property('orderId', orderId)).property('shipName', shipName).next()
}
timestart = System.currentTimeMillis()
new File('orders.csv').eachLine { line, number ->
    if (number == 1)
        return
    row = line.split(',')
    getOrCreate(row[0],row[8])
}
timeend = System.currentTimeMillis()
println(timeend - timestart)