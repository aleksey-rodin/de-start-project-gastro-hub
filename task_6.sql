-- начинаем транзакцию
begin;

-- блокируем записи соответсвующие условию, и которые будем обновлять
select *
from cafe.restaurants
where "restaurant_type" = 'coffee_shop'
  and menu -> 'Кофе' ? 'Капучино'
for update
;

-- увеличиваем цену на капучино на 20%
update cafe.restaurants
set menu = jsonb_set(menu, '{Кофе, Капучино}', to_jsonb((menu -> 'Кофе' ->> 'Капучино')::numeric * 1.2), true)
where "restaurant_type" = 'coffee_shop'
  and menu -> 'Кофе' ? 'Капучино'
;

-- фиксируем изменения/снимаем блокировку
commit;