create table if not exists users
(
    id         uuid         not null default gen_random_uuid(),
    username   varchar(255) not null,
    password   varchar(255) not null,
    email      varchar(255) not null,
    enable_2fa boolean      not null default false,
    secret_2fa varchar(255),
    created_at timestamp    not null default now(),
    updated_at timestamp    not null default now(),
    primary key (id)
);