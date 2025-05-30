DELETE [GRUPO_3312].[ubicacion]
DELETE [GRUPO_3312].[cliente]
DELETE [GRUPO_3312].[sucursal]
DELETE [GRUPO_3312].[proveedor]
DELETE [GRUPO_3312].[envio]
DELETE [GRUPO_3312].[factura]
DELETE [GRUPO_3312].[compra]
DELETE [GRUPO_3312].[pedido]
DELETE [GRUPO_3312].[pedido_cancelacion]
DELETE [GRUPO_3312].[sillon_modelo]
DELETE [GRUPO_3312].[sillon_medida]
DELETE [GRUPO_3312].[material]
DELETE [GRUPO_3312].[detalle_compra]
DELETE [GRUPO_3312].[tela]
DELETE [GRUPO_3312].[relleno]
DELETE [GRUPO_3312].[madera]
DELETE [GRUPO_3312].[composicion]
DELETE [GRUPO_3312].[sillon]
DELETE [GRUPO_3312].[detalle_pedido]
DELETE [GRUPO_3312].[detalle_factura]

DROP TABLE [GRUPO_3312].[detalle_factura]
DROP TABLE [GRUPO_3312].[detalle_pedido]
DROP TABLE [GRUPO_3312].[sillon]
DROP TABLE [GRUPO_3312].[composicion]
DROP TABLE [GRUPO_3312].[madera]
DROP TABLE [GRUPO_3312].[relleno]
DROP TABLE [GRUPO_3312].[tela]
DROP TABLE [GRUPO_3312].[detalle_compra]
DROP TABLE [GRUPO_3312].[material]
DROP TABLE [GRUPO_3312].[sillon_medida]
DROP TABLE [GRUPO_3312].[sillon_modelo]
DROP TABLE [GRUPO_3312].[pedido_cancelacion]
DROP TABLE [GRUPO_3312].[pedido]
DROP TABLE [GRUPO_3312].[compra]
DROP TABLE [GRUPO_3312].[factura]
DROP TABLE [GRUPO_3312].[envio]
DROP TABLE [GRUPO_3312].[proveedor]
DROP TABLE [GRUPO_3312].[sucursal]
DROP TABLE [GRUPO_3312].[cliente]
DROP TABLE [GRUPO_3312].[ubicacion]

DROP SCHEMA GRUPO_3312

DROP PROCEDURE migrar_ubicaciones
DROP PROCEDURE migrar_clientes
DROP PROCEDURE migrar_sucursales
DROP PROCEDURE migrar_proveedores
DROP PROCEDURE migrar_envios
DROP PROCEDURE migrar_facturas
DROP PROCEDURE migrar_compras
DROP PROCEDURE migrar_pedidos
DROP PROCEDURE migrar_pedidos_cancelados
DROP PROCEDURE migrar_sillon_modelos
DROP PROCEDURE migrar_sillon_medidas
DROP PROCEDURE migrar_materiales
DROP PROCEDURE migrar_detalle_compras
DROP PROCEDURE migrar_telas
DROP PROCEDURE migrar_maderas
DROP PROCEDURE migrar_rellenos
DROP PROCEDURE migrar_composiciones
DROP PROCEDURE migrar_sillones
DROP PROCEDURE migrar_detalle_pedidos
DROP PROCEDURE migrar_detalle_facturas
