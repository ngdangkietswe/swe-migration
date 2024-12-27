alter table "SweAuth".sweauth.permission
    add unique (action_id, resource_id);