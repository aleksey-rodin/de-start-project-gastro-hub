create schema cafe;

create type cafe.restaurant_type as enum ('coffee_shop', 'restaurant', 'bar', 'pizzeria');

create table cafe.restaurants (
 restaurant_uuid uuid primary key default gen_random_uuid(),
 restaurant_name text not null,
 restaurant_type cafe.restaurant_type not null,
 menu jsonb not null
);

create table cafe.managers (
 manager_uuid uuid primary key default gen_random_uuid(),
 manager_name text not null,
 manager_phone text not null
);

create table cafe.restaurant_manager_work_dates (
 restaurant_uuid uuid references cafe.restaurants(restaurant_uuid),
 manager_uuid uuid references cafe.managers(manager_uuid),
 work_start_date date,
 work_end_date date,
 primary key (restaurant_uuid, manager_uuid)
);

create table cafe.sales (
 date date not null,
 restaurant_uuid uuid references cafe.restaurants(restaurant_uuid) not null,
 avg_check numeric not null,
 primary key (date, restaurant_uuid)
);