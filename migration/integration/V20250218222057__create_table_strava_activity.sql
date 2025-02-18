create table if not exists strava_activity
(
    id                   uuid             not null default gen_random_uuid(),
    strava_activity_id   bigint           not null,
    athlete_id           bigint           not null,
    user_id              uuid             not null,
    activity_name        varchar(255)     not null,
    activity_type        int              not null,
    activity_url         varchar(255)     not null,
    start_date           timestamp        not null,
    distance             double precision not null,
    moving_time          int              not null,
    elapsed_time         int              not null,
    total_elevation_gain int              not null,
    average_speed        double precision not null,
    max_speed            double precision not null,
    created_at           timestamp        not null default now(),
    primary key (id),
    foreign key (user_id) references cdc_auth_users (id)
)