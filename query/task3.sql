--====REVENUE TAHUNAN
create table revenue_tahun as
	select 
		date_part('year',order_purchase_timestamp) as tahun,
		sum(revenue) as total_order_revenue
	from (
		select 
			o.order_id, o.order_status, o.order_purchase_timestamp, 
			oi.price, oi.freight_value,(oi.price + oi.freight_value) as revenue
		from orders as o
		left join order_items as oi on o.order_id = oi.order_id
		where o.order_status not in ('canceled','unavailable','created') --kategori status dengan price dan freight null
		) as tb
	group by 1
	
	
--====JUMLAH CANCEL ORDER TAHUNAN
create table jumlah_canceled_tahun as
	select 
		date_part('year',order_purchase_timestamp) as tahun,
		count(order_status) as jumlah_order_cancel
	from (
		select *
		from orders 
		where order_status = 'canceled'
		) as tb
	group by 1

--====PRODUCT KATEGORI REVENUE TAHUNAN===========================
create table product_kategori_tahun as
	select tahun, kategori as top_revenue_kategori, total as kategori_total_revenue
	from (
		select 
			tahun, kategori, total, 
			rank() over (partition by tahun order by total desc) as rangking
		from (
			select tahun,kategori, sum(revenue) as total
			from (
				select 
					date_part('year',o.order_purchase_timestamp) as tahun,
					pt.product_category_name as kategori, 
					(oi.price + oi.freight_value) as revenue
				from orders as o
				left join order_items as oi on o.order_id = oi.order_id
				left join product as pt on oi.product_id = pt.product_id
				) as tb
			group by tahun,kategori
			order by tahun,total desc
			) as tb2
		) as tb3
	where rangking = 1


--====PRODUCT CANCELED TAHUNAN
create table product_canceled_year as
select tahun, kategori as kategori_canceled,jumlah as jumlah_kategori_canceled
from (
	select 
		tahun, kategori, jumlah, 
		rank() over (partition by tahun order by jumlah desc) as rangking
	from (
		select tahun, kategori, count(kategori) as jumlah
		from (
			select 
				date_part('year',o.order_purchase_timestamp) as tahun,
				o.order_status,
				pt.product_category_name as kategori
			from orders as o
			left join order_items as oi on o.order_id = oi.order_id
			left join product as pt on oi.product_id = pt.product_id
			where order_status = 'canceled'
			) as tb
		group by tahun,kategori
		) as tb2
	) as tb3
where rangking = 1


--=====MASTER TABLE=======================
select 
	rt.tahun, rt.total_order_revenue, ct.jumlah_order_cancel, pkt.top_revenue_kategori, pkt.kategori_total_revenue,
	pct.kategori_canceled, pct.jumlah_kategori_canceled
from revenue_tahun as rt
left join jumlah_canceled_tahun as ct on rt.tahun = ct.tahun
left join product_kategori_tahun as pkt on rt.tahun = pkt.tahun
left join product_canceled_year as pct on rt.tahun = pct.tahun