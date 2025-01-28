create table if not exists strava_account
(
    id            uuid         not null default gen_random_uuid(),
    user_id       uuid         not null,
    athlete_id    bigint       not null,
    access_token  varchar(255) not null,
    refresh_token varchar(255) not null,
    expires_at    timestamp    not null,
    created_at    timestamp    not null default now(),
    updated_at    timestamp    not null default now(),
    primary key (id),
    foreign key (user_id) references cdc_auth_users (id)
);