---
title: "PE 3.7 » RBAC Service 1.0 >> Passwords APIs"
layout: default
subtitle: "Passwords APIs"
canonical: "/pe/latest/rbac_passwords.html"
---

When users forget passwords or lock themselves out of PE by attempting to log in with incorrect credentials too many times, you'll have to generate a password reset token for them. The Password APIs enable you to generate password reset tokens for a specific user or with a token that contains a temporary password in the body.

>Note: 10 is the default number of login attempts that can be made with incorrect credentials before a user will be locked out. You can change the value with the [`failed-attempts-lockout`](http://docspreview1.puppetlabs.lan/pe/latest/rbac_config.html#failed-attempts-lockout).

The path for RBAC requests is as follows, where localhost:4433 are the machine and port if you're making the call from the console machine. If you're not making the call from the console machine, then use the console machine's hostname in place of localhost.

    https://localhost:4433/rbac-api/v1/

### POST /users/:sid/password/reset
Generates a password reset token for the specified user. The generated token
is a single use, so it can only be used to reset the password
once, and has a limited lifetime. The lifetime is based on a configuration
value. The token is generated using a random token generation algorithm that's non-numeric and difficult to predict. This token is to be given to the appropriate
user for use with the `/auth/reset` endpoint. Web session authentication is
required.

**Returns:**

* **200 OK** With the token in the body of the response.
* **403 Forbidden** If the user does not have permissions to create a reset path
for the user, or if the user is a remote user.
* **404 Not found** If a user with the given identifier does not exist.

**Example return:**

    {"token":"4iDyP868392Ot3hc14B1r88551Z6T59R2Q79NiZLrR4157838gK88P6855g4z15f"}

### POST /auth/reset
Resets a user password using a one-time token, with the password in the
body. The token should be obtained via the `/users/:sid/password/reset` endpoint.
The appropriate user is identified in the payload of the token. This
does not establish a valid logged in session for the user. No authentication is required to use this endpoint.

**Example body:**

    {"token": "text of token goes here",
     "password":"someotherpassword"}

**Returns:**
* **200 OK** If the token is valid and the password has been changed.
* **403 Permission denied** If the token has been used or is invalid.

### PUT /users/current/password
Changes the password for the current user. A payload containing the current
password must be provided. Web session authentication is required.

**Example body:**

    {"current_password": "somepassword",
     "password": "someotherpassword"}

**Returns:**

* **200 OK** If the password is changed successfully
* **403 Forbidden** If the user is a remote user, or if the `current_password`
doesn't match the current password stored for the user. The body of the
response should include a message that specifies the cause of the failure.