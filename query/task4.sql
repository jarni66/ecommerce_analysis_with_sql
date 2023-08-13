--====JUMLAH TIPE PEMBAYARAN ALL TIME
select payment_type, count(payment_type) as jumlah
from (
	select distinct order_id, payment_type
	from order_payments
	) as tb
group by payment_type
order by jumlah desc

--====JUMLAH TIPE PEMBAYARAN TIAP TAHUN
select tahun, payment_type, count(payment_type) as jumlah
from (
	select distinct o.order_id, date_part('year',o.order_purchase_timestamp) as tahun, op.payment_type
	from orders as o
	left join order_payments as op on o.order_id = op.order_id
	) as tb
group by tahun, payment_type
order by tahun asc, jumlah desc