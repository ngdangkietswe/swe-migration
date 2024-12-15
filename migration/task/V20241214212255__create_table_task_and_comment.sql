create table if not exists task
(
    id          uuid         not null default gen_random_uuid(),
    title       varchar(255) not null,
    description text,
    reporter_id uuid,
    assignee_id uuid,
    status      integer      not null default 1,
    created_at  timestamp    not null default current_timestamp,
    updated_at  timestamp    not null default current_timestamp,
    is_deleted  timestamp,
    created_by  uuid         not null,
    updated_by  uuid         not null,
    deleted_by  uuid,
    primary key (id),
    constraint fk_task_reporter_id
        foreign key (reporter_id) references swetask.cdc_auth_users (id),
    constraint fk_task_assignee_id
        foreign key (assignee_id) references swetask.cdc_auth_users (id),
    constraint fk_task_created_by
        foreign key (created_by) references swetask.cdc_auth_users (id),
    constraint fk_task_updated_by
        foreign key (updated_by) references swetask.cdc_auth_users (id),
    constraint fk_task_deleted_by
        foreign key (deleted_by) references swetask.cdc_auth_users (id),
    constraint chk_task_status
        check (status in (0, 1, 2, 3, 4, 5)) -- 0: UNSPECIFIED, 1: OPEN, 2: IN_PROGRESS, 3: IN_REVIEW, 4: DONE, 5: CANCELED
);

create table if not exists comment
(
    id         uuid      not null default gen_random_uuid(),
    task_id    uuid      not null,
    content    text      not null,
    parent_id  uuid,
    created_at timestamp not null default current_timestamp,
    updated_at timestamp not null default current_timestamp,
    is_deleted timestamp,
    created_by uuid      not null,
    updated_by uuid      not null,
    deleted_by uuid,
    primary key (id),
    constraint fk_comment_task_id
        foreign key (task_id) references swetask.task (id),
    constraint fk_comment_parent_id
        foreign key (parent_id) references swetask.comment (id),
    constraint fk_comment_created_by
        foreign key (created_by) references swetask.cdc_auth_users (id),
    constraint fk_comment_updated_by
        foreign key (updated_by) references swetask.cdc_auth_users (id),
    constraint fk_comment_deleted_by
        foreign key (deleted_by) references swetask.cdc_auth_users (id)
)