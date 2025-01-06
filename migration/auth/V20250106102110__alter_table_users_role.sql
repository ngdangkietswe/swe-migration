alter table sweauth.users_role
    drop constraint users_role_pkey,
    add primary key (id),
    add unique (user_id, role_id);