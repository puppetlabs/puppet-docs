---
layout: default
title: "Language: Data types: Time-related data types"
---

[types]: ./lang_data_type.html
[data types]: ./lang_data.html
[strings]: ./lang_data_string.html
[regular expressions]: ./lang_data_regexp.html
[booleans]: ./lang_data_boolean.html
[arrays]: ./lang_data_array.html
[hashes]: ./lang_data_hash.html
[hash_missing_key_access]: ./lang_data_hash.html#accessing-values
[numbers]: ./lang_data_number.html

A `Timespan` defines the length of a duration of time, and a `Timestamp` defines a point in time. To describe it simply, "two hours" is a duration that can be represented as a `Timespan`, while "three o'clock in the afternoon UTC on November 8, 2018" is a point in time that can be represented as a `Timestamp`.

Both can use nanosecond values if available on the platform.

## `Timespan`

A `Timespan` value represents a duration of time. The `Timespan` data type matches a specified duration; `Timespan` values within a given range; or `default`, which represents a positive or infinite duration. A `Timespan` value can be specified with [strings][] or [numbers][] that can represent a `Timespan`.

The type takes up to two parameters.

### Parameters

The full signature for `Timespan` is:

    Timespan[ (<TIMESPAN START OR LENGTH>, (<TIMESPAN END>)) ]

Position | Parameter | Data Type | Default Value | Description
---------|-----------|-----------|---------------|------------
1 | Timespan Start or Length | String, Float, Integer, or `default` | `default` (-Infinity in a span) | Length of the timespan if passed alone, or the `from` value in a range if passed with a second parameter
2 | Timespan End | String, Float, Integer, or `default` | `default` (+Infinity), or none if only one value is passed | The `to` value in a range

`Timespan` values are interpreted depending on their format.

* A String in the format of `D-HH:MM:SS` represents a duration of days (`D`), hours (`HH`), minutes (`MM`), and seconds (`SS`)
* An Integer or Float represents a duration in seconds

A `Timespan` defined as a range matches any `Timespan` durations that can fit within that range. If either end of a range is defined as `default` (infinity), it is an _open range_, while any other range is a _closed range_. The range is inclusive.

In other words, `Timespan[2]` matches a duration of two seconds, but `Timespan[0, 2]` can match _any_ `Timespan` from zero to two seconds, inclusive.

The `Timespan` type is not enumerable.

For details about converting values of other types to `Timespan`, see [the `new()` function documentation](./function.html#conversion-to-timespan) for `Timespan`. To convert a `Timespan` to a `String`, see [the `strftime()` function documentation](./function.html#strftime).

### Examples:

* `Timespan[2]` --- matches a `Timespan` value of 2 seconds
* `Timespan[77.3]` --- matches a `Timespan` value of 1 minute, 17 seconds, and 300 milliseconds (77.3 seconds)
* `Timespan['1-00:00:00', '2-00:00:00']` --- matches a closed range of `Timespan` values between 1 and 2 days

## `Timestamp`

A `Timestamp` value represents a specific point in time. The `Timestamp` data type matches a specified value; `Timestamp` values within a given range; or `default`, which represents a positive or infinite range of Timestamps. A `Timestamp` value can be specified with [strings][] or [numbers][] that represent a point in time, or points in time limiting a range.

The type takes up to two parameters, and defaults to an infinite range to the past and future. A `Timestamp` with one parameter represents a single point in time, while two parameters represent a range of Timestamps, with the first parameter being the `from` value and the second being the `to` value.

### Parameters

The full signature for `Timestamp` is:

    Timestamp[ (<TIMESTAMP VALUE>, (<RANGE LIMIT>)) ]

Position | Parameter | Data Type | Default Value | Description
---------|-----------|-----------|---------------|------------
1 | Timestamp Value | String, Float, Integer, or `default` | `default` (-Infinity in a range) | Point in time if passed alone, or `from` value in a range if passed with a second parameter
2 | Range Limit | String, Float, Integer, or `default` | `default` (+Infinity), or none if only one value is passed | The `to` value in a range

A `Timestamp` defined as a single point in time matches exactly that point.

A `Timestamp` defined as a range matches any point in time within that range. If either end of a range is defined as `default` (infinity), it is an _open range_, while any other range is a _closed range_. The range is inclusive.

In other words, `Timestamp['2000-01-01T00:00:00.000']` matches 0:00 UTC on January 1, 2000, while `Timestamp['2000-01-01T00:00:00.000', '2001-01-01T00:00:00.000]` matches `Timestamp` values from that point in time to a point in time one year later, inclusive.

`Timestamp` values are interpreted depending on their format.

For details about converting values of other types to `Timestamp`, see [the `new()` function documentation](./function.html#conversion-to-timestamp). To convert a `Timespan` to a `String`, see [the `strftime()` function documentation](./function.html#strftime).

### Examples:

* `Timestamp['2000-01-01T00:00:00.000', default]` --- matches an open range of `Timestamps` from the start of the 21st century to an infinte point in the future
* `Timestamp['2012-10-10']` --- matches the exact `Timestamp` 2012-10-10T00:00:00.0 UTC
* `Timestamp[default, 1433116800]` --- matches an open range of `Timestamps` from an infinite point in the past to 2015-06-01T00:00:00 UTC, here expressed as seconds since the Unix epoch
* `Timestamp['2010-01-01', '2015-12-31T23:59:59.999999999']` --- matches a closed range of `Timestamps` between the start of 2010 and the end of 2015
