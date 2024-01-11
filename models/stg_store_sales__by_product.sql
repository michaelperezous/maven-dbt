{{config(
    materialize = 'view'
)}}
with store_sales_by_product as (
    select
        Store_ID as store_id,
        Product_ID as product_id,
        count(Sale_ID) as num_sales,
        sum(cast(Units as int)) as total_units
    from
        {{source('snowflake', 'TOY_SALES')}}
    group by
        store_id,
        product_id
)
select * from store_sales_by_product