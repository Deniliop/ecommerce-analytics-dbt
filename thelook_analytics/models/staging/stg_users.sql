with raw_users as(
    select * from {{source('thelook_ecommerce', 'users')}}
)

select 
    id as user_id,
    first_name,
    last_name,
    email,
    gender,
    age,
    state,
    street_address,
    city,
    postal_code,
    country,
    latitude,
    longitude,
    traffic_source,
    created_at
from raw_users