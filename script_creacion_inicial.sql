create procedure crear_tablas 
as
begin

	create table [Grupo_3312].[provincia] (
		prov_codigo BIGINT identity(1,1) not null, 
		prov_detalle nvarchar(255) not null
	)

	ALTER TABLE [GRUPO_3312].[provincia]
	ADD CONSTRAINT PK_provincia PRIMARY KEY (prov_codigo)

	create table [Grupo_3312].[localidad] (
		loc_codigo BIGINT identity(1,1) not null, 
		loc_provincia BIGINT not null,
		loc_detalle nvarchar(255) not null
	)

	ALTER TABLE [GRUPO_3312].[localidad]
	ADD CONSTRAINT PK_localidad PRIMARY KEY (loc_codigo)

	ALTER TABLE [GRUPO_3312].[localidad]
	ADD CONSTRAINT FK_loc_prov FOREIGN KEY (loc_provincia) REFERENCES GRUPO_3312.provincia(prov_codigo)

	CREATE TABLE [GRUPO_3312].[cliente] (
		clie_dni bigint NOT NULL,
		clie_direccion nvarchar(255),
		clie_localidad bigint not null,
		clie_nombre nvarchar(255) NOT NULL,
		clie_apellido nvarchar(255),
		clie_fechaNacimiento datetime2(6),
		clie_mail nvarchar(255) NOT NULL,
		clie_telefono nvarchar(255) NOT NULL,
	)

	-- Sentencia que crea la primary key "clie_dni".
	ALTER TABLE [GRUPO_3312].[cliente]
	ADD CONSTRAINT PK_cliente PRIMARY KEY (clie_dni)

	-- Sentencia que crea la foreign key "clie_ubicacion".
	ALTER TABLE [GRUPO_3312].[cliente]
	ADD CONSTRAINT FK_cliente_localidad FOREIGN KEY (clie_localidad) REFERENCES GRUPO_3312.localidad(loc_codigo)

	-- Sentencia que crea la tabla sucursal junto con sus atributos.
	CREATE TABLE [GRUPO_3312].[sucursal] (
		suc_numero bigint NOT NULL,
		suc_direccion nvarchar(255),
		suc_localidad bigint not null, 
		suc_telefono nvarchar(255),
		suc_mail nvarchar(255)
	)

	-- Sentencia que crea la primary key "suc_numero".
	ALTER TABLE [GRUPO_3312].[sucursal]
	ADD CONSTRAINT PK_sucursal PRIMARY KEY (suc_numero)
	
	-- Sentencia que crea la foreign key "clie_ubicacion".
	ALTER TABLE [GRUPO_3312].[sucursal]
	ADD CONSTRAINT FK_suc_localidad FOREIGN KEY (suc_localidad) REFERENCES GRUPO_3312.localidad(loc_codigo)

	-- Sentencia que crea la tabla proveedor junto con sus atributos.
	CREATE TABLE [GRUPO_3312].[proveedor] (
		prove_cuit nvarchar(255) NOT NULL,
		prove_direccion nvarchar(255),
		prove_localidad bigint,
		prove_razonSocial nvarchar(255),
		prove_telefono nvarchar(255),
		prove_mail nvarchar(255)
	)

	-- Sentencia que crea la primary key "prov_cuit".
	ALTER TABLE [GRUPO_3312].[proveedor]
	ADD CONSTRAINT PK_proveedor PRIMARY KEY (prove_cuit)
	

	-- Sentencia que crea la foreign key "clie_ubicacion".
	ALTER TABLE [GRUPO_3312].[proveedor]
	ADD CONSTRAINT FK_proveedor_localidad FOREIGN KEY (prove_localidad) REFERENCES GRUPO_3312.localidad(loc_codigo)
	

	CREATE TABLE [GRUPO_3312].[envio] (
		env_numero bigint NOT NULL,
		env_fechaProgramada datetime2(6),
		env_fechaEntrega datetime2(6),
		env_importeTraslado decimal(18,2),
		env_importeSubida decimal(18,2),
		env_total decimal(18,2)
	)

	-- Sentencia que crea la primary key "env_numero".
	ALTER TABLE [GRUPO_3312].[envio]
	ADD CONSTRAINT FK_envio_factura PRIMARY KEY (env_numero)
	

	-- Sentencia que crea la tabla factura junto con sus atributos.
	CREATE TABLE [GRUPO_3312].[factura] (
		fact_numero bigint NOT NULL,
		fact_sucursal bigint NOT NULL,
		fact_cliente bigint NOT NULL,
		fact_envio bigint NULL,
		fact_total bigint,
		fact_fecha datetime2(6)
	)

	-- Sentencia que crea la primary key "fact_numero".
	ALTER TABLE [GRUPO_3312].[factura]
	ADD CONSTRAINT PK_factura PRIMARY KEY (fact_numero)
	

	-- Sentencia que crea la foreign key "fact_sucursal".
	ALTER TABLE [GRUPO_3312].[factura]
	ADD CONSTRAINT FK_fact_sucursal FOREIGN KEY (fact_sucursal) REFERENCES GRUPO_3312.sucursal(suc_numero)
	

	-- Sentencia que crea la foreign key "fact_cliente".
	ALTER TABLE [GRUPO_3312].[factura]
	ADD CONSTRAINT FK_fact_cliente FOREIGN KEY (fact_cliente) REFERENCES GRUPO_3312.cliente(clie_dni)
	

	-- Sentencia que crea la foreign key "fact_envio".
	ALTER TABLE [GRUPO_3312].[factura]
	ADD CONSTRAINT FK_fact_envio FOREIGN KEY (fact_envio) REFERENCES GRUPO_3312.envio(env_numero)
	

	-- Sentencia que crea la tabla compra junto con sus atributos.
	CREATE TABLE [GRUPO_3312].[compra] (
		comp_numero bigint NOT NULL,
		comp_sucursal bigint NOT NULL,
		comp_proveedor nvarchar(255) NOT NULL,
		comp_fecha datetime2(6),
		comp_total decimal(18,2)
	)

	-- Sentencia que crea la primary key "comp_numero".
	ALTER TABLE [GRUPO_3312].[compra]
	ADD CONSTRAINT PK_compra PRIMARY KEY (comp_numero)
	

	-- Sentencia que crea la foreign key "comp_sucursal".
	ALTER TABLE [GRUPO_3312].[compra]
	ADD CONSTRAINT FK_compra_sucursal FOREIGN KEY (comp_sucursal) REFERENCES GRUPO_3312.sucursal(suc_numero)
	

	-- Sentencia que crea la foreign key "comp_proveedor".
	ALTER TABLE [GRUPO_3312].[compra]
	ADD CONSTRAINT FK_compra_proveedor FOREIGN KEY (comp_proveedor) REFERENCES GRUPO_3312.proveedor(prove_cuit)

    CREATE TABLE [GRUPO_3312].[pedido_estado] (
        estado_numero bigint Identity(1,1) not null,
        estado_nombre nvarchar(255) not null
    )

	ALTER TABLE [GRUPO_3312].[pedido_estado]
	ADD CONSTRAINT PK_pedido_estado PRIMARY KEY (estado_numero)

	-- Sentencia que crea la tabla pedido junto con sus atributos.
	CREATE TABLE [GRUPO_3312].[pedido] (
		ped_numero decimal(18,0) NOT NULL,
		ped_sucursal bigint NOT NULL,
		ped_cliente bigint NOT NULL,
		ped_fecha datetime2(6),
		ped_total decimal(18,0),
		ped_estado bigint
	)

	-- Sentencia que crea la primary key "ped_numero".
	ALTER TABLE [GRUPO_3312].[pedido]
	ADD CONSTRAINT PK_pedido PRIMARY KEY (ped_numero)
	

	-- Sentencia que crea la foreign key "ped_sucursal".
	ALTER TABLE [GRUPO_3312].[pedido]
	ADD CONSTRAINT FK_pedido_sucursal FOREIGN KEY (ped_sucursal) REFERENCES GRUPO_3312.sucursal(suc_numero)
	

	-- Sentencia que crea la foreign key "ped_cliente".
	ALTER TABLE [GRUPO_3312].[pedido]
	ADD CONSTRAINT FK_pedido_cliente FOREIGN KEY (ped_cliente) REFERENCES GRUPO_3312.cliente(clie_dni)

    ALTER TABLE [GRUPO_3312].[pedido]
    ADD CONSTRAINT FK_pedido_estado FOREIGN KEY (ped_estado) REFERENCES GRUPO_3312.pedido_estado(estado_numero)


    -- Sentencia que crea la tabla pedido_cancelacion junto con sus atributos.
	CREATE TABLE [GRUPO_3312].[pedido_cancelacion] (
		ped_canc_pedido decimal(18,0),
		ped_canc_motivo varchar(255),
		ped_canc_fecha datetime2(6)
	)

	-- Sentencia que crea la foreign key "ped_canc_pedido".
	ALTER TABLE [GRUPO_3312].[pedido_cancelacion]
	ADD CONSTRAINT FK_pedido_cancelacion_pedido FOREIGN KEY (ped_canc_pedido) REFERENCES GRUPO_3312.pedido(ped_numero)
	

	-- Sentencia que crea la tabla sillon_modelo junto con sus atributos.
	CREATE TABLE [GRUPO_3312].[sillon_modelo] (
		sill_mod_codigo bigint NOT NULL,
		sill_mod_precio decimal(18,2) NOT NULL,
		sill_mod_descripcion nvarchar(255) NULL,
		sill_mod_modelo nvarchar(255) NOT NULL
	)

	-- Sentencia que crea la primary key "sill_mod_codigo".
	ALTER TABLE [GRUPO_3312].[sillon_modelo]
	ADD CONSTRAINT PK_sillon_modelo PRIMARY KEY (sill_mod_codigo)
	

	-- Sentencia que crea la tabla sillon_medida junto con sus atributos.
	CREATE TABLE [GRUPO_3312].[sillon_medida] (
		sill_med_codigo bigint IDENTITY(1,1) NOT NULL,
		sill_med_alto decimal(18,2) NOT NULL,
		sill_med_ancho decimal(18,2) NOT NULL,
		sill_med_profundidad decimal(18,2) NOT NULL,
		sill_med_precio decimal(18,2) NULL
	)

	-- Sentencia que crea la primary key "sill_med_codigo".
	ALTER TABLE [GRUPO_3312].[sillon_medida]
	ADD CONSTRAINT PK_sillon_medida PRIMARY KEY (sill_med_codigo)
	

	-- Sentencia que crea la tabla material junto con sus atributos.
	CREATE TABLE [GRUPO_3312].[material] (
		mat_codigo bigint IDENTITY(1,1) NOT NULL,
		mat_precio decimal(18,2) NULL,
		mat_tipo nvarchar(255) NOT NULL
	)

	-- Sentencia que crea la primary key "mat_codigo".
	ALTER TABLE [GRUPO_3312].[material]
	ADD CONSTRAINT PK_material PRIMARY KEY (mat_codigo)
	

	-- Sentencia que crea la tabla detalle_compra junto con sus atributos.
	CREATE TABLE [GRUPO_3312].[detalle_compra] (
		det_comp_numero bigint NOT NULL,
		det_comp_material bigint NOT NULL,
		det_comp_subtotal decimal(18,0),
		det_comp_precio decimal(18,0),
		det_comp_cantidad decimal(18,0) NOT NULL
	)

	-- Sentencia que crea la foreign key "det_comp_numero".
	ALTER TABLE [GRUPO_3312].[detalle_compra]
	ADD CONSTRAINT FK_det_compra_numero FOREIGN KEY (det_comp_numero) REFERENCES GRUPO_3312.compra(comp_numero)
	

	-- Sentencia que crea la foreign key "det_comp_material".
	ALTER TABLE [GRUPO_3312].[detalle_compra]
	ADD CONSTRAINT FK_det_compra_material FOREIGN KEY (det_comp_material) REFERENCES GRUPO_3312.material(mat_codigo)
	

	-- Sentencia que crea la tabla tela junto con sus atributos.
	CREATE TABLE [GRUPO_3312].[tela] (
		tela_material bigint NOT NULL,
		tela_color nvarchar(255) NOT NULL,
		tela_textura nvarchar(255) NOT NULL,
		tela_nombre nvarchar(255),
		tela_descripcion nvarchar(255)
	)

	-- Sentencia que crea la foreign key "tela_material".
	ALTER TABLE [GRUPO_3312].[tela]
	ADD CONSTRAINT FK_tela_material FOREIGN KEY (tela_material) REFERENCES GRUPO_3312.material(mat_codigo)
	

	-- Sentencia que crea la tabla relleno junto con sus atributos.
	CREATE TABLE [GRUPO_3312].[relleno] (
		relleno_material bigint NOT NULL,
		relleno_densidad nvarchar(255),
		relleno_nombre nvarchar(255),
		relleno_descripcion nvarchar(255)
	)

	-- Sentencia que crea la foreign key "relleno_material".
	ALTER TABLE [GRUPO_3312].[relleno]
	ADD CONSTRAINT FK_relleno_material FOREIGN KEY (relleno_material) REFERENCES GRUPO_3312.material(mat_codigo)
	

	-- Sentencia que crea la tabla madera junto con sus atributos.
	CREATE TABLE [GRUPO_3312].[madera] (
		madera_material bigint NOT NULL,
		madera_color nvarchar(255),
		madera_dureza nvarchar(255),
		madera_nombre nvarchar(255),
		madera_descripcion nvarchar(255)
	)

	-- Sentencia que crea la foreign key "madera_material".
	ALTER TABLE [GRUPO_3312].[madera]
	ADD CONSTRAINT FK_madera_material FOREIGN KEY (madera_material) REFERENCES GRUPO_3312.material(mat_codigo)
	

	-- Sentencia que crea la tabla composicion junto con sus atributos.
	CREATE TABLE [GRUPO_3312].[composicion] (
		composicion_id bigint IDENTITY(1,1) NOT NULL,
		composicion_tela bigint NOT NULL,
		composicion_madera bigint NOT NULL,
		composicion_relleno bigint NOT NULL
	)

	-- Sentencia que crea la primary key "composicion_id".
	ALTER TABLE [GRUPO_3312].[composicion]
	ADD CONSTRAINT PK_composicion PRIMARY KEY (composicion_id)
	

	-- Sentencia que crea la foreign key "composicion_tela".
	ALTER TABLE [GRUPO_3312].[composicion]
	ADD CONSTRAINT FK_comp_tela FOREIGN KEY (composicion_tela) REFERENCES GRUPO_3312.material(mat_codigo)
	

	-- Sentencia que crea la foreign key "composicion_madera".
	ALTER TABLE [GRUPO_3312].[composicion]
	ADD CONSTRAINT FK_comp_madera FOREIGN KEY (composicion_madera) REFERENCES GRUPO_3312.material(mat_codigo)
	

	-- Sentencia que crea la foreign key "composicion_relleno".
	ALTER TABLE [GRUPO_3312].[composicion]
	ADD CONSTRAINT FK_comp_relleno FOREIGN KEY (composicion_relleno) REFERENCES GRUPO_3312.material(mat_codigo)
	

	-- Sentencia que crea la tabla sillon junto con sus atributos.
	CREATE TABLE [GRUPO_3312].[sillon] (
		sill_codigo bigint NOT NULL,
		sill_modelo bigint NOT NULL,
		sill_medida bigint NOT NULL,
		sill_composicion bigint NOT NULL,
		sill_modelo_desc nvarchar(255)
	)

	-- Sentencia que crea la primary key "sill_codigo".
	ALTER TABLE [GRUPO_3312].[sillon]
	ADD CONSTRAINT PK_sillon PRIMARY KEY (sill_codigo)
	

	-- Sentencia que crea la foreign key "sill_modelo".
	ALTER TABLE [GRUPO_3312].[sillon]
	ADD CONSTRAINT FK_sillon_modelo FOREIGN KEY (sill_modelo) REFERENCES GRUPO_3312.sillon_modelo(sill_mod_codigo)
	

	-- Sentencia que crea la foreign key "sill_medida".
	ALTER TABLE [GRUPO_3312].[sillon]
	ADD CONSTRAINT FK_sillon_medida FOREIGN KEY (sill_medida) REFERENCES GRUPO_3312.sillon_medida(sill_med_codigo)
	

	-- Sentencia que crea la foreign key "sill_composicion".
	ALTER TABLE [GRUPO_3312].[sillon]
	ADD CONSTRAINT FK_sillon_composicion FOREIGN KEY (sill_composicion) REFERENCES GRUPO_3312.composicion(composicion_id)
	

	-- Sentencia que crea la tabla detalle_pedido junto con sus atributos.
	CREATE TABLE [GRUPO_3312].[detalle_pedido] (
		det_ped_numero decimal(18,0) NOT NULL,
		det_ped_sillon bigint NOT NULL,
		det_ped_precio decimal(18,2) NOT NULL,
		det_ped_cantidad bigint NOT NULL,
		det_ped_subtotal decimal(18,2)
	)

	-- Sentencia que crea la foreign key "det_ped_numero".
	ALTER TABLE [GRUPO_3312].[detalle_pedido]
	ADD CONSTRAINT FK_det_pedido_numero FOREIGN KEY (det_ped_numero) REFERENCES GRUPO_3312.pedido(ped_numero)
	

	-- Sentencia que crea la foreign key "det_ped_sillon".
	ALTER TABLE [GRUPO_3312].[detalle_pedido]
	ADD CONSTRAINT FK_det_pedido_sillon FOREIGN KEY (det_ped_sillon) REFERENCES GRUPO_3312.sillon(sill_codigo)
	

	-- Sentencia que crea la tabla detalle_factura junto con sus atributos.
	CREATE TABLE [GRUPO_3312].[detalle_factura] (
		det_fact_numero bigint NOT NULL,
		det_fact_numeroPedido decimal(18,0) NOT NULL,
		det_fact_sillon bigint not null,
		det_fact_cantidad decimal(18,0),
		det_fact_precio decimal(18,2),
		det_fact_subtotal decimal(18,2)
	)

	-- Sentencia que crea la foreign key "det_fact_numero".
	ALTER TABLE [GRUPO_3312].[detalle_factura]
	ADD CONSTRAINT FK_det_fact_numero FOREIGN KEY (det_fact_numero) REFERENCES GRUPO_3312.factura(fact_numero)
	
	-- Sentencia que crea la foreign key "det_fact_sillon".
	ALTER TABLE [GRUPO_3312].[detalle_factura]
	ADD CONSTRAINT det_fact_sillon FOREIGN KEY (det_fact_sillon) REFERENCES GRUPO_3312.sillon(sill_codigo)

	-- Sentencia que crea la foreign key "det_fact_numeroPedido".
	ALTER TABLE [GRUPO_3312].[detalle_factura]
	ADD CONSTRAINT FK_det_fac_numeroPedido FOREIGN KEY (det_fact_numeroPedido) REFERENCES GRUPO_3312.pedido(ped_numero)
end
go -- Ojo con la creacion del schema

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

    -- Migracion de estados (3? rows)

    INSERT INTO GRUPO_3312.pedido_estado
    select Pedido_Estado from gd_esquema.Maestra
    WHERE Pedido_Estado is not null
    GROUP BY Pedido_Estado

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
        (select estado_numero from GRUPO_3312.pedido_estado
        where estado_nombre = Pedido_Estado)
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

	-- Migracion de composicion (3 rows = 1 + 1 + 1) --VER

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

	-- Migracion detalle pedido (72166 rows)

	INSERT INTO GRUPO_3312.detalle_pedido (det_ped_numero, det_ped_sillon, det_ped_precio, det_ped_cantidad, det_ped_subtotal)
    SELECT 
        Pedido_Numero,
        Sillon_Codigo,
        Detalle_Pedido_Precio,
        Detalle_Pedido_Cantidad,
        Detalle_Pedido_SubTotal
    FROM gd_esquema.Maestra m1
    where Pedido_Numero is not null and Detalle_Pedido_Precio is not null and Sillon_Codigo is not null
	group by Pedido_Numero, Sillon_Codigo, Detalle_Pedido_Precio, Detalle_Pedido_Cantidad, Detalle_Pedido_SubTotal
	-- Migracion de detalle factura (61087 rows)

	INSERT INTO GRUPO_3312.detalle_factura (det_fact_numero, det_fact_numeroPedido, det_fact_sillon, det_fact_cantidad, det_fact_precio, det_fact_subtotal)
    SELECT distinct
        Factura_Numero,
        Pedido_Numero,
        (select top 1 det_ped_sillon from grupo_3312.detalle_pedido 
            where det_ped_numero = Pedido_Numero 
			and Detalle_Factura_Cantidad = det_ped_cantidad 
			and Detalle_Pedido_Precio = det_ped_precio 
			and det_ped_subtotal = Detalle_Pedido_SubTotal),
        Detalle_Factura_Cantidad,
        Detalle_Factura_Precio,
        Detalle_Factura_SubTotal
    FROM gd_esquema.Maestra m1
    where Factura_Numero is not null and Pedido_Numero is not null and Sillon_Codigo is null

end
go

CREATE SCHEMA GRUPO_3312
GO

exec crear_tablas -- 0 segundos
exec migrar_datos -- 10 segundos

/*Querys costs:
	provincia: 0.2 seg
	localidad: 0.2 seg
	clientes: 0.2 seg
	sucursales: 0.2 seg
	proveedores: 0.2 seg
	envio: 0.2 seg
	factura: 0.2 seg
	compras: 0.2 seg
	pedido: 0.2 seg
	pedidos cancelados: 0.2 seg
	modelo sillones: 0.2 seg
	medida sillones: 0.2 seg
	material: 0.2 seg
	detalle compra: 0.2 seg
	tela: 0.2 seg
	madera: 0.2 seg
	relleno: 0.2 seg
	composicion: 5 seg
	sillon: 3 seg
	detalle pedido: 0.5 seg
	detalle factura: 0.2 seg

	Total: 12.1 seg aprox
*/
