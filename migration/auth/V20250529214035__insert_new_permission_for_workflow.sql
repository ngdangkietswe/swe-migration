create or replace procedure insert_new_permission_for_workflow()
    language plpgsql
as
$$
declare
    v_rs_workflow_id uuid;
begin
    insert into resource (id, name, description)
    values (gen_random_uuid(), 'Workflow', 'Workflow resource.')
    returning id into v_rs_workflow_id;

    insert into permission (id, action_id, resource_id, description)
    values (gen_random_uuid(), (select id from action where name = 'READ'), v_rs_workflow_id,
            'Read workflow permission.'),
           (gen_random_uuid(), (select id from action where name = 'CREATE'), v_rs_workflow_id,
            'Create workflow permission.'),
           (gen_random_uuid(), (select id from action where name = 'UPDATE'), v_rs_workflow_id,
            'Update workflow permission.'),
           (gen_random_uuid(), (select id from action where name = 'DELETE'), v_rs_workflow_id,
            'Delete workflow permission.');
end;
$$;
call insert_new_permission_for_workflow();
drop procedure if exists insert_new_permission_for_workflow();