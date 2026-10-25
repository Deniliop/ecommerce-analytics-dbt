with raw_products as(
    select * from {{source('thelook_ecommerce', 'products')}}
)

select
    id as product_id,
    cost,
    category,
    name as product_name,
    brand,
    retail_price,
    department,
    sku,
    distribution_center_id
from raw_products