---
title: "Activity Service >> Endpoints"
layout: default
subtitle: "Activity Service Endpoints"
canonical: "/pe/latest/rbac_activityapis.html"
---

Puppet Enterprise (PE) includes the activity service, a service that logs changes to  role-based access control (RBAC) entities, such as users, user groups, and user roles.

The activity service consists of the following endpoints.

## GET /v1/events

Fetches events in a structured JSON format. Supports filtering through query parameters. Web session authentication is required.

**Filters:**

* service_id [required]
* subject\_type [optional; required only when subject\_id is provided]
* subject\_id [optional; comma-separated list of subject\_ids]
* object\_type [optional; required only when object\_id is provided]
* object\_id [optional; comma-separated list of object\_ids]
* offset=[optional; skip `n` event commits]
* limit=[optional; return no more than `n` event commits; defaults to 1000]

**Example response body:**

GET /v1/events?service\_id=classifier&subject\_type=users&subject_id=kate


	{"commits":
 	   [{"object":{"id":"415dfsvdf-dfgd45dfg-4dsfg54d", "name":"Default Node Group"},
   		 "subject":{"id":"dfgdfc145-545dfg54f-fdg45s5s", "name":"Kate Gleason"},
         "timestamp":"2014-06-24T04:00:00Z",
         "events":
         [{"message":"Create Node"},
          {"message":"Create Node Class"}]}],
    "total-rows":1}

GET /v1/events?service_id=classifier&object_type=node_groups&object_id=2

	{"commits":
      [{"object":{"id":"415dfsvdf-dfgd45dfg-4dsfg54d", "name":"Default Node Group"},
        "subject":{"id":"dfgdfc145-545dfg54f-fdg45s5s", "name":"Kate Gleason"},
        "timestamp":"2014-06-24T04:00:00Z",
        "events":
       [{"message":"Create Node"},
        {"message":"Create Node Class"}]}],
    "total-rows":1}


## GET /v1/events.csv

Fetches events in a flat CSV format. Supports filtering through query parameters. Web session authentication is required.
**Filters:**

* service\_id=[required]
* subject\_type [optional; required only when subject_id is provided]
* subject\_id [optional; comma-separated list of subject_ids]
* object\_type [optional; required only when object_id is provided]
* object\_id [optional; comma-separated list of object_ids]
* offset=[optional; skip `n` event commits]
* limit=[optional; return no more than 'n' event commits; defaults to 10000]

**Example response body:**

GET /v1/events.csv?service_id=classifier&subject_type=users&subject_id=kate

    Submit Time,Subject Type,Subject Id,Subject Name,Object Type,Object Id,Object Name,Type,What,Description,Message
    2014-07-17 13:08:09.985221,users,kate,Kate Gleason,node\_groups,2,Default Node Group,create,node,create\_node,Create Node
    2014-07-17 13:08:09.985221,users,kate,Kate Gleason,node\_groups,2,Default Node Group,create,node\_class,create\_node\_class,Create Node Class

