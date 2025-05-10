set search_path to swenotification;

update email_template
set body    = '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Overtime Request Submission</title>
</head>
<body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
    <p>Dear {approver},</p>
    <p>A new overtime request has been submitted by <strong>{requester}</strong> with the following details:</p>
    <ul style="list-style-type: none; padding-left: 0;">
        <li><strong>Date:</strong> {date}</li>
        <li><strong>Hours Requested:</strong> {overtime_hours}</li>
        <li><strong>Reason:</strong> {reason}</li>
    </ul>
    <p>Please review this request at your earliest convenience.</p>
    <p>Best regards,<br>SWE Notification Service Team</p>
</body>
</html>',
    is_html = true
where template_key = 'overtime_request';

update email_template
set body    = '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Overtime Request Response</title>
</head>
<body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
    <p>Dear {requester},</p>
    <p>Your overtime request submitted for <strong>{date}</strong> has been reviewed by <strong>{approver}</strong>. Below are the details of the response:</p>
    <ul style="list-style-type: none; padding-left: 0;">
        <li><strong>Status:</strong> {status}</li>
        <li><strong>Reason:</strong> {reason}</li>
    </ul>
    <p>Should you have any questions or require further clarification, please feel free to reach out.</p>
    <p>Best regards,<br>SWE Notification Service Team</p>
</body>
</html>',
    is_html = true
where template_key = 'overtime_reply';