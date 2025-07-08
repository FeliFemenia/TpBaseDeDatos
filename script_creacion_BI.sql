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

create function obtener_dim_tiempo (@fecha datetime)
    returns bigint
as
begin
    declare @tiempo_id bigint
    set @tiempo_id = 0

    set @tiempo_id = (select tiempo_id from GRUPO_3312.BI_tiempo where tiempo_mes = month(@fecha)
            and tiempo_anio = year(@fecha)
            and tiempo_cuatrimestre = dbo.transformar_a_cuatrimestre(@fecha))

    return @tiempo_id
end
go

create procedure crear_modelo_bi
as
begin

    create table [Grupo_3312].[BI_rango_etario] (
        rango_etario_id bigint identity(1,1) not null,
        rango_etario_min bigint not null,
        rango_etario_max bigint not null
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
        tipo_material_id bigint identity(1,1) not null,
        tipo_material_detalle nvarchar(255) not null
    )

    alter table [Grupo_3312].[BI_tipo_material]
    add constraint PK_BI_tipo_material primary key (tipo_material_id)

    create table [Grupo_3312].[Bi_modelo_sillon] (
        modelo_sillon_id bigint not null,
        modelo_sillon_nombre nvarchar(255) not null
    )

    alter table [Grupo_3312].[BI_modelo_sillon]
    add constraint PK_BI_modelo_sillon primary key (modelo_sillon_id)

    CREATE TABLE [GRUPO_3312].[BI_estado_pedido](
        estado_pedido_id bigint not null,
        estado_pedido_detalle nvarchar(255)
    )

    alter table [Grupo_3312].[BI_estado_pedido]
    add constraint PK_BI_estado_pedido primary key (estado_pedido_id)

    create table [grupo_3312].[BI_sucursal] (
        sucursal_numero bigint not null
    )

    alter table [Grupo_3312].[BI_sucursal]
    add constraint PK_BI_sucursal primary key (sucursal_numero)

    CREATE TABLE [grupo_3312].[BI_compra](
        dim_compra_sucursal bigint not null,
        dim_compra_tiempo bigint not null,
        dim_compra_tipo_material bigint not null,
        compra_total decimal(18,2) not null
    )

    alter table [Grupo_3312].[BI_compra]
    add constraint FK_dim_sucursal foreign key (dim_compra_sucursal) references Grupo_3312.BI_sucursal (sucursal_numero)

    alter table [Grupo_3312].[BI_compra]
    add constraint FK_dim_tiempo foreign key (dim_compra_tiempo) references Grupo_3312.BI_tiempo (tiempo_id)

    alter table [Grupo_3312].[BI_compra]
    add constraint FK_dim_tipo_material foreign key (dim_compra_tipo_material) references Grupo_3312.BI_tipo_material (tipo_material_id)

    create table [GRUPO_3312].[BI_pedido] (
        dim_pedido_tiempo bigint not null,
        dim_pedido_turno bigint not null,
        dim_pedido_sucursal bigint not null,
        dim_pedido_estado bigint not null,
		pedido_cantidad bigint
    )

    alter table [Grupo_3312].[BI_pedido]
    add constraint FK_dim_pedido_tiempo foreign key (dim_pedido_tiempo) references Grupo_3312.BI_tiempo (tiempo_id)

    alter table [Grupo_3312].[BI_pedido]
        add constraint FK_dim_pedido_turno foreign key (dim_pedido_turno) references Grupo_3312.BI_turno_venta (turno_venta_id)

    alter table [Grupo_3312].[BI_pedido]
        add constraint FK_dim_pedido_sucursal foreign key (dim_pedido_sucursal) references Grupo_3312.BI_sucursal (sucursal_numero)

    alter table [Grupo_3312].[BI_pedido]
        add constraint FK_dim_pedido_estado foreign key (dim_pedido_estado) references Grupo_3312.BI_estado_pedido (estado_pedido_id)

    create table [Grupo_3312].[BI_venta] (
        dim_venta_tiempo bigint not null,
        dim_venta_rango_etario_cliente bigint not null,
        dim_venta_sucursal bigint not null,
        dim_venta_modelo bigint not null,
		dim_venta_localidad_sucursal bigint not null, 
        venta_total decimal(18,2) not null,
        venta_cantidad_sillon decimal(18,0) not null,
        venta_tiempo_fabricacion int not null,
		venta_cantidad_factura bigint not null
    )

    alter table [Grupo_3312].[BI_venta]
	add constraint FK_dim_venta_tiempo foreign key (dim_venta_tiempo) references Grupo_3312.BI_tiempo (tiempo_id)

    alter table [Grupo_3312].[BI_venta]
    add constraint FK_dim_venta_sucursal foreign key (dim_venta_sucursal) references Grupo_3312.BI_sucursal (sucursal_numero)

    alter table [Grupo_3312].[BI_venta]
	add constraint FK_dim_venta_rango_etario_cliente foreign key (dim_venta_rango_etario_cliente) references Grupo_3312.BI_rango_etario (rango_etario_id)

    alter table [Grupo_3312].[BI_venta]
    add constraint FK_dim_venta_modelo foreign key (dim_venta_modelo) references Grupo_3312.BI_modelo_sillon (modelo_sillon_id)

	alter table [Grupo_3312].[BI_venta]
    add constraint FK_dim_venta_localidad_sucursal foreign key (dim_venta_localidad_sucursal) references Grupo_3312.BI_ubicacion (ubicacion_id)

	create table [Grupo_3312].[BI_envio] (
        dim_envio_ubicacion_cliente bigint not null,
        dim_envio_tiempo bigint not null,
        envio_total decimal(18,2) not null,
		envio_cumplidos bigint,
		envio_incumplidos bigint,
	    envio_cantidad bigint
    )

    alter table [Grupo_3312].[BI_envio]
    add constraint FK_dim_ubicacion_cliente foreign key (dim_envio_ubicacion_cliente) references Grupo_3312.BI_ubicacion (ubicacion_id)

    alter table [Grupo_3312].[BI_envio]
    add constraint FK_dim_envio_tiempo foreign key (dim_envio_tiempo) references Grupo_3312.BI_tiempo (tiempo_id)

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
	suc_numero
	from GRUPO_3312.sucursal 

	--Migracion de envio
    insert into GRUPO_3312.BI_envio
    select
        ubicacion_id,
        tiempo_id,
        sum(env_total),
        sum(case when env_fechaEntrega <= env_fechaProgramada then 1 else 0 end),
        sum(case when env_fechaEntrega > env_fechaProgramada then 1 else 0 end),
        count(*)
    from GRUPO_3312.envio
    join GRUPO_3312.factura on fact_envio = env_numero
    join GRUPO_3312.Cliente on fact_cliente = clie_dni
    join GRUPO_3312.localidad on clie_localidad = loc_codigo
    join GRUPO_3312.provincia on loc_provincia = prov_codigo
    join GRUPO_3312.BI_ubicacion on ubicacion_provincia = prov_detalle and ubicacion_localidad = loc_detalle
    join GRUPO_3312.BI_tiempo on tiempo_id = dbo.obtener_dim_tiempo(fact_fecha)
    group by ubicacion_id, tiempo_id

    --Migracion de compra
	insert into GRUPO_3312.BI_compra
	select
    comp_sucursal,
    tiempo_id,
	tipo_material_id,
	sum(det_comp_precio * det_comp_cantidad)
	from GRUPO_3312.detalle_compra
	join GRUPO_3312.compra on comp_numero = det_comp_numero
	join GRUPO_3312.material on mat_codigo = det_comp_material
	join GRUPO_3312.BI_tipo_material on tipo_material_detalle = mat_tipo
    join GRUPO_3312.BI_tiempo on tiempo_id = dbo.obtener_dim_tiempo(comp_fecha)
	group by tipo_material_id, comp_sucursal, tiempo_id

	-- Migracion de ventas
	INSERT INTO GRUPO_3312.BI_venta
	select
	    tiempo_id,
	    rango_etario_id,
		fact_sucursal,
	    sill_modelo,
		ubicacion_id,
        sum(det_fact_precio * det_fact_cantidad),
        count(det_fact_sillon),
        avg(DATEDIFF(DAY, ped_fecha, fact_fecha)),
		count(distinct fact_numero)
	from GRUPO_3312.detalle_factura
	join GRUPO_3312.factura on fact_numero = det_fact_numero
	join GRUPO_3312.pedido on ped_numero = det_fact_numeroPedido
	join GRUPO_3312.sillon on det_fact_sillon = sill_codigo
	join GRUPO_3312.cliente on clie_dni = fact_cliente
	join GRUPO_3312.sucursal on fact_sucursal = suc_numero
    join GRUPO_3312.localidad on loc_codigo = suc_localidad
    join GRUPO_3312.provincia on loc_provincia = prov_codigo
    join GRUPO_3312.BI_ubicacion on ubicacion_localidad = loc_detalle and ubicacion_provincia = prov_detalle
    join GRUPO_3312.BI_rango_etario on year(getdate()) - year(clie_fechaNacimiento) between rango_etario_min and rango_etario_max
    join GRUPO_3312.BI_tiempo on tiempo_id = dbo.obtener_dim_tiempo(fact_fecha)
	group by tiempo_id, rango_etario_id, fact_sucursal, sill_modelo, ubicacion_id

    --Migracion de pedido
    insert into GRUPO_3312.BI_pedido
	select
	    tiempo_id,
	    turno_venta_id,
	    ped_sucursal,
        ped_estado,
        count(ped_numero)
	from GRUPO_3312.pedido
	join GRUPO_3312.BI_turno_venta on CONVERT(TIME(0), ped_fecha) BETWEEN turno_venta_inicio AND turno_venta_fin
    join GRUPO_3312.BI_tiempo on tiempo_id = dbo.obtener_dim_tiempo(ped_fecha)
	GROUP BY tiempo_id, turno_venta_id, ped_sucursal, ped_estado

end
go


exec crear_modelo_bi
go

exec migrar_modelo_bi
go


-- Vistas

-- Vista 1: Ganancias
create VIEW [GRUPO_3312].[ganancias] (sucursal, mes, Ganancias)
as
select 
sucursal_numero, 
tiempo_mes, 
sum(venta_total) - sum(compra_total)
from GRUPO_3312.BI_sucursal
join GRUPO_3312.BI_venta on dim_venta_sucursal = sucursal_numero
join GRUPO_3312.BI_compra on dim_compra_sucursal = sucursal_numero
join GRUPO_3312.BI_tiempo on dim_compra_tiempo = tiempo_id and dim_venta_tiempo = tiempo_id
group by sucursal_numero, tiempo_mes
go

--Vista 2: Factura promedio mensual

create view [GRUPO_3312].[factura_promedio_mensual] (provincia, anio, cuatrimestre, promedio)
as
select 
ubicacion_provincia,  
tiempo_anio,
tiempo_cuatrimestre, 
sum(venta_total) / sum(venta_cantidad_factura)
from GRUPO_3312.BI_ubicacion
join GRUPO_3312.BI_venta on dim_venta_localidad_sucursal = ubicacion_id
join GRUPO_3312.BI_tiempo on tiempo_id = dim_venta_tiempo
group by ubicacion_provincia, tiempo_cuatrimestre, tiempo_anio
go

--Vista 3: Rendimientos de modelos
create view [GRUPO_3312].[rendimiento_de_modelos] (anio, cuatrimestre, localidad_sucursal, rango_etario, modelo)
as

SELECT
    tiempo_anio,
    tiempo_cuatrimestre,
    ubicacion_localidad,
    rango_etario_id,
    modelo_sillon_nombre
FROM (
    SELECT 
        t.tiempo_anio,
        t.tiempo_cuatrimestre,
        u.ubicacion_localidad,
        r.rango_etario_id,
        m.modelo_sillon_nombre,
        ROW_NUMBER() OVER (
            PARTITION BY t.tiempo_anio, t.tiempo_cuatrimestre, u.ubicacion_localidad, r.rango_etario_id
            ORDER BY SUM(v.venta_cantidad_sillon) DESC
        ) AS rn
    FROM GRUPO_3312.BI_venta v
    JOIN GRUPO_3312.BI_tiempo t ON t.tiempo_id = v.dim_venta_tiempo
    JOIN GRUPO_3312.BI_ubicacion u ON u.ubicacion_id = v.dim_venta_localidad_sucursal
    JOIN GRUPO_3312.BI_rango_etario r ON r.rango_etario_id = v.dim_venta_rango_etario_cliente
    JOIN GRUPO_3312.Bi_modelo_sillon m ON m.modelo_sillon_id = v.dim_venta_modelo
    GROUP BY 
        t.tiempo_anio,
        t.tiempo_cuatrimestre,
        u.ubicacion_localidad,
        r.rango_etario_id,
        m.modelo_sillon_nombre
) AS ranked
WHERE rn <= 3

go

--Vista 4: Volumen de pedidos

create view [GRUPO_3312].[volumen_de_pedidos] (anio, mes, sucursal, turno, cantidad_pedidos)
as
select 
tiempo_anio, 
tiempo_mes, 
sucursal_numero,
turno_venta_id,
sum(pedido_cantidad)
from GRUPO_3312.BI_sucursal
join GRUPO_3312.BI_pedido on dim_pedido_sucursal = sucursal_numero
join GRUPO_3312.BI_turno_venta on turno_venta_id = dim_pedido_turno
join GRUPO_3312.BI_tiempo on tiempo_id = dim_pedido_tiempo
group by tiempo_anio, tiempo_mes, sucursal_numero, turno_venta_id
go

--Vista 5: Conversion de pedidos

create view [GRUPO_3312].[conversion_de_pedidos] (sucursal, cuatrimestre, estado, porcentaje)
as
select 
sucursal_numero,
tiempo_cuatrimestre,
estado_pedido_detalle,
round(CONVERT(decimal(10,2), sum(pedido_cantidad) * 100) / (select sum(pedido_cantidad) from GRUPO_3312.BI_pedido p
								join GRUPO_3312.BI_tiempo t on t.tiempo_id = p.dim_pedido_tiempo 
								and t.tiempo_cuatrimestre = tiempo_cuatrimestre
									where p.dim_pedido_sucursal = sucursal_numero),2)
from GRUPO_3312.BI_sucursal
join GRUPO_3312.BI_pedido on dim_pedido_sucursal = sucursal_numero
join GRUPO_3312.BI_estado_pedido on estado_pedido_id = dim_pedido_estado
join GRUPO_3312.BI_tiempo on tiempo_id = dim_pedido_tiempo
group by sucursal_numero, estado_pedido_detalle, tiempo_cuatrimestre
go

--Vista 6: Tiempo promedio de fabricacion

create view [GRUPO_3312].[tiempo_promedio_de_fabricacion] (sucursal, cuatrimestre, tiempo_promedio_fabricacion_en_dias)
as
select
sucursal_numero, 
tiempo_cuatrimestre, 
avg(venta_tiempo_fabricacion)
from GRUPO_3312.BI_sucursal
join GRUPO_3312.BI_venta on dim_venta_sucursal = sucursal_numero
join GRUPO_3312.BI_tiempo on tiempo_id = dim_venta_tiempo
group by sucursal_numero, tiempo_cuatrimestre
go

--Vista 7: Importe promedio de compras por mes

create view [GRUPO_3312].[promedio_de_compras] (mes, promedio)
as
    select 
	tiempo_mes, 
	avg(compra_total)
	from GRUPO_3312.BI_tiempo
	join GRUPO_3312.BI_compra on dim_compra_tiempo = tiempo_id
	group by tiempo_mes
go

--Vista 8: Compras por tipo de material

create view [GRUPO_3312].[compras_por_tipo_de_material] (cuatrimestre, sucursal, tipo_material, importe_total)
as
select 
tiempo_cuatrimestre, 
sucursal_numero,
tipo_material_detalle,
sum(compra_total)
from GRUPO_3312.BI_sucursal
join GRUPO_3312.BI_compra on dim_compra_sucursal = sucursal_numero
join GRUPO_3312.BI_tiempo on tiempo_id = dim_compra_tiempo 
join GRUPO_3312.BI_tipo_material on tipo_material_id = dim_compra_tipo_material
group by sucursal_numero, tiempo_cuatrimestre, tipo_material_detalle
go

--Vista 9: Porcentaje de cumplimiento por mes. 
create view [GRUPO_3312].[porcentaje_de_cumplimiento_por_mes] (mes, porcentaje_de_cumplimiento)
as
select 
tiempo_mes,
(sum(envio_cumplidos) * 100) / sum(envio_cantidad)
from GRUPO_3312.BI_envio
join GRUPO_3312.BI_tiempo on tiempo_id = dim_envio_tiempo
group by tiempo_mes
go

--Vista 10: Localidades que pagan mayor costo de envio
create view [GRUPO_3312].[localidad_que_pagan_mayor_costo_de_envio] (localidad)
as
	select top 3 
	ubicacion_localidad 
	from GRUPO_3312.BI_envio
	join GRUPO_3312.BI_ubicacion on ubicacion_id = dim_envio_ubicacion_cliente
	group by ubicacion_localidad
	order by avg(envio_total) desc
go





