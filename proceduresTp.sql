create procedure migrar_datos
as
begin

	-- Migracion de provincias (24 rows)

	INSERT INTO GRUPO_3312.provincia(prov_detalle)
	(SELECT Proveedor_Provincia from gd_esquema.Maestra
	where Proveedor_Provincia is not null
	union
	SELECT Cliente_Provincia FROM gd_esquema.Maestra 
	where Cliente_Provincia is not null
	union
	select Sucursal_Provincia FROM gd_esquema.Maestra 
	where Sucursal_Provincia is not null)

	-- Migracion de localidades (12268 rows)

	INSERT INTO GRUPO_3312.localidad(loc_provincia, loc_detalle)
	(select (select prov_codigo from GRUPO_3312.provincia where prov_detalle = Proveedor_Provincia), Proveedor_Localidad from gd_esquema.Maestra
	where Proveedor_Localidad is not null and Proveedor_Provincia is not null
	union
	select (select prov_codigo from GRUPO_3312.provincia where prov_detalle = Cliente_Provincia), Cliente_Localidad from gd_esquema.Maestra
	where Cliente_Localidad is not null and Cliente_Provincia is not null
	union 
	select (select prov_codigo from GRUPO_3312.provincia where prov_detalle = Sucursal_Provincia), Sucursal_Localidad from gd_esquema.Maestra
	where Sucursal_Localidad is not null and Sucursal_Provincia is not null)

	-- Migracion de clientes (20509 rows)

	INSERT INTO GRUPO_3312.cliente (clie_dni, clie_direccion, clie_localidad, clie_nombre, clie_apellido, clie_fechaNacimiento, clie_mail, clie_telefono)
    SELECT
        m2.Cliente_Dni,
        m2.Cliente_Direccion,
		(select loc_codigo from GRUPO_3312.localidad 
		where loc_detalle = m2.Cliente_Localidad and loc_provincia = (select prov_codigo from GRUPO_3312.provincia where m2.Cliente_Provincia = prov_detalle)),
        m2.Cliente_Nombre, m2.Cliente_Apellido, m2.Cliente_FechaNacimiento, m2.Cliente_Mail, m2.Cliente_Telefono
    from gd_esquema.Maestra m2
    WHERE m2.Cliente_Dni is not null and m2.Cliente_Direccion is not null
    group by Cliente_Dni, m2.Cliente_Nombre, m2.Cliente_Apellido, m2.Cliente_FechaNacimiento, m2.Cliente_Mail, m2.Cliente_Telefono, m2.Cliente_Localidad, m2.Cliente_Direccion, m2.Cliente_Provincia

	-- Migracion sucursales (9 rows)

	INSERT INTO GRUPO_3312.sucursal (suc_numero, suc_direccion, suc_localidad, suc_telefono, suc_mail)
    SELECT
        m2.Sucursal_NroSucursal,
        m2.Sucursal_Direccion,
		(select loc_codigo from GRUPO_3312.localidad 
		where loc_detalle = m2.Sucursal_Localidad
		and loc_provincia = (select prov_codigo from GRUPO_3312.provincia where m2.Sucursal_Provincia = prov_detalle)),
        m2.Sucursal_Telefono, m2.Sucursal_Mail
    from gd_esquema.Maestra m2
    WHERE m2.Sucursal_NroSucursal is not null
    group by m2.Sucursal_NroSucursal, m2.Sucursal_Telefono, m2.Sucursal_Mail, m2.Sucursal_Direccion, m2.Sucursal_Provincia, m2.Sucursal_Localidad

	-- Migracion de proveedores (10 rows)

	INSERT INTO GRUPO_3312.proveedor (prove_cuit, prove_direccion, prove_localidad, prove_razonSocial, prove_telefono, prove_mail)
    SELECT
        m2.Proveedor_Cuit,
        m2.Proveedor_Direccion,
		(select loc_codigo from GRUPO_3312.localidad 
		where loc_detalle = m2.Proveedor_Localidad
		and loc_provincia = (select prov_codigo from GRUPO_3312.provincia where m2.Proveedor_Provincia = prov_detalle)),
        m2.Proveedor_RazonSocial, m2.Proveedor_Telefono, m2.Proveedor_Mail
    from gd_esquema.Maestra m2
    WHERE m2.Proveedor_Cuit is not null
    group by m2.Proveedor_Cuit, m2.Proveedor_RazonSocial, m2.Proveedor_Telefono, 
	m2.Proveedor_Mail, m2.Proveedor_Direccion, m2.Proveedor_Localidad, m2.Proveedor_Provincia

	-- Migracion de envios (17408 rows)
	 
	INSERT INTO GRUPO_3312.envio (env_numero, env_fechaProgramada, env_fechaEntrega, env_importeTraslado, env_importeSubida, env_total)
    SELECT Envio_Numero, Envio_Fecha_Programada, Envio_Fecha, Envio_ImporteTraslado, Envio_ImporteSubida, Envio_Total
    from gd_esquema.Maestra
    WHERE Envio_Numero is not null
    
	-- Migracion de facturas (17408 rows)

	INSERT INTO GRUPO_3312.factura (fact_numero, fact_sucursal, fact_cliente, fact_envio, fact_total, fact_fecha)
    SELECT
        Factura_Numero,
        (select suc_numero from GRUPO_3312.sucursal
         where Sucursal_NroSucursal = suc_numero and Factura_Numero is not null and Envio_numero is not null
		 group by suc_numero) suc_numero,
        (select clie_dni from GRUPO_3312.cliente
         where clie_dni = Cliente_Dni
		 group by clie_dni) clie_dni,
        (select env_numero from GRUPO_3312.envio
         where Envio_Numero = env_numero and Envio_numero is not null
		 group by env_numero) env_numero,
        Factura_Total, Factura_Fecha
    from gd_esquema.Maestra
    WHERE Factura_Numero is not null and Envio_numero is not null
    group by Factura_Numero, Factura_Total, Factura_Fecha, Envio_Numero, Sucursal_NroSucursal, Detalle_Factura_Precio, Cliente_Dni

	-- Migracion de compras (79 rows)

	INSERT INTO GRUPO_3312.compra (comp_numero, comp_sucursal, comp_proveedor, comp_fecha, comp_total)
    SELECT
        Compra_Numero,
        (select suc_numero from GRUPO_3312.sucursal
        where suc_numero = Sucursal_NroSucursal
        group by suc_numero),
        (select prove_cuit from GRUPO_3312.proveedor
         where prove_cuit = Proveedor_Cuit 
         group by prove_cuit),
        Compra_Fecha,
        Compra_Total
    from gd_esquema.Maestra
	where Compra_Numero is not null
	group by Compra_Numero, Compra_Fecha, Compra_Total, Sucursal_NroSucursal, Proveedor_Cuit

	-- Migracion de pedidos (20509 rows)

	INSERT INTO GRUPO_3312.pedido (ped_numero, ped_sucursal, ped_cliente, ped_fecha, ped_total, ped_estado)
    SELECT
        Pedido_Numero,
        (select suc_numero from GRUPO_3312.sucursal 
          where suc_numero = Sucursal_NroSucursal
		  group by suc_numero),
        (select clie_dni from GRUPO_3312.cliente
         where  clie_dni = Cliente_Dni
		 group by clie_dni),
        Pedido_Fecha,
        Pedido_Total,
        Pedido_Estado
    from gd_esquema.Maestra
	WHERE Pedido_Numero is not null
	group by Pedido_Numero, Pedido_Fecha, Pedido_Total, Pedido_Estado, Cliente_Dni, Sucursal_NroSucursal

	-- Migracion de pedidos cancelados (3101 rows)

	INSERT INTO GRUPO_3312.pedido_cancelacion (ped_canc_pedido, ped_canc_motivo, ped_canc_fecha)
    SELECT
        (select ped_numero from GRUPO_3312.pedido
        where ped_numero = Pedido_Numero
        group by ped_numero),
        Pedido_Cancelacion_Motivo,
        Pedido_Cancelacion_Fecha
    from gd_esquema.Maestra 
    WHERE Pedido_Numero is not null and Pedido_Cancelacion_Motivo is not null
    group by Pedido_Cancelacion_Motivo, Pedido_Cancelacion_Fecha, Pedido_Numero

	-- Migracion de modelos de sillones (7 rows)

	INSERT INTO GRUPO_3312.sillon_modelo (sill_mod_codigo, sill_mod_precio, sill_mod_descripcion, sill_mod_modelo)
    SELECT Sillon_Modelo_Codigo, Sillon_Modelo_Precio, Sillon_Modelo_Descripcion, Sillon_Modelo
    FROM gd_esquema.Maestra
    WHERE Sillon_Modelo_Codigo is not null
    group by Sillon_Modelo_Codigo, Sillon_Modelo_Precio, Sillon_Modelo_Descripcion, Sillon_Modelo

	-- Migracion de medidas de sillones (4 rows)

	 INSERT INTO GRUPO_3312.sillon_medida (sill_med_alto, sill_med_ancho, sill_med_profundidad, sill_med_precio)
    SELECT
        Sillon_Medida_Alto, Sillon_Medida_Ancho, Sillon_Medida_Profundidad, Sillon_Medida_Precio
    from gd_esquema.Maestra
    WHERE Sillon_Codigo is not null
    group by Sillon_Medida_Alto, Sillon_Medida_Ancho, Sillon_Medida_Profundidad, Sillon_Medida_Precio

	-- Migracion de material (9 rows)

	INSERT INTO GRUPO_3312.material (mat_precio, mat_tipo)
    SELECT Material_Precio, Material_Tipo
	FROM gd_esquema.Maestra
    WHERE Material_Precio is not null and Material_Tipo is not null
    GROUP BY Material_Precio, Material_Tipo

	-- Migracion de detalle compra (711 rows)

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

	-- Migracion de telas (3 rows)

	INSERT INTO GRUPO_3312.tela (tela_material, tela_color, tela_textura, tela_nombre, tela_descripcion)
        SELECT (select mat_codigo from GRUPO_3312.material 
               WHERE Material_Tipo = mat_tipo and mat_precio = Material_Precio
			   group by mat_codigo),
               Tela_Color,
               Tela_Textura,
               Material_Nombre,
               Material_Descripcion
        from gd_esquema.Maestra
		WHERE Material_Tipo is not null and Tela_Color is not null
        group by Tela_Color, Tela_Textura, Material_Nombre, Material_Descripcion, Material_Tipo, Material_Precio

		-- Migracion de maderas (3 rows)

		INSERT INTO GRUPO_3312.madera (madera_material, madera_color, madera_dureza, madera_nombre, madera_descripcion)
    SELECT
        (select mat_codigo from GRUPO_3312.material
		WHERE Material_Tipo = mat_tipo and mat_precio = Material_Precio
         group by mat_codigo),
        Madera_Color,
        Madera_Dureza,
        Material_Nombre,
        Material_Descripcion
    FROM gd_esquema.Maestra
    WHERE Material_Tipo is not null and Madera_Dureza is not null
	group by Material_Nombre, Material_Descripcion, Madera_Color, Madera_Dureza, Material_Tipo, Material_Precio

	-- Migracion de rellenos (3 rows)

	INSERT INTO GRUPO_3312.relleno(relleno_material, relleno_densidad, relleno_nombre, relleno_descripcion)
    SELECT (select mat_codigo from GRUPO_3312.material
			WHERE Material_Tipo = mat_tipo and mat_precio = Material_Precio
            group by mat_codigo),
           Relleno_Densidad,
           Material_Nombre,
           Material_Descripcion
    from gd_esquema.Maestra
    WHERE Material_Tipo is not null and Relleno_Densidad is not null
    group by Relleno_Densidad, Material_Nombre, Material_Descripcion, Material_Tipo, Material_Precio

	-- Migracion de composicion (3 rows) --VER

	declare @tela bigint, @madera bigint, @relleno bigint
    declare cursor_composicion CURSOR LOCAL FORWARD_ONLY STATIC FOR
        SELECT
            (select tela_material from gd_esquema.Maestra m2 join GRUPO_3312.tela t1
            on m2.Sillon_Codigo = m1.Sillon_Codigo and m2.Tela_Color + m2.Tela_Textura + tela_descripcion = t1.tela_color + t1.tela_textura + m2.Material_Descripcion
            group by t1.tela_material),
            (select madera_material from gd_esquema.Maestra m2 join GRUPO_3312.madera t1
            on m2.Sillon_Codigo = m1.Sillon_Codigo and t1.madera_color + t1.madera_dureza + t1.madera_descripcion = m2.Madera_Color + m2.Madera_Dureza + m2.Material_Descripcion
			group by t1.madera_material),
            (select relleno_material from gd_esquema.Maestra m2 join GRUPO_3312.relleno r1
             on m2.Sillon_Codigo = m1.Sillon_Codigo and r1.relleno_densidad = m2.Relleno_Densidad and m2.Material_Descripcion = r1.relleno_descripcion
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

	-- Migracion de sillones (72166 rows) --VER

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

	-- Migracion detalle pedido (216498 rows)

	INSERT INTO GRUPO_3312.detalle_pedido (det_ped_numero, det_ped_sillon, det_ped_precio, det_ped_cantidad, det_ped_subtotal)
    SELECT
        Pedido_Numero,
        Sillon_Codigo,
        Detalle_Pedido_Precio,
        Detalle_Pedido_Cantidad,
        Detalle_Pedido_SubTotal
    FROM gd_esquema.Maestra m1
    where Pedido_Numero is not null and Detalle_Pedido_Precio is not null and Sillon_Codigo is not null

	-- Migracion de detalle factura (61092 rows)

	INSERT INTO GRUPO_3312.detalle_factura (det_fact_numero, det_fact_numeroPedido, det_fact_cantidad, det_fact_precio, det_fact_subtotal)
    SELECT
        Factura_Numero,
        Pedido_Numero,
        Detalle_Factura_Cantidad,
        Detalle_Factura_Precio,
        Detalle_Factura_SubTotal
    FROM gd_esquema.Maestra m1
    where Factura_Numero is not null and Pedido_Numero is not null and Sillon_Codigo is null

end
go
