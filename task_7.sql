-- начинаем транзакцию
begin;
-- блокируем таблицу cafe.managers в режиме exclusive для запрета другим транзакциям редактировать данные в таблице
lock table cafe.managers in exclusive mode;

-- добавляем новое поле manager_phones (массив текстовых значений)
alter table cafe.managers add manager_phones text[];

-- в cte phones формируем новый номер телефона
-- в update обновляем значения в новом поле manager_phones на набор [новый номер, старый номер]
with phones as (
  select manager_uuid, manager_name, manager_phone, concat('8-800-2500-', (row_number() over(order by manager_name) + 100)::text) as manager_new_phone
  from cafe.managers
)
update cafe.managers as trg
set manager_phones = array[src.manager_new_phone, src.manager_phone]
from phones src
where trg.manager_uuid = src.manager_uuid;

-- удаляем поле со старым номером из таблицы cafe.managers
alter table cafe.managers drop column manager_phone;

-- фиксируем изменнеия/снимаем блокировку
commit;