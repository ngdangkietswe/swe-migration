alter table sweauth.users
    add column is_deleted boolean not null default false,
    add column created_by uuid,
    add column updated_by uuid,
    add column deleted_by uuid;

create table if not exists role
(
    id          uuid         not null default gen_random_uuid(),
    name        varchar(255) not null,
    description text,
    is_default  boolean      not null default false,
    created_at  timestamp    not null default current_timestamp,
    updated_at  timestamp    not null default current_timestamp,
    is_deleted  boolean      not null default false,
    created_by  uuid,
    updated_by  uuid,
    deleted_by  uuid,
    primary key (id),
    constraint fk_role_created_by
        foreign key (created_by) references sweauth.users (id),
    constraint fk_role_updated_by
        foreign key (updated_by) references sweauth.users (id),
    unique (name)
);

insert into role (id, name, description, is_default)
values (gen_random_uuid(), 'Admin', 'Admin role.', true),
       (gen_random_uuid(), 'User', 'User role.', true);

create table if not exists users_role
(
    id      uuid not null default gen_random_uuid(),
    user_id uuid not null,
    role_id uuid not null,
    primary key (user_id, role_id),
    constraint fk_user_role_user_id
        foreign key (user_id) references sweauth.users (id),
    constraint fk_user_role_role_id
        foreign key (role_id) references sweauth.role (id),
    unique (user_id, role_id)
);
