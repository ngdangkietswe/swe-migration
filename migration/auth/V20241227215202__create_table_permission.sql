do
$$
    declare
        action_read_id      uuid;
        action_create_id    uuid;
        action_update_id    uuid;
        action_delete_id    uuid;
        action_download_id  uuid;
        action_upload_id    uuid;
        resource_task_id    uuid;
        resource_comment_id uuid;
        resource_file_id    uuid;
    begin
        create table if not exists action
        (
            id          uuid        not null default gen_random_uuid(),
            name        varchar(50) not null, -- e.g. READ, CREATE, UPDATE, DELETE, ...
            description text,
            primary key (id)
        );

        create table if not exists resource
        (
            id          uuid        not null default gen_random_uuid(),
            name        varchar(50) not null, -- e.g. task, comment, file, ...
            description text,
            primary key (id)
        );

        create table if not exists permission
        (
            id          uuid not null default gen_random_uuid(),
            action_id   uuid not null,
            resource_id uuid not null,
            description text,
            primary key (id),
            foreign key (action_id) references action (id),
            foreign key (resource_id) references resource (id)
        );

        create table if not exists users_permission
        (
            id            uuid not null default gen_random_uuid(),
            user_id       uuid not null,
            permission_id uuid not null,
            primary key (id),
            foreign key (user_id) references users (id),
            foreign key (permission_id) references permission (id),
            unique (user_id, permission_id)
        );

        insert into action (name, description)
        values ('READ', 'Read operation.')
        returning id into action_read_id;

        insert into action (name, description)
        values ('CREATE', 'Create operation.')
        returning id into action_create_id;

        insert into action (name, description)
        values ('UPDATE', 'Update operation.')
        returning id into action_update_id;

        insert into action (name, description)
        values ('DELETE', 'Delete operation.')
        returning id into action_delete_id;

        insert into action (name, description)
        values ('DOWNLOAD', 'Download operation.')
        returning id into action_download_id;

        insert into action (name, description)
        values ('UPLOAD', 'Upload operation.')
        returning id into action_upload_id;

        insert into resource (name, description)
        values ('Task', 'Task resource.')
        returning id into resource_task_id;

        insert into resource (name, description)
        values ('Comment', 'Comment resource.')
        returning id into resource_comment_id;

        insert into resource (name, description)
        values ('File', 'File resource.')
        returning id into resource_file_id;

        insert into permission (action_id, resource_id, description)
        values (action_read_id, resource_task_id, 'Read task.');

        insert into permission (action_id, resource_id, description)
        values (action_create_id, resource_task_id, 'Create task.');

        insert into permission (action_id, resource_id, description)
        values (action_update_id, resource_task_id, 'Update task.');

        insert into permission (action_id, resource_id, description)
        values (action_delete_id, resource_task_id, 'Delete task.');

        insert into permission (action_id, resource_id, description)
        values (action_read_id, resource_comment_id, 'Read comment.');

        insert into permission (action_id, resource_id, description)
        values (action_create_id, resource_comment_id, 'Create comment.');

        insert into permission (action_id, resource_id, description)
        values (action_update_id, resource_comment_id, 'Update comment.');

        insert into permission (action_id, resource_id, description)
        values (action_delete_id, resource_comment_id, 'Delete comment.');

        insert into permission (action_id, resource_id, description)
        values (action_download_id, resource_file_id, 'Download file.');

        insert into permission (action_id, resource_id, description)
        values (action_upload_id, resource_file_id, 'Upload file.');
    end;
$$