with store_sales_by_product as (
    select
        store_id,
        product_id,
        count(sale_id) as num_sales,
        sum(units::int) as total_units
    from
        dbt.sales
    group by
        store_id,
        product_id
),
top_products_by_store_by_revenue as (
    select
        distinct on (ssp.store_id)
        ssp.store_id,
        products.product_name,
        ssp.total_units * products.product_price as revenue
    from
        store_sales_by_product ssp
    inner join
        dbt.products on ssp.product_id = products.product_id
    order by
        ssp.store_id,
        revenue desc
),
top_products_by_store_by_profit as (
    select
        distinct on (ssp.store_id)
        ssp.store_id,
        products.product_name,
        ssp.total_units * (products.product_price - products.product_cost) as profit
    from
        store_sales_by_product ssp
    inner join
        dbt.products on ssp.product_id = products.product_id
    order by
        ssp.store_id,
        profit desc
),
store_metrics as (
    select
        ssp.store_id,
        sum(ssp.num_sales) as total_store_sales,
        sum(ssp.total_units * products.product_price) as total_store_revenue,
        sum(ssp.total_units * (products.product_price - products.product_cost)) as total_store_profit,
        sum(ssp.total_units * products.product_price) / sum(ssp.total_units) as avg_store_revenue_per_unit_sold,
        sum(ssp.total_units * (products.product_price - products.product_cost)) / sum(ssp.total_units) as avg_store_profit_per_unit_sold
    from
        store_sales_by_product ssp
    left join
        dbt.products on ssp.store_id = products.product_id
    group by
        store_id
)
select
    sm.store_id,
    stores.store_name,
    stores.store_city,
    stores.store_location,
    stores.store_open_date,
    stores.latitude,
    stores.longitude,
    sm.total_store_sales,
    sm.total_store_revenue,
    sm.total_store_profit,
    sm.avg_store_revenue_per_unit_sold,
    sm.avg_store_profit_per_unit_sold,
    tpr.product_name as top_product_by_revenue,
    tpr.revenue as top_product_total_revenue,
    tpr.revenue / sm.total_store_revenue as top_product_revenue_share,
    tpp.product_name as top_product_by_profit,
    tpp.profit as top_product_total_profit,
    tpp.profit / sm.total_store_profit as top_product_profit_share
from
    store_metrics sm
inner join
    dbt.stores on sm.store_id = stores.store_id
left join
    top_products_by_store_by_revenue tpr on tpr.store_id = sm.store_id
left join
    top_products_by_store_by_profit tpp on tpp.store_id = sm.store_id