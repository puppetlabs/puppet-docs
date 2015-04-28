---
title: "Activity Service >> Activity Reporting"
layout: default
subtitle: "Activity Reporting"
canonical: "/pe/latest/rbac_activityservice.html"
---

# RBAC Activity Reporting

The RBAC service's activity reporting is intended to provide a useful
audit trail for actions that change entities within the purview of
RBAC. The following sections describe the potential events for each RBAC entity.

### Local Users

These events are displayed in the console on the **Activity** tab on the affected user's page.

 * Creation

 	An event is reported when a new local user is created. An initial value for each metadata field is reported. For example: Created with login set to "kate".

 * Metadata

   An event is reported if any of these keys change: `login`, `display name`, or `email`. For example: display name set to "Kate Gleason".

 * Role Membership

   An event is reported when a user is added to or removed from a role. These events, the display name, and user ID of the affected user are displayed on the page for the role. For example: User Kate Gleason (973c0cee-5ed3-11e4-aa15-123b93f75cba) added to role Operators.
 * Authentication

   An event is reported when a user logs in. The display name and user ID of the affected user are displayed. For example: User Kate Gleason (973c0cee-5ed3-11e4-aa15-123b93f75cba) logged in.
 * Password Reset Token

   An event is reported when a token is generated for a user to use in resetting their password. The display name and user ID of the affected user are shown. For example: A password reset token was generated for user Kate Gleason (973c0cee-5ed3-11e4-aa15-123b93f75cba).
 * Password Changed

  An event is reported when a user successfully changes their password with a token. For example: Password reset for user Kate Gleason (973c0cee-5ed3-11e4-aa15-123b93f75cba).
 * Revocation

   An event is reported when a user is revoked or reinstated. For example: User revoked.
   Or, User reinstated.

### Remote Users

These events are displayed in the UI on the page for the affected user.

 * Role Membership

   An event is reported when a user is added to or removed from a role. These events are also shown on the page for the role. The display name and user ID of the affected user are displayed. For example: User Frances (76483e62-5ed4-11e4-aa15-123b93f75cba) added to role Viewers.
 * Revocation

   An event is reported when a user is revoked or reinstated. For example: User revoked. Or, User reinstated.

### User Groups

These events are displayed in the UI on the page for the affected group.

 * Importation

   An event is reported when a user group is imported. The initial value for each metadata field is reported, (though these cannot later be updated using the RBAC UI). For example: Created with display name set to "Engineers".
 * Role Membership

   An event is reported when a group is added to or removed from a role. These events are also shown on the page for the role. The group's display name ID are provided. For example: Group Engineers (7dee3acc-5ed4-11e4-aa15-123b93f75cba) added to role Operators.

### Roles

These events are displayed in the UI on the page for the affected role.

 * Metadata

   An event is reported if a role's `display name` or `description` changes. For example: Description set to "Sysadmins with full privileges for node groups".
 * Members

   An event is reported when a group is added to or removed from a role. The display name of the user or group and its ID are provided. These events are also displayed on the page for the affected user or group. For example: User Frances (76483e62-5ed4-11e4-aa15-123b93f75cba) removed from role Operators.
 * Permissions

   An event is reported when a given permission is added to or removed from a role. For example: Permission users:edit:76483e62-5ed4-11e4-aa15-123b93f75cba added to role Operators.

### Directory Server Settings

These events are not exposed via the UI. The Activity Service API must be used to see these events.

 * Update Settings (except password)

   An event is generated for each setting changed in the directory server settings. For example: User rdn set to "ou=users".
 * Update directory server password

   An event is generated when the directory server password is changed. For example: Password updated.