insert into cafe.restaurants (restaurant_name, restaurant_type, menu)
select distinct
    m.cafe_name as restaurant_name,
    cast(s.type as cafe.restaurant_type) as restaurant_type,
    m.menu as menu
from raw_data.menu as m
inner join raw_data.sales as s
  using (cafe_name)
;

insert into cafe.managers (manager_name, manager_phone)
select distinct
    s.manager as manager_name,
    s.manager_phone as manager_phone
from raw_data.sales as s
;

insert into cafe.restaurant_manager_work_dates (restaurant_uuid, manager_uuid, work_start_date, work_end_date)
select r.restaurant_uuid as restaurant_uuid,
    m.manager_uuid as manager_uuid,
    min(s.report_date) as work_start_date,
    max(s.report_date) as work_end_date
from raw_data.sales as s
inner join cafe.restaurants as r
  on s.cafe_name = r.restaurant_name
inner join cafe.managers as m
  on s.manager = m.manager_name
group by r.restaurant_uuid, m.manager_uuid
;

insert into cafe.sales (date, restaurant_uuid, avg_check)
select s.report_date as date,
    r.restaurant_uuid as restaurant_uuid,
    s.avg_check as avg_check
from raw_data.sales as s
join cafe.restaurants as r
  on s.cafe_name = r.restaurant_name
;