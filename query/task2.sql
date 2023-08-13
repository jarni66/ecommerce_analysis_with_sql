-- ====MONTHLY ACTIVE USER
with table1 as (
	select orders.customer_id, customer.customer_unique_id, orders.order_purchase_timestamp
	from orders
	left join customer on orders.customer_id = customer.customer_id
	),
	table2 as (
	select 
		date_part('year',order_purchase_timestamp) as tahun,
		date_part('month',order_purchase_timestamp) as bulan,
		count(distinct customer_unique_id) as jumlah
	from table1
	group by 1,2
	)
select tahun, round(avg(jumlah),3) as rata_rata_MAU
from table2
group by 1

-- ====PELANGGAN BARU
with table1 as (
	select orders.customer_id, customer.customer_unique_id, orders.order_purchase_timestamp
	from orders
	left join customer on orders.customer_id = customer.customer_id
	),
	table2 as (
	select distinct customer_unique_id, min(order_purchase_timestamp) as first_order
	from table1
	group by customer_unique_id
	)
select date_part('year',first_order) as tahun, count(customer_unique_id) as jumlah_customer_baru
from table2
group by tahun
order by tahun

-- ====REPEAT ORDER
with table1 as (
	select 
		orders.customer_id, 
		customer.customer_unique_id, 
		date_part('year',orders.order_purchase_timestamp) as tahun
	from orders
	left join customer on orders.customer_id = customer.customer_id
	),
	table2 as (select tahun, customer_unique_id,count(customer_unique_id) as jumlah
	from table1
	group by 1,2
	having count(customer_unique_id) > 1
	)
select tahun, count(customer_unique_id) as jumlah_repeat_order
from table2
group by tahun

-- ====RATA-RATA ORDER
with table1 as (
	select 
		orders.customer_id, 
		customer.customer_unique_id, 
		date_part('year',orders.order_purchase_timestamp) as tahun
	from orders
	left join customer on orders.customer_id = customer.customer_id
	),
	table2 as (
	select tahun, customer_unique_id,count(customer_unique_id) as jumlah
	from table1
	group by 1,2
	)
select tahun, round(avg(jumlah),3) as rata_rata_order
from table2
group by tahun

-- ==== TABLE GABUNGAN
with tb11 as (
		select orders.customer_id, customer.customer_unique_id, orders.order_purchase_timestamp
		from orders
		left join customer on orders.customer_id = customer.customer_id),
	tb12 as (
		select 
			date_part('year',order_purchase_timestamp) as tahun,
			date_part('month',order_purchase_timestamp) as bulan,
			count(distinct customer_unique_id) as jumlah
		from tb11
		group by 1,2), 
	tb1 as (
		select tahun, round(avg(jumlah),3) as rata_rata_MAU
		from tb12
		group by 1),
	tb21 as (
		select orders.customer_id, customer.customer_unique_id, orders.order_purchase_timestamp
		from orders
		left join customer on orders.customer_id = customer.customer_id),
	tb22 as (
		select distinct customer_unique_id, min(order_purchase_timestamp) as first_order
		from tb21
		group by customer_unique_id),
	tb2 as (
		select date_part('year',first_order) as tahun, count(customer_unique_id) as jumlah_customer_baru
		from tb22
		group by tahun),
	tb31 as (
		select 
			orders.customer_id, 
			customer.customer_unique_id, 
			date_part('year',orders.order_purchase_timestamp) as tahun
		from orders
		left join customer on orders.customer_id = customer.customer_id),
	tb32 as (select tahun, customer_unique_id,count(customer_unique_id) as jumlah
		from tb31
		group by 1,2
		having count(customer_unique_id) > 1),
	tb3 as (
		select tahun, count(customer_unique_id) as jumlah_repeat_order
		from tb32
		group by tahun),
	tb41 as (
		select 
			orders.customer_id, 
			customer.customer_unique_id, 
			date_part('year',orders.order_purchase_timestamp) as tahun
		from orders
		left join customer on orders.customer_id = customer.customer_id),
	tb42 as (
		select tahun, customer_unique_id,count(customer_unique_id) as jumlah
		from tb41
		group by 1,2),
	tb4 as (
		select tahun, round(avg(jumlah),3) as rata_rata_order
		from tb42
		group by tahun)

select tb1.tahun, tb1.rata_rata_mau, tb2.jumlah_customer_baru, tb3.jumlah_repeat_order,tb4.rata_rata_order
from tb1
left join tb2 on tb1.tahun = tb2.tahun
left join tb3 on tb1.tahun = tb3.tahun
left join tb4 on tb1.tahun = tb4.tahun