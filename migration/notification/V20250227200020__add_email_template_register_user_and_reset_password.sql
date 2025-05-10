set search_path to swenotification;

insert into email_template (id, template_key, name, subject, body, is_html, created_at, updated_at)
values (gen_random_uuid(), 'register_user', 'Register User', 'Welcome to the SWE System',
        '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body style="font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f5f5f5; color: #333333;">
    <div style="max-width: 600px; margin: 0 auto; background-color: #ffffff; padding: 20px; border: 1px solid #dddddd;">
        <h2 style="color: #1a73e8; margin: 0 0 20px;">Welcome to the SWE System</h2>
        <p>Hello new member,</p>
        <p>Your account has been successfully created at {created_at} with the username: {username}.</p>
        <p>Best regards,<br>The SWE Team</p>
        <p style="font-size: 12px; color: #777777; margin-top: 20px;">This is an automated message. Please do not reply directly to this email.</p>
    </div>
</body>
</html>', true, now(), now()),

       (gen_random_uuid(), 'reset_password', 'Reset Password', 'Reset Your Password',
        '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body style="font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f5f5f5; color: #333333;">
    <div style="max-width: 600px; margin: 0 auto; background-color: #ffffff; padding: 20px; border: 1px solid #dddddd;">
        <h2 style="color: #1a73e8; margin: 0 0 20px;">Reset Your Password</h2>
        <p>Hello,</p>
        <p>We received a request to reset your password. If you did not make this request, please ignore this email.</p>
        <p>To reset your password, click below:</p>
        <p><a href="{reset_link}" style="color: #1a73e8; text-decoration: none;">Reset Password</a></p>
        <p>Or copy and paste this URL into your browser:<br><a href="{reset_link}" style="color: #1a73e8; text-decoration: none;">{reset_link}</a></p>
        <p>This link will expire in 30 minutes.</p>
        <p>Best regards,<br>The SWE Team</p>
        <p style="font-size: 12px; color: #777777; margin-top: 20px;">This is an automated message. Please do not reply directly to this email.</p>
    </div>
</body>
</html>', true, now(), now());
