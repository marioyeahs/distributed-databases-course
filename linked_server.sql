use AdventureWorks2019

/*crear servidor vinculado

hacer una consulta entre dos tablas adventures*/

select * from Production.Product
/*
crear stored procedure O TRIGGER para registrar una orden (numero de oreden, ID producto a asociar), verifica que el producto (EndDate = NULL, disponible para venta) 
schema.production, en maquina conrtraria (PRODUCT ID)
schema.sales, desde propia máquina (SALES ORDER ID)
*/

SELECT * FROM OPENQUERY (LINKED_SERVER, 'SELECT product_id FROM production.product');
