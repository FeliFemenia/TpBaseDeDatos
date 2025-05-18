CREATE PROCEDURE migrar_ubicacion
AS 

INSERT INTO GRUPO_3312.ubicacion (ubi_provincia, ubi_localidad, ubi_direccion)
SELECT Sucursal_Provincia, Sucursal_Localidad, Sucursal_Direccion 
from gd_esquema.Maestra
WHERE Sucursal_Provincia is not null and Sucursal_Localidad is not null and Sucursal_Direccion is not null
group by Sucursal_Provincia, Sucursal_Localidad, Sucursal_Direccion

INSERT INTO GRUPO_3312.ubicacion (ubi_provincia, ubi_localidad, ubi_direccion)
SELECT Cliente_Provincia, Cliente_Localidad, Cliente_Direccion 
from gd_esquema.Maestra
WHERE Cliente_Provincia is not null and Cliente_Localidad is not null and Cliente_Direccion is not null
group by Cliente_Provincia, Cliente_Localidad, Cliente_Direccion 

INSERT INTO GRUPO_3312.ubicacion (ubi_provincia, ubi_localidad, ubi_direccion)
SELECT Proveedor_Provincia, Proveedor_Localidad, Proveedor_Direccion 
from gd_esquema.Maestra
WHERE Proveedor_Provincia is not null and Proveedor_Localidad is not null and Proveedor_Direccion is not null
group by Proveedor_Provincia, Proveedor_Localidad, Proveedor_Direccion 
GO

CREATE PROCEDURE migrar_clientes
AS 
INSERT INTO GRUPO_3312.cliente (clie_dni, clie_ubicacion, clie_nombre, clie_apellido, clie_fechaNacimiento, clie_mail, clie_telefono)
SELECT 
	m2.Cliente_Dni, 
	(select ubi_codigo from GRUPO_3312.ubicacion join gd_esquema.Maestra m1
	on m1.Cliente_Provincia = ubi_provincia and m1.Cliente_Localidad = ubi_localidad and m1.Cliente_Direccion = ubi_direccion
	where m2.Cliente_Dni = m1.Cliente_Dni
	group by ubi_codigo) ubi_codigo,
	m2.Cliente_Nombre, m2.Cliente_Apellido, m2.Cliente_FechaNacimiento, m2.Cliente_Mail, m2.Cliente_Telefono
	from gd_esquema.Maestra m2
	WHERE m2.Cliente_Dni is not null
	group by Cliente_Dni, m2.Cliente_Nombre, m2.Cliente_Apellido, m2.Cliente_FechaNacimiento, m2.Cliente_Mail, m2.Cliente_Telefono 



SELECT * FROM gd_esquema.Maestra

exec migrar_ubicacion
exec migrar_clientes

select * from GRUPO_3312.cliente join GRUPO_3312.ubicacion on clie_ubicacion = ubi_codigo



