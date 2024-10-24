with pizza_menu as (
  select
      restaurant_name,
      jsonb_object_keys(menu) as type,
      menu
  from cafe.restaurants
  where restaurant_type = 'pizzeria'
),
pizza_list as (
  select
      restaurant_name,
      type,
      (jsonb_each(menu -> type)).key as pizza_name,
      (jsonb_each(menu -> type)).value::int as pizza_cost
  from pizza_menu
  where type = 'Пицца'
),
cost_rank as (
  select
      restaurant_name,
      type,
      pizza_name,
      pizza_cost,
      row_number() over(partition by restaurant_name order by pizza_cost desc) as rn
  from pizza_list
)
select
    restaurant_name,
    type,
    pizza_name,
    pizza_cost
from cost_rank
where rn = 1
;