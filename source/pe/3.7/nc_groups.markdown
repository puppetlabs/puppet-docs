---
title: "Node Classifier 1.0 >> API >> v1 >> Groups"
layout: default
subtitle: "Node Classifier Groups"
canonical: "/pe/latest/nc_groups.html"
---

## Groups Endpoint

### General Error Responses

Whenever the request path contains a group's ID, which must be a UUID, there is the potential for that ID to be malformed.
If it is, a 400 Bad Request response will be returned to the client.
The body of the response will contain a JSON error object as described in the [errors documentation](./nc_errors.html).
The object's `kind` key will be "malformed-uuid", and the value of the `details` key will be a string containing the malformed UUID as received by the server.

### GET /v1/groups

Retrieve a list of all node groups in the node classifier.

#### Query Parameters

* `inherited`: if set to any value besides `0` or `false`, the node group will include the classes, class parameters, and variables that it inherits from its ancestors.

#### Response Format

The response is a JSON array of node group objects.
Each node group object contains the following keys:

* `name`: the name of the node group (a string).
* `id`: the node group's ID, which is a string containing a type-4 (random) UUID.
* `description`: an optional key containing an arbitrary string describing the node group.
* `environment`: the name of the node group's environment (a string), which indirectly defines what classes will be available for the node group to set, and will be the environment that nodes classified into this node group will run under.
* `environment_trumps`: this is a boolean that changes the behavior of classifications that this node group is involved in.
                        The default behavior is to return a classification-conflict error if the node groups that a node is classified into do not all have the same environment.
                        If this flag is set, then this node group's environment will override the environments of the other node groups (provided that none of them also have this flag set), with no attempt made to validate that the other node groups' classes and class parameters exist in this node group's environment.
* `parent`: the ID of the node group's parent (a string).
            A node group is not permitted to be its own parent, unless it is the default group (which is the root of the hierarchy).
            Note that the root group always has the lowest-possible random UUID, `00000000-0000-4000-8000-000000000000`.
* `rule`: a boolean condition on node properties.
          When a node's properties satisfy this condition, it will be classified into the node group.
          See the ["Rule Condition Grammar"](#rule-condition-grammar) section below for more information on how this condition must be structured.
* `classes`: an object that defines both the classes consumed by nodes in this node group and any non-default values for their parameters.
             The keys of the object are the class names, and the values are objects describing the parameters.
             The parameter objects' keys are parameter names, and the values are what the node group sets for that parameter (always a string).
* `deleted`: an object similar the `classes` object that shows which classes and class parameters set by the node group have since been deleted from Puppet.
             If none of the node group's classes or parameters have been deleted, this key will not be present, so checking the presence of this key is an easy way to check whether the node group has references that need updating.
             The keys of this object are class names, and the values are further objects.
             These secondary objects always contain the `puppetlabs.classifier/deleted` key, whose value is a boolean indicating whether the entire class has been deleted from Puppet.
             The other keys of these objects are parameter names, and the other values are objects that always contain two keys: `puppetlabs.classifier/deleted`, mapping to a boolean indicating whether the specific class parameter has been deleted from Puppet; and `value`, mapping to the string value set by the node group for this parameter (the value is duplicated for convenience, as it also appears in the `classes` object).
* `variables`: an object that defines the values of any top-level variables set by the node group.
               The object is a mapping between variable names and their values (which can be any JSON value).

Here is an example of a node group object:

{% highlight javascript %}
{
  "name": "Webservers",
  "id": "fc500c43-5065-469b-91fc-37ed0e500e81",
  "environment": "production",
  "description": "This group captures configuration relevant to all web-facing production webservers, regardless of location.",
  "parent": "00000000-0000-4000-8000-000000000000",
  "rule": ["and", ["~", ["trusted", "certname"], "www"],
                  [">=", ["fact", "total_ram"], "512"]],
  "classes": {
    "apache": {
      "serveradmin": "bofh@travaglia.net",
      "keepalive_timeout": "5"
    }
  },
  "variables": {
    "ntp_servers": ["0.us.pool.ntp.org", "1.us.pool.ntp.org", "2.us.pool.ntp.org"]
  }
}
{% endhighlight %}

Here is an example of a node group object that refers to some classes and parameters that have been deleted from Puppet:

{% highlight javascript %}
{
  "name": "Spaceship",
  "id": "fc500c43-5065-469b-91fc-37ed0e500e81",
  "environment": "space",
  "parent": "00000000-0000-4000-8000-000000000000",
  "rule": ["=", ["fact", "is_spaceship"], "true"],
  "classes": {
    "payload": {
      "type": "cubesat",
      "count": "8",
      "mass": "10.64"
    },
    "rocket": {
      "stages": "3"
    }
  },
  "deleted": {
    "payload": {"puppetlabs.classifier/deleted": true},
    "rocket": {
      "puppetlabs.classifier/deleted": false,
      "stages": {
        "puppetlabs.classifier/deleted": true,
        "value": "3"
      }
    }
  },
  "variables": {}
}
{% endhighlight %}

The entire `payload` class has been deleted, since its deleted parameters object's `puppetlabs.classifier/deleted` key maps to `true`, in contrast to the `rocket` class, which has only had its `stages` parameter deleted.

##### Rule Condition Grammar

The grammar for a rule condition is:

    condition  : [ {bool} {condition}+ ] | [ "not" {condition} ] | {operation}
         bool  : "and" | "or"
    operation  : [ {operator} {fact-path} {value} ]
     operator  : "=" | "~" | ">" | ">=" | "<" | "<="
    fact-path  : {field-name} | [ {field-name} + ]
    field-name : string
        value  : string

For the regex operator `"~"`, the value will be interpreted as a Java regular expression, and literal backslashes will have to be used to escape regex characters in order to match those characters in the fact value.
For the numeric comparison operators (`">"`, `">="`, `"<"`, and `"<="`), the fact value (which is always a string) will be coerced to a number (either integral or floating-point).
If the value cannot be coerced to a number, then the numeric operation will always evaluate to false.

For the fact path, this can be either a string representing a top level field (the only current meaningful value here would be "name" representing the node name) or a list of strings that represent looking up a field in a nested data structure.
Regular facts will all start with "fact" (e.g. `["fact", "architecture"]`) and trusted facts start with "trusted" (e.g. `["trusted", "certname"]`).

#### Error Responses

No error responses specific to this request are expected.

### POST /v1/groups

Create a new node group without specifying its ID (one will be randomly generated by the service).

#### Request Format

The request body must be a JSON object describing the node group to be created.
The keys allowed in this object are:

* `name`: the name of the node group (required).
* `environment`: the name of the node group's environment.
                 This key is optional; if it's not provided, the default environment (`production`) will be used.
* `environment_trumps`: whether this node group's environment should override those of other node groups at classification-time.
                        This key is optional; if it's not provided, the default value of `false` will be used.
* `description`: a string describing the node group.
                 This key is optional; if it's not provided, the node group will have no description and this key will not appear in responses.
* `parent`: the ID of the node group's parent (required).
* `rule`: the condition that must be satisfied for a node to be classified into this node group.
          The structure of this condition is described in the ["Rule Condition Grammar"](#rule-condition-grammar) section above.
* `variables`: an object that defines the names and values of any top-level variables set by the node group.
               The keys of the object are the variable names, and the corresponding value is that variable's value, which can be any sort of JSON value.
               The `variables` key is optional, and if a node group does not define any top-level variables then it may be omitted.
* `classes`: An object that defines the classes to be used by nodes in the node group, as well as custom values for those classes' parameters (required).
             This is a two-level object; that is, the keys of the object are class names (strings), and each key's value is another object that defines class parameter values.
             This innermost object maps between class parameter names and their values.
             The keys are the parameter names (strings), and each value is the parameter's value, which can be any kind of JSON value.
             The `classes` key is _not_ optional; if it is missing, a 400 Bad Request response will be returned by the server.

### Error Responses

#### `schema-violation`

If any of the required keys are missing or the values of any of the defined keys do not match the required type, the server will return a 400 Bad Request response with the following keys: 

* `kind`: "schema-violation"
* `details`: an object that contains three keys:

  * `submitted`: describes the submitted object
  * `schema`: describes the schema that object should conform to
  * `error`: describes how the submitted object failed to conform to the schema

#### `malformed-request`

If the request's body could not be parsed as JSON, the server will return a 400 Bad Request response with the following keys: 

* `kind`: "malformed-request" 
* `details`: an object that contains two keys:

  * `body`: holds the request body that was received
  * `error`: the error message encountered while trying to parse the JSON

#### `uniqueness-violation`

The server will return a 422 Unprocessable Entity response if your attempt to create the node group violates uniqueness constraints (such as the constraint that each node group name must be unique within its environment). The response object will have the following keys:

* `kind`: "uniqueness-violation"
* `msg`: describes which fields of the node group caused the constraint to be violated, along with their values
* `details`: contains an object that has two keys:

  * `conflict`: an object whose keys are the fields of the node group that violated the constraint and whose values are the corresponding field values
  * `constraintName`: the name of the database constraint that was violated

#### `missing-referents`

The server will return a 422 Unprocessable Entity response if classes or class parameters defined by the node group, or inherited by the node group from its parent, do not exist in the submitted node group's environment. In both cases the response object will have the following keys:

* `kind`: "missing-referents"
* `msg`: describes the error and lists the missing classes and/or parameters
* `details`: an array of objects, where each object describes a single missing referent, and has the following keys:

  * `kind`: "missing-class" or "missing-parameter", depending on whether the entire class doesn't exist, or the class just doesn't have the parameter
  * `missing`: the name of the missing class or class parameter
  * `environment`: the environment that the class or parameter is missing from; i.e. the environment of the node group where the error was encountered
  * `group`: the name of the node group where the error was encountered
           Note that, due to inheritance, this may not be the group where the parameter was defined.
  * `defined_by`: the name of the node group that defines the class or parameter

#### `unspecified-parameters`

The server will return a 422 Unprocessable Entity response if a required parameter is missing. The response object will have the following keys:

* `kind`: "unspecified-parameters"
* `msg`: shows the classes that have required parameters, and lists the required parameters for each of the classes
* `details`: an array of objects, where each object describes a single unspecified referent, and has the following keys:

  * `kind`: "unspecified-parameters"
  * `group`: the name of the node group where the error was encountered
           Note that, due to inheritance, this may not be the group where the parameter was defined.
  * `environment`: the environment that the parameter is required in. This is the environment of the node group where the error was encountered
  * `class`: the class that the parameter is required in
  * `unspecified`: an array of the names of parameters that are required but have not been specified
  * `defined_by`: the name of the node group that defines the parameter

#### `missing-parent`

The server will return a 422 Unprocessable Entity response if the parent of the node group does not exist. The response object will have the following keys:

* `kind`: "missing-parent"
* `msg`: shows the parent UUID that did not exist
* `details`: the full submitted node group

#### `inheritance-cycle`

The server will return a 422 Unprocessable Entity response if the request would cause an inheritance cycle to be created. The response object will have the following keys:

* `kind`: "inheritance-cycle"
* `details`: an array of node group objects that includes each node group involved in the cycle
* `msg`: a shortened description of the cycle, including a list of the node group names with each followed by its parent until the first node group is repeated.

### GET /v1/groups/\<id\>

Retrieve the node group with the given ID.

#### Response Format

If the node group exists, the response will be a node group object as described above, in JSON format.

#### Error Responses

In addition to the general `malformed-uuid` error response, if the node group with the given ID cannot be found, a 404 Not Found response will be returned.
The body will be a generic 404 error response as described in the [errors documentation](./nc_errors.html).

### PUT /v1/groups/\<id\>

Create a node group with the given ID.

Note that any existing node group with that ID will be overwritten!

#### Request Format

The request format is the same as the format for the [POST group creation endpoint](#post-v1groups) above.

##### Deleted classes and class parameters

It is possible to overwrite an existing node group with a new node group definition that contains deleted classes or parameters.

#### Response Format

If the node group was successfully created, the server will return a 201 Created response, with the node group object (in JSON) as the body.
If the node group already exists and is identical to the submitted node group, then the server will take no action and return a 200 OK response, again with the node group object as the body.

See above for a complete description of a node group object.

#### Error Responses

If the request's node group object contains the `id` key and its value differs from the UUID specified in the request's path, a 400 Bad Request response will be returned.

The response will contain an error object as described in the [errors documentation](./nc_errors.html).

The object's `kind` key will be "conflicting-ids", and its `details` key will itself contain an object with two keys: `submitted`, which contains the ID submitted in the request's body, and `fromUrl`, which contains the ID taken from the request's URL.

In addition, this operation can produce the general `malformed-error` response and any response that could also be generated by the [POST group creation endpoint](#post-v1groups) above.

### POST /v1/groups/\<id\>

Update the name, environment, parent, rule, classes, class parameters, and variables of the node group with the given ID by submitting a node group delta.

#### Request Format

The request body must be JSON object describing the delta to be applied to the node group.

The `classes` and `variables` keys of the delta will be merged with the node group, and then any keys of the resulting object that have a null value will be deleted.
This allows you to change or remove individual classes, class parameters, or variables from the node group by giving them a new value or setting them to null in the delta.

If the delta has a `rule` key that's set to a new value or nil, it will be updated wholesale or removed from the group accordingly.

The `name`, `environment`, `description`, and `parent` keys, if present in the delta, will replace the old values wholesale with their values.

Note that the root group's `rule` cannot be edited; any attempts to do so will be met with a 422 Unprocessable Entity response.

For example, given the following node group:

{% highlight javascript %}
{
  "name": "Webservers",
  "id": "58463036-0efa-4365-b367-b5401c0711d3",
  "environment": "staging",
  "parent": "00000000-0000-4000-8000-000000000000",
  "rule": ["~", ["trusted", "certname"], "www"],
  "classes": {
    "apache": {
      "serveradmin": "bofh@travaglia.net",
      "keepalive_timeout": 5
    },
    "ssl": {
      "keystore": "/etc/ssl/keystore"
    }
  },
  "variables": {
    "ntp_servers": ["0.us.pool.ntp.org", "1.us.pool.ntp.org", "2.us.pool.ntp.org"]
  }
}
{% endhighlight %}

and this delta:

{% highlight javascript %}
{
  "name": "Production Webservers",
  "id": "58463036-0efa-4365-b367-b5401c0711d3",
  "environment": "production",
  "parent": "01522c99-627c-4a07-b28e-a25dd563d756",
  "classes": {
    "apache": {
      "serveradmin": "roy@reynholm.co.uk",
      "keepalive_timeout": null
    },
    "ssl": null
  },
  "variables": {
    "dns_servers": ["dns.reynholm.co.uk"]
  }
}
{% endhighlight %}

then the value of the node group after the update will be:

{% highlight javascript %}
{
  "name": "Production Webservers",
  "id": "58463036-0efa-4365-b367-b5401c0711d3",
  "environment": "production",
  "parent": "01522c99-627c-4a07-b28e-a25dd563d756",
  "rule": ["~", ["trusted", "certname"], "www"],
  "classes": {
    "apache": {
      "serveradmin": "roy@reynholm.co.uk"
    }
  },
  "variables": {
    "ntp_servers": ["0.us.pool.ntp.org", "1.us.pool.ntp.org", "2.us.pool.ntp.org"],
    "dns_servers": ["dns.reynholm.co.uk"]
  }
}
{% endhighlight %}

Note how the `ssl` class was deleted because its entire object was mapped to null, whereas for the `apache` class only the `keepalive_timeout` parameter was deleted.

##### Deleted classes and class parameters

If the node group definition contains classes and parameters that have been deleted it is still possible to update the node group with those parameters and classes.
Updates that don't increase the number of errors associated with a node group are allowed.

#### Error Responses

This operation can return any of the errors that could be returned to a PUT request on this same endpoint.
See [above](#response-format) for details on these responses.
Note that 422 responses to POST requests can include errors that were caused by the node group's children, but a node group being created with a PUT request cannot have any children.

### DELETE /v1/groups/\<id\>

Delete the node group with the given ID.

#### Response Format

If the delete operation is successful, then a 204 No Content with an empty body will be returned.

#### Error Responses

In addition to the general `malformed-uuid` response, if the node group with the given ID does not exist, then a 404 Not Found response as described in the [errors documentation](./nc_errors.html) will be returned to the client.

If the node group that is being deleted has children, then the delete will be rejected, and a 422 Unprocessable Entity response will be returned to the client.
The response body will be the usual JSON error object, with a `kind` key of `children-present`, a `msg` that explains why the delete was rejected and names the children, and `details` that contains the node group in question along with all of its children, in full.
