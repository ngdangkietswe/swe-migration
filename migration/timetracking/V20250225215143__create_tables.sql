set search_path to swetimetracking;

-- Create the table for the users
create table if not exists cdc_auth_users
(
    id       uuid         not null,
    username varchar(255) not null,
    email    varchar(255) not null,
    primary key (id)
);

-- Create the table for the time tracking
create table if not exists time_tracking
(
    id             uuid      not null default gen_random_uuid(),
    user_id        uuid      not null,
    date           date      not null,
    check_in_time  timestamp with time zone,
    check_out_time timestamp with time zone,
    status         integer   not null default 1,
    is_overtime    boolean   not null default false,
    overtime_hours double precision,
    created_at     timestamp not null default current_timestamp,
    updated_at     timestamp not null default current_timestamp,
    is_deleted     boolean   not null default false,
    created_by     uuid      not null,
    updated_by     uuid      not null,
    deleted_by     uuid,
    primary key (id),
    constraint valid_timed check (check_in_time < check_out_time),
    constraint valid_status check (status in (0, 1, 2, 3, 4, 5)), -- 0: UNSPECIFIED, 1: NOT_CHECKED_IN, 2: CHECKED_IN, 3: CHECKED_IN_LATE, 4: CHECKED_OUT, 5: CHECKED_OUT_EARLY, 6: CHECKED_OUT
    constraint fk_time_tracking_user_id
        foreign key (user_id) references cdc_auth_users (id),
    constraint fk_time_tracking_created_by
        foreign key (created_by) references cdc_auth_users (id),
    constraint fk_time_tracking_updated_by
        foreign key (updated_by) references cdc_auth_users (id),
    constraint fk_time_tracking_deleted_by
        foreign key (deleted_by) references cdc_auth_users (id),
    unique (user_id, date)
);

-- Create the index for the time tracking
create index idx_time_tracking_user_date on time_tracking (user_id, date);

-- Create the trigger for the time tracking status
create or replace function update_time_tracking_status()
    returns trigger as
$$
begin
    if new.check_in_time is null then
        new.status := 1; -- NOT_CHECKED_IN
    elsif new.check_out_time is null then
        if extract(hour from new.check_in_time) > 9 and extract(minute from new.check_in_time) > 0 then
            new.status := 3; -- CHECKED_IN_LATE
        else
            new.status := 2; -- CHECKED_IN
        end if;
    else
        if extract(hour from new.check_out_time) < 14 and extract(minute from new.check_out_time) < 0 then
            new.status := 5; -- CHECKED_OUT_EARLY
        else
            new.status := 4; -- CHECKED_OUT
        end if;
    end if;
    return new;
end;
$$ language plpgsql;

-- Create the trigger for the time tracking status before insert or update
create trigger update_time_tracking_status
    before insert or update
    on time_tracking
    for each row
execute function update_time_tracking_status();