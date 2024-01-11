{{config(
    materialize = 'view'
)}}
with top_products_by_store as (
    select
        ssp.store_id,
        max_by(p.Product_Name, ssp.total_units * p.Product_Price) as top_product_by_revenue,
        max(ssp.total_units * p.Product_Price) as top_product_total_revenue,
        max_by(p.Product_Name, ssp.total_units * (p.product_price - p.Product_Cost)) as top_product_by_profit,
        max(ssp.total_units * (p.Product_Price - p.Product_Cost)) as top_product_total_profit
    from
        {{ref('stg_store_sales__by_product')}} ssp
    inner join
        {{source('postgres', 'toy_products')}} p on ssp.product_id = p.Product_ID
    group by
        store_id
)
select * from top_products_by_store