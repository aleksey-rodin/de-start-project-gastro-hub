create materialized view cafe.mv_diff_avg_check_by_year as
with avg_check_by_years as (
  select
      extract(year from s.date) as year,
      s.restaurant_uuid,
      round(avg(s.avg_check), 2) as avg_check
  from cafe.sales as s
  where extract(year from s.date) <> 2024
  group by extract(year from s.date), s.restaurant_uuid
)
select
    c.year,
    r.restaurant_name,
    r.restaurant_type,
    c.avg_check as current_year_avg_check,
    lag(c.avg_check) over(partition by c.restaurant_uuid order by c.year asc) as prev_year_avg_check,
    round(((c.avg_check - lag(c.avg_check) over(partition by c.restaurant_uuid order by c.year asc)) / lag(c.avg_check) over(partition by c.restaurant_uuid order by c.year asc)) * 100, 2) as diff
from avg_check_by_years as c
inner join cafe.restaurants as r
  using (restaurant_uuid)
;