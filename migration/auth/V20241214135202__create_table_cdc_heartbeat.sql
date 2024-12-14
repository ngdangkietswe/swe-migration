create table if not exists cdc_heartbeat
(
    id           bigserial    not null,
    connector    varchar(256) not null,
    created_date timestamp    not null default current_timestamp,
    constraint cdc_heartbeat_connector_key unique (connector),
    constraint cdc_heartbeat_pkey primary key (id)
);