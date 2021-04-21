graph = TinkerGraph.open()
g = graph.traversal()

// Create categories
getOrCreate = { categoryId, categoryName, description ->
  g.V().has('category','categoryId', categoryId).
    fold().
    coalesce(unfold(), addV('category').property('categoryId', categoryId)).property('categoryName', categoryName).property('description', description).next()
}
timestart = System.currentTimeMillis()
new File('categories.csv').eachLine { line, number ->
    if (number == 1)
        return
    row = line.split(',')
    getOrCreate(row[0],row[1],row[2])
}
timeend = System.currentTimeMillis()
println(timeend - timestart)println(timeend - timestart)