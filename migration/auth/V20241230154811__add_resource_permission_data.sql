do
$$
    declare
        rs_permission_id uuid;
    begin
        insert into resource (id, name, description)
        values (gen_random_uuid(), 'Permission', 'Permission resource.')
        returning id into rs_permission_id;

        insert into permission (id, action_id, resource_id, description)
        values (gen_random_uuid(), (select id from action where name = 'READ'), rs_permission_id, 'Read permission.');

        insert into permission (id, action_id, resource_id, description)
        values (gen_random_uuid(), (select id from action where name = 'CREATE'), rs_permission_id,
                'Create permission.');

        insert into permission (id, action_id, resource_id, description)
        values (gen_random_uuid(), (select id from action where name = 'UPDATE'), rs_permission_id,
                'Update permission.');

        insert into permission (id, action_id, resource_id, description)
        values (gen_random_uuid(), (select id from action where name = 'DELETE'), rs_permission_id,
                'Delete permission.');
    end;
$$