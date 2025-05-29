CREATE PROCEDURE migrar_ubicaciones
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
    WHERE m2.Factura_Numero is not null and m2.Detalle_Factura_Precio is null
    group by m2.Factura_Numero, m2.Factura_Total, m2.Factura_Fecha, m2.Envio_Numero
    END
GO

CREATE PROCEDURE migrar_compras
AS
    BEGIN
    INSERT INTO GRUPO_3312.compra (comp_numero, comp_sucursal, comp_proveedor, comp_fecha, comp_total)
    SELECT
        m2.Compra_Numero,
        (select suc_numero from GRUPO_3312.sucursal join gd_esquema.Maestra m1
        on suc_numero = m1.Sucursal_NroSucursal
        where m1.Compra_Numero = m2.Compra_Numero
        group by suc_numero),
        (select prov_cuit from GRUPO_3312.proveedor join gd_esquema.Maestra m1
         on prov_cuit = m1.Proveedor_Cuit
         where m1.Compra_Numero = m2.Compra_Numero
         group by prov_cuit),
        m2.Compra_Fecha,
        m2.Compra_Total
    from gd_esquema.Maestra m2
	where m2.Compra_Numero is not null
	group by m2.Compra_Numero, m2.Compra_Fecha, m2.Compra_Total
    END
GO

CREATE PROCEDURE migrar_pedidos
AS
    BEGIN
    INSERT INTO GRUPO_3312.pedido (ped_numero, ped_sucursal, ped_cliente, ped_fecha, ped_total, ped_estado)
    SELECT
        m2.Pedido_Numero,
        (select suc_numero from GRUPO_3312.sucursal join gd_esquema.Maestra m1
          on suc_numero = m1.Sucursal_NroSucursal
          where m1.Pedido_Numero = m2.Pedido_Numero
		  group by suc_numero),
        (select clie_dni from GRUPO_3312.cliente join gd_esquema.Maestra m1
         on clie_dni = m1.Cliente_Dni
         where m1.Pedido_Numero = m2.Pedido_Numero
		 group by clie_dni),
        m2.Pedido_Fecha,
        m2.Pedido_Total,
        m2.Pedido_Estado
    from gd_esquema.Maestra m2
	WHERE m2.Pedido_Numero is not null
	group by m2.Pedido_Numero, m2.Pedido_Fecha, m2.Pedido_Total, m2.Pedido_Estado
    END
GO

CREATE PROCEDURE migrar_pedidos_cancelados
AS
    BEGIN
    INSERT INTO GRUPO_3312.pedido_cancelacion (ped_canc_pedido, ped_canc_motivo, ped_canc_fecha)
    SELECT
        (select ped_numero from GRUPO_3312.pedido join gd_esquema.Maestra m1
        on ped_numero = m1.Pedido_Numero
        where m2.Pedido_Numero = m1.Pedido_Numero
        group by ped_numero),
        m2.Pedido_Cancelacion_Motivo,
        m2.Pedido_Cancelacion_Fecha
    from gd_esquema.Maestra m2
    WHERE m2.Pedido_Numero is not null and m2.Pedido_Cancelacion_Motivo is not null
    group by m2.Pedido_Cancelacion_Motivo, m2.Pedido_Cancelacion_Fecha, m2.Pedido_Numero
    END
GO

CREATE PROCEDURE migrar_sillon_modelos
AS
    BEGIN
    INSERT INTO GRUPO_3312.sillon_modelo (sill_mod_codigo, sill_mod_precio, sill_mod_descripcion, sill_mod_modelo)
    SELECT Sillon_Modelo_Codigo, Sillon_Modelo_Precio, Sillon_Modelo_Descripcion, Sillon_Modelo
    FROM gd_esquema.Maestra
    WHERE Sillon_Modelo_Codigo is not null
    group by Sillon_Modelo_Codigo, Sillon_Modelo_Precio, Sillon_Modelo_Descripcion, Sillon_Modelo
    END
GO

CREATE PROCEDURE migrar_sillon_medidas
AS
    BEGIN
    INSERT INTO GRUPO_3312.sillon_medida (sill_med_alto, sill_med_ancho, sill_med_profundidad, sill_med_precio)
    SELECT
        Sillon_Medida_Alto, Sillon_Medida_Ancho, Sillon_Medida_Profundidad, Sillon_Medida_Precio
    from gd_esquema.Maestra
    WHERE Sillon_Codigo is not null
    group by Sillon_Medida_Alto, Sillon_Medida_Ancho, Sillon_Medida_Profundidad, Sillon_Medida_Precio
    END
GO

CREATE PROCEDURE migrar_materiales
AS
    BEGIN
    INSERT INTO GRUPO_3312.material (mat_precio, mat_tipo)
    SELECT Material_Precio, Material_Tipo
	FROM gd_esquema.Maestra
    WHERE Material_Precio is not null and Material_Tipo is not null
    GROUP BY Material_Precio, Material_Tipo
    END
GO

CREATE PROCEDURE migrar_detalle_compras
AS
    BEGIN
    INSERT INTO GRUPO_3312.detalle_compra (det_comp_numero, det_comp_material, det_comp_subtotal, det_comp_precio, det_comp_cantidad)
    SELECT
        (select comp_numero from GRUPO_3312.compra
         where comp_numero = m2.Compra_Numero
         group by comp_numero),
        (select mat_codigo from GRUPO_3312.material
         where mat_precio = m2.Material_Precio and mat_tipo = m2.Material_Tipo
         group by mat_codigo),
        m2.Detalle_Compra_SubTotal,
        m2.Detalle_Compra_Precio,
        m2.Detalle_Compra_Cantidad
    from gd_esquema.Maestra m2
    WHERE m2.Compra_Numero is not null
    group by m2.Detalle_Compra_SubTotal, m2.Detalle_Compra_Precio, m2.Detalle_Compra_Cantidad, m2.Compra_Numero, m2.Material_Precio, m2.Material_Tipo
    END
GO

CREATE PROCEDURE migrar_telas
AS
    BEGIN
        INSERT INTO GRUPO_3312.tela (tela_material, tela_color, tela_textura, tela_nombre, tela_descripcion)
        SELECT (select mat_codigo from GRUPO_3312.material join gd_esquema.Maestra m2
               on m2.Material_Tipo = mat_tipo and m2.Material_Precio = mat_precio
               WHERE Material_Tipo is not null
                    and m1.Tela_Color = m2.Tela_Color
                    and m1.Tela_Textura = m2.Tela_Textura
                    and m1.Material_Descripcion = m2.Material_Descripcion
			   group by mat_codigo),
               m1.Tela_Color,
               m1.Tela_Textura,
               m1.Material_Nombre,
               m1.Material_Descripcion
        from gd_esquema.Maestra m1
		WHERE m1.Material_Tipo is not null and m1.Tela_Color is not null
        group by m1.Tela_Color, m1.Tela_Textura, m1.Material_Nombre, m1.Material_Descripcion
    END
GO

CREATE PROCEDURE migrar_maderas
AS
    BEGIN
    INSERT INTO GRUPO_3312.madera (madera_material, madera_color, madera_dureza, madera_nombre, madera_descripcion)
    SELECT
        (select mat_codigo from GRUPO_3312.material join gd_esquema.Maestra m2
         on m2.Material_Tipo = mat_tipo and m2.Material_Precio = mat_precio
         WHERE Material_Tipo is not null
            and m1.Madera_Dureza = m2.Madera_Dureza
            and m1.Madera_Color = m2.Madera_Color
		    and m1.Material_Descripcion = m2.Material_Descripcion
         group by mat_codigo),
        m1.Madera_Color,
        m1.Madera_Dureza,
        m1.Material_Nombre,
        m1.Material_Descripcion
    FROM gd_esquema.Maestra m1
    WHERE m1.Material_Tipo is not null and m1.Madera_Dureza is not null
	group by m1.Material_Nombre, m1.Material_Descripcion, m1.Madera_Color, m1.Madera_Dureza
    END
GO

CREATE PROCEDURE migrar_rellenos
AS
    BEGIN
    INSERT INTO GRUPO_3312.relleno(relleno_material, relleno_densidad, relleno_nombre, relleno_descripcion)
    SELECT (select mat_codigo from GRUPO_3312.material join gd_esquema.Maestra m2
            on m2.Material_Tipo = mat_tipo and m2.Material_Precio = mat_precio
            WHERE Material_Tipo is not null
               and m1.Relleno_Densidad = m2.Relleno_Densidad
               and m1.Material_Descripcion = m2.Material_Descripcion
            group by mat_codigo),
           m1.Relleno_Densidad,
           m1.Material_Nombre,
           m1.Material_Descripcion
    from gd_esquema.Maestra m1
    WHERE Material_Tipo is not null and m1.Relleno_Densidad is not null
    group by m1.Relleno_Densidad, m1.Material_Nombre, m1.Material_Descripcion
    END
GO

CREATE PROCEDURE migrar_composiciones
AS
    BEGIN
    declare @tela bigint, @madera bigint, @relleno bigint
    declare cursor_composicion CURSOR LOCAL FORWARD_ONLY STATIC FOR
        SELECT
            (select tela_material from gd_esquema.Maestra m2 join GRUPO_3312.tela t1
            on m2.Tela_Color + m2.Tela_Textura + tela_descripcion = t1.tela_color + t1.tela_textura + m2.Material_Descripcion
            where m2.Sillon_Codigo = m1.Sillon_Codigo
            group by t1.tela_material),
            (select madera_material from gd_esquema.Maestra m2 join GRUPO_3312.madera t1
            on t1.madera_color + t1.madera_dureza + t1.madera_descripcion = m2.Madera_Color + m2.Madera_Dureza + m2.Material_Descripcion
            where m2.Sillon_Codigo = m1.Sillon_Codigo
            group by t1.madera_material),
            (select relleno_material from gd_esquema.Maestra m2 join GRUPO_3312.relleno r1
             on r1.relleno_densidad = m2.Relleno_Densidad and m2.Material_Descripcion = r1.relleno_descripcion
             where m2.Sillon_Codigo = m1.Sillon_Codigo
             group by r1.relleno_material)
        FROM gd_esquema.Maestra m1
        WHERE m1.Sillon_Codigo is not null

    open cursor_composicion
    fetch cursor_composicion into @tela, @madera, @relleno

    WHILE @@FETCH_STATUS = 0
        BEGIN
        IF NOT EXISTS (SELECT 1 FROM GRUPO_3312.composicion
            WHERE composicion_tela = @tela
              AND composicion_madera = @madera
              AND composicion_relleno = @relleno)
           BEGIN
               insert into GRUPO_3312.composicion (composicion_tela, composicion_madera, composicion_relleno)
               VALUES (@tela, @madera, @relleno)
           END

        fetch cursor_composicion into @tela, @madera, @relleno
        END
        CLOSE cursor_composicion
        DEALLOCATE cursor_composicion
    END
GO

CREATE PROCEDURE migrar_sillones
AS
    BEGIN
        INSERT INTO GRUPO_3312.sillon (sill_codigo, sill_modelo, sill_medida, sill_composicion)
            SELECT
                Sillon_Codigo,
                (select sill_mod_codigo from GRUPO_3312.sillon_modelo
                where sill_mod_codigo = m1.Sillon_Modelo_Codigo
                group by sill_mod_codigo),
                (select sill_med_codigo from GRUPO_3312.sillon_medida
                where sill_med_alto = m1.Sillon_Medida_Alto
                    and sill_med_ancho = m1.Sillon_Medida_Ancho
                    and sill_med_profundidad = m1.Sillon_Medida_Profundidad
                group by sill_med_codigo),
                (select composicion_id from GRUPO_3312.composicion
                    where composicion_tela in (select tela_material from GRUPO_3312.tela join gd_esquema.Maestra m2
                                               on m2.Sillon_Codigo = m1.Sillon_Codigo
                                               and tela_descripcion = m2.Material_Descripcion)
                 and composicion_madera in (select madera_material from GRUPO_3312.madera join gd_esquema.Maestra m2
                                            on m2.Sillon_Codigo = m1.Sillon_Codigo
                                            and madera_descripcion = m2.Material_Descripcion)
                 and composicion_relleno in (select relleno_material from GRUPO_3312.relleno join gd_esquema.Maestra m2
                                             on m2.Sillon_Codigo = m1.Sillon_Codigo
                                             and relleno_descripcion = m2.Material_Descripcion)
                )
            FROM gd_esquema.Maestra m1
            Where m1.Sillon_Codigo is not null
        group by m1.Sillon_Codigo, m1.Sillon_Modelo_Codigo, m1.Sillon_Medida_Alto, m1.Sillon_Medida_Ancho, m1.Sillon_Medida_Profundidad
    END
GO

CREATE PROCEDURE migrar_detalle_pedidos
AS
    BEGIN
        INSERT INTO GRUPO_3312.detalle_pedido (det_ped_numero, det_ped_sillon, det_ped_precio, det_ped_cantidad, det_ped_subtotal)
        SELECT
            Pedido_Numero,
            Sillon_Codigo,
            Detalle_Pedido_Precio,
            Detalle_Pedido_Cantidad,
            Detalle_Pedido_SubTotal
        FROM gd_esquema.Maestra m1
        where Pedido_Numero is not null and Detalle_Pedido_Precio is not null and Sillon_Codigo is not null
    END
GO

CREATE PROCEDURE migrar_detalle_facturas
AS
    BEGIN
    INSERT INTO GRUPO_3312.detalle_factura (det_fact_numero, det_fact_numeroPedido, det_fact_cantidad, det_fact_precio, det_fact_subtotal)
    SELECT
        Factura_Numero,
        Pedido_Numero,
        Detalle_Factura_Cantidad,
        Detalle_Factura_Precio,
        Detalle_Factura_SubTotal
    FROM gd_esquema.Maestra m1
    where Factura_Numero is not null and Detalle_Factura_Precio is not null and Sillon_Codigo is null
    END
GO

exec migrar_ubicaciones
exec migrar_clientes
exec migrar_sucursales
exec migrar_proveedores
exec migrar_envios
exec migrar_facturas
exec migrar_compras
exec migrar_pedidos
exec migrar_pedidos_cancelados
exec migrar_sillon_modelos
exec migrar_sillon_medidas
exec migrar_materiales
exec migrar_telas
exec migrar_maderas
exec migrar_rellenos
exec migrar_composiciones
exec migrar_sillones
exec migrar_detalle_pedidos
exec migrar_detalle_facturas

