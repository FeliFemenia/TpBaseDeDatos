-- Creacion de tablas BI

alter procedure crear_modelo_bi
as
begin

    create table [Grupo_3312].[BI_rango_etario] (
        dim_rango_etario_id bigint identity(1,1) not null,
        dim_rango_etario_edad_minima bigint not null,
        dim_rango_etario_edad_maxima bigint not null
    )

    alter table [Grupo_3312].[BI_rango_etario]
    add constraint PK_BI_rango_etario primary key (dim_rango_etario_id)

    create table [Grupo_3312].[BI_tiempo] (
        dim_tiempo_id bigint identity(1,1) not null,
        dim_tiempo_mes int not null,
        dim_tiempo_anio int not null,
        dim_tiemp_cuatrimestre int not null
    )

    alter table [Grupo_3312].[BI_tiempo]
    add constraint PK_BI_tiempo primary key (dim_tiempo_id)

    create table [Grupo_3312].[BI_ubicacion] (
        dim_ubicacion_id bigint identity(1,1) not null,
        dim_ubicacion_localidad nvarchar(255) not null,
        dim_ubicacion_provincia nvarchar(255) not null
    )

    alter table [Grupo_3312].[BI_ubicacion]
    add constraint PK_BI_ubicacion primary key (dim_ubicacion_id)

    create table [Grupo_3312].[BI_turno_venta] (
        dim_turno_venta_id bigint identity(1,1) not null,
        dim_turno_venta_inicio time not null,
        dim_turno_venta_fin time not null
    )

    alter table [Grupo_3312].[BI_turno_venta]
    add constraint PK_BI_turno_venta primary key (dim_turno_venta_id)

    create table [Grupo_3312].[BI_tipo_material] (
        dim_tipo_material bigint identity(1,1) not null,
        dim_detalle_material nvarchar(255) not null
    )

    alter table [Grupo_3312].[BI_tipo_material]
    add constraint PK_BI_tipo_material primary key (dim_tipo_material)

    create table [Grupo_3312].[Bi_modelo_sillon] (
        dim_modelo_sillon_id bigint IDENTITY(1,1) not null,
        dim_modelo_sillon_nombre nvarchar(255) not null
    )

    alter table [Grupo_3312].[BI_modelo_sillon]
    add constraint PK_BI_modelo_sillon primary key (dim_modelo_sillon_id)

    CREATE TABLE [GRUPO_3312].[BI_estado_pedido](
        dim_estado_pedido bigint IDENTITY(1,1) not null,
        dim_estado_pedido_estado nvarchar(255)
    )

    alter table [Grupo_3312].[BI_estado_pedido]
    add constraint PK_BI_estado_pedido primary key (dim_estado_pedido)

    create table [Grupo_3312].[Bi_cliente] (
        dim_cliente_id bigint identity(1,1) not null,
        dim_cliente_ubicacion bigint not null,
        dim_cliente_rango_etario bigint not null
    )

    alter table [Grupo_3312].[BI_cliente]
    add constraint PK_BI_cliente primary key (dim_cliente_id)

    alter table [Grupo_3312].[BI_cliente]
    add constraint FK_BI_cliente_ubicacion foreign key (dim_cliente_ubicacion) references Grupo_3312.BI_ubicacion (dim_ubicacion_id)

    alter table [Grupo_3312].[BI_cliente]
    add constraint FK_BI_cliente_rango_etario foreign key (dim_cliente_rango_etario) references Grupo_3312.BI_rango_etario (dim_rango_etario_id)

    create table [grupo_3312].[BI_sucursal] (
        dim_suc_numero bigint identity(1,1),
        dim_suc_ubicacion bigint not null
    )

    alter table [Grupo_3312].[BI_sucursal]
    add constraint PK_BI_sucursal primary key (dim_suc_numero)

    alter table [Grupo_3312].[BI_sucursal]
    add constraint FK_BI_suc_ubicacion foreign key (dim_suc_ubicacion) references Grupo_3312.BI_ubicacion (dim_ubicacion_id)

    CREATE TABLE [grupo_3312].[BI_compra](
        compra_numero bigint identity(1,1) not null,
        dim_compra_sucursal bigint not null,
        dim_compra_tiempo bigint not null,
        compra_total decimal(18,0)
        )

    alter table [Grupo_3312].[BI_compra]
        add constraint PK_BI_hecho_compra primary key (compra_numero)

    alter table [Grupo_3312].[BI_compra]
        add constraint FK_BI_dim_sucursal foreign key (dim_compra_sucursal) references Grupo_3312.BI_sucursal (dim_suc_numero)

    alter table [Grupo_3312].[BI_compra]
        add constraint FK_BI_dim_tiempo foreign key (dim_compra_tiempo) references Grupo_3312.BI_tiempo (dim_tiempo_id)

    CREATE TABLE [grupo_3312].[BI_detalle_compra] (
        det_compra_numero bigint identity(1,1) not null,
        dim_det_compra_material bigint not null,
        det_compra_precio decimal(18,0),
        det_compra_cantidad decimal(18,0)
    )

    alter table [Grupo_3312].[BI_detalle_compra]
    add constraint FK_BI_numero_compra foreign key (det_compra_numero) references Grupo_3312.BI_compra (compra_numero)

    alter table [Grupo_3312].[BI_detalle_compra]
    add constraint FK_BI_tipo_material foreign key (dim_det_compra_material) references Grupo_3312.BI_tipo_material (dim_tipo_material)

    create table [GRUPO_3312].[BI_pedido] (
        pedido_numero bigint not null,
        dim_pedido_tiempo bigint not null,
        dim_pedido_turno bigint not null,
        dim_pedido_sucursal bigint not null,
        dim_pedido_estado bigint not null
    )

    alter table [Grupo_3312].[BI_pedido]
        add constraint PK_BI_hecho_pedido_numero primary key (pedido_numero)

    alter table [Grupo_3312].[BI_pedido]
    add constraint FK_BI_dim_pedido_tiempo foreign key (dim_pedido_tiempo) references Grupo_3312.BI_tiempo (dim_tiempo_id)

    alter table [Grupo_3312].[BI_pedido]
        add constraint FK_BI_dim_pedido_turno foreign key (dim_pedido_turno) references Grupo_3312.BI_turno_venta (dim_turno_venta_id)

    alter table [Grupo_3312].[BI_pedido]
        add constraint FK_BI_dim_pedido_sucursal foreign key (dim_pedido_sucursal) references Grupo_3312.BI_sucursal (dim_suc_numero)

    alter table [Grupo_3312].[BI_pedido]
        add constraint FK_BI_dim_pedido_estado foreign key (dim_pedido_estado) references Grupo_3312.BI_estado_pedido (dim_estado_pedido)

    create table [Grupo_3312].[BI_factura] (
        factura_id bigint not null,
        dim_factura_tiempo bigint not null,
        dim_factura_cliente bigint not null,
        factura_pedido bigint not null,
        factura_total decimal(12,2) not null
    )

    alter table [Grupo_3312].[BI_factura]
	add constraint PK_BI_hecho_factura_numero primary key (factura_id)

    alter table [Grupo_3312].[BI_factura]
	add constraint FK_BI_dim_factura_tiempo foreign key (dim_factura_tiempo) references Grupo_3312.BI_tiempo (dim_tiempo_id)

    alter table [Grupo_3312].[BI_factura]
    add constraint FK_BI_factura_pedido_numero foreign key (factura_pedido) references Grupo_3312.BI_pedido (pedido_numero)

    alter table [Grupo_3312].[BI_factura]
	add constraint FK_BI_factiura_cliente foreign key (dim_factura_cliente) references Grupo_3312.Bi_cliente (dim_cliente_id)

    create table [Grupo_3312].[BI_detalle_factura] (
        detalle_factura_numero bigint not null,
        dim_detalle_factura_modelo bigint not null,
        dim_detalle_factura_rango_etario bigint not null,
        dim_detalle_factura_sucursal bigint not null,
        detalle_factura_precio decimal(18,2) not null,
        detalle_factura_cantidad decimal(18,0) not null
    )

    alter table [Grupo_3312].[BI_detalle_factura]
    add constraint FK_BI_detalle_factura_numero foreign key (detalle_factura_numero) references Grupo_3312.BI_factura (factura_id)

    alter table [Grupo_3312].[BI_detalle_factura]
    add constraint FK_BI_detalle_factura_modelo foreign key (dim_detalle_factura_modelo) references Grupo_3312.Bi_modelo_sillon (dim_modelo_sillon_id)

    alter table [Grupo_3312].[BI_detalle_factura]
    add constraint FK_BI_detalle_factura_rango_etario foreign key (dim_detalle_factura_rango_etario) references Grupo_3312.BI_rango_etario (dim_rango_etario_id)

    alter table [Grupo_3312].[BI_detalle_factura]
    add constraint FK_BI_detalle_factura_sucursal foreign key (dim_detalle_factura_sucursal) references Grupo_3312.BI_sucursal (dim_suc_numero)

    create table [Grupo_3312].[BI_envio] (
        envio_factura_id bigint not null,
        dim_envio_cliente bigint not null,
        envio_fecha_estimada smalldatetime not null,
        envio_fecha_entregado smalldatetime not null,
        envio_total decimal(18,2) not null
    )

    alter table [Grupo_3312].[BI_envio]
    add constraint FK_BI_envio_factura_id foreign key (envio_factura_id) references Grupo_3312.BI_factura (factura_id)

    alter table [Grupo_3312].[BI_envio]
    add constraint FK_BI_dim_envio_cliente foreign key (dim_envio_cliente) references Grupo_3312.Bi_cliente (dim_cliente_id)

end
go

--Migracion

create procedure migrar_modelo_bi
as
begin
	
	-- Migracion dimension rango etario
	insert into GRUPO_3312.BI_rango_etario values
	(0,24),
	(25,34),
	(35,49),
	(50,150)

	--Migracion dimension del tiempo
	insert into GRUPO_3312.bi_turno_venta values
	('08:00:00', '13:59:59'),
	('14:00:00', '20:00:00')

	--Migracion dimension tipo material
	insert into GRUPO_3312.BI_tipo_material values
	('Madera'),('Relleno'),('Tela')

	--Migracion dimension del tiempo
	insert into grupo_3312.BI_tiempo
	select distinct
    month(fact_fecha),
    year(fact_fecha),
    CASE
    WHEN MONTH(fact_fecha) BETWEEN 1 AND 3 THEN 1
    WHEN MONTH(fact_fecha) BETWEEN 4 AND 6 THEN 2
    WHEN MONTH(fact_fecha) BETWEEN 7 AND 9 THEN 3
    WHEN MONTH(fact_fecha) BETWEEN 10 AND 12 THEN 4 END
    from grupo_3312.factura
	union
    select distinct
    month(ped_fecha),
    year(ped_fecha),
    CASE
    WHEN MONTH(ped_fecha) BETWEEN 1 AND 3 THEN 1
    WHEN MONTH(ped_fecha) BETWEEN 4 AND 6 THEN 2
    WHEN MONTH(ped_fecha) BETWEEN 7 AND 9 THEN 3
    WHEN MONTH(ped_fecha) BETWEEN 10 AND 12 THEN 4 END
    from grupo_3312.pedido
    union
    select distinct
    month(comp_fecha),
    year(comp_fecha),
    CASE
    WHEN MONTH(comp_fecha) BETWEEN 1 AND 3 THEN 1
    WHEN MONTH(comp_fecha) BETWEEN 4 AND 6 THEN 2
    WHEN MONTH(comp_fecha) BETWEEN 7 AND 9 THEN 3
    WHEN MONTH(comp_fecha) BETWEEN 10 AND 12 THEN 4 END
    from grupo_3312.compra

	--Migracion dimension ubicacion
	insert into GRUPO_3312.BI_ubicacion
	select distinct loc_detalle, prov_detalle from GRUPO_3312.localidad join GRUPO_3312.provincia on loc_provincia = prov_codigo

	--Migracion dimension estado
	insert into GRUPO_3312.BI_estado_pedido
	select distinct ped_estado from GRUPO_3312.pedido

	--Migracion modelo sillon
	insert into GRUPO_3312.Bi_modelo_sillon
	select distinct sill_mod_modelo from GRUPO_3312.sillon_modelo

	--Migracion modelo sucursal
	insert into GRUPO_3312.BI_sucursal
	select
	dim_ubicacion_id
	from GRUPO_3312.sucursal 
	join GRUPO_3312.localidad on loc_codigo = suc_localidad 
	join GRUPO_3312.provincia on prov_codigo = loc_provincia
	join GRUPO_3312.BI_ubicacion on prov_detalle = dim_ubicacion_provincia and loc_detalle = dim_ubicacion_localidad


end
go

SELECT * FROM GRUPO_3312.BI_tiempo

select * from GRUPO_3312.sucursal 

exec crear_modelo_bi
