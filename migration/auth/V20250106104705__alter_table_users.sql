alter table sweauth.users
    add unique (username),
    add unique (email);

insert into sweauth.users_role (id, user_id, role_id)
values (gen_random_uuid(),
        (select id from sweauth.users where username = 'sweadmin'),
        (select id from sweauth.role where name = 'Admin'));