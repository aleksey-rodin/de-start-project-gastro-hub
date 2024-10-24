with pizzeria_rest as (
  select
      restaurant_name,
      (jsonb_each(menu -> 'Пицца')).key as menu
  from cafe.restaurants
  where restaurant_type = 'pizzeria'
),
pzz_cnt as (
  select
      restaurant_name,
      count(menu) as pizza_count
  from pizzeria_rest
  group by restaurant_name
),
top_test as (
  select
      restaurant_name,
      pizza_count,
      dense_rank() over(order by pizza_count desc) as dr
  from pzz_cnt
)
select
    restaurant_name,
    pizza_count
from top_test
where dr <= 3
;