graph = TinkerGraph.open()
g = graph.traversal()

// Create employees
getOrCreate = { employeeId, firstName, lastName, title ->
  g.V().has('employee','employeeId', employeeId).
    fold().
    coalesce(unfold(), addV('employee').property('employeeId', employeeId)).property('firstName', firstName).property('lastName', lastName).property('title', title).next()
}
timestart = System.currentTimeMillis()
new File('employees.csv').eachLine { line, number ->
    if (number == 1)
        return
    row = line.split(',')
    getOrCreate(row[0],row[2],row[1],row[3])
}
timeend = System.currentTimeMillis()
println(timeend - timestart)println(timeend - timestart)