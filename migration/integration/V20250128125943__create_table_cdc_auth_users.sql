create table if not exists cdc_auth_users
(
    id       uuid         not null,
    username varchar(255) not null,
    email    varchar(255) not null,
    primary key (id)
)