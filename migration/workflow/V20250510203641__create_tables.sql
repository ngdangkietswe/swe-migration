create table if not exists cdc_auth_users
(
    id       uuid         not null,
    username varchar(255) not null,
    email    varchar(255) not null,
    primary key (id)
);

create table if not exists workflow
(
    id         uuid         not null default gen_random_uuid(),
    name       varchar(255) not null,
    code       varchar(255) not null,
    module     int          not null,
    is_default bool         not null default false,
    created_at timestamptz  not null default now(),
    updated_at timestamptz  not null default now(),
    is_deleted boolean      not null default false,
    created_by uuid,
    updated_by uuid,
    deleted_by uuid,
    primary key (id),
    constraint fk_workflow_created_by
        foreign key (created_by) references cdc_auth_users (id),
    constraint fk_workflow_updated_by
        foreign key (updated_by) references cdc_auth_users (id),
    constraint fk_workflow_deleted_by
        foreign key (deleted_by) references cdc_auth_users (id),
    constraint uq_workflow_name_module
        unique (name, module)
);

create table if not exists state
(
    id          uuid         not null default gen_random_uuid(),
    workflow_id uuid         not null,
    name        varchar(255) not null,
    code        varchar(255) not null,
    hex_color   varchar(7),
    is_initial  bool         not null default false,
    is_final    bool         not null default false,
    order_no    int,
    created_at  timestamptz  not null default now(),
    updated_at  timestamptz  not null default now(),
    is_deleted  boolean      not null default false,
    created_by  uuid,
    updated_by  uuid,
    deleted_by  uuid,
    primary key (id),
    constraint fk_state_workflow_id
        foreign key (workflow_id) references workflow (id),
    constraint fk_state_created_by
        foreign key (created_by) references cdc_auth_users (id),
    constraint fk_state_updated_by
        foreign key (updated_by) references cdc_auth_users (id),
    constraint fk_state_deleted_by
        foreign key (deleted_by) references cdc_auth_users (id),
    constraint uq_state_workflow_id_name
        unique (workflow_id, name),
    constraint uq_state_workflow_id_code
        unique (workflow_id, code),
    constraint uq_state_workflow_id_order_no
        unique (workflow_id, order_no),
    constraint uq_state_workflow_id_hex_color
        unique (workflow_id, hex_color)
);

create table if not exists transition
(
    id              uuid         not null default gen_random_uuid(),
    workflow_id     uuid         not null,
    name            varchar(255) not null,
    code            varchar(255) not null,
    source_state_id uuid         not null,
    target_state_id uuid         not null,
    condition_expr  text,
    created_at      timestamptz  not null default now(),
    updated_at      timestamptz  not null default now(),
    is_deleted      boolean      not null default false,
    created_by      uuid,
    updated_by      uuid,
    deleted_by      uuid,
    primary key (id),
    constraint fk_transition_workflow_id
        foreign key (workflow_id) references workflow (id),
    constraint fk_transition_source_state_id
        foreign key (source_state_id) references state (id),
    constraint fk_transition_target_state_id
        foreign key (target_state_id) references state (id),
    constraint fk_transition_created_by
        foreign key (created_by) references cdc_auth_users (id),
    constraint fk_transition_updated_by
        foreign key (updated_by) references cdc_auth_users (id),
    constraint fk_transition_deleted_by
        foreign key (deleted_by) references cdc_auth_users (id),
    constraint uq_transition_workflow_id_name
        unique (workflow_id, name),
    constraint uq_transition_workflow_id_code
        unique (workflow_id, code),
    constraint uq_transition_source_state_id_target_state_id
        unique (source_state_id, target_state_id)
);

create table if not exists instance
(
    id               uuid        not null default gen_random_uuid(),
    workflow_id      uuid        not null,
    module           int         not null,
    entity_id        uuid        not null,
    current_state_id uuid        not null,
    created_at       timestamptz not null default now(),
    updated_at       timestamptz not null default now(),
    is_deleted       boolean     not null default false,
    created_by       uuid,
    updated_by       uuid,
    deleted_by       uuid,
    primary key (id),
    constraint fk_instance_workflow_id
        foreign key (workflow_id) references workflow (id),
    constraint fk_instance_current_state_id
        foreign key (current_state_id) references state (id),
    constraint fk_instance_created_by
        foreign key (created_by) references cdc_auth_users (id),
    constraint fk_instance_updated_by
        foreign key (updated_by) references cdc_auth_users (id),
    constraint fk_instance_deleted_by
        foreign key (deleted_by) references cdc_auth_users (id)
);

create table if not exists instance_log
(
    id            uuid        not null default gen_random_uuid(),
    instance_id   uuid        not null,
    transition_id uuid        not null,
    performed_by  uuid        not null,
    performed_at  timestamptz not null default now(),
    comment       text,
    created_at    timestamptz not null default now(),
    updated_at    timestamptz not null default now(),
    is_deleted    boolean     not null default false,
    created_by    uuid,
    updated_by    uuid,
    deleted_by    uuid,
    primary key (id),
    constraint fk_instance_log_instance_id
        foreign key (instance_id) references instance (id),
    constraint fk_instance_log_transition_id
        foreign key (transition_id) references transition (id),
    constraint fk_instance_log_performed_by
        foreign key (performed_by) references cdc_auth_users (id),
    constraint fk_instance_log_created_by
        foreign key (created_by) references cdc_auth_users (id),
    constraint fk_instance_log_updated_by
        foreign key (updated_by) references cdc_auth_users (id),
    constraint fk_instance_log_deleted_by
        foreign key (deleted_by) references cdc_auth_users (id)
);

create sequence if not exists workflow_code_seq
    start with 1
    increment by 1
    minvalue 1
    maxvalue 999999;

create sequence if not exists state_code_seq
    start with 1
    increment by 1
    minvalue 1
    maxvalue 999999;

create sequence if not exists transition_code_seq
    start with 1
    increment by 1
    minvalue 1
    maxvalue 999999;

-- function and trigger to set workflow code
create or replace function get_next_workflow_code(p_module int)
    returns varchar(255) as
$$
begin
    return 'WF' || lpad(p_module::text, 3, '0') || lpad(nextval('workflow_code_seq')::text, 6, '0');
end;
$$ language plpgsql;

create or replace function set_workflow_code()
    returns trigger as
$$
begin
    new.code := get_next_workflow_code(new.module);
    return new;
end;
$$ language plpgsql;

create trigger set_workflow_code_trigger
    before insert
    on workflow
    for each row
execute function set_workflow_code();

-- function and trigger to set state code
create or replace function get_next_state_code(p_workflow uuid)
    returns varchar(255) as
$$
begin
    return 'ST' || lpad(p_workflow::text, 36, '0') || lpad(nextval('state_code_seq')::text, 6, '0');
end;
$$ language plpgsql;

create or replace function set_state_code()
    returns trigger as
$$
begin
    new.code := get_next_state_code(new.workflow_id);
    return new;
end;
$$ language plpgsql;

create trigger set_state_code_trigger
    before insert
    on state
    for each row
execute function set_state_code();

-- function and trigger to set transition code
create or replace function get_next_transition_code(p_workflow uuid)
    returns varchar(255) as
$$
begin
    return 'TR' || lpad(p_workflow::text, 36, '0') || lpad(nextval('transition_code_seq')::text, 6, '0');
end;
$$ language plpgsql;

create or replace function set_transition_code()
    returns trigger as
$$
begin
    new.code := get_next_transition_code(new.workflow_id);
    return new;
end;
$$ language plpgsql;

create trigger set_transition_code_trigger
    before insert
    on transition
    for each row
execute function set_transition_code();
