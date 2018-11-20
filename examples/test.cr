# Nop
nil
# => null

# Bool
true
# => true

false
# => false

# Number
1
# => 1

12.0
# => 12.0

# Char
'c'
# => 'c'

# String
"string"
# => `c`

"string interpolation #{true}"
# => `string interpolation ${true}`

# Array
[] of String
# => []

[1, 2, 3]
# => [1, 2, 3]

# Hash
{"hash" => true}
# => {"hash": true}

# Named Tuple
{named_tuple: true}
# => {named_tuple: true}

{x: 32, y: 32}
# => {x: 32, y: 32}

# Range
0..50

50..100

0...50

50...100

# Regex
/regex : true!/im
# => /regex : true!/gim

# Creates regex but throws a warning
/(?<uh_oh>extended regex is not supported)/x
# => /(?<uh_oh>extended regex is not supported)/g

/regex #{"interpolation #{true}"}/im
# => /regex ${"interpolation #{true}"}/im

# Tuple
{1, 2, 3}
# => [1, 2, 3]

# Variables need to be assigned before it's recongnized as a variable
x = 1
x

# Call
# Empty calls need to be prefixed () like js.
# Otherwise any undefined variabled would be calls like a being a()
empty_call()

empty_call_variable

call_args(a, b, c)

# Block
call_block do
  true
end

call_block do |c, d|
  true
end

call_block_args(a, b, c) do |c, d|
  true
end

call_block_alt { |c, d| true }

# Will not compile
# call_block_alt_args a, b, c { |c, d| true }

# Named Arguments
call_named_arg(named: "true")

# Will not compile
# call_named_args(a, c: false, b)

# Will not function correctly
call_named_args(a, c: false, b: "second_argument")

# If
if true
  true
end

# else
if !false
  true
else
  false
end

# elsif
if false
  false
elsif !true
  false
else
  true
end

# Unless
unless false
  true
end
