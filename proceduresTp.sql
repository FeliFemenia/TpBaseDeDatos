CREATE PROCEDURE migrar_ubicacion
AS 
    BEGIN
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
    END
GO

CREATE PROCEDURE migrar_clientes
AS
    BEGIN
    INSERT INTO GRUPO_3312.cliente (clie_dni, clie_ubicacion, clie_nombre, clie_apellido, clie_fechaNacimiento, clie_mail, clie_telefono)
    SELECT
            m2.Cliente_Dni,
            (select ubi_codigo from GRUPO_3312.ubicacion join gd_esquema.Maestra m1
            on m1.Cliente_Provincia + m1.Cliente_Localidad + m1.Cliente_Direccion = ubi_provincia + ubi_localidad + ubi_direccion
            where m2.Cliente_Dni = m1.Cliente_Dni
            group by ubi_codigo) ubi_codigo,
            m2.Cliente_Nombre, m2.Cliente_Apellido, m2.Cliente_FechaNacimiento, m2.Cliente_Mail, m2.Cliente_Telefono
        from gd_esquema.Maestra m2
        WHERE m2.Cliente_Dni is not null
        group by Cliente_Dni, m2.Cliente_Nombre, m2.Cliente_Apellido, m2.Cliente_FechaNacimiento, m2.Cliente_Mail, m2.Cliente_Telefono
    END
GO

CREATE PROCEDURE migrar_sucursales
AS
    BEGIN
    INSERT INTO GRUPO_3312.sucursal (suc_numero, suc_ubicacion, suc_telefono, suc_mail)
    SELECT
        m2.Sucursal_NroSucursal,
        (select ubi_codigo from GRUPO_3312.ubicacion join gd_esquema.Maestra m1
         on m1.Sucursal_Provincia + m1.Sucursal_Localidad + m1.Sucursal_Direccion = ubi_provincia + ubi_localidad + ubi_direccion
         where m2.Sucursal_NroSucursal = m1.Sucursal_NroSucursal
         group by ubi_codigo) ubi_codigo,
        m2.Sucursal_Telefono, m2.Sucursal_Mail
    from gd_esquema.Maestra m2
    WHERE m2.Sucursal_NroSucursal is not null
    group by m2.Sucursal_NroSucursal, m2.Sucursal_Telefono, m2.Sucursal_Mail
    END
GO

CREATE PROCEDURE migrar_proveedores
AS
    BEGIN
    INSERT INTO GRUPO_3312.proveedor (prov_cuit, prov_ubicacion, prov_razonSocial, prov_telefono, prov_mail)
    SELECT
        m2.Proveedor_Cuit,
        (select ubi_codigo from GRUPO_3312.ubicacion join gd_esquema.Maestra m1
         on m1.Proveedor_Provincia + m1.Proveedor_Localidad + m1.Proveedor_Direccion = ubi_provincia + ubi_localidad + ubi_direccion
         where m2.Proveedor_Cuit = m1.Proveedor_Cuit
         group by ubi_codigo) ubi_codigo,
        m2.Proveedor_RazonSocial, m2.Proveedor_Telefono, m2.Proveedor_Mail
    from gd_esquema.Maestra m2
    WHERE m2.Proveedor_Cuit is not null
    group by m2.Proveedor_Cuit, m2.Proveedor_RazonSocial, m2.Proveedor_Telefono, m2.Proveedor_Mail
    END
GO

CREATE PROCEDURE migrar_envios
AS
BEGIN
    INSERT INTO GRUPO_3312.envio (env_numero, env_fechaProgramada, env_fechaEntrega, env_importeTraslado, env_importeSubida, env_total)
    SELECT Envio_Numero, Envio_Fecha_Programada, Envio_Fecha, Envio_ImporteTraslado, Envio_ImporteSubida, Envio_Total
    from gd_esquema.Maestra
    WHERE Envio_Numero is not null
    END
GO

CREATE PROCEDURE migrar_facturas
AS
    BEGIN
    INSERT INTO GRUPO_3312.factura (fact_numero, fact_sucursal, fact_cliente, fact_envio, fact_total, fact_fecha)
    SELECT
        m2.Factura_Numero,
        (select suc_numero from GRUPO_3312.sucursal join gd_esquema.Maestra m1
         on m1.Sucursal_NroSucursal = suc_numero
         where m2.Factura_numero = m1.Factura_Numero
         group by suc_numero) suc_numero,
        (select clie_dni from GRUPO_3312.cliente join gd_esquema.Maestra m1
         on m1.Cliente_DNI = clie_dni
         where m2.Factura_numero = m1.Factura_Numero
         group by clie_dni) clie_dni,
        (select env_numero from GRUPO_3312.envio join gd_esquema.Maestra m1
         on m1.Envio_Numero = env_numero
         where m1.Envio_Numero = m2.Envio_Numero
		 group by env_numero) env_numero,
        m2.Factura_Total, m2.Factura_Fecha
    from gd_esquema.Maestra m2
    WHERE m2.Factura_Numero is not null and m2.Envio_Numero is not null
    group by m2.Factura_Numero, m2.Factura_Total, m2.Factura_Fecha, m2.Envio_Numero
    END
GO

exec migrar_ubicacion
exec migrar_clientes
exec migrar_sucursales
exec migrar_proveedores
exec migrar_envios
exec migrar_facturas


select * from GRUPO_3312.cliente join GRUPO_3312.ubicacion on clie_ubicacion = ubi_codigo



