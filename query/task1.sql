create table public.customer (
	customer_id varchar(50),
	customer_unique_id varchar(50),
	customer_zip_code_prefix integer,
	customer_city varchar(50),
	customer_state varchar(50),
	primary key (customer_id)
);

COPY customer (
	customer_id,
	customer_unique_id,
	customer_zip_code_prefix,
	customer_city,
	customer_state
)
from 'C:\Users\jarni\Desktop\bootcamp\Projects\mp_ecommerce\customers_dataset.csv'
delimiter ','
csv header;

create table public.geolocation (
	geolocation_zip_code_prefix integer,
	geolocation_lat numeric,
	geolocation_lng numeric,
	geolocation_city varchar(50),
	geolocation_state varchar(50)
);
copy geolocation (
	geolocation_zip_code_prefix,
	geolocation_lat,
	geolocation_lng,
	geolocation_city,
	geolocation_state
)
from 'C:\Users\jarni\Desktop\bootcamp\Projects\mp_ecommerce\geolocation_dataset.csv'
delimiter ','
csv header;

create table public.order_items (
	order_id varchar(50),
	order_item_id integer,
	product_id varchar(50),
	seller_id varchar(50),
	shipping_limit_date timestamp,
	price float8,
	freight_value float8
);
copy order_items (
	order_id,
	order_item_id,
	product_id,
	seller_id,
	shipping_limit_date,
	price,
	freight_value
)
from 'C:\Users\jarni\Desktop\bootcamp\Projects\mp_ecommerce\order_items_dataset.csv'
delimiter ','
csv header;

create table public.order_payments (
	order_id varchar(50),
	payment_sequential integer,
	payment_type varchar(50),
	payment_installments integer,
	payment_value float8
);
copy order_payments (
	order_id,
	payment_sequential,
	payment_type,
	payment_installments,
	payment_value
)
from 'C:\Users\jarni\Desktop\bootcamp\Projects\mp_ecommerce\order_payments_dataset.csv'
delimiter ','
csv header;

create table public.order_reviews (
	review_id varchar(50),
	order_id varchar(50),
	review_score integer,
	review_comment_title text,
	review_comment_message text,
	review_creation_date timestamp,
	review_answer_timestamp timestamp
);
copy order_reviews (
	review_id,
	order_id,
	review_score,
	review_comment_title,
	review_comment_message,
	review_creation_date,
	review_answer_timestamp
)
from 'C:\Users\jarni\Desktop\bootcamp\Projects\mp_ecommerce\order_reviews_dataset.csv'
delimiter ','
csv header;

create table public.orders (
	order_id varchar(50),
	customer_id varchar(50),
	order_status varchar(50),
	order_purchase_timestamp timestamp,
	order_approved_at timestamp,
	order_delivered_carrier_date timestamp,
	order_delivered_customer_date timestamp,
	order_estimated_delivery_date timestamp,
	primary key (order_id)
);
copy orders (
	order_id,
	customer_id,
	order_status,
	order_purchase_timestamp,
	order_approved_at,
	order_delivered_carrier_date,
	order_delivered_customer_date,
	order_estimated_delivery_date
)
from 'C:\Users\jarni\Desktop\bootcamp\Projects\mp_ecommerce\orders_dataset.csv'
delimiter ','
csv header;

create table public.product (
	number_ varchar(50),
	product_id varchar(50),
	product_category_name varchar(50),
	product_name_lenght numeric,
	product_description_lenght numeric,
	product_photos_qty numeric,
	product_weight_g numeric,
	product_length_cm numeric,
	product_height_cm numeric,
	product_width_cm numeric,
	primary key (product_id)
);
copy product (
	number_,
	product_id,
	product_category_name,
	product_name_lenght,
	product_description_lenght,
	product_photos_qty,
	product_weight_g,
	product_length_cm,
	product_height_cm,
	product_width_cm
)
from 'C:\Users\jarni\Desktop\bootcamp\Projects\mp_ecommerce\product_dataset.csv'
delimiter ','
csv header;

create table public.sellers (
	seller_id varchar(50),
	seller_zip_code_prefix integer,
	seller_city varchar(50),
	seller_state varchar(50),
	primary key (seller_id)
);
copy sellers (
	seller_id,
	seller_zip_code_prefix,
	seller_city,
	seller_state
)
from 'C:\Users\jarni\Desktop\bootcamp\Projects\mp_ecommerce\sellers_dataset.csv'
delimiter ','
csv header;



alter table orders 
add constraint fk_customer_id foreign key (customer_id) references customer (customer_id)

alter table order_reviews
add constraint fk_review_order foreign key (order_id) references orders (order_id)

alter table order_payments
add constraint fk_payment_order foreign key (order_id) references orders (order_id)

alter table order_items
add constraint fk_item_order foreign key (order_id) references orders (order_id),
add constraint fk_item_product foreign key (product_id) references product (product_id),
add constraint fk_item_seller foreign key (seller_id) references sellers (seller_id)

alter table product
drop column number_