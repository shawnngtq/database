// Create categories
LOAD CSV WITH HEADERS FROM 'file:///categories.csv' AS row
MERGE (c:Category {categoryID: row.CategoryID})
  ON CREATE SET c.categoryName = row.CategoryName, c.description = row.Description;