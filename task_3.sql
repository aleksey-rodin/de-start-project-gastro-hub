with top_restaurant as (
  select
      rm.restaurant_uuid,
      count(distinct rm.manager_uuid) as count_manager
  from cafe.restaurant_manager_work_dates as rm
  group by rm.restaurant_uuid
)
select
    r.restaurant_name,
    t.count_manager
from top_restaurant as t
inner join cafe.restaurants as r
  using (restaurant_uuid)
order by t.count_manager desc
limit 3
;