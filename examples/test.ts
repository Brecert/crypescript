null
true
false
1
12.0
'c'
"string"
`string interpolation ${true}`
[]
[1, 2, 3]
{"hash": true}
{named_tuple: true}
{x: 32,y: 32}
[...Array(50 - 0 - 1).keys()].map(i => i + 0)
[...Array(100 - 50 - 1).keys()].map(i => i + 50)
[...Array(50 - 0 - 1).keys()].map(i => i + 0)
[...Array(100 - 50 - 1).keys()].map(i => i + 50)
/regex : true!/gi
/(?<uh_oh>extended regex is not supported)/g
/regex ${"interpolation #{true}"}/gi
[1, 2, 3]
let x = 1
x
empty_call()
empty_call_variable
call_args(a, b, c)
call_block(function() { true })
call_block(function(c, d) { true })
call_block_args(a, b, c, function(c, d) { true })
call_block_alt(function(c, d) { true })
call_named_arg("true")
call_named_args(a, false, "second_argument")
if(true) { true }
if(!false) { true } else { false }
if(false) { false } else { if(!true) { false } else { true } }
if(!false) { true }