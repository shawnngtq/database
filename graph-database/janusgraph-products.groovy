graph = TinkerGraph.open()
g = graph.traversal()

// Create products
getOrCreate = { productId, productName, unitPrice ->
  g.V().has('product','productId', productId).
    fold().
    coalesce(unfold(), addV('product').property('productId', productId)).property('productName', productName).property('unitPrice', unitPrice).next()
}
timestart = System.currentTimeMillis()
new File('products.csv').eachLine { line, number ->
    if (number == 1)
        return
    row = line.split(',')
    getOrCreate(row[0],row[1],row[5])
}
timeend = System.currentTimeMillis()