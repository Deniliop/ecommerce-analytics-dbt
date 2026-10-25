with orders as (
    select * from {{ref('stg_orders')}}
),

order_items as (
    select * from {{ref('int_order_items_detailed')}}
),

order_metrics as ( 
    select
        order_id,
        round(sum(sale_price),2)as order_revenue,
        round(sum(product_cost),2) as order_cost,
        round(sum(margin),2) as order_margin,
        count(order_item_id) as total_items
        from order_items
    group by 1
),

final as (
    select
        o.order_id,
        o.user_id,
        o.status as order_status,
        o.gender as user_gender,
        o.created_at as order_created_at,
        o.returned_at as order_returned_at,
        o.shipped_at as order_shipped_at,
        o.delivered_at as order_delivered_at,
        coalesce(m.order_revenue, 0) as order_revenue,
        coalesce(m.order_cost, 0) as order_cost,
        coalesce(m.order_margin, 0) as order_margin,
        coalesce(m.total_items, 0) as total_items
    from orders o
    left join order_metrics m
        on o.order_id = m.order_id

)

select * from final