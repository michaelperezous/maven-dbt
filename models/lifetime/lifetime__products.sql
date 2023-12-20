with product_sales as (
    select
        product_id,
        count(sale_id) as num_sales,
        sum(units::int) as total_units,
        avg(units::int) as avg_units_per_sale
    from
        dbt.sales
    group by
        product_id
)
select
    product_sales.product_id as id,
    products.product_name as name,
    products.product_category as category,
    product_sales.num_sales,
    product_sales.total_units,
    product_sales.avg_units_per_sale,
    product_sales.total_units * products.product_price as total_revenue,
    product_sales.total_units * (products.product_price - products.product_cost) as total_profit,
    product_sales.avg_units_per_sale * products.product_price as avg_revenue_per_sale,
    product_sales.avg_units_per_sale * (products.product_price - products.product_cost) as avg_profit_per_sale
from
    product_sales
inner join
    dbt.products on product_sales.product_id = products.product_id