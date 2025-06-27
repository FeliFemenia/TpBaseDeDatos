-- Creacion de tablas BI

CREATE FUNCTION transformar_a_cuatrimestre (@fecha smalldatetime)
RETURNS int
AS
BEGIN
RETURN CASE
        WHEN MONTH(@fecha) BETWEEN 1 AND 3 THEN 1
        WHEN MONTH(@fecha) BETWEEN 4 AND 6 THEN 2
        WHEN MONTH(@fecha) BETWEEN 7 AND 9 THEN 3
        WHEN MONTH(@fecha) BETWEEN 10 AND 12 THEN 4 END
END
GO

alter procedure crear_modelo_bi
as
begin

    create table [Grupo_3312].[BI_rango_etario] (
        rango_etario_id bigint identity(1,1) not null,
        rango_etario_edad_minima bigint not null,
        rango_etario_edad_maxima bigint not null
    )

    alter table [Grupo_3312].[BI_rango_etario]
    add constraint PK_BI_rango_etario primary key (rango_etario_id)

    create table [Grupo_3312].[BI_tiempo] (
        tiempo_id bigint identity(1,1) not null,
        tiempo_mes int not null,
        tiempo_anio int not null,
        tiempo_cuatrimestre int not null
    )

    alter table [Grupo_3312].[BI_tiempo]
    add constraint PK_BI_tiempo primary key (tiempo_id)

    create table [Grupo_3312].[BI_ubicacion] (
        ubicacion_id bigint identity(1,1) not null,
        ubicacion_localidad nvarchar(255) not null,
        ubicacion_provincia nvarchar(255) not null
    )

    alter table [Grupo_3312].[BI_ubicacion]
    add constraint PK_BI_ubicacion primary key (ubicacion_id)

    create table [Grupo_3312].[BI_turno_venta] (
        turno_venta_id bigint identity(1,1) not null,
        turno_venta_inicio time not null,
        turno_venta_fin time not null
    )

    alter table [Grupo_3312].[BI_turno_venta]
    add constraint PK_BI_turno_venta primary key (turno_venta_id)

    create table [Grupo_3312].[BI_tipo_material] (
        tipo_material bigint identity(1,1) not null,
        detalle_material nvarchar(255) not null
    )

    alter table [Grupo_3312].[BI_tipo_material]
    add constraint PK_BI_tipo_material primary key (tipo_material)

    create table [Grupo_3312].[Bi_modelo_sillon] (
        modelo_sillon_id bigint not null,
        modelo_sillon_nombre nvarchar(255) not null
    )

    alter table [Grupo_3312].[BI_modelo_sillon]
    add constraint PK_BI_modelo_sillon primary key (modelo_sillon_id)

    CREATE TABLE [GRUPO_3312].[BI_estado_pedido](
        estado_pedido bigint not null,
        estado_pedido_estado nvarchar(255)
    )

    alter table [Grupo_3312].[BI_estado_pedido]
    add constraint PK_BI_estado_pedido primary key (estado_pedido)

    create table [Grupo_3312].[Bi_cliente] (
        cliente_id bigint not null,
        cliente_ubicacion bigint not null,
        cliente_rango_etario bigint not null
    )

    alter table [Grupo_3312].[BI_cliente]
    add constraint PK_BI_cliente primary key (cliente_id)

    alter table [Grupo_3312].[BI_cliente]
    add constraint FK_BI_cliente_ubicacion foreign key (cliente_ubicacion) references Grupo_3312.BI_ubicacion (ubicacion_id)

    alter table [Grupo_3312].[BI_cliente]
    add constraint FK_BI_cliente_rango_etario foreign key (cliente_rango_etario) references Grupo_3312.BI_rango_etario (rango_etario_id)

    create table [grupo_3312].[BI_sucursal] (
        suc_numero bigint not null,
        suc_ubicacion bigint not null
    )

    alter table [Grupo_3312].[BI_sucursal]
    add constraint PK_BI_sucursal primary key (suc_numero)

    alter table [Grupo_3312].[BI_sucursal]
    add constraint FK_BI_suc_ubicacion foreign key (suc_ubicacion) references Grupo_3312.BI_ubicacion (ubicacion_id)

    CREATE TABLE [grupo_3312].[BI_compra](
        compra_numero bigint not null,
        dim_compra_sucursal bigint not null,
        dim_compra_tiempo bigint not null
    )

    alter table [Grupo_3312].[BI_compra]
        add constraint PK_BI_hecho_compra primary key (compra_numero)

    alter table [Grupo_3312].[BI_compra]
        add constraint FK_BI_dim_sucursal foreign key (dim_compra_sucursal) references Grupo_3312.BI_sucursal (suc_numero)

    alter table [Grupo_3312].[BI_compra]
        add constraint FK_BI_dim_tiempo foreign key (dim_compra_tiempo) references Grupo_3312.BI_tiempo (tiempo_id)

    CREATE TABLE [grupo_3312].[BI_detalle_compra] (
        det_compra_numero bigint not null,
        dim_det_compra_material bigint not null,
        det_compra_precio decimal(18,0),
        det_compra_cantidad decimal(18,0)
    )

    alter table [Grupo_3312].[BI_detalle_compra]
    add constraint FK_BI_numero_compra foreign key (det_compra_numero) references Grupo_3312.BI_compra (compra_numero)

    alter table [Grupo_3312].[BI_detalle_compra]
    add constraint FK_BI_tipo_material foreign key (dim_det_compra_material) references Grupo_3312.BI_tipo_material (tipo_material)

    create table [GRUPO_3312].[BI_pedido] (
        pedido_numero decimal(18,0) not null,
        dim_pedido_tiempo bigint not null,
        dim_pedido_turno bigint not null,
        dim_pedido_sucursal bigint not null,
        dim_pedido_estado bigint not null
    )

    alter table [Grupo_3312].[BI_pedido]
        add constraint PK_BI_hecho_pedido_numero primary key (pedido_numero)

    alter table [Grupo_3312].[BI_pedido]
    add constraint FK_BI_dim_pedido_tiempo foreign key (dim_pedido_tiempo) references Grupo_3312.BI_tiempo (tiempo_id)

    alter table [Grupo_3312].[BI_pedido]
        add constraint FK_BI_dim_pedido_turno foreign key (dim_pedido_turno) references Grupo_3312.BI_turno_venta (turno_venta_id)

    alter table [Grupo_3312].[BI_pedido]
        add constraint FK_BI_dim_pedido_sucursal foreign key (dim_pedido_sucursal) references Grupo_3312.BI_sucursal (suc_numero)

    alter table [Grupo_3312].[BI_pedido]
        add constraint FK_BI_dim_pedido_estado foreign key (dim_pedido_estado) references Grupo_3312.BI_estado_pedido (estado_pedido)

    create table [Grupo_3312].[BI_factura] (
        factura_id bigint not null,
        dim_factura_tiempo bigint not null,
        dim_factura_cliente bigint not null,
        dim_factura_sucursal bigint not null,
        factura_pedido decimal(18,0) not null
    )

    alter table [Grupo_3312].[BI_factura]
	add constraint PK_BI_hecho_factura_numero primary key (factura_id)

    alter table [Grupo_3312].[BI_factura]
	add constraint FK_BI_dim_factura_tiempo foreign key (dim_factura_tiempo) references Grupo_3312.BI_tiempo (tiempo_id)

    alter table [Grupo_3312].[BI_factura]
    add constraint FK_BI_factura_sucursal foreign key (dim_factura_sucursal) references Grupo_3312.BI_sucursal (suc_numero)

    alter table [Grupo_3312].[BI_factura]
    add constraint FK_BI_factura_pedido_numero foreign key (factura_pedido) references Grupo_3312.BI_pedido (pedido_numero)

    alter table [Grupo_3312].[BI_factura]
	add constraint FK_BI_factiura_cliente foreign key (dim_factura_cliente) references Grupo_3312.Bi_cliente (cliente_id)

    create table [Grupo_3312].[BI_detalle_factura] (
        detalle_factura_numero bigint not null,
        dim_detalle_factura_modelo bigint not null,
        detalle_factura_precio decimal(18,2) not null,
        detalle_factura_cantidad decimal(18,0) not null
    )

    alter table [Grupo_3312].[BI_detalle_factura]
    add constraint FK_BI_detalle_factura_numero foreign key (detalle_factura_numero) references Grupo_3312.BI_factura (factura_id)

    alter table [Grupo_3312].[BI_detalle_factura]
    add constraint FK_BI_detalle_factura_modelo foreign key (dim_detalle_factura_modelo) references Grupo_3312.Bi_modelo_sillon (modelo_sillon_id)

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
    add constraint FK_BI_dim_envio_cliente foreign key (dim_envio_cliente) references Grupo_3312.Bi_cliente (cliente_id)

end
go

--Migracion

alter procedure migrar_modelo_bi
as
begin
	
	-- Migracion dimension rango etario
	insert into GRUPO_3312.BI_rango_etario values
	(0,24),
	(25,34),
	(35,49),
	(50,150)

	--Migracion dimension de turno de ventas
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
    dbo.transformar_a_cuatrimestre(fact_fecha)
    from grupo_3312.factura
	union
    select distinct
    month(ped_fecha),
    year(ped_fecha),
    dbo.transformar_a_cuatrimestre(ped_fecha)
    from grupo_3312.pedido
    union
    select distinct
    month(comp_fecha),
    year(comp_fecha),
    dbo.transformar_a_cuatrimestre(comp_fecha)
    from grupo_3312.compra

	--Migracion dimension ubicacion
	insert into GRUPO_3312.BI_ubicacion
	select distinct loc_detalle, prov_detalle from GRUPO_3312.localidad 
	join GRUPO_3312.provincia on loc_provincia = prov_codigo

	--Migracion dimension estado
	insert into GRUPO_3312.BI_estado_pedido
	select estado_numero, estado_nombre from GRUPO_3312.pedido_estado

	--Migracion modelo sillon
	insert into GRUPO_3312.Bi_modelo_sillon
	select
	sill_mod_codigo,
    sill_mod_modelo
	from GRUPO_3312.sillon_modelo

	--Migracion modelo sucursal
	insert into GRUPO_3312.BI_sucursal
	select
	suc_numero,
	(select ubicacion_id from GRUPO_3312.BI_ubicacion where prov_detalle = ubicacion_provincia 
	and loc_detalle = ubicacion_localidad)
	from GRUPO_3312.sucursal 
	left join GRUPO_3312.localidad on loc_codigo = suc_localidad 
	left join GRUPO_3312.provincia on prov_codigo = loc_provincia


    --Migracion dimension cliente
	insert into GRUPO_3312.Bi_cliente
	select 
	clie_dni,
	ubicacion_id,
	(select rango_etario_id from GRUPO_3312.BI_rango_etario
	where year(getdate()) - year(clie_fechaNacimiento) between rango_etario_edad_minima AND rango_etario_edad_maxima)
	from GRUPO_3312.cliente
	join GRUPO_3312.localidad on loc_codigo = clie_localidad 
	join GRUPO_3312.provincia on prov_codigo = loc_provincia
	join GRUPO_3312.BI_ubicacion on prov_detalle = ubicacion_provincia and loc_detalle = ubicacion_localidad

	--Migracion de pedidos
	INSERT INTO GRUPO_3312.BI_pedido
	select
    ped_numero,
    (select tiempo_id from GRUPO_3312.BI_tiempo
    where year(ped_fecha) = tiempo_anio
    and month(ped_fecha) = tiempo_mes
    and dbo.transformar_a_cuatrimestre(ped_fecha) = tiempo_cuatrimestre),
    (select turno_venta_id from GRUPO_3312.BI_turno_venta
    where CONVERT(TIME(0), ped_fecha) BETWEEN turno_venta_inicio AND turno_venta_fin),
    ped_sucursal,
    ped_estado
	from GRUPO_3312.pedido

	--Migracion de Facturas
	insert into GRUPO_3312.BI_factura
	select
    fact_numero,
    (select tiempo_id from GRUPO_3312.BI_tiempo where year(fact_fecha) = tiempo_anio
    and month(fact_fecha) = tiempo_mes
    and dbo.transformar_a_cuatrimestre(fact_fecha) = tiempo_cuatrimestre),
	fact_cliente,
	fact_sucursal,
    (select top 1 det_fact_numeroPedido from GRUPO_3312.detalle_factura where det_fact_numero = fact_numero)
	from GRUPO_3312.factura 
	group by fact_numero, fact_fecha, fact_cliente, fact_sucursal

	--Migracion detalle factura
	INSERT INTO GRUPO_3312.BI_detalle_factura
	select
    det_fact_numero,
    (select sill_modelo from GRUPO_3312.sillon
    where det_fact_sillon = sill_codigo),
    det_fact_precio,
    det_fact_cantidad
	from GRUPO_3312.detalle_factura

	--Migracion de envios
    INSERT INTO GRUPO_3312.BI_envio
    SELECT
        fact_numero,
        fact_cliente,
        env_fechaProgramada,
        env_fechaEntrega,
        env_total
    FROM GRUPO_3312.factura
    join GRUPO_3312.envio on fact_envio = env_numero

	--Migracion compra
	insert into GRUPO_3312.BI_compra
	select
	comp_numero,
	comp_sucursal,
	(select tiempo_id from GRUPO_3312.BI_tiempo where year(comp_fecha) = tiempo_anio
	and month(comp_fecha) = tiempo_mes
	and dbo.transformar_a_cuatrimestre(comp_fecha) = tiempo_cuatrimestre)
	from GRUPO_3312.compra 

	--Migracion detalle compra
	insert into GRUPO_3312.BI_detalle_compra
	select
	det_comp_numero,
	(select tipo_material from GRUPO_3312.BI_tipo_material 
	join GRUPO_3312.material on det_comp_material = mat_codigo
	where detalle_material = mat_tipo
	),
	det_comp_precio,
	det_comp_cantidad
	from GRUPO_3312.detalle_compra

end
go

exec crear_modelo_bi
go

exec migrar_modelo_bi
go
-- Vistas

-- Vista 1: Ganancias
alter VIEW ganancias (sucursal, mes, Ganancias)
as
SELECT
    suc_numero,
    tiempo_mes,
	sum(detalle_factura_precio * detalle_factura_cantidad) - sum(det_compra_precio * det_compra_cantidad) 
FROM GRUPO_3312.BI_sucursal
join GRUPO_3312.BI_compra on suc_numero = dim_compra_sucursal
join GRUPO_3312.BI_detalle_compra on det_compra_numero = compra_numero
join GRUPO_3312.Bi_factura on suc_numero = dim_factura_sucursal
join GRUPO_3312.BI_detalle_factura on detalle_factura_numero = factura_id
join GRUPO_3312.Bi_tiempo on tiempo_id = dim_factura_tiempo and tiempo_id = dim_compra_tiempo
group by suc_numero, tiempo_mes
go

SELECT * FROM ganancias
go

--Vista 2: Factura promedio mensual

create view factura_promedio_mensual (provincia, cuatrimestre, anio, promedio)
as
select 
ubicacion_provincia, 
tiempo_cuatrimestre,
tiempo_anio,
sum(detalle_factura_cantidad * detalle_factura_precio) / count(distinct factura_id)
from GRUPO_3312.BI_tiempo
join GRUPO_3312.BI_factura on dim_factura_tiempo = tiempo_id
join GRUPO_3312.BI_detalle_factura on detalle_factura_numero = factura_id
join GRUPO_3312.BI_sucursal on dim_factura_sucursal = suc_numero
join GRUPO_3312.BI_ubicacion on ubicacion_id = suc_ubicacion
group by ubicacion_provincia, tiempo_cuatrimestre, tiempo_anio
go

select * from factura_promedio_mensual
go

--Vista 3: Rendimientos de modelos
/*
create view rendimiento_de_pedidos (anio, cuatrimestre, localidad_sucursal, rango_etario, modelo_sillon)
as
select top 3 from GRUPO_3312.Bi_modelo_sillon
join GRUPO_3312.BI_detalle_factura on dim_detalle_factura_modelo = modelo_sillon_id
join GRUPO_3312.BI_factura on factura_id = detalle_factura_numero
join GRUPO_3312.BI_tiempo on tiempo_id = dim_factura_tiempo
join GRUPO_3312.BI_sucursal on suc_numero = dim_factura_sucursal
join GRUPO_3312.Bi_cliente on cliente_id = dim_factura_cliente
join GRUPO_3312.BI_rango_etario on rango_etario_id = cliente_rango_etario
group by tiempo_anio,
*/

go
--Vista 4: Volumen de pedidos

alter view volumen_de_pedidos (anio, mes, sucursal, turno, cantidad_pedidos)
as
select 
tiempo_anio, 
tiempo_mes, 
suc_numero, 
turno_venta_id,
count(distinct pedido_numero) 
from GRUPO_3312.BI_sucursal
join GRUPO_3312.BI_pedido on dim_pedido_sucursal = suc_numero
join GRUPO_3312.BI_turno_venta on turno_venta_id = dim_pedido_turno
join GRUPO_3312.BI_tiempo on tiempo_id = dim_pedido_tiempo
group by tiempo_anio, tiempo_mes, suc_numero, turno_venta_id 
go

select * from volumen_de_pedidos
go

--Vista 5: Conversion de pedidos

alter view conversion_de_pedidos (sucursal, cuatrimestre, estado, porcentaje)
as
select 
suc_numero, 
tiempo_cuatrimestre, 
estado_pedido_estado,
((count(pedido_numero) * 100) / (select count(*) from GRUPO_3312.BI_pedido 
								where dim_pedido_tiempo = tiempo_id and dim_pedido_sucursal = suc_numero)) 
from GRUPO_3312.sucursal
join GRUPO_3312.BI_pedido on dim_pedido_sucursal = suc_numero
join GRUPO_3312.BI_estado_pedido on estado_pedido = dim_pedido_estado
join GRUPO_3312.BI_tiempo on tiempo_id = dim_pedido_tiempo
group by suc_numero, estado_pedido_estado, tiempo_cuatrimestre, tiempo_id
go

select * from conversion_de_pedidos
go

--Vista 6: Tiempo promedio de fabricacion
/*
create view tiempo_promedio_de_fabricacion (sucursal, cuatrimestre, tiempo_promedio_fabricacion)
as
select 
suc_numero, 
tiempo_cuatrimestre,

from GRUPO_3312.BI_sucursal
join GRUPO_3312.BI_factura on dim_factura_sucursal = suc_numero
join GRUPO_3312.BI_pedido on pedido_numero = factura_pedido
join GRUPO_3312.BI_tiempo on tiempo_id = dim_factura_tiempo and tiempo_id = dim_pedido_tiempo
group by 
go
*/

--Vista 7: Importe promedio de compras por mes

create view promedio_de_compras (anio, mes, promedio)
as
    SELECT tiempo_anio, tiempo_mes, AVG(det_compra_precio * det_compra_cantidad)
    FROM GRUPO_3312.BI_compra
    join GRUPO_3312.BI_detalle_compra on compra_numero = det_compra_numero
    join GRUPO_3312.BI_tiempo on tiempo_id = dim_compra_tiempo
    GROUP BY tiempo_anio, tiempo_mes
go

select * from promedio_de_compras
go

--Vista 8: Compras por tipo de material

create view compras_por_tipo_de_material (cuatrimestre, sucursal, tipo_material, importe_total)
as
select 
tiempo_cuatrimestre, 
suc_numero, 
detalle_material,
sum(det_compra_cantidad * det_compra_precio)
from GRUPO_3312.BI_sucursal
join GRUPO_3312.BI_compra on dim_compra_sucursal = suc_numero
join GRUPO_3312.BI_detalle_compra on det_compra_numero = compra_numero
join GRUPO_3312.BI_tiempo on tiempo_id = dim_compra_tiempo 
join GRUPO_3312.BI_tipo_material on tipo_material = dim_det_compra_material
group by tiempo_cuatrimestre, suc_numero, tipo_material, detalle_material
go

select * from compras_por_tipo_de_material
go

--Vista 9: Porcentaje de cumplimiento por mes. 
alter view porcentaje_de_cumplimiento_por_mes (mes, envios_programados)
as
select 
month(envio_fecha_entregado),
(count(pedido_numero) * 100) / (select count(*) from GRUPO_3312.BI_pedido join GRUPO_3312.BI_tiempo on tiempo_id = dim_pedido_tiempo
							where tiempo_mes = month(envio_fecha_entregado))
from GRUPO_3312.BI_envio
join GRUPO_3312.BI_factura on factura_id = envio_factura_id
join GRUPO_3312.BI_pedido on pedido_numero = factura_pedido
join GRUPO_3312.BI_estado_pedido on estado_pedido = dim_pedido_estado 
where estado_pedido_estado = 'ENTREGADO' and envio_fecha_entregado <= envio_fecha_estimada
group by MONTH(envio_fecha_entregado)
go

select * from porcentaje_de_cumplimiento_por_mes
go

--Vista 10: Localidades que pagan mayor costo de envio
create view localidad_que_pagan_mayor_costo_de_envio (localidad)
as
select top 3 ubicacion_localidad from GRUPO_3312.BI_envio
join GRUPO_3312.Bi_cliente on cliente_id = dim_envio_cliente
join GRUPO_3312.BI_ubicacion on ubicacion_id = cliente_ubicacion
group by ubicacion_localidad 
order by avg(envio_total) desc
go

select * from localidad_que_pagan_mayor_costo_de_envio
go