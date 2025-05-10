set search_path to swetimetracking;

alter table time_tracking
    add column latitude  double precision,
    add column longitude double precision,
    add column location  text;