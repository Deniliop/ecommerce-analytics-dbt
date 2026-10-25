with users as(
    select * from {{ref('stg_users')}}
), 

orders as(
    select * from {{ref('stg_orders')}}
),

fct_orders as(
    select * from {{ref('fct_orders')}}
),

user_order_stats as(
    select
        o.user_id,
        min(o.created_at) as first_order_date,
        max(o.created_at) as most_recent_order_date,
        count(distinct o.order_id) as lifetime_orders,
        round(coalesce(sum(fo.order_revenue),0),2) as lifetime_revenue
    from orders o
    left join fct_orders fo
    on o.order_id = fo.order_id
    group by 1
),

final as(
    select
        u.user_id,
        u.first_name,
        u.last_name,
        u.email,
        u.gender,
        u.age,
        u.state,
        u.city,
        u.country,
        u.traffic_source,
        u.created_at as account_created_at,
        coalesce(uos.lifetime_orders, 0) as lifetime_orders,
        coalesce(uos.lifetime_revenue, 0) as lifetime_revenue,
        uos.first_order_date,
        uos.most_recent_order_date
    from users u
    left join user_order_stats uos 
    on u.user_id = uos.user_id
)

select * from final