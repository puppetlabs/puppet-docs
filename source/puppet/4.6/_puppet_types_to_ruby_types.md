[boolean]: ./lang_data_boolean.html
[undef]: ./lang_data_undef.html
[string]: ./lang_data_string.html
[number]: ./lang_data_number.html
[array]: ./lang_data_array.html
[hash]: ./lang_data_hash.html
[default]: ./lang_data_default.html
[regexp]: ./lang_data_regexp.html
[resource reference]: ./lang_data_resource_reference.html
[lambda]: ./lang_lambdas.html
[data type]: ./lang_data_type.html

Puppet type             | Ruby class
------------------------|-------------------------------------------------------------------------------
[Boolean][]             | `Boolean`
[Undef][]               | `NilClass` (value `nil`)
[String][]              | `String`
[Number][]              | subtype of `Numeric`
[Array][]               | `Array`
[Hash][]                | `Hash`
[Default][]             | `Symbol` (value `:default`)
[Regexp][]              | `Regexp`
[Resource reference][]  | `Puppet::Pops::Types::PResourceType`, or `Puppet::Pops::Types::PHostClassType`
[Lambda][] (code block) | `Puppet::Pops::Evaluator::Closure`
[Data type][] (`Type`)  | A type class under `Puppet::Pops::Types`, e.g. `Puppet::Pops::Types::PIntegerType`
