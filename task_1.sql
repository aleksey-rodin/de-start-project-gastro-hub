create view cafe.v_top_3_restaurant as
with all_period_avg_check as (
  select
      s.restaurant_uuid,
      avg(s.avg_check) as avg_check_all_period
  from cafe.sales as s
  group by s.restaurant_uuid
),
top_restaurant as (
  select
      r.restaurant_name,
      r.restaurant_type,
      c.avg_check_all_period,
      row_number() over(partition by r.restaurant_type order by c.avg_check_all_period desc) as rn
  from all_period_avg_check as c
  inner join cafe.restaurants r
    using (restaurant_uuid)
)
select
    restaurant_name,
    restaurant_type,
    round(avg_check_all_period, 2) avg_check
from top_restaurant
where rn <= 3
;