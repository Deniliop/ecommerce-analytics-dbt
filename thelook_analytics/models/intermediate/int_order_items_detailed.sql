with order_items as (
    
    select * from {{ref('stg_orders_items')}}
),

products as(
    select * from {{ref('stg_products')}}
),

joined as(
    select
        oi.order_item_id,
        oi.order_id,
        oi.user_id,
        oi.product_id,
        oi.status,
        oi.created_at,
        oi.shipped_at,
        oi.delivered_at,
        oi.returned_at,
        oi.sale_price,
        p.cost as product_cost,
        p.retail_price as product_retail_price,
        p.category as product_category,
        p.brand as product_brand,
        round(oi.sale_price - p.cost, 2) as margin,
    from order_items oi
    left join products p
        on oi.product_id = p.product_id
)
select * from joined