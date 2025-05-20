SELECT * FROM gd_esquema.Maestra

-- Clientes repetidos en maestra
select m1.Cliente_Dni dni_1, m1.Cliente_Nombre nombre_1, m1.Cliente_Apellido apellido_1, m2.Cliente_Dni dni_2, m2.Cliente_Nombre nombre_2, m2.Cliente_Apellido apellido_2, count(*)
from gd_esquema.Maestra m1 join gd_esquema.Maestra m2 on m1.Cliente_Dni = m2.Cliente_Dni
where m1.Cliente_Nombre <> m2.Cliente_Nombre and m1.Cliente_Nombre < m2.Cliente_Nombre
group by m1.Cliente_Dni, m1.Cliente_Nombre, m1.Cliente_Apellido, m2.Cliente_Dni, m2.Cliente_Nombre, m2.Cliente_Apellido

select cliente_nombre, Cliente_Dni, count(*) from gd_esquema.Maestra
where Cliente_Dni = '61180069'
group by Cliente_Nombre, Cliente_Dni
order by 2 desc

-- Proveedores repetidos en maestra
select m1.Proveedor_Cuit cuit_1, m1.Proveedor_Mail nombre_1, m2.Proveedor_Cuit cuit2, m2.Proveedor_Mail nombre_2, count(*)
from gd_esquema.Maestra m1 join gd_esquema.Maestra m2 on m1.Proveedor_Cuit = m2.Proveedor_Cuit
where m1.Proveedor_Mail <> m2.Proveedor_Mail and m1.Proveedor_Mail < m2.Proveedor_Mail
group by m1.Proveedor_Cuit, m1.Proveedor_Mail, m2.Proveedor_Cuit, m2.Proveedor_Mail

-- Sillones repetidos en maestra
select m1.Sillon_Codigo cod_1, m1.Sillon_Modelo_Descripcion, m2.Sillon_Codigo cod_2, m2.Sillon_Modelo_Descripcion, count(*)
from gd_esquema.Maestra m1 join gd_esquema.Maestra m2 on m1.Sillon_Codigo = m2.Sillon_Codigo
where m1.Sillon_Modelo_Descripcion <> m2.Sillon_Modelo_Descripcion
group by m1.Sillon_Codigo, m2.Sillon_Codigo, m1.Sillon_Modelo_Descripcion, m2.Sillon_Modelo_Descripcion

-- Pedidos repetidos en maestra
select m1.Pedido_Numero cod_1, m1.Pedido_Fecha, m2.Pedido_Numero cod_2, m2.Pedido_Fecha, count(*)
from gd_esquema.Maestra m1 join gd_esquema.Maestra m2 on m1.Pedido_Numero = m2.Pedido_Numero
where m1.Pedido_Fecha <> m2.Pedido_Fecha
group by m1.Pedido_Numero, m2.Pedido_Numero, m1.Pedido_Fecha, m2.Pedido_Fecha

-- Sucursal repetidos en maestra
select m1.Sucursal_NroSucursal cod_1, m1.Sucursal_Direccion, m2.Sucursal_NroSucursal cod_2, m2.Sucursal_Direccion, count(*)
from gd_esquema.Maestra m1 join gd_esquema.Maestra m2 on m1.Sucursal_NroSucursal = m2.Sucursal_NroSucursal
where m1.Sucursal_Direccion <> m2.Sucursal_Direccion
group by m1.Sucursal_NroSucursal, m1.Sucursal_Direccion, m2.Sucursal_NroSucursal, m2.Sucursal_Direccion

-- Facturas repetidas en maestra
select m1.Factura_Numero cod_1, m1.Factura_Fecha, m2.Factura_Numero cod_2, m2.Factura_Fecha, count(*)
from gd_esquema.Maestra m1 join gd_esquema.Maestra m2 on m1.Factura_Numero = m2.Factura_Numero
where m1.Factura_Fecha <> m2.Factura_Fecha
group by m1.Factura_Numero, m1.Factura_Fecha, m2.Factura_Numero, m2.Factura_Fecha

-- Compras repetidas en maestra
select m1.Compra_Numero cod_1, m1.Compra_Fecha, m2.Compra_Numero cod_2, m2.Compra_Fecha, count(*)
from gd_esquema.Maestra m1 join gd_esquema.Maestra m2 on m1.Compra_Numero = m2.Compra_Numero
where m1.Compra_Fecha <> m2.Compra_Fecha
group by m1.Compra_Numero, m1.Compra_Fecha, m2.Compra_Numero, m2.Compra_Fecha

