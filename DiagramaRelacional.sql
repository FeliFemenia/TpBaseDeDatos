CREATE SCHEMA [GRUPO_3312]
GO

CREATE TABLE [GRUPO_3312].[ubicacion] (
    ubi_codigo BIGINT IDENTITY(1,1) NOT NULL,
    ubi_provincia NVARCHAR(255) NOT NULL,
    ubi_localidad NVARCHAR(255) NOT NULL,
    ubi_direccion NVARCHAR(255) NOT NULL
)

ALTER TABLE [GRUPO_3312].[ubicacion]
ADD CONSTRAINT PK_ubicacion PRIMARY KEY (ubi_codigo)
GO

CREATE TABLE [GRUPO_3312].[cliente] (
	clie_dni bigint NOT NULL,
    clie_ubicacion bigint NOT NULL,
    clie_nombre nvarchar(255) NOT NULL,
    clie_apellido nvarchar(255),
    clie_fechaNacimiento datetime2(6),
    clie_mail nvarchar(255) NOT NULL,
    clie_telefono nvarchar(255) NOT NULL,
)

ALTER TABLE [GRUPO_3312].[cliente]
ADD CONSTRAINT PK_cliente PRIMARY KEY (clie_dni)
GO

ALTER TABLE [GRUPO_3312].[cliente]
ADD CONSTRAINT FK_cliente_ubi FOREIGN KEY (clie_ubicacion) REFERENCES GRUPO_3312.ubicacion(ubi_codigo)
GO

CREATE TABLE [GRUPO_3312].[sucursal] (
    suc_numero bigint NOT NULL,
    suc_ubicacion bigint NOT NULL,
    suc_telefono nvarchar(255),
    suc_mail nvarchar(255)
)

ALTER TABLE [GRUPO_3312].[sucursal]
ADD CONSTRAINT PK_sucursal PRIMARY KEY (suc_numero)
GO

ALTER TABLE [GRUPO_3312].[sucursal]
ADD CONSTRAINT FK_sucursal_ubi FOREIGN KEY (suc_ubicacion) REFERENCES GRUPO_3312.ubicacion(ubi_codigo)
GO

CREATE TABLE [GRUPO_3312].[proveedor] (
    prov_cuit nvarchar(255) NOT NULL,
    prov_ubicacion bigint NOT NULL,
    prov_razonSocial nvarchar(255),
    prov_telefono nvarchar(255),
    prov_mail nvarchar(255)
)

ALTER TABLE [GRUPO_3312].[proveedor]
ADD CONSTRAINT PK_proveedor PRIMARY KEY (prov_cuit)
GO

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

ALTER TABLE [GRUPO_3312].[envio]
ADD CONSTRAINT FK_envio_factura PRIMARY KEY (env_numero)
GO

CREATE TABLE [GRUPO_3312].[factura] (
    fact_numero bigint NOT NULL,
    fact_sucursal bigint NOT NULL,
    fact_cliente bigint NOT NULL,
    fact_envio bigint NULL,
    fact_total bigint,
    fact_fecha datetime2(6)
)

ALTER TABLE [GRUPO_3312].[factura]
ADD CONSTRAINT PK_factura PRIMARY KEY (fact_numero)
GO

ALTER TABLE [GRUPO_3312].[factura]
ADD CONSTRAINT FK_fact_sucursal FOREIGN KEY (fact_sucursal) REFERENCES GRUPO_3312.sucursal(suc_numero)
GO

ALTER TABLE [GRUPO_3312].[factura]
ADD CONSTRAINT FK_fact_cliente FOREIGN KEY (fact_cliente) REFERENCES GRUPO_3312.cliente(clie_dni)
GO

ALTER TABLE [GRUPO_3312].[factura]
ADD CONSTRAINT FK_fact_envio FOREIGN KEY (fact_envio) REFERENCES GRUPO_3312.envio(env_numero)
GO

CREATE TABLE [GRUPO_3312].[compra] (
    comp_numero bigint NOT NULL,
    comp_sucursal bigint NOT NULL,
    comp_proveedor nvarchar(255) NOT NULL,
    comp_fecha datetime2(6),
    comp_total decimal(18,2)
)

ALTER TABLE [GRUPO_3312].[compra]
ADD CONSTRAINT PK_compra PRIMARY KEY (comp_numero)
GO

ALTER TABLE [GRUPO_3312].[compra]
ADD CONSTRAINT FK_compra_sucursal FOREIGN KEY (comp_sucursal) REFERENCES GRUPO_3312.sucursal(suc_numero)
GO

ALTER TABLE [GRUPO_3312].[compra]
ADD CONSTRAINT FK_compra_proveedor FOREIGN KEY (comp_proveedor) REFERENCES GRUPO_3312.proveedor(prov_cuit)
GO

CREATE TABLE [GRUPO_3312].[pedido] (
    ped_numero decimal(18,0) NOT NULL,
    ped_sucursal bigint NOT NULL,
    ped_cliente bigint NOT NULL,
    ped_fecha datetime2(6),
    ped_total decimal(18,0),
    ped_estado nvarchar(255)
)

ALTER TABLE [GRUPO_3312].[pedido]
ADD CONSTRAINT PK_pedido PRIMARY KEY (ped_numero)
GO

ALTER TABLE [GRUPO_3312].[pedido]
ADD CONSTRAINT FK_pedido_sucursal FOREIGN KEY (ped_sucursal) REFERENCES GRUPO_3312.sucursal(suc_numero)
GO

ALTER TABLE [GRUPO_3312].[pedido]
ADD CONSTRAINT FK_pedido_cliente FOREIGN KEY (ped_cliente) REFERENCES GRUPO_3312.cliente(clie_dni)
GO

CREATE TABLE [GRUPO_3312].[pedido_cancelacion] (
    ped_canc_pedido decimal(18,0),
    ped_canc_motivo varchar(255),
    ped_canc_fecha datetime2(6)
)

ALTER TABLE [GRUPO_3312].[pedido_cancelacion]
ADD CONSTRAINT FK_pedido_cancelacion_pedido FOREIGN KEY (ped_canc_pedido) REFERENCES GRUPO_3312.pedido(ped_numero)
GO

CREATE TABLE [GRUPO_3312].[sillon_modelo] (
    sill_mod_codigo bigint NOT NULL,
    sill_mod_precio decimal(18,2) NOT NULL,
    sill_mod_descripcion nvarchar(255) NULL,
    sill_mod_modelo nvarchar(255) NOT NULL
)

ALTER TABLE [GRUPO_3312].[sillon_modelo]
ADD CONSTRAINT PK_sillon_modelo PRIMARY KEY (sill_mod_codigo)
GO

CREATE TABLE [GRUPO_3312].[sillon_medida] (
    sill_med_codigo bigint IDENTITY(1,1) NOT NULL,
    sill_med_alto decimal(18,2) NOT NULL,
    sill_med_ancho decimal(18,2) NOT NULL,
    sill_med_profundidad decimal(18,2) NOT NULL,
    sill_med_precio decimal(18,2) NULL
)

ALTER TABLE [GRUPO_3312].[sillon_medida]
ADD CONSTRAINT PK_sillon_medida PRIMARY KEY (sill_med_codigo)
GO

CREATE TABLE [GRUPO_3312].[material] (
    mat_codigo bigint IDENTITY(1,1) NOT NULL,
    mat_precio decimal(18,2) NULL,
    mat_tipo nvarchar(255) NOT NULL
)

ALTER TABLE [GRUPO_3312].[material]
ADD CONSTRAINT PK_material PRIMARY KEY (mat_codigo)
GO

CREATE TABLE [GRUPO_3312].[detalle_compra] (
    det_comp_numero bigint NOT NULL,
    det_comp_material bigint NOT NULL,
    det_comp_subtotal decimal(18,0),
    det_comp_precio decimal(18,0),
    det_comp_cantidad decimal(18,0) NOT NULL
)

ALTER TABLE [GRUPO_3312].[detalle_compra]
ADD CONSTRAINT FK_det_compra_numero FOREIGN KEY (det_comp_numero) REFERENCES GRUPO_3312.compra(comp_numero)
GO

ALTER TABLE [GRUPO_3312].[detalle_compra]
ADD CONSTRAINT FK_det_compra_material FOREIGN KEY (det_comp_material) REFERENCES GRUPO_3312.material(mat_codigo)
GO

CREATE TABLE [GRUPO_3312].[tela] (
    tela_material bigint NOT NULL,
    tela_color nvarchar(255) NOT NULL,
    tela_textura nvarchar(255) NOT NULL,
    tela_nombre nvarchar(255),
    tela_descripcion nvarchar(255)
)


ALTER TABLE [GRUPO_3312].[tela]
ADD CONSTRAINT FK_tela_material FOREIGN KEY (tela_material) REFERENCES GRUPO_3312.material(mat_codigo)
GO

CREATE TABLE [GRUPO_3312].[relleno] (
    relleno_material bigint NOT NULL,
    relleno_densidad nvarchar(255),
    relleno_nombre nvarchar(255),
    relleno_descripcion nvarchar(255)
)

ALTER TABLE [GRUPO_3312].[relleno]
ADD CONSTRAINT FK_relleno_material FOREIGN KEY (relleno_material) REFERENCES GRUPO_3312.material(mat_codigo)
GO

CREATE TABLE [GRUPO_3312].[madera] (
    madera_material bigint NOT NULL,
    madera_color nvarchar(255),
    madera_dureza nvarchar(255),
    madera_nombre nvarchar(255),
    madera_descripcion nvarchar(255)
)

ALTER TABLE [GRUPO_3312].[madera]
ADD CONSTRAINT FK_madera_material FOREIGN KEY (madera_material) REFERENCES GRUPO_3312.material(mat_codigo)
GO

CREATE TABLE [GRUPO_3312].[composicion] (
    composicion_id bigint IDENTITY(1,1) NOT NULL,
    composicion_tela bigint NOT NULL,
    composicion_madera bigint NOT NULL,
    composicion_relleno bigint NOT NULL
)

ALTER TABLE [GRUPO_3312].[composicion]
ADD CONSTRAINT PK_composicion PRIMARY KEY (composicion_id)
GO

ALTER TABLE [GRUPO_3312].[composicion]
ADD CONSTRAINT FK_comp_tela FOREIGN KEY (composicion_tela) REFERENCES GRUPO_3312.material(mat_codigo)
GO

ALTER TABLE [GRUPO_3312].[composicion]
ADD CONSTRAINT FK_comp_madera FOREIGN KEY (composicion_madera) REFERENCES GRUPO_3312.material(mat_codigo)
GO

ALTER TABLE [GRUPO_3312].[composicion]
ADD CONSTRAINT FK_comp_relleno FOREIGN KEY (composicion_relleno) REFERENCES GRUPO_3312.material(mat_codigo)
GO

CREATE TABLE [GRUPO_3312].[sillon] (
    sill_codigo bigint NOT NULL,
    sill_modelo bigint NOT NULL,
    sill_medida bigint NOT NULL,
    sill_composicion bigint NOT NULL,
    sill_modelo_desc nvarchar(255)
)

ALTER TABLE [GRUPO_3312].[sillon]
ADD CONSTRAINT PK_sillon PRIMARY KEY (sill_codigo)
GO

ALTER TABLE [GRUPO_3312].[sillon]
ADD CONSTRAINT FK_sillon_modelo FOREIGN KEY (sill_modelo) REFERENCES GRUPO_3312.sillon_modelo(sill_mod_codigo)
GO

ALTER TABLE [GRUPO_3312].[sillon]
ADD CONSTRAINT FK_sillon_medida FOREIGN KEY (sill_medida) REFERENCES GRUPO_3312.sillon_medida(sill_med_codigo)
GO

ALTER TABLE [GRUPO_3312].[sillon]
ADD CONSTRAINT FK_sillon_composicion FOREIGN KEY (sill_composicion) REFERENCES GRUPO_3312.composicion(composicion_id)
GO

CREATE TABLE [GRUPO_3312].[detalle_pedido] (
    det_ped_numero decimal(18,0) NOT NULL,
    det_ped_sillon bigint NOT NULL,
    det_ped_precio decimal(18,2) NOT NULL,
    det_ped_cantidad bigint NOT NULL,
    det_ped_subprecio decimal(18,2)
)

ALTER TABLE [GRUPO_3312].[detalle_pedido]
ADD CONSTRAINT FK_det_pedido_numero FOREIGN KEY (det_ped_numero) REFERENCES GRUPO_3312.pedido(ped_numero)
GO

ALTER TABLE [GRUPO_3312].[detalle_pedido]
ADD CONSTRAINT FK_det_pedido_sillon FOREIGN KEY (det_ped_sillon) REFERENCES GRUPO_3312.sillon(sill_codigo)
GO

CREATE TABLE [GRUPO_3312].[detalle_factura] (
    det_fact_numero bigint NOT NULL,
    det_fact_numeroPedido decimal(18,0) NOT NULL,
    det_fact_cantidad decimal(18,0),
    det_fact_precio decimal(18,2),
    det_fact_subtotal decimal(18,2)
)

ALTER TABLE [GRUPO_3312].[detalle_factura]
ADD CONSTRAINT FK_det_fact_numero FOREIGN KEY (det_fact_numero) REFERENCES GRUPO_3312.factura(fact_numero)
GO

ALTER TABLE [GRUPO_3312].[detalle_factura]
ADD CONSTRAINT FK_det_fac_numeroPedido FOREIGN KEY (det_fact_numeroPedido) REFERENCES GRUPO_3312.pedido(ped_numero)
GO
