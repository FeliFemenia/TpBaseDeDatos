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

	CREATE TABLE [GRUPO_3312].[ubicacion] (
		ubi_codigo BIGINT IDENTITY(1,1) NOT NULL,
		ubi_provincia NVARCHAR(255) NOT NULL,
		ubi_localidad NVARCHAR(255) NOT NULL,
		ubi_direccion NVARCHAR(255) NOT NULL
	)

	-- Sentencia que crea la primary key "ubi_codigo".
	ALTER TABLE [GRUPO_3312].[ubicacion]
	ADD CONSTRAINT PK_ubicacion PRIMARY KEY (ubi_codigo)

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
	ADD CONSTRAINT FK_cliente_loc FOREIGN KEY (clie_localidad) REFERENCES GRUPO_3312.localidad(loc_codigo)

	-- Sentencia que crea la tabla sucursal junto con sus atributos.
	CREATE TABLE [GRUPO_3312].[sucursal] (
		suc_numero bigint NOT NULL,
		suc_direccion nvarchar(255) ,
		suc_telefono nvarchar(255),
		suc_mail nvarchar(255)
	)

	-- Sentencia que crea la primary key "suc_numero".
	ALTER TABLE [GRUPO_3312].[sucursal]
	ADD CONSTRAINT PK_sucursal PRIMARY KEY (suc_numero)
	

	-- Sentencia que crea la foreign key "suc_ubicacion".
	ALTER TABLE [GRUPO_3312].[sucursal]
	ADD CONSTRAINT FK_sucursal_ubi FOREIGN KEY (suc_ubicacion) REFERENCES GRUPO_3312.ubicacion(ubi_codigo)
	

	-- Sentencia que crea la tabla proveedor junto con sus atributos.
	CREATE TABLE [GRUPO_3312].[proveedor] (
		prov_cuit nvarchar(255) NOT NULL,
		prov_ubicacion bigint NOT NULL,
		prov_razonSocial nvarchar(255),
		prov_telefono nvarchar(255),
		prov_mail nvarchar(255)
	)

	-- Sentencia que crea la primary key "prov_cuit".
	ALTER TABLE [GRUPO_3312].[proveedor]
	ADD CONSTRAINT PK_proveedor PRIMARY KEY (prov_cuit)
	

	-- Sentencia que crea la foreign key "prov_ubicacion".
	ALTER TABLE [GRUPO_3312].[proveedor]
	ADD CONSTRAINT FK_proveedor_ubi FOREIGN KEY (prov_ubicacion) REFERENCES GRUPO_3312.ubicacion(ubi_codigo)
	

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
	ADD CONSTRAINT FK_compra_proveedor FOREIGN KEY (comp_proveedor) REFERENCES GRUPO_3312.proveedor(prov_cuit)
	

	-- Sentencia que crea la tabla pedido junto con sus atributos.
	CREATE TABLE [GRUPO_3312].[pedido] (
		ped_numero decimal(18,0) NOT NULL,
		ped_sucursal bigint NOT NULL,
		ped_cliente bigint NOT NULL,
		ped_fecha datetime2(6),
		ped_total decimal(18,0),
		ped_estado nvarchar(255)
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
		det_fact_cantidad decimal(18,0),
		det_fact_precio decimal(18,2),
		det_fact_subtotal decimal(18,2)
	)

	-- Sentencia que crea la foreign key "det_fact_numero".
	ALTER TABLE [GRUPO_3312].[detalle_factura]
	ADD CONSTRAINT FK_det_fact_numero FOREIGN KEY (det_fact_numero) REFERENCES GRUPO_3312.factura(fact_numero)
	

	-- Sentencia que crea la foreign key "det_fact_numeroPedido".
	ALTER TABLE [GRUPO_3312].[detalle_factura]
	ADD CONSTRAINT FK_det_fac_numeroPedido FOREIGN KEY (det_fact_numeroPedido) REFERENCES GRUPO_3312.pedido(ped_numero)
end
go

alter procedure migrar_datos
as
begin

	-- Migracion de provincias
	INSERT INTO GRUPO_3312.provincia(prov_detalle)
	(SELECT Proveedor_Provincia from gd_esquema.Maestra
	where Proveedor_Provincia is not null
	union
	SELECT Cliente_Provincia FROM gd_esquema.Maestra 
	where Cliente_Provincia is not null
	union
	select Sucursal_Provincia FROM gd_esquema.Maestra 
	where Sucursal_Provincia is not null)

	-- Migracion de localidades
	INSERT INTO GRUPO_3312.localidad(loc_provincia, loc_detalle)
	(select (select prov_codigo from GRUPO_3312.provincia where prov_detalle = Proveedor_Provincia), Proveedor_Localidad from gd_esquema.Maestra
	where Proveedor_Localidad is not null and Proveedor_Provincia is not null
	union
	select (select prov_codigo from GRUPO_3312.provincia where prov_detalle = Cliente_Provincia), Cliente_Localidad from gd_esquema.Maestra
	where Cliente_Localidad is not null and Cliente_Provincia is not null
	union 
	select (select prov_codigo from GRUPO_3312.provincia where prov_detalle = Sucursal_Provincia), Sucursal_Localidad from gd_esquema.Maestra
	where Sucursal_Localidad is not null and Sucursal_Provincia is not null
	)

	-- Migracion de clientes

	INSERT INTO GRUPO_3312.cliente (clie_dni, clie_direccion, clie_localidad, clie_nombre, clie_apellido, clie_fechaNacimiento, clie_mail, clie_telefono)
    SELECT
        m2.Cliente_Dni,
        m2.Cliente_Direccion,
		(select loc_codigo from GRUPO_3312.localidad where loc_detalle = m2.Cliente_Localidad),
        m2.Cliente_Nombre, m2.Cliente_Apellido, m2.Cliente_FechaNacimiento, m2.Cliente_Mail, m2.Cliente_Telefono
    from gd_esquema.Maestra m2
    WHERE m2.Cliente_Dni is not null and m2.Cliente_Direccion is not null
    group by Cliente_Dni, m2.Cliente_Nombre, m2.Cliente_Apellido, m2.Cliente_FechaNacimiento, m2.Cliente_Mail, m2.Cliente_Telefono, m2.Cliente_Localidad, m2.Cliente_Direccion
end

exec migrar_datos

delete GRUPO_3312.provincia
delete GRUPO_3312.localidad

select loc_detalle, count(*) from GRUPO_3312.localidad
group by loc_detalle
ORDER BY count(*) desc


