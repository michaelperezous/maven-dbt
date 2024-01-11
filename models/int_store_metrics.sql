{{config(
    materialize = 'view'
)}}
with store_metrics as (
    select
        ssp.store_id,
        sum(ssp.num_sales) as total_store_sales,
        sum(ssp.total_units * products.Product_Price) as total_store_revenue,
        sum(ssp.total_units * (products.Product_Price - products.Product_Cost)) as total_store_profit,
        sum(ssp.total_units * products.Product_Price) / sum(ssp.total_units) as avg_store_revenue_per_unit_sold,
        sum(ssp.total_units * (products.Product_Price - products.Product_Cost)) / sum(ssp.total_units) as avg_store_profit_per_unit_sold
    from
        {{ref('stg_store_sales__by_product')}} ssp
    left join
        {{source('postgres', 'toy_products')}} products on ssp.product_id = products.Product_ID
    group by
        store_id
)
select * from store_metrics