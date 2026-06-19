 -- # anything written inside the ' ' will be case sensitive
  create database hotel_db;
create or replace file format ff_csv
    type = 'csv' 
-- # anything written inside the ' ' will be case sensitive
    field_optionally_enclosed_by = '"'
    skip_header =1
-- so we dont want headers beacuse we create it the columns
    null_if = ('NULL','null','')
-- above 3 mentioned if any values presnt in the column chnage to null 


create or replace stage stg_hotel_bookings
     file_format = ff_csv;

create table bronze_hotel_booking (
     booking_id STRING,
     hotel_id STRING,
     hotel_city STRING,
     customer_id STRING,
     customer_name STRING,
     customer_email STRING,
     check_in_date STRING,
     check_out_date STRING,
     room_type STRING,
     num_guests STRING,
     total_amount STRING,
     currency STRING,
     booking_status STRING
);

copy into bronze_hotel_booking
from @stg_hotel_bookings
file_format = (format_name = ff_csv)
on_error = 'continue';

select * from bronze_hotel_booking limit 50;

create table silver_hotel_booking(
     booking_id VARCHAR,
     hotel_id VARCHAR,
     hotel_city VARCHAR,
     customer_id VARCHAR,
     customer_name VARCHAR,
     customer_email VARCHAR,
     check_in_date DATE,
     check_out_date DATE,
     room_type VARCHAR,
     num_guests INTEGER,
     total_amount FLOAT,
     currency VARCHAR,
     booking_status VARCHAR
);


SELECT CUSTOMER_EMAIL 
FROM bronze_hotel_booking
WHERE not (CUSTOMER_EMAIL like '%@%.%')
    or CUSTOMER_EMAIL is NULL;

SELECT total_amount
from bronze_hotel_booking
where try_to_number(total_amount)<0;


select  check_in_date , check_out_date
from bronze_hotel_booking
where try_to_date(check_out_date) < try_to_date(check_in_date)

select distinct booking_status
from bronze_hotel_booking;

insert into silver_hotel_booking
select  
   booking_id,
   hotel_id,
   INITCAP(TRIM(hotel_city)) as hotel_city,
   customer_id,
   initcap(trim(customer_name)) as customer_name,
   case 
       when customer_email like '%@%.%' then lower(trim(customer_email))
       else null
   end as customer_email,
   try_to_date(nullif(check_in_date,'')) as check_in_date,
   try_to_date(nullif(check_out_date,'')) as check_out_date,
   room_type, 
   num_guests,
   abs(try_to_number(total_amount)) as total_amount,
   currency,
   case
      when lower(booking_status) in ('confirmeeed','confirmd') then 'Confirmed'
        else booking_status
   end as booking_status
   from bronze_hotel_booking
   where 
      try_to_date(check_in_date) is not null
      and try_to_date(check_out_date) is not null
      and try_to_date(check_out_date) >= try_to_date(check_in_date);    


select * from silver_hotel_booking limit 30;


create table gold_agg_daily_booking as
select 
     check_in_date as date,
     count(*) as total_booking,
     sum(total_amount) as total_revenue
from silver_hotel_booking
group by check_in_date
order by date;

create table gold_agg_hotel_city_sales as
select 
    hotel_city,
    sum(total_amount) as total_revenue
from silver_hotel_booking
group by hotel_city
order by total_revenue desc;

create table gold_booking_clean as 
select
     booking_id,
     hotel_id,
     hotel_city,
     customer_id,
     customer_name,
     customer_email,
     check_in_date,
     check_out_date,
     room_type,
     num_guests,
     total_amount,
     currency,
     booking_status
from silver_hotel_booking;
    

select * from gold_agg_daily_booking limit 30;

select * from gold_agg_hotel_city_sales limit 30;