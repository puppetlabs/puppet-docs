---
title: "Node Classifier 1.0 >> API >> v1 >> Node History"
layout: default
subtitle: "Node Classifier Node History"
canonical: "/pe/latest/nc_nodes.html"
---

## Node History Endpoint

### GET /v1/nodes

Retrieve a list of all nodes that have checked in with the node classifier, each with their check-in history.

#### Response Format

The response is a JSON array of node objects.
Each node object contains these two keys:

* `name`: the name of the node according to Puppet (a string).
* `check_ins`: an array of check-in objects (described below).

Each check-in object described a single check-in of the node.
The check-in objects have the following keys:

* `time`: the time of the check-in as a string in ISO 8601 format (with timezone).
* `explanation`: an object mapping between IDs of groups that the node was classified into and explained condition objects that describe why the node matched this group's rule.
* `transaction_uuid`: a uuid representing a particular Puppet transaction that is submitted by Puppet at classification time.
                      This makes it possible to identify the check-in involved in generating a specific catalog and report.

The explained condition objects are essentially just the node group's rule condition marked up with the node's value and the result of evalution.
Each form in the rule (that is, each array in the JSON representation of the rule condition) is replaced with an object that has two keys:

* `value`: a boolean that is the result of evaluating this form.
           At the top level, this is the result of the entire rule condition, but since each sub-condition is marked up with its value, you can use this to understand, say, which parts of an `or` condition were true.
* `form`: the condition form, with all sub-forms as further explained condition objects.

Besides the condition markup, the comparison operations of the rule condition will have their first argument (the fact path) replaced with an object that has both the fact path and the value that was found in the node at that path.

It may be easier to grasp the format of an explained condition through example.
Let's say that we have a node group with this rule:

{% highlight javascript %}
["and", [">=", ["fact", "pressure hulls"], "1"],
        ["=", ["fact", "warp cores"], "0"],
        [">=", ["fact", "docking ports"], "10"]]
{% endhighlight %}

and we have this node:

{% highlight javascript %}
{
  "name": "Deep Space 9",
  "fact": {
    "pressure hulls": "10",
    "docking ports": "18",
    "docking pylons": "3",
    "warp cores": "0",
    "bars": "1"
  }
}
{% endhighlight %}

When the node checks in for classification, it will match the above rule, so that check-in's explanation object will have an entry for the node group that the rule came from.
The value of this entry will be this explained condition object:

{% highlight javascript %}
{
  "value": true,
  "form": [
    "and",
    {
      "value": true,
      "form": [">=", {"path": ["fact", "pressure hulls"], "value": "3"}, "1"]
    },
    {
      "value": true,
      "form": ["=", {"path": ["fact", "warp cores"], "value": "0"}, "0"]
    },
    {
      "value": true,
      "form": [">" {"path": ["fact", "docking ports"], "value": "18"}, "9"]
    }
  ]
}
{% endhighlight %}

### GET /v1/nodes/\<node\>

Retrieve the check-in history for only the specified node.

#### Response Format

The response will be one node object as described above, for the specified node.

Here's an example node object:

{% highlight javascript %}
{
  "name": "Deep Space 9",
  "check_ins": [
    {
      "time": "2369-01-04T03:00:00Z",
      "explanation": {
        "53029cf7-2070-4539-87f5-9fc754a0f041": {
          "value": true,
          "form": [
            "and",
            {
              "value": true,
              "form": [">=", {"path": ["fact", "pressure hulls"], "value": "3"}, "1"]
            },
            {
              "value": true,
              "form": ["=", {"path": ["fact", "warp cores"], "value": "0"}, "0"]
            },
            {
              "value": true,
              "form": [">" {"path": ["fact", "docking ports"], "value": "18"}, "9"]
            }
          ]
        }
      }
    }
  ],
  "transaction_uuid": "d3653a4a-4ebe-426e-a04d-dbebec00e97f"
}
{% endhighlight %}

#### Error Responses

If the specified node has not checked in, then the server will return a 404 Not Found response, with the usual JSON error response in its body.
