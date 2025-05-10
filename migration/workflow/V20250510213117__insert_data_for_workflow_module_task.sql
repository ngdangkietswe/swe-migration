create or replace procedure insert_data_for_workflow_module_task()
    language plpgsql
as
$$
declare
    module_task constant   int := 2;
    v_workflow_id          uuid;
    v_state_to_do_id       uuid;
    v_state_in_progress_id uuid;
    v_state_in_review_id   uuid;
    v_state_done_id        uuid;
    v_state_cancelled_id   uuid;
    v_state_rejected_id    uuid;
begin
    insert into workflow (name, code, module)
    values ('Workflow I for module task', get_next_workflow_code(module_task), module_task)
    on conflict (name, module) do nothing
    returning id into v_workflow_id;

    if v_workflow_id is not null then
        insert into state (workflow_id, name, code, hex_color, order_no, is_initial, is_final)
        values (v_workflow_id, 'To Do', get_next_state_code(v_workflow_id), '#FF5733', 1, true, false)
        returning id into v_state_to_do_id;
        insert into state (workflow_id, name, code, hex_color, order_no, is_initial, is_final)
        values (v_workflow_id, 'In Progress', get_next_state_code(v_workflow_id), '#FFC107', 2, false, false)
        returning id into v_state_in_progress_id;
        insert into state (workflow_id, name, code, hex_color, order_no, is_initial, is_final)
        values (v_workflow_id, 'In Review', get_next_state_code(v_workflow_id), '#17A2B8', 3, false, false)
        returning id into v_state_in_review_id;
        insert into state (workflow_id, name, code, hex_color, order_no, is_initial, is_final)
        values (v_workflow_id, 'Done', get_next_state_code(v_workflow_id), '#28A745', 4, false, true)
        returning id into v_state_done_id;
        insert into state (workflow_id, name, code, hex_color, order_no, is_initial, is_final)
        values (v_workflow_id, 'Cancelled', get_next_state_code(v_workflow_id), '#DC3545', 5, false, true)
        returning id into v_state_cancelled_id;
        insert into state (workflow_id, name, code, hex_color, order_no, is_initial, is_final)
        values (v_workflow_id, 'Rejected', get_next_state_code(v_workflow_id), '#6C757D', 6, false, false)
        returning id into v_state_rejected_id;

        insert into transition (workflow_id, name, code, source_state_id, target_state_id)
        values (v_workflow_id, 'Start task', get_next_transition_code(v_workflow_id), v_state_to_do_id,
                v_state_in_progress_id);
        insert into transition (workflow_id, name, code, source_state_id, target_state_id)
        values (v_workflow_id, 'Submit for review', get_next_transition_code(v_workflow_id), v_state_in_progress_id,
                v_state_in_review_id);
        insert into transition (workflow_id, name, code, source_state_id, target_state_id)
        values (v_workflow_id, 'Approve', get_next_transition_code(v_workflow_id), v_state_in_review_id,
                v_state_done_id);
        insert into transition (workflow_id, name, code, source_state_id, target_state_id)
        values (v_workflow_id, 'Reject', get_next_transition_code(v_workflow_id), v_state_in_review_id,
                v_state_rejected_id);
        insert into transition (workflow_id, name, code, source_state_id, target_state_id)
        values (v_workflow_id, 'Cancel from to do', get_next_transition_code(v_workflow_id), v_state_to_do_id,
                v_state_cancelled_id);
        insert into transition (workflow_id, name, code, source_state_id, target_state_id)
        values (v_workflow_id, 'Cancel from in progress', get_next_transition_code(v_workflow_id),
                v_state_in_progress_id, v_state_cancelled_id);
        insert into transition (workflow_id, name, code, source_state_id, target_state_id)
        values (v_workflow_id, 'Cancel from in review', get_next_transition_code(v_workflow_id),
                v_state_in_review_id, v_state_cancelled_id);
        insert into transition (workflow_id, name, code, source_state_id, target_state_id)
        values (v_workflow_id, 'Reopen from done', get_next_transition_code(v_workflow_id), v_state_done_id,
                v_state_in_progress_id);
        insert into transition (workflow_id, name, code, source_state_id, target_state_id)
        values (v_workflow_id, 'Reopen from cancelled', get_next_transition_code(v_workflow_id), v_state_cancelled_id,
                v_state_in_progress_id);
        insert into transition (workflow_id, name, code, source_state_id, target_state_id)
        values (v_workflow_id, 'Reopen from rejected', get_next_transition_code(v_workflow_id), v_state_rejected_id,
                v_state_in_progress_id);
    end if;
end;
$$;
call insert_data_for_workflow_module_task();
drop procedure if exists insert_data_for_workflow_module_task();