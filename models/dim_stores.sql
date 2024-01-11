{{config(
    materialize = 'view'
)}}
with store_sales_by_product as (select * from {{ref('stg_store_sales__by_product')}}),
top_products_by_store as (select * from {{ref('int_product_sales__by_store')}}),
store_metrics as (select * from {{ref('int_store_metrics')}})
select
    sm.store_id,
    stores.Store_Name as store_name,
    stores.Store_City as store_city,
    stores.Store_Location as store_location,
    stores.Store_Open_Date as store_open_date,
    stores.Latitude as store_latitude,
    stores.Longitude as store_longitude,
    sm.total_store_sales,
    sm.total_store_revenue,
    sm.total_store_profit,
    sm.avg_store_revenue_per_unit_sold,
    sm.avg_store_profit_per_unit_sold,
    tps.top_product_by_revenue,
    tps.top_product_total_revenue,
    tps.top_product_total_revenue / sm.total_store_revenue as top_product_revenue_share,
    tps.top_product_by_profit,
    tps.top_product_total_profit,
    tps.top_product_total_profit / sm.total_store_profit as top_product_profit_share
from
    store_metrics sm
inner join
    {{source('postgres', 'toy_stores')}} stores on sm.store_id = stores.store_id
left join
    top_products_by_store tps on tps.store_id = sm.store_id
