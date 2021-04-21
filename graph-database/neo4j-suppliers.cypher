// Create suppliers
LOAD CSV WITH HEADERS FROM 'file:///suppliers.csv' AS row
MERGE (supplier:Supplier {supplierID: row.SupplierID})
  ON CREATE SET supplier.companyName = row.CompanyName;