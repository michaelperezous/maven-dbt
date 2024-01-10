{{config(
    catalog = 'hive',
    schema = 'preview_trino',
    materialize = 'view'
)}}
with
  product_sales as (
    select
      Product_ID as product_id,
      count(Sale_ID) as num_sales,
      sum(cast(Units as int)) as total_units,
      avg(cast(Units as int)) as avg_units_per_sale
    from
      Snowflake.CUSTOMER_DEMO.TOY_SALES
    group by
      product_id
  )
select
  product_sales.product_id as id,
  products.Product_Name as name,
  products.Product_Category as category,
  product_sales.num_sales,
  product_sales.total_units,
  product_sales.avg_units_per_sale,
  product_sales.total_units * products.Product_Price as total_revenue,
  product_sales.total_units * (products.Product_Price - products.Product_Cost) as total_profit,
  product_sales.avg_units_per_sale * products.Product_Price as avg_revenue_per_sale,
  product_sales.avg_units_per_sale * (products.Product_Price - products.Product_Cost) as avg_profit_per_sale
from
  product_sales
  inner join postgresql.customer_demo.toy_products products on product_sales.product_id = products.Product_ID