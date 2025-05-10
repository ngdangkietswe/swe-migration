set search_path to swenotification;

-- Create the table for the users
create table if not exists cdc_auth_users
(
    id       uuid         not null,
    username varchar(255) not null,
    email    varchar(255) not null,
    primary key (id)
);

-- Create the table for the email template
create table if not exists email_template
(
    id           uuid         not null default gen_random_uuid(),
    template_key varchar(100) not null,
    name         varchar(255) not null,
    subject      varchar(255) not null,
    body         text         not null,
    is_html      boolean      not null default false,
    created_at   timestamp    not null default current_timestamp,
    updated_at   timestamp    not null default current_timestamp,
    is_deleted   boolean      not null default false,
    created_by   uuid,
    updated_by   uuid,
    deleted_by   uuid,
    primary key (id),
    constraint fk_email_template_created_by
        foreign key (created_by) references cdc_auth_users (id),
    constraint fk_email_template_updated_by
        foreign key (updated_by) references cdc_auth_users (id),
    constraint fk_email_template_deleted_by
        foreign key (deleted_by) references cdc_auth_users (id),
    unique (template_key)
);

-- Insert the default email templates
insert into email_template (template_key, name, subject, body, is_html)
values ('overtime_request',
        'Overtime Request Submission',
        'New Overtime Request Awaiting Your Review',
        'Dear {approver},\n\nA new overtime request has been submitted by {requester} with the following details:\n\n- **Date**: {date}\n- **Hours Requested**: {overtime_hours}\n- **Reason**: {reason}\n\nPlease review this request at your earliest convenience.\n\nBest regards,\nSWE Notification Service Team',
        false);

insert into email_template (template_key, name, subject, body, is_html)
values ('overtime_reply',
        'Overtime Request Response',
        'Response to Your Overtime Request',
        'Dear {requester},\n\nYour overtime request for {date} has been reviewed by {approver}. Below are the details:\n\n- Status: {status}\n- Reason: {reason}\n\nBest regards,\nSWE Notification Service Team',
        false);