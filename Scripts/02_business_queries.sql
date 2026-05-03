

1.
select a.nombre,count(*) as ventas_totales from productos a
inner join detalle_ventas b on b.id_producto=a.id_producto
group by a.nombre
order by count(*) desc
limit 5


2.
select a.nombre,a.precio_venta,a.costo_produccion,a.precio_venta-a.costo_produccion as ganacia from productos a
inner join categorias b on b.id_categoria=a.id_categoria
where b.nombre='Pastelería Fina'


3.
select count(*) from ventas
where extract(hour from fecha_hora) between 8 and 10

4.
select round(sum(total_venta)/count(*),2) as Ticket_promedio from ventas


5.
--no se si re refieres por mese o que pero creo que asi esta bien
with ingresos as(
select sum(total_venta)*0.30 as Ingreso_total from ventas)

select a.nombre,sum(b.cantidad)*b.precio_unitario_aplicado as ingresos from productos a
inner join detalle_ventas b on b.id_producto=a.id_producto
group by a.nombre,b.precio_unitario_aplicado
having sum(b.cantidad)*b.precio_unitario_aplicado>(select Ingreso_total from ingresos)

6.
with ventas_pago_movil as(
select count(*) as pago_movil from ventas
where metodo_pago='Pago Móvil')


select count(*)  as zelle,(select pago_movil from ventas_pago_movil ) from ventas
where metodo_pago='Zelle'




select * from categorias
select * from detalle_ventas
select  * from productos
select * from ventas

7.
select  * from productos where stock_actual<10


8.
Venta Sugerida (Cross-selling): Encuentra qué productos se venden frecuentemente juntos (por ejemplo, cuántas veces se vendió un "Café" y un "Dulce" en la misma id_venta).

--Esta si es verdad que no se como hacerla, 
select b.id_venta,a.nombre,count(*) from productos a
inner join detalle_ventas b on b.id_producto=a.id_producto
group by b.id_venta,a.nombre
order by  b.id_venta asc



9.
SELECT to_char(a.fecha_hora, 'TMDay') as dia_semana, sum(total_venta) as ingreso_total from ventas a
group by to_char(a.fecha_hora, 'TMDay')
order by sum(total_venta) desc
limit 1

10.
--Creo que deberia ser sum(prrecio_venta)*sum(stock_actual) pero bueno si tu dices que no
select sum(costo_produccion)*sum(stock_actual) as valor_inventario from productos
