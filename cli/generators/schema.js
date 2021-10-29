(function(scope){
'use strict';

function F(arity, fun, wrapper) {
  wrapper.a = arity;
  wrapper.f = fun;
  return wrapper;
}

function F2(fun) {
  return F(2, fun, function(a) { return function(b) { return fun(a,b); }; })
}
function F3(fun) {
  return F(3, fun, function(a) {
    return function(b) { return function(c) { return fun(a, b, c); }; };
  });
}
function F4(fun) {
  return F(4, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return fun(a, b, c, d); }; }; };
  });
}
function F5(fun) {
  return F(5, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return fun(a, b, c, d, e); }; }; }; };
  });
}
function F6(fun) {
  return F(6, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return fun(a, b, c, d, e, f); }; }; }; }; };
  });
}
function F7(fun) {
  return F(7, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return fun(a, b, c, d, e, f, g); }; }; }; }; }; };
  });
}
function F8(fun) {
  return F(8, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) {
    return fun(a, b, c, d, e, f, g, h); }; }; }; }; }; }; };
  });
}
function F9(fun) {
  return F(9, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) { return function(i) {
    return fun(a, b, c, d, e, f, g, h, i); }; }; }; }; }; }; }; };
  });
}

function A2(fun, a, b) {
  return fun.a === 2 ? fun.f(a, b) : fun(a)(b);
}
function A3(fun, a, b, c) {
  return fun.a === 3 ? fun.f(a, b, c) : fun(a)(b)(c);
}
function A4(fun, a, b, c, d) {
  return fun.a === 4 ? fun.f(a, b, c, d) : fun(a)(b)(c)(d);
}
function A5(fun, a, b, c, d, e) {
  return fun.a === 5 ? fun.f(a, b, c, d, e) : fun(a)(b)(c)(d)(e);
}
function A6(fun, a, b, c, d, e, f) {
  return fun.a === 6 ? fun.f(a, b, c, d, e, f) : fun(a)(b)(c)(d)(e)(f);
}
function A7(fun, a, b, c, d, e, f, g) {
  return fun.a === 7 ? fun.f(a, b, c, d, e, f, g) : fun(a)(b)(c)(d)(e)(f)(g);
}
function A8(fun, a, b, c, d, e, f, g, h) {
  return fun.a === 8 ? fun.f(a, b, c, d, e, f, g, h) : fun(a)(b)(c)(d)(e)(f)(g)(h);
}
function A9(fun, a, b, c, d, e, f, g, h, i) {
  return fun.a === 9 ? fun.f(a, b, c, d, e, f, g, h, i) : fun(a)(b)(c)(d)(e)(f)(g)(h)(i);
}

console.warn('Compiled in DEV mode. Follow the advice at https://elm-lang.org/0.19.1/optimize for better performance and smaller assets.');


var _List_Nil_UNUSED = { $: 0 };
var _List_Nil = { $: '[]' };

function _List_Cons_UNUSED(hd, tl) { return { $: 1, a: hd, b: tl }; }
function _List_Cons(hd, tl) { return { $: '::', a: hd, b: tl }; }


var _List_cons = F2(_List_Cons);

function _List_fromArray(arr)
{
	var out = _List_Nil;
	for (var i = arr.length; i--; )
	{
		out = _List_Cons(arr[i], out);
	}
	return out;
}

function _List_toArray(xs)
{
	for (var out = []; xs.b; xs = xs.b) // WHILE_CONS
	{
		out.push(xs.a);
	}
	return out;
}

var _List_map2 = F3(function(f, xs, ys)
{
	for (var arr = []; xs.b && ys.b; xs = xs.b, ys = ys.b) // WHILE_CONSES
	{
		arr.push(A2(f, xs.a, ys.a));
	}
	return _List_fromArray(arr);
});

var _List_map3 = F4(function(f, xs, ys, zs)
{
	for (var arr = []; xs.b && ys.b && zs.b; xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A3(f, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map4 = F5(function(f, ws, xs, ys, zs)
{
	for (var arr = []; ws.b && xs.b && ys.b && zs.b; ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A4(f, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map5 = F6(function(f, vs, ws, xs, ys, zs)
{
	for (var arr = []; vs.b && ws.b && xs.b && ys.b && zs.b; vs = vs.b, ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A5(f, vs.a, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_sortBy = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		return _Utils_cmp(f(a), f(b));
	}));
});

var _List_sortWith = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		var ord = A2(f, a, b);
		return ord === $elm$core$Basics$EQ ? 0 : ord === $elm$core$Basics$LT ? -1 : 1;
	}));
});



var _JsArray_empty = [];

function _JsArray_singleton(value)
{
    return [value];
}

function _JsArray_length(array)
{
    return array.length;
}

var _JsArray_initialize = F3(function(size, offset, func)
{
    var result = new Array(size);

    for (var i = 0; i < size; i++)
    {
        result[i] = func(offset + i);
    }

    return result;
});

var _JsArray_initializeFromList = F2(function (max, ls)
{
    var result = new Array(max);

    for (var i = 0; i < max && ls.b; i++)
    {
        result[i] = ls.a;
        ls = ls.b;
    }

    result.length = i;
    return _Utils_Tuple2(result, ls);
});

var _JsArray_unsafeGet = F2(function(index, array)
{
    return array[index];
});

var _JsArray_unsafeSet = F3(function(index, value, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[index] = value;
    return result;
});

var _JsArray_push = F2(function(value, array)
{
    var length = array.length;
    var result = new Array(length + 1);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[length] = value;
    return result;
});

var _JsArray_foldl = F3(function(func, acc, array)
{
    var length = array.length;

    for (var i = 0; i < length; i++)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_foldr = F3(function(func, acc, array)
{
    for (var i = array.length - 1; i >= 0; i--)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_map = F2(function(func, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = func(array[i]);
    }

    return result;
});

var _JsArray_indexedMap = F3(function(func, offset, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = A2(func, offset + i, array[i]);
    }

    return result;
});

var _JsArray_slice = F3(function(from, to, array)
{
    return array.slice(from, to);
});

var _JsArray_appendN = F3(function(n, dest, source)
{
    var destLen = dest.length;
    var itemsToCopy = n - destLen;

    if (itemsToCopy > source.length)
    {
        itemsToCopy = source.length;
    }

    var size = destLen + itemsToCopy;
    var result = new Array(size);

    for (var i = 0; i < destLen; i++)
    {
        result[i] = dest[i];
    }

    for (var i = 0; i < itemsToCopy; i++)
    {
        result[i + destLen] = source[i];
    }

    return result;
});



// LOG

var _Debug_log_UNUSED = F2(function(tag, value)
{
	return value;
});

var _Debug_log = F2(function(tag, value)
{
	console.log(tag + ': ' + _Debug_toString(value));
	return value;
});


// TODOS

function _Debug_todo(moduleName, region)
{
	return function(message) {
		_Debug_crash(8, moduleName, region, message);
	};
}

function _Debug_todoCase(moduleName, region, value)
{
	return function(message) {
		_Debug_crash(9, moduleName, region, value, message);
	};
}


// TO STRING

function _Debug_toString_UNUSED(value)
{
	return '<internals>';
}

function _Debug_toString(value)
{
	return _Debug_toAnsiString(false, value);
}

function _Debug_toAnsiString(ansi, value)
{
	if (typeof value === 'function')
	{
		return _Debug_internalColor(ansi, '<function>');
	}

	if (typeof value === 'boolean')
	{
		return _Debug_ctorColor(ansi, value ? 'True' : 'False');
	}

	if (typeof value === 'number')
	{
		return _Debug_numberColor(ansi, value + '');
	}

	if (value instanceof String)
	{
		return _Debug_charColor(ansi, "'" + _Debug_addSlashes(value, true) + "'");
	}

	if (typeof value === 'string')
	{
		return _Debug_stringColor(ansi, '"' + _Debug_addSlashes(value, false) + '"');
	}

	if (typeof value === 'object' && '$' in value)
	{
		var tag = value.$;

		if (typeof tag === 'number')
		{
			return _Debug_internalColor(ansi, '<internals>');
		}

		if (tag[0] === '#')
		{
			var output = [];
			for (var k in value)
			{
				if (k === '$') continue;
				output.push(_Debug_toAnsiString(ansi, value[k]));
			}
			return '(' + output.join(',') + ')';
		}

		if (tag === 'Set_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Set')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Set$toList(value));
		}

		if (tag === 'RBNode_elm_builtin' || tag === 'RBEmpty_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Dict')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Dict$toList(value));
		}

		if (tag === 'Array_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Array')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Array$toList(value));
		}

		if (tag === '::' || tag === '[]')
		{
			var output = '[';

			value.b && (output += _Debug_toAnsiString(ansi, value.a), value = value.b)

			for (; value.b; value = value.b) // WHILE_CONS
			{
				output += ',' + _Debug_toAnsiString(ansi, value.a);
			}
			return output + ']';
		}

		var output = '';
		for (var i in value)
		{
			if (i === '$') continue;
			var str = _Debug_toAnsiString(ansi, value[i]);
			var c0 = str[0];
			var parenless = c0 === '{' || c0 === '(' || c0 === '[' || c0 === '<' || c0 === '"' || str.indexOf(' ') < 0;
			output += ' ' + (parenless ? str : '(' + str + ')');
		}
		return _Debug_ctorColor(ansi, tag) + output;
	}

	if (typeof DataView === 'function' && value instanceof DataView)
	{
		return _Debug_stringColor(ansi, '<' + value.byteLength + ' bytes>');
	}

	if (typeof File !== 'undefined' && value instanceof File)
	{
		return _Debug_internalColor(ansi, '<' + value.name + '>');
	}

	if (typeof value === 'object')
	{
		var output = [];
		for (var key in value)
		{
			var field = key[0] === '_' ? key.slice(1) : key;
			output.push(_Debug_fadeColor(ansi, field) + ' = ' + _Debug_toAnsiString(ansi, value[key]));
		}
		if (output.length === 0)
		{
			return '{}';
		}
		return '{ ' + output.join(', ') + ' }';
	}

	return _Debug_internalColor(ansi, '<internals>');
}

function _Debug_addSlashes(str, isChar)
{
	var s = str
		.replace(/\\/g, '\\\\')
		.replace(/\n/g, '\\n')
		.replace(/\t/g, '\\t')
		.replace(/\r/g, '\\r')
		.replace(/\v/g, '\\v')
		.replace(/\0/g, '\\0');

	if (isChar)
	{
		return s.replace(/\'/g, '\\\'');
	}
	else
	{
		return s.replace(/\"/g, '\\"');
	}
}

function _Debug_ctorColor(ansi, string)
{
	return ansi ? '\x1b[96m' + string + '\x1b[0m' : string;
}

function _Debug_numberColor(ansi, string)
{
	return ansi ? '\x1b[95m' + string + '\x1b[0m' : string;
}

function _Debug_stringColor(ansi, string)
{
	return ansi ? '\x1b[93m' + string + '\x1b[0m' : string;
}

function _Debug_charColor(ansi, string)
{
	return ansi ? '\x1b[92m' + string + '\x1b[0m' : string;
}

function _Debug_fadeColor(ansi, string)
{
	return ansi ? '\x1b[37m' + string + '\x1b[0m' : string;
}

function _Debug_internalColor(ansi, string)
{
	return ansi ? '\x1b[36m' + string + '\x1b[0m' : string;
}

function _Debug_toHexDigit(n)
{
	return String.fromCharCode(n < 10 ? 48 + n : 55 + n);
}


// CRASH


function _Debug_crash_UNUSED(identifier)
{
	throw new Error('https://github.com/elm/core/blob/1.0.0/hints/' + identifier + '.md');
}


function _Debug_crash(identifier, fact1, fact2, fact3, fact4)
{
	switch(identifier)
	{
		case 0:
			throw new Error('What node should I take over? In JavaScript I need something like:\n\n    Elm.Main.init({\n        node: document.getElementById("elm-node")\n    })\n\nYou need to do this with any Browser.sandbox or Browser.element program.');

		case 1:
			throw new Error('Browser.application programs cannot handle URLs like this:\n\n    ' + document.location.href + '\n\nWhat is the root? The root of your file system? Try looking at this program with `elm reactor` or some other server.');

		case 2:
			var jsonErrorString = fact1;
			throw new Error('Problem with the flags given to your Elm program on initialization.\n\n' + jsonErrorString);

		case 3:
			var portName = fact1;
			throw new Error('There can only be one port named `' + portName + '`, but your program has multiple.');

		case 4:
			var portName = fact1;
			var problem = fact2;
			throw new Error('Trying to send an unexpected type of value through port `' + portName + '`:\n' + problem);

		case 5:
			throw new Error('Trying to use `(==)` on functions.\nThere is no way to know if functions are "the same" in the Elm sense.\nRead more about this at https://package.elm-lang.org/packages/elm/core/latest/Basics#== which describes why it is this way and what the better version will look like.');

		case 6:
			var moduleName = fact1;
			throw new Error('Your page is loading multiple Elm scripts with a module named ' + moduleName + '. Maybe a duplicate script is getting loaded accidentally? If not, rename one of them so I know which is which!');

		case 8:
			var moduleName = fact1;
			var region = fact2;
			var message = fact3;
			throw new Error('TODO in module `' + moduleName + '` ' + _Debug_regionToString(region) + '\n\n' + message);

		case 9:
			var moduleName = fact1;
			var region = fact2;
			var value = fact3;
			var message = fact4;
			throw new Error(
				'TODO in module `' + moduleName + '` from the `case` expression '
				+ _Debug_regionToString(region) + '\n\nIt received the following value:\n\n    '
				+ _Debug_toString(value).replace('\n', '\n    ')
				+ '\n\nBut the branch that handles it says:\n\n    ' + message.replace('\n', '\n    ')
			);

		case 10:
			throw new Error('Bug in https://github.com/elm/virtual-dom/issues');

		case 11:
			throw new Error('Cannot perform mod 0. Division by zero error.');
	}
}

function _Debug_regionToString(region)
{
	if (region.start.line === region.end.line)
	{
		return 'on line ' + region.start.line;
	}
	return 'on lines ' + region.start.line + ' through ' + region.end.line;
}



// EQUALITY

function _Utils_eq(x, y)
{
	for (
		var pair, stack = [], isEqual = _Utils_eqHelp(x, y, 0, stack);
		isEqual && (pair = stack.pop());
		isEqual = _Utils_eqHelp(pair.a, pair.b, 0, stack)
		)
	{}

	return isEqual;
}

function _Utils_eqHelp(x, y, depth, stack)
{
	if (x === y)
	{
		return true;
	}

	if (typeof x !== 'object' || x === null || y === null)
	{
		typeof x === 'function' && _Debug_crash(5);
		return false;
	}

	if (depth > 100)
	{
		stack.push(_Utils_Tuple2(x,y));
		return true;
	}

	/**/
	if (x.$ === 'Set_elm_builtin')
	{
		x = $elm$core$Set$toList(x);
		y = $elm$core$Set$toList(y);
	}
	if (x.$ === 'RBNode_elm_builtin' || x.$ === 'RBEmpty_elm_builtin')
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	/**_UNUSED/
	if (x.$ < 0)
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	for (var key in x)
	{
		if (!_Utils_eqHelp(x[key], y[key], depth + 1, stack))
		{
			return false;
		}
	}
	return true;
}

var _Utils_equal = F2(_Utils_eq);
var _Utils_notEqual = F2(function(a, b) { return !_Utils_eq(a,b); });



// COMPARISONS

// Code in Generate/JavaScript.hs, Basics.js, and List.js depends on
// the particular integer values assigned to LT, EQ, and GT.

function _Utils_cmp(x, y, ord)
{
	if (typeof x !== 'object')
	{
		return x === y ? /*EQ*/ 0 : x < y ? /*LT*/ -1 : /*GT*/ 1;
	}

	/**/
	if (x instanceof String)
	{
		var a = x.valueOf();
		var b = y.valueOf();
		return a === b ? 0 : a < b ? -1 : 1;
	}
	//*/

	/**_UNUSED/
	if (typeof x.$ === 'undefined')
	//*/
	/**/
	if (x.$[0] === '#')
	//*/
	{
		return (ord = _Utils_cmp(x.a, y.a))
			? ord
			: (ord = _Utils_cmp(x.b, y.b))
				? ord
				: _Utils_cmp(x.c, y.c);
	}

	// traverse conses until end of a list or a mismatch
	for (; x.b && y.b && !(ord = _Utils_cmp(x.a, y.a)); x = x.b, y = y.b) {} // WHILE_CONSES
	return ord || (x.b ? /*GT*/ 1 : y.b ? /*LT*/ -1 : /*EQ*/ 0);
}

var _Utils_lt = F2(function(a, b) { return _Utils_cmp(a, b) < 0; });
var _Utils_le = F2(function(a, b) { return _Utils_cmp(a, b) < 1; });
var _Utils_gt = F2(function(a, b) { return _Utils_cmp(a, b) > 0; });
var _Utils_ge = F2(function(a, b) { return _Utils_cmp(a, b) >= 0; });

var _Utils_compare = F2(function(x, y)
{
	var n = _Utils_cmp(x, y);
	return n < 0 ? $elm$core$Basics$LT : n ? $elm$core$Basics$GT : $elm$core$Basics$EQ;
});


// COMMON VALUES

var _Utils_Tuple0_UNUSED = 0;
var _Utils_Tuple0 = { $: '#0' };

function _Utils_Tuple2_UNUSED(a, b) { return { a: a, b: b }; }
function _Utils_Tuple2(a, b) { return { $: '#2', a: a, b: b }; }

function _Utils_Tuple3_UNUSED(a, b, c) { return { a: a, b: b, c: c }; }
function _Utils_Tuple3(a, b, c) { return { $: '#3', a: a, b: b, c: c }; }

function _Utils_chr_UNUSED(c) { return c; }
function _Utils_chr(c) { return new String(c); }


// RECORDS

function _Utils_update(oldRecord, updatedFields)
{
	var newRecord = {};

	for (var key in oldRecord)
	{
		newRecord[key] = oldRecord[key];
	}

	for (var key in updatedFields)
	{
		newRecord[key] = updatedFields[key];
	}

	return newRecord;
}


// APPEND

var _Utils_append = F2(_Utils_ap);

function _Utils_ap(xs, ys)
{
	// append Strings
	if (typeof xs === 'string')
	{
		return xs + ys;
	}

	// append Lists
	if (!xs.b)
	{
		return ys;
	}
	var root = _List_Cons(xs.a, ys);
	xs = xs.b
	for (var curr = root; xs.b; xs = xs.b) // WHILE_CONS
	{
		curr = curr.b = _List_Cons(xs.a, ys);
	}
	return root;
}



// MATH

var _Basics_add = F2(function(a, b) { return a + b; });
var _Basics_sub = F2(function(a, b) { return a - b; });
var _Basics_mul = F2(function(a, b) { return a * b; });
var _Basics_fdiv = F2(function(a, b) { return a / b; });
var _Basics_idiv = F2(function(a, b) { return (a / b) | 0; });
var _Basics_pow = F2(Math.pow);

var _Basics_remainderBy = F2(function(b, a) { return a % b; });

// https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/divmodnote-letter.pdf
var _Basics_modBy = F2(function(modulus, x)
{
	var answer = x % modulus;
	return modulus === 0
		? _Debug_crash(11)
		:
	((answer > 0 && modulus < 0) || (answer < 0 && modulus > 0))
		? answer + modulus
		: answer;
});


// TRIGONOMETRY

var _Basics_pi = Math.PI;
var _Basics_e = Math.E;
var _Basics_cos = Math.cos;
var _Basics_sin = Math.sin;
var _Basics_tan = Math.tan;
var _Basics_acos = Math.acos;
var _Basics_asin = Math.asin;
var _Basics_atan = Math.atan;
var _Basics_atan2 = F2(Math.atan2);


// MORE MATH

function _Basics_toFloat(x) { return x; }
function _Basics_truncate(n) { return n | 0; }
function _Basics_isInfinite(n) { return n === Infinity || n === -Infinity; }

var _Basics_ceiling = Math.ceil;
var _Basics_floor = Math.floor;
var _Basics_round = Math.round;
var _Basics_sqrt = Math.sqrt;
var _Basics_log = Math.log;
var _Basics_isNaN = isNaN;


// BOOLEANS

function _Basics_not(bool) { return !bool; }
var _Basics_and = F2(function(a, b) { return a && b; });
var _Basics_or  = F2(function(a, b) { return a || b; });
var _Basics_xor = F2(function(a, b) { return a !== b; });



var _String_cons = F2(function(chr, str)
{
	return chr + str;
});

function _String_uncons(string)
{
	var word = string.charCodeAt(0);
	return !isNaN(word)
		? $elm$core$Maybe$Just(
			0xD800 <= word && word <= 0xDBFF
				? _Utils_Tuple2(_Utils_chr(string[0] + string[1]), string.slice(2))
				: _Utils_Tuple2(_Utils_chr(string[0]), string.slice(1))
		)
		: $elm$core$Maybe$Nothing;
}

var _String_append = F2(function(a, b)
{
	return a + b;
});

function _String_length(str)
{
	return str.length;
}

var _String_map = F2(function(func, string)
{
	var len = string.length;
	var array = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = string.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			array[i] = func(_Utils_chr(string[i] + string[i+1]));
			i += 2;
			continue;
		}
		array[i] = func(_Utils_chr(string[i]));
		i++;
	}
	return array.join('');
});

var _String_filter = F2(function(isGood, str)
{
	var arr = [];
	var len = str.length;
	var i = 0;
	while (i < len)
	{
		var char = str[i];
		var word = str.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += str[i];
			i++;
		}

		if (isGood(_Utils_chr(char)))
		{
			arr.push(char);
		}
	}
	return arr.join('');
});

function _String_reverse(str)
{
	var len = str.length;
	var arr = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = str.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			arr[len - i] = str[i + 1];
			i++;
			arr[len - i] = str[i - 1];
			i++;
		}
		else
		{
			arr[len - i] = str[i];
			i++;
		}
	}
	return arr.join('');
}

var _String_foldl = F3(function(func, state, string)
{
	var len = string.length;
	var i = 0;
	while (i < len)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += string[i];
			i++;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_foldr = F3(function(func, state, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_split = F2(function(sep, str)
{
	return str.split(sep);
});

var _String_join = F2(function(sep, strs)
{
	return strs.join(sep);
});

var _String_slice = F3(function(start, end, str) {
	return str.slice(start, end);
});

function _String_trim(str)
{
	return str.trim();
}

function _String_trimLeft(str)
{
	return str.replace(/^\s+/, '');
}

function _String_trimRight(str)
{
	return str.replace(/\s+$/, '');
}

function _String_words(str)
{
	return _List_fromArray(str.trim().split(/\s+/g));
}

function _String_lines(str)
{
	return _List_fromArray(str.split(/\r\n|\r|\n/g));
}

function _String_toUpper(str)
{
	return str.toUpperCase();
}

function _String_toLower(str)
{
	return str.toLowerCase();
}

var _String_any = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (isGood(_Utils_chr(char)))
		{
			return true;
		}
	}
	return false;
});

var _String_all = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (!isGood(_Utils_chr(char)))
		{
			return false;
		}
	}
	return true;
});

var _String_contains = F2(function(sub, str)
{
	return str.indexOf(sub) > -1;
});

var _String_startsWith = F2(function(sub, str)
{
	return str.indexOf(sub) === 0;
});

var _String_endsWith = F2(function(sub, str)
{
	return str.length >= sub.length &&
		str.lastIndexOf(sub) === str.length - sub.length;
});

var _String_indexes = F2(function(sub, str)
{
	var subLen = sub.length;

	if (subLen < 1)
	{
		return _List_Nil;
	}

	var i = 0;
	var is = [];

	while ((i = str.indexOf(sub, i)) > -1)
	{
		is.push(i);
		i = i + subLen;
	}

	return _List_fromArray(is);
});


// TO STRING

function _String_fromNumber(number)
{
	return number + '';
}


// INT CONVERSIONS

function _String_toInt(str)
{
	var total = 0;
	var code0 = str.charCodeAt(0);
	var start = code0 == 0x2B /* + */ || code0 == 0x2D /* - */ ? 1 : 0;

	for (var i = start; i < str.length; ++i)
	{
		var code = str.charCodeAt(i);
		if (code < 0x30 || 0x39 < code)
		{
			return $elm$core$Maybe$Nothing;
		}
		total = 10 * total + code - 0x30;
	}

	return i == start
		? $elm$core$Maybe$Nothing
		: $elm$core$Maybe$Just(code0 == 0x2D ? -total : total);
}


// FLOAT CONVERSIONS

function _String_toFloat(s)
{
	// check if it is a hex, octal, or binary number
	if (s.length === 0 || /[\sxbo]/.test(s))
	{
		return $elm$core$Maybe$Nothing;
	}
	var n = +s;
	// faster isNaN check
	return n === n ? $elm$core$Maybe$Just(n) : $elm$core$Maybe$Nothing;
}

function _String_fromList(chars)
{
	return _List_toArray(chars).join('');
}




function _Char_toCode(char)
{
	var code = char.charCodeAt(0);
	if (0xD800 <= code && code <= 0xDBFF)
	{
		return (code - 0xD800) * 0x400 + char.charCodeAt(1) - 0xDC00 + 0x10000
	}
	return code;
}

function _Char_fromCode(code)
{
	return _Utils_chr(
		(code < 0 || 0x10FFFF < code)
			? '\uFFFD'
			:
		(code <= 0xFFFF)
			? String.fromCharCode(code)
			:
		(code -= 0x10000,
			String.fromCharCode(Math.floor(code / 0x400) + 0xD800, code % 0x400 + 0xDC00)
		)
	);
}

function _Char_toUpper(char)
{
	return _Utils_chr(char.toUpperCase());
}

function _Char_toLower(char)
{
	return _Utils_chr(char.toLowerCase());
}

function _Char_toLocaleUpper(char)
{
	return _Utils_chr(char.toLocaleUpperCase());
}

function _Char_toLocaleLower(char)
{
	return _Utils_chr(char.toLocaleLowerCase());
}



/**/
function _Json_errorToString(error)
{
	return $elm$json$Json$Decode$errorToString(error);
}
//*/


// CORE DECODERS

function _Json_succeed(msg)
{
	return {
		$: 0,
		a: msg
	};
}

function _Json_fail(msg)
{
	return {
		$: 1,
		a: msg
	};
}

function _Json_decodePrim(decoder)
{
	return { $: 2, b: decoder };
}

var _Json_decodeInt = _Json_decodePrim(function(value) {
	return (typeof value !== 'number')
		? _Json_expecting('an INT', value)
		:
	(-2147483647 < value && value < 2147483647 && (value | 0) === value)
		? $elm$core$Result$Ok(value)
		:
	(isFinite(value) && !(value % 1))
		? $elm$core$Result$Ok(value)
		: _Json_expecting('an INT', value);
});

var _Json_decodeBool = _Json_decodePrim(function(value) {
	return (typeof value === 'boolean')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a BOOL', value);
});

var _Json_decodeFloat = _Json_decodePrim(function(value) {
	return (typeof value === 'number')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a FLOAT', value);
});

var _Json_decodeValue = _Json_decodePrim(function(value) {
	return $elm$core$Result$Ok(_Json_wrap(value));
});

var _Json_decodeString = _Json_decodePrim(function(value) {
	return (typeof value === 'string')
		? $elm$core$Result$Ok(value)
		: (value instanceof String)
			? $elm$core$Result$Ok(value + '')
			: _Json_expecting('a STRING', value);
});

function _Json_decodeList(decoder) { return { $: 3, b: decoder }; }
function _Json_decodeArray(decoder) { return { $: 4, b: decoder }; }

function _Json_decodeNull(value) { return { $: 5, c: value }; }

var _Json_decodeField = F2(function(field, decoder)
{
	return {
		$: 6,
		d: field,
		b: decoder
	};
});

var _Json_decodeIndex = F2(function(index, decoder)
{
	return {
		$: 7,
		e: index,
		b: decoder
	};
});

function _Json_decodeKeyValuePairs(decoder)
{
	return {
		$: 8,
		b: decoder
	};
}

function _Json_mapMany(f, decoders)
{
	return {
		$: 9,
		f: f,
		g: decoders
	};
}

var _Json_andThen = F2(function(callback, decoder)
{
	return {
		$: 10,
		b: decoder,
		h: callback
	};
});

function _Json_oneOf(decoders)
{
	return {
		$: 11,
		g: decoders
	};
}


// DECODING OBJECTS

var _Json_map1 = F2(function(f, d1)
{
	return _Json_mapMany(f, [d1]);
});

var _Json_map2 = F3(function(f, d1, d2)
{
	return _Json_mapMany(f, [d1, d2]);
});

var _Json_map3 = F4(function(f, d1, d2, d3)
{
	return _Json_mapMany(f, [d1, d2, d3]);
});

var _Json_map4 = F5(function(f, d1, d2, d3, d4)
{
	return _Json_mapMany(f, [d1, d2, d3, d4]);
});

var _Json_map5 = F6(function(f, d1, d2, d3, d4, d5)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5]);
});

var _Json_map6 = F7(function(f, d1, d2, d3, d4, d5, d6)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6]);
});

var _Json_map7 = F8(function(f, d1, d2, d3, d4, d5, d6, d7)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7]);
});

var _Json_map8 = F9(function(f, d1, d2, d3, d4, d5, d6, d7, d8)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7, d8]);
});


// DECODE

var _Json_runOnString = F2(function(decoder, string)
{
	try
	{
		var value = JSON.parse(string);
		return _Json_runHelp(decoder, value);
	}
	catch (e)
	{
		return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'This is not valid JSON! ' + e.message, _Json_wrap(string)));
	}
});

var _Json_run = F2(function(decoder, value)
{
	return _Json_runHelp(decoder, _Json_unwrap(value));
});

function _Json_runHelp(decoder, value)
{
	switch (decoder.$)
	{
		case 2:
			return decoder.b(value);

		case 5:
			return (value === null)
				? $elm$core$Result$Ok(decoder.c)
				: _Json_expecting('null', value);

		case 3:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('a LIST', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _List_fromArray);

		case 4:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _Json_toElmArray);

		case 6:
			var field = decoder.d;
			if (typeof value !== 'object' || value === null || !(field in value))
			{
				return _Json_expecting('an OBJECT with a field named `' + field + '`', value);
			}
			var result = _Json_runHelp(decoder.b, value[field]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, field, result.a));

		case 7:
			var index = decoder.e;
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			if (index >= value.length)
			{
				return _Json_expecting('a LONGER array. Need index ' + index + ' but only see ' + value.length + ' entries', value);
			}
			var result = _Json_runHelp(decoder.b, value[index]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, index, result.a));

		case 8:
			if (typeof value !== 'object' || value === null || _Json_isArray(value))
			{
				return _Json_expecting('an OBJECT', value);
			}

			var keyValuePairs = _List_Nil;
			// TODO test perf of Object.keys and switch when support is good enough
			for (var key in value)
			{
				if (value.hasOwnProperty(key))
				{
					var result = _Json_runHelp(decoder.b, value[key]);
					if (!$elm$core$Result$isOk(result))
					{
						return $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, key, result.a));
					}
					keyValuePairs = _List_Cons(_Utils_Tuple2(key, result.a), keyValuePairs);
				}
			}
			return $elm$core$Result$Ok($elm$core$List$reverse(keyValuePairs));

		case 9:
			var answer = decoder.f;
			var decoders = decoder.g;
			for (var i = 0; i < decoders.length; i++)
			{
				var result = _Json_runHelp(decoders[i], value);
				if (!$elm$core$Result$isOk(result))
				{
					return result;
				}
				answer = answer(result.a);
			}
			return $elm$core$Result$Ok(answer);

		case 10:
			var result = _Json_runHelp(decoder.b, value);
			return (!$elm$core$Result$isOk(result))
				? result
				: _Json_runHelp(decoder.h(result.a), value);

		case 11:
			var errors = _List_Nil;
			for (var temp = decoder.g; temp.b; temp = temp.b) // WHILE_CONS
			{
				var result = _Json_runHelp(temp.a, value);
				if ($elm$core$Result$isOk(result))
				{
					return result;
				}
				errors = _List_Cons(result.a, errors);
			}
			return $elm$core$Result$Err($elm$json$Json$Decode$OneOf($elm$core$List$reverse(errors)));

		case 1:
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, decoder.a, _Json_wrap(value)));

		case 0:
			return $elm$core$Result$Ok(decoder.a);
	}
}

function _Json_runArrayDecoder(decoder, value, toElmValue)
{
	var len = value.length;
	var array = new Array(len);
	for (var i = 0; i < len; i++)
	{
		var result = _Json_runHelp(decoder, value[i]);
		if (!$elm$core$Result$isOk(result))
		{
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, i, result.a));
		}
		array[i] = result.a;
	}
	return $elm$core$Result$Ok(toElmValue(array));
}

function _Json_isArray(value)
{
	return Array.isArray(value) || (typeof FileList !== 'undefined' && value instanceof FileList);
}

function _Json_toElmArray(array)
{
	return A2($elm$core$Array$initialize, array.length, function(i) { return array[i]; });
}

function _Json_expecting(type, value)
{
	return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'Expecting ' + type, _Json_wrap(value)));
}


// EQUALITY

function _Json_equality(x, y)
{
	if (x === y)
	{
		return true;
	}

	if (x.$ !== y.$)
	{
		return false;
	}

	switch (x.$)
	{
		case 0:
		case 1:
			return x.a === y.a;

		case 2:
			return x.b === y.b;

		case 5:
			return x.c === y.c;

		case 3:
		case 4:
		case 8:
			return _Json_equality(x.b, y.b);

		case 6:
			return x.d === y.d && _Json_equality(x.b, y.b);

		case 7:
			return x.e === y.e && _Json_equality(x.b, y.b);

		case 9:
			return x.f === y.f && _Json_listEquality(x.g, y.g);

		case 10:
			return x.h === y.h && _Json_equality(x.b, y.b);

		case 11:
			return _Json_listEquality(x.g, y.g);
	}
}

function _Json_listEquality(aDecoders, bDecoders)
{
	var len = aDecoders.length;
	if (len !== bDecoders.length)
	{
		return false;
	}
	for (var i = 0; i < len; i++)
	{
		if (!_Json_equality(aDecoders[i], bDecoders[i]))
		{
			return false;
		}
	}
	return true;
}


// ENCODE

var _Json_encode = F2(function(indentLevel, value)
{
	return JSON.stringify(_Json_unwrap(value), null, indentLevel) + '';
});

function _Json_wrap(value) { return { $: 0, a: value }; }
function _Json_unwrap(value) { return value.a; }

function _Json_wrap_UNUSED(value) { return value; }
function _Json_unwrap_UNUSED(value) { return value; }

function _Json_emptyArray() { return []; }
function _Json_emptyObject() { return {}; }

var _Json_addField = F3(function(key, value, object)
{
	object[key] = _Json_unwrap(value);
	return object;
});

function _Json_addEntry(func)
{
	return F2(function(entry, array)
	{
		array.push(_Json_unwrap(func(entry)));
		return array;
	});
}

var _Json_encodeNull = _Json_wrap(null);



var _Bitwise_and = F2(function(a, b)
{
	return a & b;
});

var _Bitwise_or = F2(function(a, b)
{
	return a | b;
});

var _Bitwise_xor = F2(function(a, b)
{
	return a ^ b;
});

function _Bitwise_complement(a)
{
	return ~a;
};

var _Bitwise_shiftLeftBy = F2(function(offset, a)
{
	return a << offset;
});

var _Bitwise_shiftRightBy = F2(function(offset, a)
{
	return a >> offset;
});

var _Bitwise_shiftRightZfBy = F2(function(offset, a)
{
	return a >>> offset;
});



// TASKS

function _Scheduler_succeed(value)
{
	return {
		$: 0,
		a: value
	};
}

function _Scheduler_fail(error)
{
	return {
		$: 1,
		a: error
	};
}

function _Scheduler_binding(callback)
{
	return {
		$: 2,
		b: callback,
		c: null
	};
}

var _Scheduler_andThen = F2(function(callback, task)
{
	return {
		$: 3,
		b: callback,
		d: task
	};
});

var _Scheduler_onError = F2(function(callback, task)
{
	return {
		$: 4,
		b: callback,
		d: task
	};
});

function _Scheduler_receive(callback)
{
	return {
		$: 5,
		b: callback
	};
}


// PROCESSES

var _Scheduler_guid = 0;

function _Scheduler_rawSpawn(task)
{
	var proc = {
		$: 0,
		e: _Scheduler_guid++,
		f: task,
		g: null,
		h: []
	};

	_Scheduler_enqueue(proc);

	return proc;
}

function _Scheduler_spawn(task)
{
	return _Scheduler_binding(function(callback) {
		callback(_Scheduler_succeed(_Scheduler_rawSpawn(task)));
	});
}

function _Scheduler_rawSend(proc, msg)
{
	proc.h.push(msg);
	_Scheduler_enqueue(proc);
}

var _Scheduler_send = F2(function(proc, msg)
{
	return _Scheduler_binding(function(callback) {
		_Scheduler_rawSend(proc, msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});

function _Scheduler_kill(proc)
{
	return _Scheduler_binding(function(callback) {
		var task = proc.f;
		if (task.$ === 2 && task.c)
		{
			task.c();
		}

		proc.f = null;

		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
}


/* STEP PROCESSES

type alias Process =
  { $ : tag
  , id : unique_id
  , root : Task
  , stack : null | { $: SUCCEED | FAIL, a: callback, b: stack }
  , mailbox : [msg]
  }

*/


var _Scheduler_working = false;
var _Scheduler_queue = [];


function _Scheduler_enqueue(proc)
{
	_Scheduler_queue.push(proc);
	if (_Scheduler_working)
	{
		return;
	}
	_Scheduler_working = true;
	while (proc = _Scheduler_queue.shift())
	{
		_Scheduler_step(proc);
	}
	_Scheduler_working = false;
}


function _Scheduler_step(proc)
{
	while (proc.f)
	{
		var rootTag = proc.f.$;
		if (rootTag === 0 || rootTag === 1)
		{
			while (proc.g && proc.g.$ !== rootTag)
			{
				proc.g = proc.g.i;
			}
			if (!proc.g)
			{
				return;
			}
			proc.f = proc.g.b(proc.f.a);
			proc.g = proc.g.i;
		}
		else if (rootTag === 2)
		{
			proc.f.c = proc.f.b(function(newRoot) {
				proc.f = newRoot;
				_Scheduler_enqueue(proc);
			});
			return;
		}
		else if (rootTag === 5)
		{
			if (proc.h.length === 0)
			{
				return;
			}
			proc.f = proc.f.b(proc.h.shift());
		}
		else // if (rootTag === 3 || rootTag === 4)
		{
			proc.g = {
				$: rootTag === 3 ? 0 : 1,
				b: proc.f.b,
				i: proc.g
			};
			proc.f = proc.f.d;
		}
	}
}



function _Process_sleep(time)
{
	return _Scheduler_binding(function(callback) {
		var id = setTimeout(function() {
			callback(_Scheduler_succeed(_Utils_Tuple0));
		}, time);

		return function() { clearTimeout(id); };
	});
}




// PROGRAMS


var _Platform_worker = F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function() { return function() {} }
	);
});



// INITIALIZE A PROGRAM


function _Platform_initialize(flagDecoder, args, init, update, subscriptions, stepperBuilder)
{
	var result = A2(_Json_run, flagDecoder, _Json_wrap(args ? args['flags'] : undefined));
	$elm$core$Result$isOk(result) || _Debug_crash(2 /**/, _Json_errorToString(result.a) /**/);
	var managers = {};
	var initPair = init(result.a);
	var model = initPair.a;
	var stepper = stepperBuilder(sendToApp, model);
	var ports = _Platform_setupEffects(managers, sendToApp);

	function sendToApp(msg, viewMetadata)
	{
		var pair = A2(update, msg, model);
		stepper(model = pair.a, viewMetadata);
		_Platform_enqueueEffects(managers, pair.b, subscriptions(model));
	}

	_Platform_enqueueEffects(managers, initPair.b, subscriptions(model));

	return ports ? { ports: ports } : {};
}



// TRACK PRELOADS
//
// This is used by code in elm/browser and elm/http
// to register any HTTP requests that are triggered by init.
//


var _Platform_preload;


function _Platform_registerPreload(url)
{
	_Platform_preload.add(url);
}



// EFFECT MANAGERS


var _Platform_effectManagers = {};


function _Platform_setupEffects(managers, sendToApp)
{
	var ports;

	// setup all necessary effect managers
	for (var key in _Platform_effectManagers)
	{
		var manager = _Platform_effectManagers[key];

		if (manager.a)
		{
			ports = ports || {};
			ports[key] = manager.a(key, sendToApp);
		}

		managers[key] = _Platform_instantiateManager(manager, sendToApp);
	}

	return ports;
}


function _Platform_createManager(init, onEffects, onSelfMsg, cmdMap, subMap)
{
	return {
		b: init,
		c: onEffects,
		d: onSelfMsg,
		e: cmdMap,
		f: subMap
	};
}


function _Platform_instantiateManager(info, sendToApp)
{
	var router = {
		g: sendToApp,
		h: undefined
	};

	var onEffects = info.c;
	var onSelfMsg = info.d;
	var cmdMap = info.e;
	var subMap = info.f;

	function loop(state)
	{
		return A2(_Scheduler_andThen, loop, _Scheduler_receive(function(msg)
		{
			var value = msg.a;

			if (msg.$ === 0)
			{
				return A3(onSelfMsg, router, value, state);
			}

			return cmdMap && subMap
				? A4(onEffects, router, value.i, value.j, state)
				: A3(onEffects, router, cmdMap ? value.i : value.j, state);
		}));
	}

	return router.h = _Scheduler_rawSpawn(A2(_Scheduler_andThen, loop, info.b));
}



// ROUTING


var _Platform_sendToApp = F2(function(router, msg)
{
	return _Scheduler_binding(function(callback)
	{
		router.g(msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});


var _Platform_sendToSelf = F2(function(router, msg)
{
	return A2(_Scheduler_send, router.h, {
		$: 0,
		a: msg
	});
});



// BAGS


function _Platform_leaf(home)
{
	return function(value)
	{
		return {
			$: 1,
			k: home,
			l: value
		};
	};
}


function _Platform_batch(list)
{
	return {
		$: 2,
		m: list
	};
}


var _Platform_map = F2(function(tagger, bag)
{
	return {
		$: 3,
		n: tagger,
		o: bag
	}
});



// PIPE BAGS INTO EFFECT MANAGERS
//
// Effects must be queued!
//
// Say your init contains a synchronous command, like Time.now or Time.here
//
//   - This will produce a batch of effects (FX_1)
//   - The synchronous task triggers the subsequent `update` call
//   - This will produce a batch of effects (FX_2)
//
// If we just start dispatching FX_2, subscriptions from FX_2 can be processed
// before subscriptions from FX_1. No good! Earlier versions of this code had
// this problem, leading to these reports:
//
//   https://github.com/elm/core/issues/980
//   https://github.com/elm/core/pull/981
//   https://github.com/elm/compiler/issues/1776
//
// The queue is necessary to avoid ordering issues for synchronous commands.


// Why use true/false here? Why not just check the length of the queue?
// The goal is to detect "are we currently dispatching effects?" If we
// are, we need to bail and let the ongoing while loop handle things.
//
// Now say the queue has 1 element. When we dequeue the final element,
// the queue will be empty, but we are still actively dispatching effects.
// So you could get queue jumping in a really tricky category of cases.
//
var _Platform_effectsQueue = [];
var _Platform_effectsActive = false;


function _Platform_enqueueEffects(managers, cmdBag, subBag)
{
	_Platform_effectsQueue.push({ p: managers, q: cmdBag, r: subBag });

	if (_Platform_effectsActive) return;

	_Platform_effectsActive = true;
	for (var fx; fx = _Platform_effectsQueue.shift(); )
	{
		_Platform_dispatchEffects(fx.p, fx.q, fx.r);
	}
	_Platform_effectsActive = false;
}


function _Platform_dispatchEffects(managers, cmdBag, subBag)
{
	var effectsDict = {};
	_Platform_gatherEffects(true, cmdBag, effectsDict, null);
	_Platform_gatherEffects(false, subBag, effectsDict, null);

	for (var home in managers)
	{
		_Scheduler_rawSend(managers[home], {
			$: 'fx',
			a: effectsDict[home] || { i: _List_Nil, j: _List_Nil }
		});
	}
}


function _Platform_gatherEffects(isCmd, bag, effectsDict, taggers)
{
	switch (bag.$)
	{
		case 1:
			var home = bag.k;
			var effect = _Platform_toEffect(isCmd, home, taggers, bag.l);
			effectsDict[home] = _Platform_insert(isCmd, effect, effectsDict[home]);
			return;

		case 2:
			for (var list = bag.m; list.b; list = list.b) // WHILE_CONS
			{
				_Platform_gatherEffects(isCmd, list.a, effectsDict, taggers);
			}
			return;

		case 3:
			_Platform_gatherEffects(isCmd, bag.o, effectsDict, {
				s: bag.n,
				t: taggers
			});
			return;
	}
}


function _Platform_toEffect(isCmd, home, taggers, value)
{
	function applyTaggers(x)
	{
		for (var temp = taggers; temp; temp = temp.t)
		{
			x = temp.s(x);
		}
		return x;
	}

	var map = isCmd
		? _Platform_effectManagers[home].e
		: _Platform_effectManagers[home].f;

	return A2(map, applyTaggers, value)
}


function _Platform_insert(isCmd, newEffect, effects)
{
	effects = effects || { i: _List_Nil, j: _List_Nil };

	isCmd
		? (effects.i = _List_Cons(newEffect, effects.i))
		: (effects.j = _List_Cons(newEffect, effects.j));

	return effects;
}



// PORTS


function _Platform_checkPortName(name)
{
	if (_Platform_effectManagers[name])
	{
		_Debug_crash(3, name)
	}
}



// OUTGOING PORTS


function _Platform_outgoingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		e: _Platform_outgoingPortMap,
		u: converter,
		a: _Platform_setupOutgoingPort
	};
	return _Platform_leaf(name);
}


var _Platform_outgoingPortMap = F2(function(tagger, value) { return value; });


function _Platform_setupOutgoingPort(name)
{
	var subs = [];
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Process_sleep(0);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, cmdList, state)
	{
		for ( ; cmdList.b; cmdList = cmdList.b) // WHILE_CONS
		{
			// grab a separate reference to subs in case unsubscribe is called
			var currentSubs = subs;
			var value = _Json_unwrap(converter(cmdList.a));
			for (var i = 0; i < currentSubs.length; i++)
			{
				currentSubs[i](value);
			}
		}
		return init;
	});

	// PUBLIC API

	function subscribe(callback)
	{
		subs.push(callback);
	}

	function unsubscribe(callback)
	{
		// copy subs into a new array in case unsubscribe is called within a
		// subscribed callback
		subs = subs.slice();
		var index = subs.indexOf(callback);
		if (index >= 0)
		{
			subs.splice(index, 1);
		}
	}

	return {
		subscribe: subscribe,
		unsubscribe: unsubscribe
	};
}



// INCOMING PORTS


function _Platform_incomingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		f: _Platform_incomingPortMap,
		u: converter,
		a: _Platform_setupIncomingPort
	};
	return _Platform_leaf(name);
}


var _Platform_incomingPortMap = F2(function(tagger, finalTagger)
{
	return function(value)
	{
		return tagger(finalTagger(value));
	};
});


function _Platform_setupIncomingPort(name, sendToApp)
{
	var subs = _List_Nil;
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Scheduler_succeed(null);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, subList, state)
	{
		subs = subList;
		return init;
	});

	// PUBLIC API

	function send(incomingValue)
	{
		var result = A2(_Json_run, converter, _Json_wrap(incomingValue));

		$elm$core$Result$isOk(result) || _Debug_crash(4, name, result.a);

		var value = result.a;
		for (var temp = subs; temp.b; temp = temp.b) // WHILE_CONS
		{
			sendToApp(temp.a(value));
		}
	}

	return { send: send };
}



// EXPORT ELM MODULES
//
// Have DEBUG and PROD versions so that we can (1) give nicer errors in
// debug mode and (2) not pay for the bits needed for that in prod mode.
//


function _Platform_export_UNUSED(exports)
{
	scope['Elm']
		? _Platform_mergeExportsProd(scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsProd(obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6)
				: _Platform_mergeExportsProd(obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}


function _Platform_export(exports)
{
	scope['Elm']
		? _Platform_mergeExportsDebug('Elm', scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsDebug(moduleName, obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6, moduleName)
				: _Platform_mergeExportsDebug(moduleName + '.' + name, obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}



// SEND REQUEST

var _Http_toTask = F3(function(router, toTask, request)
{
	return _Scheduler_binding(function(callback)
	{
		function done(response) {
			callback(toTask(request.expect.a(response)));
		}

		var xhr = new XMLHttpRequest();
		xhr.addEventListener('error', function() { done($elm$http$Http$NetworkError_); });
		xhr.addEventListener('timeout', function() { done($elm$http$Http$Timeout_); });
		xhr.addEventListener('load', function() { done(_Http_toResponse(request.expect.b, xhr)); });
		$elm$core$Maybe$isJust(request.tracker) && _Http_track(router, xhr, request.tracker.a);

		try {
			xhr.open(request.method, request.url, true);
		} catch (e) {
			return done($elm$http$Http$BadUrl_(request.url));
		}

		_Http_configureRequest(xhr, request);

		request.body.a && xhr.setRequestHeader('Content-Type', request.body.a);
		xhr.send(request.body.b);

		return function() { xhr.c = true; xhr.abort(); };
	});
});


// CONFIGURE

function _Http_configureRequest(xhr, request)
{
	for (var headers = request.headers; headers.b; headers = headers.b) // WHILE_CONS
	{
		xhr.setRequestHeader(headers.a.a, headers.a.b);
	}
	xhr.timeout = request.timeout.a || 0;
	xhr.responseType = request.expect.d;
	xhr.withCredentials = request.allowCookiesFromOtherDomains;
}


// RESPONSES

function _Http_toResponse(toBody, xhr)
{
	return A2(
		200 <= xhr.status && xhr.status < 300 ? $elm$http$Http$GoodStatus_ : $elm$http$Http$BadStatus_,
		_Http_toMetadata(xhr),
		toBody(xhr.response)
	);
}


// METADATA

function _Http_toMetadata(xhr)
{
	return {
		url: xhr.responseURL,
		statusCode: xhr.status,
		statusText: xhr.statusText,
		headers: _Http_parseHeaders(xhr.getAllResponseHeaders())
	};
}


// HEADERS

function _Http_parseHeaders(rawHeaders)
{
	if (!rawHeaders)
	{
		return $elm$core$Dict$empty;
	}

	var headers = $elm$core$Dict$empty;
	var headerPairs = rawHeaders.split('\r\n');
	for (var i = headerPairs.length; i--; )
	{
		var headerPair = headerPairs[i];
		var index = headerPair.indexOf(': ');
		if (index > 0)
		{
			var key = headerPair.substring(0, index);
			var value = headerPair.substring(index + 2);

			headers = A3($elm$core$Dict$update, key, function(oldValue) {
				return $elm$core$Maybe$Just($elm$core$Maybe$isJust(oldValue)
					? value + ', ' + oldValue.a
					: value
				);
			}, headers);
		}
	}
	return headers;
}


// EXPECT

var _Http_expect = F3(function(type, toBody, toValue)
{
	return {
		$: 0,
		d: type,
		b: toBody,
		a: toValue
	};
});

var _Http_mapExpect = F2(function(func, expect)
{
	return {
		$: 0,
		d: expect.d,
		b: expect.b,
		a: function(x) { return func(expect.a(x)); }
	};
});

function _Http_toDataView(arrayBuffer)
{
	return new DataView(arrayBuffer);
}


// BODY and PARTS

var _Http_emptyBody = { $: 0 };
var _Http_pair = F2(function(a, b) { return { $: 0, a: a, b: b }; });

function _Http_toFormData(parts)
{
	for (var formData = new FormData(); parts.b; parts = parts.b) // WHILE_CONS
	{
		var part = parts.a;
		formData.append(part.a, part.b);
	}
	return formData;
}

var _Http_bytesToBlob = F2(function(mime, bytes)
{
	return new Blob([bytes], { type: mime });
});


// PROGRESS

function _Http_track(router, xhr, tracker)
{
	// TODO check out lengthComputable on loadstart event

	xhr.upload.addEventListener('progress', function(event) {
		if (xhr.c) { return; }
		_Scheduler_rawSpawn(A2($elm$core$Platform$sendToSelf, router, _Utils_Tuple2(tracker, $elm$http$Http$Sending({
			sent: event.loaded,
			size: event.total
		}))));
	});
	xhr.addEventListener('progress', function(event) {
		if (xhr.c) { return; }
		_Scheduler_rawSpawn(A2($elm$core$Platform$sendToSelf, router, _Utils_Tuple2(tracker, $elm$http$Http$Receiving({
			received: event.loaded,
			size: event.lengthComputable ? $elm$core$Maybe$Just(event.total) : $elm$core$Maybe$Nothing
		}))));
	});
}var $elm$core$Basics$EQ = {$: 'EQ'};
var $elm$core$Basics$LT = {$: 'LT'};
var $elm$core$List$cons = _List_cons;
var $elm$core$Elm$JsArray$foldr = _JsArray_foldr;
var $elm$core$Array$foldr = F3(
	function (func, baseCase, _v0) {
		var tree = _v0.c;
		var tail = _v0.d;
		var helper = F2(
			function (node, acc) {
				if (node.$ === 'SubTree') {
					var subTree = node.a;
					return A3($elm$core$Elm$JsArray$foldr, helper, acc, subTree);
				} else {
					var values = node.a;
					return A3($elm$core$Elm$JsArray$foldr, func, acc, values);
				}
			});
		return A3(
			$elm$core$Elm$JsArray$foldr,
			helper,
			A3($elm$core$Elm$JsArray$foldr, func, baseCase, tail),
			tree);
	});
var $elm$core$Array$toList = function (array) {
	return A3($elm$core$Array$foldr, $elm$core$List$cons, _List_Nil, array);
};
var $elm$core$Dict$foldr = F3(
	function (func, acc, t) {
		foldr:
		while (true) {
			if (t.$ === 'RBEmpty_elm_builtin') {
				return acc;
			} else {
				var key = t.b;
				var value = t.c;
				var left = t.d;
				var right = t.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3($elm$core$Dict$foldr, func, acc, right)),
					$temp$t = left;
				func = $temp$func;
				acc = $temp$acc;
				t = $temp$t;
				continue foldr;
			}
		}
	});
var $elm$core$Dict$toList = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, list) {
				return A2(
					$elm$core$List$cons,
					_Utils_Tuple2(key, value),
					list);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Dict$keys = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, keyList) {
				return A2($elm$core$List$cons, key, keyList);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Set$toList = function (_v0) {
	var dict = _v0.a;
	return $elm$core$Dict$keys(dict);
};
var $elm$core$Basics$GT = {$: 'GT'};
var $author$project$Generate$InputError = {$: 'InputError'};
var $elm$core$Basics$identity = function (x) {
	return x;
};
var $author$project$Generate$SchemaReceived = function (a) {
	return {$: 'SchemaReceived', a: a};
};
var $elm$core$Basics$append = _Utils_append;
var $elm$core$Result$Err = function (a) {
	return {$: 'Err', a: a};
};
var $elm$json$Json$Decode$Failure = F2(
	function (a, b) {
		return {$: 'Failure', a: a, b: b};
	});
var $elm$json$Json$Decode$Field = F2(
	function (a, b) {
		return {$: 'Field', a: a, b: b};
	});
var $elm$json$Json$Decode$Index = F2(
	function (a, b) {
		return {$: 'Index', a: a, b: b};
	});
var $elm$core$Result$Ok = function (a) {
	return {$: 'Ok', a: a};
};
var $elm$json$Json$Decode$OneOf = function (a) {
	return {$: 'OneOf', a: a};
};
var $elm$core$Basics$False = {$: 'False'};
var $elm$core$Basics$add = _Basics_add;
var $elm$core$Maybe$Just = function (a) {
	return {$: 'Just', a: a};
};
var $elm$core$Maybe$Nothing = {$: 'Nothing'};
var $elm$core$String$all = _String_all;
var $elm$core$Basics$and = _Basics_and;
var $elm$json$Json$Encode$encode = _Json_encode;
var $elm$core$String$fromInt = _String_fromNumber;
var $elm$core$String$join = F2(
	function (sep, chunks) {
		return A2(
			_String_join,
			sep,
			_List_toArray(chunks));
	});
var $elm$core$String$split = F2(
	function (sep, string) {
		return _List_fromArray(
			A2(_String_split, sep, string));
	});
var $elm$json$Json$Decode$indent = function (str) {
	return A2(
		$elm$core$String$join,
		'\n    ',
		A2($elm$core$String$split, '\n', str));
};
var $elm$core$List$foldl = F3(
	function (func, acc, list) {
		foldl:
		while (true) {
			if (!list.b) {
				return acc;
			} else {
				var x = list.a;
				var xs = list.b;
				var $temp$func = func,
					$temp$acc = A2(func, x, acc),
					$temp$list = xs;
				func = $temp$func;
				acc = $temp$acc;
				list = $temp$list;
				continue foldl;
			}
		}
	});
var $elm$core$List$length = function (xs) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, i) {
				return i + 1;
			}),
		0,
		xs);
};
var $elm$core$List$map2 = _List_map2;
var $elm$core$Basics$le = _Utils_le;
var $elm$core$Basics$sub = _Basics_sub;
var $elm$core$List$rangeHelp = F3(
	function (lo, hi, list) {
		rangeHelp:
		while (true) {
			if (_Utils_cmp(lo, hi) < 1) {
				var $temp$lo = lo,
					$temp$hi = hi - 1,
					$temp$list = A2($elm$core$List$cons, hi, list);
				lo = $temp$lo;
				hi = $temp$hi;
				list = $temp$list;
				continue rangeHelp;
			} else {
				return list;
			}
		}
	});
var $elm$core$List$range = F2(
	function (lo, hi) {
		return A3($elm$core$List$rangeHelp, lo, hi, _List_Nil);
	});
var $elm$core$List$indexedMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$map2,
			f,
			A2(
				$elm$core$List$range,
				0,
				$elm$core$List$length(xs) - 1),
			xs);
	});
var $elm$core$Char$toCode = _Char_toCode;
var $elm$core$Char$isLower = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (97 <= code) && (code <= 122);
};
var $elm$core$Char$isUpper = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 90) && (65 <= code);
};
var $elm$core$Basics$or = _Basics_or;
var $elm$core$Char$isAlpha = function (_char) {
	return $elm$core$Char$isLower(_char) || $elm$core$Char$isUpper(_char);
};
var $elm$core$Char$isDigit = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 57) && (48 <= code);
};
var $elm$core$Char$isAlphaNum = function (_char) {
	return $elm$core$Char$isLower(_char) || ($elm$core$Char$isUpper(_char) || $elm$core$Char$isDigit(_char));
};
var $elm$core$List$reverse = function (list) {
	return A3($elm$core$List$foldl, $elm$core$List$cons, _List_Nil, list);
};
var $elm$core$String$uncons = _String_uncons;
var $elm$json$Json$Decode$errorOneOf = F2(
	function (i, error) {
		return '\n\n(' + ($elm$core$String$fromInt(i + 1) + (') ' + $elm$json$Json$Decode$indent(
			$elm$json$Json$Decode$errorToString(error))));
	});
var $elm$json$Json$Decode$errorToString = function (error) {
	return A2($elm$json$Json$Decode$errorToStringHelp, error, _List_Nil);
};
var $elm$json$Json$Decode$errorToStringHelp = F2(
	function (error, context) {
		errorToStringHelp:
		while (true) {
			switch (error.$) {
				case 'Field':
					var f = error.a;
					var err = error.b;
					var isSimple = function () {
						var _v1 = $elm$core$String$uncons(f);
						if (_v1.$ === 'Nothing') {
							return false;
						} else {
							var _v2 = _v1.a;
							var _char = _v2.a;
							var rest = _v2.b;
							return $elm$core$Char$isAlpha(_char) && A2($elm$core$String$all, $elm$core$Char$isAlphaNum, rest);
						}
					}();
					var fieldName = isSimple ? ('.' + f) : ('[\'' + (f + '\']'));
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, fieldName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'Index':
					var i = error.a;
					var err = error.b;
					var indexName = '[' + ($elm$core$String$fromInt(i) + ']');
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, indexName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'OneOf':
					var errors = error.a;
					if (!errors.b) {
						return 'Ran into a Json.Decode.oneOf with no possibilities' + function () {
							if (!context.b) {
								return '!';
							} else {
								return ' at json' + A2(
									$elm$core$String$join,
									'',
									$elm$core$List$reverse(context));
							}
						}();
					} else {
						if (!errors.b.b) {
							var err = errors.a;
							var $temp$error = err,
								$temp$context = context;
							error = $temp$error;
							context = $temp$context;
							continue errorToStringHelp;
						} else {
							var starter = function () {
								if (!context.b) {
									return 'Json.Decode.oneOf';
								} else {
									return 'The Json.Decode.oneOf at json' + A2(
										$elm$core$String$join,
										'',
										$elm$core$List$reverse(context));
								}
							}();
							var introduction = starter + (' failed in the following ' + ($elm$core$String$fromInt(
								$elm$core$List$length(errors)) + ' ways:'));
							return A2(
								$elm$core$String$join,
								'\n\n',
								A2(
									$elm$core$List$cons,
									introduction,
									A2($elm$core$List$indexedMap, $elm$json$Json$Decode$errorOneOf, errors)));
						}
					}
				default:
					var msg = error.a;
					var json = error.b;
					var introduction = function () {
						if (!context.b) {
							return 'Problem with the given value:\n\n';
						} else {
							return 'Problem with the value at json' + (A2(
								$elm$core$String$join,
								'',
								$elm$core$List$reverse(context)) + ':\n\n    ');
						}
					}();
					return introduction + ($elm$json$Json$Decode$indent(
						A2($elm$json$Json$Encode$encode, 4, json)) + ('\n\n' + msg));
			}
		}
	});
var $elm$core$Array$branchFactor = 32;
var $elm$core$Array$Array_elm_builtin = F4(
	function (a, b, c, d) {
		return {$: 'Array_elm_builtin', a: a, b: b, c: c, d: d};
	});
var $elm$core$Elm$JsArray$empty = _JsArray_empty;
var $elm$core$Basics$ceiling = _Basics_ceiling;
var $elm$core$Basics$fdiv = _Basics_fdiv;
var $elm$core$Basics$logBase = F2(
	function (base, number) {
		return _Basics_log(number) / _Basics_log(base);
	});
var $elm$core$Basics$toFloat = _Basics_toFloat;
var $elm$core$Array$shiftStep = $elm$core$Basics$ceiling(
	A2($elm$core$Basics$logBase, 2, $elm$core$Array$branchFactor));
var $elm$core$Array$empty = A4($elm$core$Array$Array_elm_builtin, 0, $elm$core$Array$shiftStep, $elm$core$Elm$JsArray$empty, $elm$core$Elm$JsArray$empty);
var $elm$core$Elm$JsArray$initialize = _JsArray_initialize;
var $elm$core$Array$Leaf = function (a) {
	return {$: 'Leaf', a: a};
};
var $elm$core$Basics$apL = F2(
	function (f, x) {
		return f(x);
	});
var $elm$core$Basics$apR = F2(
	function (x, f) {
		return f(x);
	});
var $elm$core$Basics$eq = _Utils_equal;
var $elm$core$Basics$floor = _Basics_floor;
var $elm$core$Elm$JsArray$length = _JsArray_length;
var $elm$core$Basics$gt = _Utils_gt;
var $elm$core$Basics$max = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) > 0) ? x : y;
	});
var $elm$core$Basics$mul = _Basics_mul;
var $elm$core$Array$SubTree = function (a) {
	return {$: 'SubTree', a: a};
};
var $elm$core$Elm$JsArray$initializeFromList = _JsArray_initializeFromList;
var $elm$core$Array$compressNodes = F2(
	function (nodes, acc) {
		compressNodes:
		while (true) {
			var _v0 = A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodes);
			var node = _v0.a;
			var remainingNodes = _v0.b;
			var newAcc = A2(
				$elm$core$List$cons,
				$elm$core$Array$SubTree(node),
				acc);
			if (!remainingNodes.b) {
				return $elm$core$List$reverse(newAcc);
			} else {
				var $temp$nodes = remainingNodes,
					$temp$acc = newAcc;
				nodes = $temp$nodes;
				acc = $temp$acc;
				continue compressNodes;
			}
		}
	});
var $elm$core$Tuple$first = function (_v0) {
	var x = _v0.a;
	return x;
};
var $elm$core$Array$treeFromBuilder = F2(
	function (nodeList, nodeListSize) {
		treeFromBuilder:
		while (true) {
			var newNodeSize = $elm$core$Basics$ceiling(nodeListSize / $elm$core$Array$branchFactor);
			if (newNodeSize === 1) {
				return A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodeList).a;
			} else {
				var $temp$nodeList = A2($elm$core$Array$compressNodes, nodeList, _List_Nil),
					$temp$nodeListSize = newNodeSize;
				nodeList = $temp$nodeList;
				nodeListSize = $temp$nodeListSize;
				continue treeFromBuilder;
			}
		}
	});
var $elm$core$Array$builderToArray = F2(
	function (reverseNodeList, builder) {
		if (!builder.nodeListSize) {
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.tail),
				$elm$core$Array$shiftStep,
				$elm$core$Elm$JsArray$empty,
				builder.tail);
		} else {
			var treeLen = builder.nodeListSize * $elm$core$Array$branchFactor;
			var depth = $elm$core$Basics$floor(
				A2($elm$core$Basics$logBase, $elm$core$Array$branchFactor, treeLen - 1));
			var correctNodeList = reverseNodeList ? $elm$core$List$reverse(builder.nodeList) : builder.nodeList;
			var tree = A2($elm$core$Array$treeFromBuilder, correctNodeList, builder.nodeListSize);
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.tail) + treeLen,
				A2($elm$core$Basics$max, 5, depth * $elm$core$Array$shiftStep),
				tree,
				builder.tail);
		}
	});
var $elm$core$Basics$idiv = _Basics_idiv;
var $elm$core$Basics$lt = _Utils_lt;
var $elm$core$Array$initializeHelp = F5(
	function (fn, fromIndex, len, nodeList, tail) {
		initializeHelp:
		while (true) {
			if (fromIndex < 0) {
				return A2(
					$elm$core$Array$builderToArray,
					false,
					{nodeList: nodeList, nodeListSize: (len / $elm$core$Array$branchFactor) | 0, tail: tail});
			} else {
				var leaf = $elm$core$Array$Leaf(
					A3($elm$core$Elm$JsArray$initialize, $elm$core$Array$branchFactor, fromIndex, fn));
				var $temp$fn = fn,
					$temp$fromIndex = fromIndex - $elm$core$Array$branchFactor,
					$temp$len = len,
					$temp$nodeList = A2($elm$core$List$cons, leaf, nodeList),
					$temp$tail = tail;
				fn = $temp$fn;
				fromIndex = $temp$fromIndex;
				len = $temp$len;
				nodeList = $temp$nodeList;
				tail = $temp$tail;
				continue initializeHelp;
			}
		}
	});
var $elm$core$Basics$remainderBy = _Basics_remainderBy;
var $elm$core$Array$initialize = F2(
	function (len, fn) {
		if (len <= 0) {
			return $elm$core$Array$empty;
		} else {
			var tailLen = len % $elm$core$Array$branchFactor;
			var tail = A3($elm$core$Elm$JsArray$initialize, tailLen, len - tailLen, fn);
			var initialFromIndex = (len - tailLen) - $elm$core$Array$branchFactor;
			return A5($elm$core$Array$initializeHelp, fn, initialFromIndex, len, _List_Nil, tail);
		}
	});
var $elm$core$Basics$True = {$: 'True'};
var $elm$core$Result$isOk = function (result) {
	if (result.$ === 'Ok') {
		return true;
	} else {
		return false;
	}
};
var $elm$json$Json$Decode$decodeValue = _Json_run;
var $elm$json$Json$Encode$object = function (pairs) {
	return _Json_wrap(
		A3(
			$elm$core$List$foldl,
			F2(
				function (_v0, obj) {
					var k = _v0.a;
					var v = _v0.b;
					return A3(_Json_addField, k, v, obj);
				}),
			_Json_emptyObject(_Utils_Tuple0),
			pairs));
};
var $elm$json$Json$Encode$string = _Json_wrap;
var $author$project$Elm$Gen$onFailureSend = _Platform_outgoingPort(
	'onFailureSend',
	function ($) {
		return $elm$json$Json$Encode$object(
			_List_fromArray(
				[
					_Utils_Tuple2(
					'description',
					$elm$json$Json$Encode$string($.description)),
					_Utils_Tuple2(
					'title',
					$elm$json$Json$Encode$string($.title))
				]));
	});
var $author$project$Elm$Gen$error = function (err) {
	return $author$project$Elm$Gen$onFailureSend(err);
};
var $author$project$Generate$SchemaGet = function (a) {
	return {$: 'SchemaGet', a: a};
};
var $author$project$Generate$SchemaInline = function (a) {
	return {$: 'SchemaInline', a: a};
};
var $elm$json$Json$Decode$andThen = _Json_andThen;
var $elm$json$Json$Decode$field = _Json_decodeField;
var $elm$core$Dict$RBEmpty_elm_builtin = {$: 'RBEmpty_elm_builtin'};
var $elm$core$Dict$empty = $elm$core$Dict$RBEmpty_elm_builtin;
var $author$project$GraphQL$Schema$empty = {enums: $elm$core$Dict$empty, inputObjects: $elm$core$Dict$empty, interfaces: $elm$core$Dict$empty, mutations: $elm$core$Dict$empty, objects: $elm$core$Dict$empty, queries: $elm$core$Dict$empty, scalars: $elm$core$Dict$empty, unions: $elm$core$Dict$empty};
var $elm$core$Dict$Black = {$: 'Black'};
var $elm$core$Dict$RBNode_elm_builtin = F5(
	function (a, b, c, d, e) {
		return {$: 'RBNode_elm_builtin', a: a, b: b, c: c, d: d, e: e};
	});
var $elm$core$Dict$Red = {$: 'Red'};
var $elm$core$Dict$balance = F5(
	function (color, key, value, left, right) {
		if ((right.$ === 'RBNode_elm_builtin') && (right.a.$ === 'Red')) {
			var _v1 = right.a;
			var rK = right.b;
			var rV = right.c;
			var rLeft = right.d;
			var rRight = right.e;
			if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) {
				var _v3 = left.a;
				var lK = left.b;
				var lV = left.c;
				var lLeft = left.d;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Red,
					key,
					value,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					color,
					rK,
					rV,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, key, value, left, rLeft),
					rRight);
			}
		} else {
			if ((((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) && (left.d.$ === 'RBNode_elm_builtin')) && (left.d.a.$ === 'Red')) {
				var _v5 = left.a;
				var lK = left.b;
				var lV = left.c;
				var _v6 = left.d;
				var _v7 = _v6.a;
				var llK = _v6.b;
				var llV = _v6.c;
				var llLeft = _v6.d;
				var llRight = _v6.e;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Red,
					lK,
					lV,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, llK, llV, llLeft, llRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, key, value, lRight, right));
			} else {
				return A5($elm$core$Dict$RBNode_elm_builtin, color, key, value, left, right);
			}
		}
	});
var $elm$core$Basics$compare = _Utils_compare;
var $elm$core$Dict$insertHelp = F3(
	function (key, value, dict) {
		if (dict.$ === 'RBEmpty_elm_builtin') {
			return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, key, value, $elm$core$Dict$RBEmpty_elm_builtin, $elm$core$Dict$RBEmpty_elm_builtin);
		} else {
			var nColor = dict.a;
			var nKey = dict.b;
			var nValue = dict.c;
			var nLeft = dict.d;
			var nRight = dict.e;
			var _v1 = A2($elm$core$Basics$compare, key, nKey);
			switch (_v1.$) {
				case 'LT':
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						A3($elm$core$Dict$insertHelp, key, value, nLeft),
						nRight);
				case 'EQ':
					return A5($elm$core$Dict$RBNode_elm_builtin, nColor, nKey, value, nLeft, nRight);
				default:
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						nLeft,
						A3($elm$core$Dict$insertHelp, key, value, nRight));
			}
		}
	});
var $elm$core$Dict$insert = F3(
	function (key, value, dict) {
		var _v0 = A3($elm$core$Dict$insertHelp, key, value, dict);
		if ((_v0.$ === 'RBNode_elm_builtin') && (_v0.a.$ === 'Red')) {
			var _v1 = _v0.a;
			var k = _v0.b;
			var v = _v0.c;
			var l = _v0.d;
			var r = _v0.e;
			return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, k, v, l, r);
		} else {
			var x = _v0;
			return x;
		}
	});
var $author$project$GraphQL$Schema$Enum_Kind = function (a) {
	return {$: 'Enum_Kind', a: a};
};
var $author$project$GraphQL$Schema$InputObject_Kind = function (a) {
	return {$: 'InputObject_Kind', a: a};
};
var $author$project$GraphQL$Schema$Interface_Kind = function (a) {
	return {$: 'Interface_Kind', a: a};
};
var $author$project$GraphQL$Schema$Mutation_Kind = function (a) {
	return {$: 'Mutation_Kind', a: a};
};
var $author$project$GraphQL$Schema$Object_Kind = function (a) {
	return {$: 'Object_Kind', a: a};
};
var $author$project$GraphQL$Schema$Query_Kind = function (a) {
	return {$: 'Query_Kind', a: a};
};
var $author$project$GraphQL$Schema$Scalar_Kind = function (a) {
	return {$: 'Scalar_Kind', a: a};
};
var $author$project$GraphQL$Schema$Union_Kind = function (a) {
	return {$: 'Union_Kind', a: a};
};
var $author$project$GraphQL$Schema$Enum$Enum = F3(
	function (name, description, values) {
		return {description: description, name: name, values: values};
	});
var $elm$json$Json$Decode$list = _Json_decodeList;
var $elm$json$Json$Decode$map3 = _Json_map3;
var $elm$json$Json$Decode$map = _Json_map1;
var $elm$json$Json$Decode$oneOf = _Json_oneOf;
var $elm$json$Json$Decode$succeed = _Json_succeed;
var $elm$json$Json$Decode$maybe = function (decoder) {
	return $elm$json$Json$Decode$oneOf(
		_List_fromArray(
			[
				A2($elm$json$Json$Decode$map, $elm$core$Maybe$Just, decoder),
				$elm$json$Json$Decode$succeed($elm$core$Maybe$Nothing)
			]));
};
var $elm$json$Json$Decode$fail = _Json_fail;
var $elm$core$String$isEmpty = function (string) {
	return string === '';
};
var $elm$json$Json$Decode$string = _Json_decodeString;
var $elm$core$String$trim = _String_trim;
var $author$project$Utils$Json$nonEmptyString = A2(
	$elm$json$Json$Decode$andThen,
	function (str) {
		return $elm$core$String$isEmpty(
			$elm$core$String$trim(str)) ? $elm$json$Json$Decode$fail('String was empty.') : $elm$json$Json$Decode$succeed(str);
	},
	$elm$json$Json$Decode$string);
var $author$project$GraphQL$Schema$Enum$Value = F2(
	function (name, description) {
		return {description: description, name: name};
	});
var $elm$json$Json$Decode$map2 = _Json_map2;
var $author$project$GraphQL$Schema$Enum$valueDecoder = A3(
	$elm$json$Json$Decode$map2,
	$author$project$GraphQL$Schema$Enum$Value,
	A2($elm$json$Json$Decode$field, 'name', $elm$json$Json$Decode$string),
	A2(
		$elm$json$Json$Decode$field,
		'description',
		$elm$json$Json$Decode$maybe($author$project$Utils$Json$nonEmptyString)));
var $author$project$GraphQL$Schema$Enum$decoder = A4(
	$elm$json$Json$Decode$map3,
	$author$project$GraphQL$Schema$Enum$Enum,
	A2($elm$json$Json$Decode$field, 'name', $elm$json$Json$Decode$string),
	A2(
		$elm$json$Json$Decode$field,
		'description',
		$elm$json$Json$Decode$maybe($author$project$Utils$Json$nonEmptyString)),
	A2(
		$elm$json$Json$Decode$field,
		'enumValues',
		$elm$json$Json$Decode$list($author$project$GraphQL$Schema$Enum$valueDecoder)));
var $author$project$GraphQL$Schema$InputObject$InputObject = F3(
	function (name, description, fields) {
		return {description: description, fields: fields, name: name};
	});
var $author$project$GraphQL$Schema$Field$Field = F5(
	function (name, description, _arguments, type_, permissions) {
		return {_arguments: _arguments, description: description, name: name, permissions: permissions, type_: type_};
	});
var $elm$core$List$foldrHelper = F4(
	function (fn, acc, ctr, ls) {
		if (!ls.b) {
			return acc;
		} else {
			var a = ls.a;
			var r1 = ls.b;
			if (!r1.b) {
				return A2(fn, a, acc);
			} else {
				var b = r1.a;
				var r2 = r1.b;
				if (!r2.b) {
					return A2(
						fn,
						a,
						A2(fn, b, acc));
				} else {
					var c = r2.a;
					var r3 = r2.b;
					if (!r3.b) {
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(fn, c, acc)));
					} else {
						var d = r3.a;
						var r4 = r3.b;
						var res = (ctr > 500) ? A3(
							$elm$core$List$foldl,
							fn,
							acc,
							$elm$core$List$reverse(r4)) : A4($elm$core$List$foldrHelper, fn, acc, ctr + 1, r4);
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(
									fn,
									c,
									A2(fn, d, res))));
					}
				}
			}
		}
	});
var $elm$core$List$foldr = F3(
	function (fn, acc, ls) {
		return A4($elm$core$List$foldrHelper, fn, acc, 0, ls);
	});
var $elm$json$Json$Decode$at = F2(
	function (fields, decoder) {
		return A3($elm$core$List$foldr, $elm$json$Json$Decode$field, decoder, fields);
	});
var $elm$core$Maybe$withDefault = F2(
	function (_default, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return value;
		} else {
			return _default;
		}
	});
var $author$project$GraphQL$Schema$Permission$decoder = A2(
	$elm$json$Json$Decode$map,
	$elm$core$Maybe$withDefault(_List_Nil),
	$elm$json$Json$Decode$maybe(
		A2(
			$elm$json$Json$Decode$at,
			_List_fromArray(
				['directives', 'requires', 'permissions']),
			$elm$json$Json$Decode$list($elm$json$Json$Decode$string))));
var $author$project$GraphQL$Schema$Type$Inner_Enum = function (a) {
	return {$: 'Inner_Enum', a: a};
};
var $author$project$GraphQL$Schema$Type$Inner_InputObject = function (a) {
	return {$: 'Inner_InputObject', a: a};
};
var $author$project$GraphQL$Schema$Type$Inner_Interface = function (a) {
	return {$: 'Inner_Interface', a: a};
};
var $author$project$GraphQL$Schema$Type$Inner_List_ = function (a) {
	return {$: 'Inner_List_', a: a};
};
var $author$project$GraphQL$Schema$Type$Inner_Non_Null = function (a) {
	return {$: 'Inner_Non_Null', a: a};
};
var $author$project$GraphQL$Schema$Type$Inner_Object = function (a) {
	return {$: 'Inner_Object', a: a};
};
var $author$project$GraphQL$Schema$Type$Inner_Scalar = function (a) {
	return {$: 'Inner_Scalar', a: a};
};
var $author$project$GraphQL$Schema$Type$Inner_Union = function (a) {
	return {$: 'Inner_Union', a: a};
};
var $elm$json$Json$Decode$lazy = function (thunk) {
	return A2(
		$elm$json$Json$Decode$andThen,
		thunk,
		$elm$json$Json$Decode$succeed(_Utils_Tuple0));
};
var $author$project$GraphQL$Schema$Type$nameDecoder = A2($elm$json$Json$Decode$field, 'name', $elm$json$Json$Decode$string);
var $author$project$GraphQL$Schema$Type$fromKind = function (kind) {
	switch (kind) {
		case 'SCALAR':
			return A2($elm$json$Json$Decode$map, $author$project$GraphQL$Schema$Type$Inner_Scalar, $author$project$GraphQL$Schema$Type$nameDecoder);
		case 'INPUT_OBJECT':
			return A2($elm$json$Json$Decode$map, $author$project$GraphQL$Schema$Type$Inner_InputObject, $author$project$GraphQL$Schema$Type$nameDecoder);
		case 'OBJECT':
			return A2($elm$json$Json$Decode$map, $author$project$GraphQL$Schema$Type$Inner_Object, $author$project$GraphQL$Schema$Type$nameDecoder);
		case 'ENUM':
			return A2($elm$json$Json$Decode$map, $author$project$GraphQL$Schema$Type$Inner_Enum, $author$project$GraphQL$Schema$Type$nameDecoder);
		case 'UNION':
			return A2($elm$json$Json$Decode$map, $author$project$GraphQL$Schema$Type$Inner_Union, $author$project$GraphQL$Schema$Type$nameDecoder);
		case 'INTERFACE':
			return A2($elm$json$Json$Decode$map, $author$project$GraphQL$Schema$Type$Inner_Interface, $author$project$GraphQL$Schema$Type$nameDecoder);
		case 'LIST':
			return A2(
				$elm$json$Json$Decode$map,
				$author$project$GraphQL$Schema$Type$Inner_List_,
				A2(
					$elm$json$Json$Decode$field,
					'ofType',
					$author$project$GraphQL$Schema$Type$cyclic$lazyDecoder()));
		case 'NON_NULL':
			return A2(
				$elm$json$Json$Decode$map,
				$author$project$GraphQL$Schema$Type$Inner_Non_Null,
				A2(
					$elm$json$Json$Decode$field,
					'ofType',
					$author$project$GraphQL$Schema$Type$cyclic$lazyDecoder()));
		default:
			return $elm$json$Json$Decode$fail('Unrecognized kind: ' + kind);
	}
};
function $author$project$GraphQL$Schema$Type$cyclic$innerDecoder() {
	return A2(
		$elm$json$Json$Decode$andThen,
		$author$project$GraphQL$Schema$Type$fromKind,
		A2($elm$json$Json$Decode$field, 'kind', $elm$json$Json$Decode$string));
}
function $author$project$GraphQL$Schema$Type$cyclic$lazyDecoder() {
	return $elm$json$Json$Decode$lazy(
		function (_v0) {
			return $author$project$GraphQL$Schema$Type$cyclic$innerDecoder();
		});
}
try {
	var $author$project$GraphQL$Schema$Type$innerDecoder = $author$project$GraphQL$Schema$Type$cyclic$innerDecoder();
	$author$project$GraphQL$Schema$Type$cyclic$innerDecoder = function () {
		return $author$project$GraphQL$Schema$Type$innerDecoder;
	};
	var $author$project$GraphQL$Schema$Type$lazyDecoder = $author$project$GraphQL$Schema$Type$cyclic$lazyDecoder();
	$author$project$GraphQL$Schema$Type$cyclic$lazyDecoder = function () {
		return $author$project$GraphQL$Schema$Type$lazyDecoder;
	};
} catch ($) {
	throw 'Some top-level definitions from `GraphQL.Schema.Type` are causing infinite recursion:\n\n  ┌─────┐\n  │    innerDecoder\n  │     ↓\n  │    fromKind\n  │     ↓\n  │    lazyDecoder\n  └─────┘\n\nThese errors are very tricky, so read https://elm-lang.org/0.19.1/bad-recursion to learn how to fix it!';}
var $author$project$GraphQL$Schema$Type$Enum = function (a) {
	return {$: 'Enum', a: a};
};
var $author$project$GraphQL$Schema$Type$InputObject = function (a) {
	return {$: 'InputObject', a: a};
};
var $author$project$GraphQL$Schema$Type$Interface = function (a) {
	return {$: 'Interface', a: a};
};
var $author$project$GraphQL$Schema$Type$List_ = function (a) {
	return {$: 'List_', a: a};
};
var $author$project$GraphQL$Schema$Type$Nullable = function (a) {
	return {$: 'Nullable', a: a};
};
var $author$project$GraphQL$Schema$Type$Object = function (a) {
	return {$: 'Object', a: a};
};
var $author$project$GraphQL$Schema$Type$Scalar = function (a) {
	return {$: 'Scalar', a: a};
};
var $author$project$GraphQL$Schema$Type$Union = function (a) {
	return {$: 'Union', a: a};
};
var $author$project$GraphQL$Schema$Type$invert_ = F2(
	function (wrappedInNull, inner) {
		invert_:
		while (true) {
			var nullable = function (type_) {
				return wrappedInNull ? $author$project$GraphQL$Schema$Type$Nullable(type_) : type_;
			};
			switch (inner.$) {
				case 'Inner_Non_Null':
					var inner_ = inner.a;
					var $temp$wrappedInNull = false,
						$temp$inner = inner_;
					wrappedInNull = $temp$wrappedInNull;
					inner = $temp$inner;
					continue invert_;
				case 'Inner_List_':
					var inner_ = inner.a;
					return nullable(
						$author$project$GraphQL$Schema$Type$List_(
							A2($author$project$GraphQL$Schema$Type$invert_, true, inner_)));
				case 'Inner_Scalar':
					var value = inner.a;
					return nullable(
						$author$project$GraphQL$Schema$Type$Scalar(value));
				case 'Inner_InputObject':
					var value = inner.a;
					return nullable(
						$author$project$GraphQL$Schema$Type$InputObject(value));
				case 'Inner_Object':
					var value = inner.a;
					return nullable(
						$author$project$GraphQL$Schema$Type$Object(value));
				case 'Inner_Enum':
					var value = inner.a;
					return nullable(
						$author$project$GraphQL$Schema$Type$Enum(value));
				case 'Inner_Union':
					var value = inner.a;
					return nullable(
						$author$project$GraphQL$Schema$Type$Union(value));
				default:
					var value = inner.a;
					return nullable(
						$author$project$GraphQL$Schema$Type$Interface(value));
			}
		}
	});
var $author$project$GraphQL$Schema$Type$invert = $author$project$GraphQL$Schema$Type$invert_(true);
var $author$project$GraphQL$Schema$Type$decoder = A2($elm$json$Json$Decode$map, $author$project$GraphQL$Schema$Type$invert, $author$project$GraphQL$Schema$Type$innerDecoder);
var $elm$json$Json$Decode$map5 = _Json_map5;
var $author$project$GraphQL$Schema$Field$decoder = A6(
	$elm$json$Json$Decode$map5,
	$author$project$GraphQL$Schema$Field$Field,
	A2($elm$json$Json$Decode$field, 'name', $elm$json$Json$Decode$string),
	A2(
		$elm$json$Json$Decode$field,
		'description',
		$elm$json$Json$Decode$maybe($author$project$Utils$Json$nonEmptyString)),
	$elm$json$Json$Decode$succeed(_List_Nil),
	A2($elm$json$Json$Decode$field, 'type', $author$project$GraphQL$Schema$Type$decoder),
	$author$project$GraphQL$Schema$Permission$decoder);
var $author$project$GraphQL$Schema$InputObject$decoder = A4(
	$elm$json$Json$Decode$map3,
	$author$project$GraphQL$Schema$InputObject$InputObject,
	A2($elm$json$Json$Decode$field, 'name', $elm$json$Json$Decode$string),
	A2(
		$elm$json$Json$Decode$field,
		'description',
		$elm$json$Json$Decode$maybe($author$project$Utils$Json$nonEmptyString)),
	A2(
		$elm$json$Json$Decode$field,
		'inputFields',
		$elm$json$Json$Decode$list($author$project$GraphQL$Schema$Field$decoder)));
var $author$project$GraphQL$Schema$Interface$Interface = F4(
	function (name, description, fields, implementedBy) {
		return {description: description, fields: fields, implementedBy: implementedBy, name: name};
	});
var $author$project$GraphQL$Schema$Kind$Enum = function (a) {
	return {$: 'Enum', a: a};
};
var $author$project$GraphQL$Schema$Kind$InputObject = function (a) {
	return {$: 'InputObject', a: a};
};
var $author$project$GraphQL$Schema$Kind$Interface = function (a) {
	return {$: 'Interface', a: a};
};
var $author$project$GraphQL$Schema$Kind$Object = function (a) {
	return {$: 'Object', a: a};
};
var $author$project$GraphQL$Schema$Kind$Scalar = function (a) {
	return {$: 'Scalar', a: a};
};
var $author$project$GraphQL$Schema$Kind$Union = function (a) {
	return {$: 'Union', a: a};
};
var $author$project$GraphQL$Schema$Kind$kindFromNameAndString = F2(
	function (name_, kind) {
		switch (kind) {
			case 'OBJECT':
				return $elm$json$Json$Decode$succeed(
					$author$project$GraphQL$Schema$Kind$Object(name_));
			case 'SCALAR':
				return $elm$json$Json$Decode$succeed(
					$author$project$GraphQL$Schema$Kind$Scalar(name_));
			case 'INTERFACE':
				return $elm$json$Json$Decode$succeed(
					$author$project$GraphQL$Schema$Kind$Interface(name_));
			case 'INPUT_OBJECT':
				return $elm$json$Json$Decode$succeed(
					$author$project$GraphQL$Schema$Kind$InputObject(name_));
			case 'ENUM':
				return $elm$json$Json$Decode$succeed(
					$author$project$GraphQL$Schema$Kind$Enum(name_));
			case 'UNION':
				return $elm$json$Json$Decode$succeed(
					$author$project$GraphQL$Schema$Kind$Union(name_));
			default:
				return $elm$json$Json$Decode$fail('Didn\'t recognize variant kind: ' + kind);
		}
	});
var $author$project$GraphQL$Schema$Kind$decoder = A2(
	$elm$json$Json$Decode$andThen,
	function (n) {
		return A2(
			$elm$json$Json$Decode$andThen,
			$author$project$GraphQL$Schema$Kind$kindFromNameAndString(n),
			A2($elm$json$Json$Decode$field, 'kind', $elm$json$Json$Decode$string));
	},
	A2($elm$json$Json$Decode$field, 'name', $elm$json$Json$Decode$string));
var $elm$json$Json$Decode$map4 = _Json_map4;
var $author$project$GraphQL$Schema$Interface$decoder = A5(
	$elm$json$Json$Decode$map4,
	$author$project$GraphQL$Schema$Interface$Interface,
	A2($elm$json$Json$Decode$field, 'name', $elm$json$Json$Decode$string),
	A2(
		$elm$json$Json$Decode$field,
		'description',
		$elm$json$Json$Decode$maybe($elm$json$Json$Decode$string)),
	A2(
		$elm$json$Json$Decode$field,
		'fields',
		$elm$json$Json$Decode$list($author$project$GraphQL$Schema$Field$decoder)),
	A2(
		$elm$json$Json$Decode$field,
		'possibleTypes',
		$elm$json$Json$Decode$list($author$project$GraphQL$Schema$Kind$decoder)));
var $author$project$GraphQL$Schema$Object$Object = F4(
	function (name, description, fields, interfaces) {
		return {description: description, fields: fields, interfaces: interfaces, name: name};
	});
var $author$project$GraphQL$Schema$Object$interface = A2(
	$elm$json$Json$Decode$map,
	$author$project$GraphQL$Schema$Kind$Interface,
	A2($elm$json$Json$Decode$field, 'name', $elm$json$Json$Decode$string));
var $author$project$GraphQL$Schema$Object$decoder = A5(
	$elm$json$Json$Decode$map4,
	$author$project$GraphQL$Schema$Object$Object,
	A2($elm$json$Json$Decode$field, 'name', $elm$json$Json$Decode$string),
	A2(
		$elm$json$Json$Decode$field,
		'description',
		$elm$json$Json$Decode$maybe($author$project$Utils$Json$nonEmptyString)),
	A2(
		$elm$json$Json$Decode$field,
		'fields',
		$elm$json$Json$Decode$list($author$project$GraphQL$Schema$Field$decoder)),
	A2(
		$elm$json$Json$Decode$field,
		'interfaces',
		$elm$json$Json$Decode$list($author$project$GraphQL$Schema$Object$interface)));
var $elm$core$List$maybeCons = F3(
	function (f, mx, xs) {
		var _v0 = f(mx);
		if (_v0.$ === 'Just') {
			var x = _v0.a;
			return A2($elm$core$List$cons, x, xs);
		} else {
			return xs;
		}
	});
var $elm$core$List$filterMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			$elm$core$List$maybeCons(f),
			_List_Nil,
			xs);
	});
var $elm$core$Dict$fromList = function (assocs) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, dict) {
				var key = _v0.a;
				var value = _v0.b;
				return A3($elm$core$Dict$insert, key, value, dict);
			}),
		$elm$core$Dict$empty,
		assocs);
};
var $elm$core$Maybe$map = F2(
	function (f, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return $elm$core$Maybe$Just(
				f(value));
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $author$project$GraphQL$Schema$Operation$Operation = F6(
	function (name, deprecation, description, _arguments, type_, permissions) {
		return {_arguments: _arguments, deprecation: deprecation, description: description, name: name, permissions: permissions, type_: type_};
	});
var $author$project$GraphQL$Schema$Argument$Argument = F3(
	function (name, description, type_) {
		return {description: description, name: name, type_: type_};
	});
var $author$project$GraphQL$Schema$Argument$decoder = A4(
	$elm$json$Json$Decode$map3,
	$author$project$GraphQL$Schema$Argument$Argument,
	A2($elm$json$Json$Decode$field, 'name', $elm$json$Json$Decode$string),
	A2(
		$elm$json$Json$Decode$field,
		'description',
		$elm$json$Json$Decode$maybe($author$project$Utils$Json$nonEmptyString)),
	A2($elm$json$Json$Decode$field, 'type', $author$project$GraphQL$Schema$Type$decoder));
var $author$project$GraphQL$Schema$Deprecation$Active = {$: 'Active'};
var $author$project$GraphQL$Schema$Deprecation$Deprecated = function (a) {
	return {$: 'Deprecated', a: a};
};
var $elm$json$Json$Decode$bool = _Json_decodeBool;
var $author$project$GraphQL$Schema$Deprecation$decoder = function () {
	var fromBoolean = function (isDeprecated_) {
		return isDeprecated_ ? A2(
			$elm$json$Json$Decode$map,
			$author$project$GraphQL$Schema$Deprecation$Deprecated,
			$elm$json$Json$Decode$maybe(
				A2($elm$json$Json$Decode$field, 'deprecationReason', $elm$json$Json$Decode$string))) : $elm$json$Json$Decode$succeed($author$project$GraphQL$Schema$Deprecation$Active);
	};
	return A2(
		$elm$json$Json$Decode$andThen,
		fromBoolean,
		A2($elm$json$Json$Decode$field, 'isDeprecated', $elm$json$Json$Decode$bool));
}();
var $elm$core$List$any = F2(
	function (isOkay, list) {
		any:
		while (true) {
			if (!list.b) {
				return false;
			} else {
				var x = list.a;
				var xs = list.b;
				if (isOkay(x)) {
					return true;
				} else {
					var $temp$isOkay = isOkay,
						$temp$list = xs;
					isOkay = $temp$isOkay;
					list = $temp$list;
					continue any;
				}
			}
		}
	});
var $elm$json$Json$Decode$keyValuePairs = _Json_decodeKeyValuePairs;
var $elm$json$Json$Decode$dict = function (decoder) {
	return A2(
		$elm$json$Json$Decode$map,
		$elm$core$Dict$fromList,
		$elm$json$Json$Decode$keyValuePairs(decoder));
};
var $elm$core$Dict$get = F2(
	function (targetKey, dict) {
		get:
		while (true) {
			if (dict.$ === 'RBEmpty_elm_builtin') {
				return $elm$core$Maybe$Nothing;
			} else {
				var key = dict.b;
				var value = dict.c;
				var left = dict.d;
				var right = dict.e;
				var _v1 = A2($elm$core$Basics$compare, targetKey, key);
				switch (_v1.$) {
					case 'LT':
						var $temp$targetKey = targetKey,
							$temp$dict = left;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
					case 'EQ':
						return $elm$core$Maybe$Just(value);
					default:
						var $temp$targetKey = targetKey,
							$temp$dict = right;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
				}
			}
		}
	});
var $elm$core$Dict$member = F2(
	function (key, dict) {
		var _v0 = A2($elm$core$Dict$get, key, dict);
		if (_v0.$ === 'Just') {
			return true;
		} else {
			return false;
		}
	});
var $elm$json$Json$Decode$value = _Json_decodeValue;
var $author$project$Utils$Json$filterHidden = function (decoder_) {
	var filterByDirectives = function (directives) {
		return A2(
			$elm$core$List$any,
			function (d) {
				return A2($elm$core$Dict$member, d, directives);
			},
			_List_fromArray(
				['NoDocs', 'Unimplemented'])) ? $elm$json$Json$Decode$succeed($elm$core$Maybe$Nothing) : A2($elm$json$Json$Decode$map, $elm$core$Maybe$Just, decoder_);
	};
	return $elm$json$Json$Decode$oneOf(
		_List_fromArray(
			[
				A2(
				$elm$json$Json$Decode$andThen,
				filterByDirectives,
				A2(
					$elm$json$Json$Decode$field,
					'directives',
					$elm$json$Json$Decode$dict($elm$json$Json$Decode$value))),
				A2($elm$json$Json$Decode$map, $elm$core$Maybe$Just, decoder_)
			]));
};
var $elm$json$Json$Decode$map6 = _Json_map6;
var $author$project$GraphQL$Schema$Operation$operationDecoder = $author$project$Utils$Json$filterHidden(
	A7(
		$elm$json$Json$Decode$map6,
		$author$project$GraphQL$Schema$Operation$Operation,
		A2($elm$json$Json$Decode$field, 'name', $elm$json$Json$Decode$string),
		$author$project$GraphQL$Schema$Deprecation$decoder,
		A2(
			$elm$json$Json$Decode$field,
			'description',
			$elm$json$Json$Decode$maybe($author$project$Utils$Json$nonEmptyString)),
		A2(
			$elm$json$Json$Decode$field,
			'args',
			$elm$json$Json$Decode$list($author$project$GraphQL$Schema$Argument$decoder)),
		A2($elm$json$Json$Decode$field, 'type', $author$project$GraphQL$Schema$Type$decoder),
		$author$project$GraphQL$Schema$Permission$decoder));
var $elm$core$Tuple$pair = F2(
	function (a, b) {
		return _Utils_Tuple2(a, b);
	});
var $author$project$GraphQL$Schema$Operation$decoder = function () {
	var tupleDecoder = A3(
		$elm$json$Json$Decode$map2,
		$elm$core$Tuple$pair,
		A2($elm$json$Json$Decode$field, 'name', $elm$json$Json$Decode$string),
		$author$project$GraphQL$Schema$Operation$operationDecoder);
	return A2(
		$elm$json$Json$Decode$map,
		$elm$core$Dict$fromList,
		A2(
			$elm$json$Json$Decode$field,
			'fields',
			A2(
				$elm$json$Json$Decode$map,
				$elm$core$List$filterMap(
					function (_v0) {
						var name = _v0.a;
						var maybeOperation = _v0.b;
						return A2(
							$elm$core$Maybe$map,
							$elm$core$Tuple$pair(name),
							maybeOperation);
					}),
				$elm$json$Json$Decode$list(tupleDecoder))));
}();
var $author$project$GraphQL$Schema$Scalar$Scalar = F2(
	function (name, description) {
		return {description: description, name: name};
	});
var $author$project$GraphQL$Schema$Scalar$decoder = A3(
	$elm$json$Json$Decode$map2,
	$author$project$GraphQL$Schema$Scalar$Scalar,
	A2($elm$json$Json$Decode$field, 'name', $elm$json$Json$Decode$string),
	A2(
		$elm$json$Json$Decode$field,
		'description',
		$elm$json$Json$Decode$maybe($author$project$Utils$Json$nonEmptyString)));
var $author$project$GraphQL$Schema$Union$Union = F3(
	function (name, description, variants) {
		return {description: description, name: name, variants: variants};
	});
var $author$project$GraphQL$Schema$Union$Variant = function (kind) {
	return {kind: kind};
};
var $author$project$GraphQL$Schema$Union$variant = A2($elm$json$Json$Decode$map, $author$project$GraphQL$Schema$Union$Variant, $author$project$GraphQL$Schema$Kind$decoder);
var $author$project$GraphQL$Schema$Union$decoder = A4(
	$elm$json$Json$Decode$map3,
	$author$project$GraphQL$Schema$Union$Union,
	A2($elm$json$Json$Decode$field, 'name', $elm$json$Json$Decode$string),
	A2(
		$elm$json$Json$Decode$field,
		'description',
		$elm$json$Json$Decode$maybe($author$project$Utils$Json$nonEmptyString)),
	A2(
		$elm$json$Json$Decode$field,
		'possibleTypes',
		$elm$json$Json$Decode$list($author$project$GraphQL$Schema$Union$variant)));
var $author$project$GraphQL$Schema$kinds = function (names) {
	var fromNameAndKind = F2(
		function (name_, k) {
			switch (k) {
				case 'OBJECT':
					return _Utils_eq(name_, names.queryName) ? A2(
						$elm$json$Json$Decode$map,
						$elm$core$Maybe$Just,
						A2($elm$json$Json$Decode$map, $author$project$GraphQL$Schema$Query_Kind, $author$project$GraphQL$Schema$Operation$decoder)) : (_Utils_eq(name_, names.mutationName) ? A2(
						$elm$json$Json$Decode$map,
						$elm$core$Maybe$Just,
						A2($elm$json$Json$Decode$map, $author$project$GraphQL$Schema$Mutation_Kind, $author$project$GraphQL$Schema$Operation$decoder)) : $author$project$Utils$Json$filterHidden(
						A2($elm$json$Json$Decode$map, $author$project$GraphQL$Schema$Object_Kind, $author$project$GraphQL$Schema$Object$decoder)));
				case 'SCALAR':
					return $author$project$Utils$Json$filterHidden(
						A2($elm$json$Json$Decode$map, $author$project$GraphQL$Schema$Scalar_Kind, $author$project$GraphQL$Schema$Scalar$decoder));
				case 'INTERFACE':
					return $author$project$Utils$Json$filterHidden(
						A2($elm$json$Json$Decode$map, $author$project$GraphQL$Schema$Interface_Kind, $author$project$GraphQL$Schema$Interface$decoder));
				case 'INPUT_OBJECT':
					return $author$project$Utils$Json$filterHidden(
						A2($elm$json$Json$Decode$map, $author$project$GraphQL$Schema$InputObject_Kind, $author$project$GraphQL$Schema$InputObject$decoder));
				case 'ENUM':
					return $author$project$Utils$Json$filterHidden(
						A2($elm$json$Json$Decode$map, $author$project$GraphQL$Schema$Enum_Kind, $author$project$GraphQL$Schema$Enum$decoder));
				case 'UNION':
					return $author$project$Utils$Json$filterHidden(
						A2($elm$json$Json$Decode$map, $author$project$GraphQL$Schema$Union_Kind, $author$project$GraphQL$Schema$Union$decoder));
				default:
					return $elm$json$Json$Decode$fail('Didnt recognize kind: ' + k);
			}
		});
	var kind = A2(
		$elm$json$Json$Decode$andThen,
		function (name) {
			return A2(
				$elm$json$Json$Decode$map,
				function (kind_) {
					return A2(
						$elm$core$Maybe$map,
						$elm$core$Tuple$pair(name),
						kind_);
				},
				A2(
					$elm$json$Json$Decode$andThen,
					fromNameAndKind(name),
					A2($elm$json$Json$Decode$field, 'kind', $elm$json$Json$Decode$string)));
		},
		A2($elm$json$Json$Decode$field, 'name', $elm$json$Json$Decode$string));
	return A2(
		$elm$json$Json$Decode$field,
		'types',
		A2(
			$elm$json$Json$Decode$map,
			$elm$core$List$filterMap($elm$core$Basics$identity),
			$elm$json$Json$Decode$list(kind)));
};
var $elm$core$String$startsWith = _String_startsWith;
var $author$project$GraphQL$Schema$grabTypes = function (names) {
	var loop = F2(
		function (_v1, schema) {
			var name = _v1.a;
			var kind = _v1.b;
			switch (kind.$) {
				case 'Query_Kind':
					var queries = kind.a;
					return _Utils_update(
						schema,
						{queries: queries});
				case 'Mutation_Kind':
					var mutations = kind.a;
					return _Utils_update(
						schema,
						{mutations: mutations});
				case 'Object_Kind':
					var object = kind.a;
					return _Utils_update(
						schema,
						{
							objects: A2($elm$core$String$startsWith, '__', name) ? schema.objects : A3($elm$core$Dict$insert, name, object, schema.objects)
						});
				case 'Scalar_Kind':
					var scalar = kind.a;
					return _Utils_update(
						schema,
						{
							scalars: A3($elm$core$Dict$insert, name, scalar, schema.scalars)
						});
				case 'InputObject_Kind':
					var inputObject = kind.a;
					return _Utils_update(
						schema,
						{
							inputObjects: A3($elm$core$Dict$insert, name, inputObject, schema.inputObjects)
						});
				case 'Enum_Kind':
					var _enum = kind.a;
					return _Utils_update(
						schema,
						{
							enums: A3($elm$core$Dict$insert, name, _enum, schema.enums)
						});
				case 'Union_Kind':
					var union = kind.a;
					return _Utils_update(
						schema,
						{
							unions: A3($elm$core$Dict$insert, name, union, schema.unions)
						});
				default:
					var _interface = kind.a;
					return _Utils_update(
						schema,
						{
							interfaces: A3($elm$core$Dict$insert, name, _interface, schema.interfaces)
						});
			}
		});
	return A2(
		$elm$json$Json$Decode$map,
		A2($elm$core$List$foldl, loop, $author$project$GraphQL$Schema$empty),
		$author$project$GraphQL$Schema$kinds(names));
};
var $author$project$GraphQL$Schema$Names = F2(
	function (queryName, mutationName) {
		return {mutationName: mutationName, queryName: queryName};
	});
var $author$project$Utils$Json$apply = $elm$json$Json$Decode$map2($elm$core$Basics$apR);
var $author$project$GraphQL$Schema$namesDecoder = A2(
	$author$project$Utils$Json$apply,
	A2(
		$elm$json$Json$Decode$at,
		_List_fromArray(
			['mutationType', 'name']),
		$elm$json$Json$Decode$string),
	A2(
		$author$project$Utils$Json$apply,
		A2(
			$elm$json$Json$Decode$at,
			_List_fromArray(
				['queryType', 'name']),
			$elm$json$Json$Decode$string),
		$elm$json$Json$Decode$succeed($author$project$GraphQL$Schema$Names)));
var $author$project$GraphQL$Schema$decoder = A2(
	$elm$json$Json$Decode$field,
	'__schema',
	A2($elm$json$Json$Decode$andThen, $author$project$GraphQL$Schema$grabTypes, $author$project$GraphQL$Schema$namesDecoder));
var $author$project$Generate$flagsDecoder = $elm$json$Json$Decode$oneOf(
	_List_fromArray(
		[
			A3(
			$elm$json$Json$Decode$map2,
			F2(
				function (namespace, schemaUrl) {
					return $author$project$Generate$SchemaGet(
						{namespace: namespace, schema: schemaUrl});
				}),
			A2($elm$json$Json$Decode$field, 'namespace', $elm$json$Json$Decode$string),
			A2($elm$json$Json$Decode$field, 'schema', $elm$json$Json$Decode$string)),
			A2($elm$json$Json$Decode$map, $author$project$Generate$SchemaInline, $author$project$GraphQL$Schema$decoder)
		]));
var $author$project$Generate$Input$Mutation = {$: 'Mutation'};
var $author$project$Generate$Input$Query = {$: 'Query'};
var $author$project$Elm$Gen$encodeFile = function (file) {
	return $elm$json$Json$Encode$object(
		_List_fromArray(
			[
				_Utils_Tuple2(
				'path',
				$elm$json$Json$Encode$string(file.path)),
				_Utils_Tuple2(
				'contents',
				$elm$json$Json$Encode$string(file.contents))
			]));
};
var $elm$core$List$map = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (x, acc) {
					return A2(
						$elm$core$List$cons,
						f(x),
						acc);
				}),
			_List_Nil,
			xs);
	});
var $elm$json$Json$Encode$list = F2(
	function (func, entries) {
		return _Json_wrap(
			A3(
				$elm$core$List$foldl,
				_Json_addEntry(func),
				_Json_emptyArray(_Utils_Tuple0),
				entries));
	});
var $author$project$Elm$Gen$onSuccessSend = _Platform_outgoingPort(
	'onSuccessSend',
	$elm$json$Json$Encode$list($elm$core$Basics$identity));
var $author$project$Elm$Gen$files = function (list) {
	return $author$project$Elm$Gen$onSuccessSend(
		A2($elm$core$List$map, $author$project$Elm$Gen$encodeFile, list));
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$Application = function (a) {
	return {$: 'Application', a: a};
};
var $author$project$Internal$Compiler$Expression = function (a) {
	return {$: 'Expression', a: a};
};
var $author$project$Internal$Compiler$FunctionAppliedToTooManyArgs = {$: 'FunctionAppliedToTooManyArgs'};
var $stil4m$elm_syntax$Elm$Syntax$Node$value = function (_v0) {
	var v = _v0.b;
	return v;
};
var $author$project$Internal$Compiler$denode = $stil4m$elm_syntax$Elm$Syntax$Node$value;
var $stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$FunctionTypeAnnotation = F2(
	function (a, b) {
		return {$: 'FunctionTypeAnnotation', a: a, b: b};
	});
var $stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Record = function (a) {
	return {$: 'Record', a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Tupled = function (a) {
	return {$: 'Tupled', a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Typed = F2(
	function (a, b) {
		return {$: 'Typed', a: a, b: b};
	});
var $stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Unit = {$: 'Unit'};
var $author$project$Internal$Compiler$getField = F4(
	function (name, val, fields, captured) {
		getField:
		while (true) {
			if (!fields.b) {
				return $elm$core$Result$Err('Could not find ' + name);
			} else {
				var top = fields.a;
				var remain = fields.b;
				var _v1 = $author$project$Internal$Compiler$denode(top);
				var topFieldName = _v1.a;
				var topFieldVal = _v1.b;
				var topName = $author$project$Internal$Compiler$denode(topFieldName);
				var topVal = $author$project$Internal$Compiler$denode(topFieldVal);
				if (_Utils_eq(topName, name)) {
					return $elm$core$Result$Ok(
						_Utils_Tuple2(
							topVal,
							_Utils_ap(captured, remain)));
				} else {
					var $temp$name = name,
						$temp$val = val,
						$temp$fields = remain,
						$temp$captured = A2($elm$core$List$cons, top, captured);
					name = $temp$name;
					val = $temp$val;
					fields = $temp$fields;
					captured = $temp$captured;
					continue getField;
				}
			}
		}
	});
var $stil4m$elm_syntax$Elm$Syntax$Node$Node = F2(
	function (a, b) {
		return {$: 'Node', a: a, b: b};
	});
var $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange = {
	end: {column: 0, row: 0},
	start: {column: 0, row: 0}
};
var $author$project$Internal$Compiler$nodify = function (exp) {
	return A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, exp);
};
var $author$project$Internal$Compiler$nodifyAll = $elm$core$List$map($author$project$Internal$Compiler$nodify);
var $author$project$Internal$Compiler$unifiableFields = F4(
	function (vars, one, two, unified) {
		unifiableFields:
		while (true) {
			var _v27 = _Utils_Tuple2(one, two);
			if (!_v27.a.b) {
				if (!_v27.b.b) {
					return _Utils_Tuple2(
						vars,
						$elm$core$Result$Ok(
							$author$project$Internal$Compiler$nodifyAll(
								$elm$core$List$reverse(unified))));
				} else {
					return _Utils_Tuple2(
						vars,
						$elm$core$Result$Err('Mismatched numbers of type variables'));
				}
			} else {
				var _v28 = _v27.a;
				var oneX = _v28.a;
				var oneRemain = _v28.b;
				var twoFields = _v27.b;
				var _v29 = $author$project$Internal$Compiler$denode(oneX);
				var oneFieldName = _v29.a;
				var oneFieldVal = _v29.b;
				var oneName = $author$project$Internal$Compiler$denode(oneFieldName);
				var oneVal = $author$project$Internal$Compiler$denode(oneFieldVal);
				var _v30 = A4($author$project$Internal$Compiler$getField, oneName, oneVal, twoFields, _List_Nil);
				if (_v30.$ === 'Ok') {
					var _v31 = _v30.a;
					var matchingFieldVal = _v31.a;
					var remainingTwo = _v31.b;
					var _v32 = A3($author$project$Internal$Compiler$unifiableHelper, vars, oneVal, matchingFieldVal);
					var newVars = _v32.a;
					var unifiedField = _v32.b;
					var $temp$vars = newVars,
						$temp$one = oneRemain,
						$temp$two = remainingTwo,
						$temp$unified = A2($elm$core$List$cons, unifiedField, unified);
					vars = $temp$vars;
					one = $temp$one;
					two = $temp$two;
					unified = $temp$unified;
					continue unifiableFields;
				} else {
					var notFound = _v30.a;
					return _Utils_Tuple2(
						vars,
						$elm$core$Result$Err('Could not find ' + oneName));
				}
			}
		}
	});
var $author$project$Internal$Compiler$unifiableHelper = F3(
	function (vars, one, two) {
		unifiableHelper:
		while (true) {
			switch (one.$) {
				case 'GenericType':
					var varName = one.a;
					var _v8 = A2($elm$core$Dict$get, varName, vars);
					if (_v8.$ === 'Nothing') {
						return _Utils_Tuple2(
							A3($elm$core$Dict$insert, varName, two, vars),
							$elm$core$Result$Ok(two));
					} else {
						var found = _v8.a;
						if (two.$ === 'GenericType') {
							var varNameB = two.a;
							var _v10 = A2($elm$core$Dict$get, varNameB, vars);
							if (_v10.$ === 'Nothing') {
								return _Utils_Tuple2(
									A3($elm$core$Dict$insert, varNameB, found, vars),
									$elm$core$Result$Ok(two));
							} else {
								var foundTwo = _v10.a;
								var $temp$vars = vars,
									$temp$one = found,
									$temp$two = foundTwo;
								vars = $temp$vars;
								one = $temp$one;
								two = $temp$two;
								continue unifiableHelper;
							}
						} else {
							var $temp$vars = vars,
								$temp$one = found,
								$temp$two = two;
							vars = $temp$vars;
							one = $temp$one;
							two = $temp$two;
							continue unifiableHelper;
						}
					}
				case 'Typed':
					var oneName = one.a;
					var oneContents = one.b;
					switch (two.$) {
						case 'Typed':
							var twoName = two.a;
							var twoContents = two.b;
							if (_Utils_eq(
								$author$project$Internal$Compiler$denode(oneName),
								$author$project$Internal$Compiler$denode(twoName))) {
								var _v12 = A4($author$project$Internal$Compiler$unifiableLists, vars, oneContents, twoContents, _List_Nil);
								if (_v12.b.$ === 'Ok') {
									var newVars = _v12.a;
									var unifiedContent = _v12.b.a;
									return _Utils_Tuple2(
										newVars,
										$elm$core$Result$Ok(
											A2($stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Typed, twoName, unifiedContent)));
								} else {
									var newVars = _v12.a;
									var err = _v12.b.a;
									return _Utils_Tuple2(
										newVars,
										$elm$core$Result$Err(err));
								}
							} else {
								return _Utils_Tuple2(
									vars,
									$elm$core$Result$Err('Unable to unify container!'));
							}
						case 'GenericType':
							var b = two.a;
							return _Utils_Tuple2(
								vars,
								$elm$core$Result$Ok(one));
						default:
							return _Utils_Tuple2(
								vars,
								$elm$core$Result$Err('Unable to unify container!'));
					}
				case 'Unit':
					switch (two.$) {
						case 'GenericType':
							var b = two.a;
							var _v14 = A2($elm$core$Dict$get, b, vars);
							if (_v14.$ === 'Nothing') {
								return _Utils_Tuple2(
									A3($elm$core$Dict$insert, b, one, vars),
									$elm$core$Result$Ok(one));
							} else {
								var foundTwo = _v14.a;
								var $temp$vars = vars,
									$temp$one = one,
									$temp$two = foundTwo;
								vars = $temp$vars;
								one = $temp$one;
								two = $temp$two;
								continue unifiableHelper;
							}
						case 'Unit':
							return _Utils_Tuple2(
								vars,
								$elm$core$Result$Ok($stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Unit));
						default:
							return _Utils_Tuple2(
								vars,
								$elm$core$Result$Err('Unable to unify units!'));
					}
				case 'Tupled':
					var valsA = one.a;
					switch (two.$) {
						case 'GenericType':
							var b = two.a;
							var _v16 = A2($elm$core$Dict$get, b, vars);
							if (_v16.$ === 'Nothing') {
								return _Utils_Tuple2(
									A3($elm$core$Dict$insert, b, one, vars),
									$elm$core$Result$Ok(one));
							} else {
								var foundTwo = _v16.a;
								var $temp$vars = vars,
									$temp$one = one,
									$temp$two = foundTwo;
								vars = $temp$vars;
								one = $temp$one;
								two = $temp$two;
								continue unifiableHelper;
							}
						case 'Tupled':
							var valsB = two.a;
							var _v17 = A4($author$project$Internal$Compiler$unifiableLists, vars, valsA, valsB, _List_Nil);
							if (_v17.b.$ === 'Ok') {
								var newVars = _v17.a;
								var unified = _v17.b.a;
								return _Utils_Tuple2(
									newVars,
									$elm$core$Result$Ok(
										$stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Tupled(unified)));
							} else {
								var newVars = _v17.a;
								var err = _v17.b.a;
								return _Utils_Tuple2(
									newVars,
									$elm$core$Result$Err(err));
							}
						default:
							return _Utils_Tuple2(
								vars,
								$elm$core$Result$Err('Unable to unify tuples!'));
					}
				case 'Record':
					var fieldsA = one.a;
					switch (two.$) {
						case 'GenericType':
							var b = two.a;
							var _v19 = A2($elm$core$Dict$get, b, vars);
							if (_v19.$ === 'Nothing') {
								return _Utils_Tuple2(
									A3($elm$core$Dict$insert, b, one, vars),
									$elm$core$Result$Ok(one));
							} else {
								var foundTwo = _v19.a;
								var $temp$vars = vars,
									$temp$one = one,
									$temp$two = foundTwo;
								vars = $temp$vars;
								one = $temp$one;
								two = $temp$two;
								continue unifiableHelper;
							}
						case 'Record':
							var fieldsB = two.a;
							var _v20 = A4($author$project$Internal$Compiler$unifiableFields, vars, fieldsA, fieldsB, _List_Nil);
							if (_v20.b.$ === 'Ok') {
								var newVars = _v20.a;
								var unifiedFields = _v20.b.a;
								return _Utils_Tuple2(
									newVars,
									$elm$core$Result$Ok(
										$stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Record(unifiedFields)));
							} else {
								var newVars = _v20.a;
								var err = _v20.b.a;
								return _Utils_Tuple2(
									newVars,
									$elm$core$Result$Err(err));
							}
						default:
							return _Utils_Tuple2(
								vars,
								$elm$core$Result$Err('Unable to unify function with non function type!'));
					}
				case 'GenericRecord':
					var reVarName = one.a;
					var fieldsA = one.b;
					switch (two.$) {
						case 'GenericType':
							var b = two.a;
							var _v22 = A2($elm$core$Dict$get, b, vars);
							if (_v22.$ === 'Nothing') {
								return _Utils_Tuple2(
									A3($elm$core$Dict$insert, b, one, vars),
									$elm$core$Result$Ok(one));
							} else {
								var foundTwo = _v22.a;
								var $temp$vars = vars,
									$temp$one = one,
									$temp$two = foundTwo;
								vars = $temp$vars;
								one = $temp$one;
								two = $temp$two;
								continue unifiableHelper;
							}
						case 'Record':
							var fieldsB = two.a;
							return _Utils_Tuple2(
								vars,
								$elm$core$Result$Err('Unable to unify function with non function type!'));
						default:
							return _Utils_Tuple2(
								vars,
								$elm$core$Result$Err('Unable to unify function with non function type!'));
					}
				default:
					var oneA = one.a;
					var oneB = one.b;
					switch (two.$) {
						case 'GenericType':
							var b = two.a;
							var _v24 = A2($elm$core$Dict$get, b, vars);
							if (_v24.$ === 'Nothing') {
								return _Utils_Tuple2(
									A3($elm$core$Dict$insert, b, one, vars),
									$elm$core$Result$Ok(one));
							} else {
								var foundTwo = _v24.a;
								var $temp$vars = vars,
									$temp$one = one,
									$temp$two = foundTwo;
								vars = $temp$vars;
								one = $temp$one;
								two = $temp$two;
								continue unifiableHelper;
							}
						case 'FunctionTypeAnnotation':
							var twoA = two.a;
							var twoB = two.b;
							var _v25 = A3(
								$author$project$Internal$Compiler$unifiableHelper,
								vars,
								$author$project$Internal$Compiler$denode(oneA),
								$author$project$Internal$Compiler$denode(twoA));
							if (_v25.b.$ === 'Ok') {
								var aVars = _v25.a;
								var unifiedA = _v25.b.a;
								var _v26 = A3(
									$author$project$Internal$Compiler$unifiableHelper,
									aVars,
									$author$project$Internal$Compiler$denode(oneB),
									$author$project$Internal$Compiler$denode(twoB));
								if (_v26.b.$ === 'Ok') {
									var bVars = _v26.a;
									var unifiedB = _v26.b.a;
									return _Utils_Tuple2(
										bVars,
										$elm$core$Result$Ok(
											A2(
												$stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$FunctionTypeAnnotation,
												$author$project$Internal$Compiler$nodify(unifiedA),
												$author$project$Internal$Compiler$nodify(unifiedB))));
								} else {
									var otherwise = _v26;
									return otherwise;
								}
							} else {
								var otherwise = _v25;
								return otherwise;
							}
						default:
							return _Utils_Tuple2(
								vars,
								$elm$core$Result$Err('Unable to unify function with non function type!'));
					}
			}
		}
	});
var $author$project$Internal$Compiler$unifiableLists = F4(
	function (vars, one, two, unified) {
		unifiableLists:
		while (true) {
			var _v0 = _Utils_Tuple2(one, two);
			_v0$3:
			while (true) {
				if (!_v0.a.b) {
					if (!_v0.b.b) {
						return _Utils_Tuple2(
							vars,
							$elm$core$Result$Ok(
								$author$project$Internal$Compiler$nodifyAll(
									$elm$core$List$reverse(unified))));
					} else {
						break _v0$3;
					}
				} else {
					if (_v0.b.b) {
						if ((!_v0.a.b.b) && (!_v0.b.b.b)) {
							var _v1 = _v0.a;
							var oneX = _v1.a;
							var _v2 = _v0.b;
							var twoX = _v2.a;
							var _v3 = A3(
								$author$project$Internal$Compiler$unifiableHelper,
								vars,
								$author$project$Internal$Compiler$denode(oneX),
								$author$project$Internal$Compiler$denode(twoX));
							if (_v3.b.$ === 'Ok') {
								var newVars = _v3.a;
								var un = _v3.b.a;
								return _Utils_Tuple2(
									newVars,
									$elm$core$Result$Ok(
										$author$project$Internal$Compiler$nodifyAll(
											$elm$core$List$reverse(
												A2($elm$core$List$cons, un, unified)))));
							} else {
								var newVars = _v3.a;
								var err = _v3.b.a;
								return _Utils_Tuple2(
									newVars,
									$elm$core$Result$Err(err));
							}
						} else {
							var _v4 = _v0.a;
							var oneX = _v4.a;
							var oneRemain = _v4.b;
							var _v5 = _v0.b;
							var twoX = _v5.a;
							var twoRemain = _v5.b;
							var _v6 = A3(
								$author$project$Internal$Compiler$unifiableHelper,
								vars,
								$author$project$Internal$Compiler$denode(oneX),
								$author$project$Internal$Compiler$denode(twoX));
							if (_v6.b.$ === 'Ok') {
								var newVars = _v6.a;
								var un = _v6.b.a;
								var $temp$vars = newVars,
									$temp$one = oneRemain,
									$temp$two = twoRemain,
									$temp$unified = A2($elm$core$List$cons, un, unified);
								vars = $temp$vars;
								one = $temp$one;
								two = $temp$two;
								unified = $temp$unified;
								continue unifiableLists;
							} else {
								var newVars = _v6.a;
								var err = _v6.b.a;
								return _Utils_Tuple2(
									vars,
									$elm$core$Result$Err(err));
							}
						}
					} else {
						break _v0$3;
					}
				}
			}
			return _Utils_Tuple2(
				vars,
				$elm$core$Result$Err('Mismatched numbers of type variables'));
		}
	});
var $author$project$Internal$Compiler$unifiable = F2(
	function (one, two) {
		var _v0 = A3($author$project$Internal$Compiler$unifiableHelper, $elm$core$Dict$empty, one, two);
		var result = _v0.b;
		var _v1 = function () {
			if (result.$ === 'Ok') {
				return _Utils_Tuple2(one, two);
			} else {
				return _Utils_Tuple2(one, two);
			}
		}();
		return result;
	});
var $author$project$Internal$Compiler$applyTypeHelper = F2(
	function (fn, args) {
		applyTypeHelper:
		while (true) {
			if (fn.$ === 'FunctionTypeAnnotation') {
				var one = fn.a;
				var two = fn.b;
				if (!args.b) {
					return $elm$core$Result$Ok(fn);
				} else {
					var top = args.a;
					var rest = args.b;
					var _v2 = A2(
						$author$project$Internal$Compiler$unifiable,
						$author$project$Internal$Compiler$denode(one),
						top);
					if (_v2.$ === 'Ok') {
						if (!rest.b) {
							return $elm$core$Result$Ok(
								$author$project$Internal$Compiler$denode(two));
						} else {
							var $temp$fn = $author$project$Internal$Compiler$denode(two),
								$temp$args = rest;
							fn = $temp$fn;
							args = $temp$args;
							continue applyTypeHelper;
						}
					} else {
						var err = _v2.a;
						return $elm$core$Result$Err(_List_Nil);
					}
				}
			} else {
				var _final = fn;
				if (!args.b) {
					return $elm$core$Result$Ok(fn);
				} else {
					return $elm$core$Result$Err(
						_List_fromArray(
							[$author$project$Internal$Compiler$FunctionAppliedToTooManyArgs]));
				}
			}
		}
	});
var $author$project$Internal$Compiler$extractListAnnotation = F2(
	function (expressions, annotations) {
		extractListAnnotation:
		while (true) {
			if (!expressions.b) {
				return $elm$core$Result$Ok(
					$elm$core$List$reverse(annotations));
			} else {
				var top = expressions.a.a;
				var remain = expressions.b;
				var _v1 = top.annotation;
				if (_v1.$ === 'Ok') {
					var ann = _v1.a;
					var $temp$expressions = remain,
						$temp$annotations = A2($elm$core$List$cons, ann, annotations);
					expressions = $temp$expressions;
					annotations = $temp$annotations;
					continue extractListAnnotation;
				} else {
					var err = _v1.a;
					return $elm$core$Result$Err(err);
				}
			}
		}
	});
var $author$project$Internal$Compiler$applyType = F2(
	function (_v0, args) {
		var exp = _v0.a;
		var _v1 = exp.annotation;
		if (_v1.$ === 'Err') {
			var err = _v1.a;
			return $elm$core$Result$Err(err);
		} else {
			var topAnnotation = _v1.a;
			var _v2 = A2($author$project$Internal$Compiler$extractListAnnotation, args, _List_Nil);
			if (_v2.$ === 'Ok') {
				var types = _v2.a;
				return A2($author$project$Internal$Compiler$applyTypeHelper, topAnnotation, types);
			} else {
				var err = _v2.a;
				return $elm$core$Result$Err(err);
			}
		}
	});
var $elm$core$Basics$composeL = F3(
	function (g, f, x) {
		return g(
			f(x));
	});
var $elm$core$List$append = F2(
	function (xs, ys) {
		if (!ys.b) {
			return xs;
		} else {
			return A3($elm$core$List$foldr, $elm$core$List$cons, ys, xs);
		}
	});
var $elm$core$List$concat = function (lists) {
	return A3($elm$core$List$foldr, $elm$core$List$append, _List_Nil, lists);
};
var $elm$core$List$concatMap = F2(
	function (f, list) {
		return $elm$core$List$concat(
			A2($elm$core$List$map, f, list));
	});
var $elm$core$List$filter = F2(
	function (isGood, list) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (x, xs) {
					return isGood(x) ? A2($elm$core$List$cons, x, xs) : xs;
				}),
			_List_Nil,
			list);
	});
var $author$project$Elm$getExpression = function (_v0) {
	var exp = _v0.a;
	return exp.expression;
};
var $author$project$Elm$getImports = function (_v0) {
	var exp = _v0.a;
	return exp.imports;
};
var $elm$core$Basics$not = _Basics_not;
var $stil4m$elm_syntax$Elm$Syntax$Expression$ParenthesizedExpression = function (a) {
	return {$: 'ParenthesizedExpression', a: a};
};
var $author$project$Elm$parens = function (expr) {
	return $stil4m$elm_syntax$Elm$Syntax$Expression$ParenthesizedExpression(
		$author$project$Internal$Compiler$nodify(expr));
};
var $author$project$Elm$apply = F2(
	function (top, allArgs) {
		var exp = top.a;
		var args = A2(
			$elm$core$List$filter,
			function (_v0) {
				var arg = _v0.a;
				return !arg.skip;
			},
			allArgs);
		return $author$project$Internal$Compiler$Expression(
			{
				annotation: A2($author$project$Internal$Compiler$applyType, top, args),
				expression: $stil4m$elm_syntax$Elm$Syntax$Expression$Application(
					$author$project$Internal$Compiler$nodifyAll(
						A2(
							$elm$core$List$cons,
							exp.expression,
							A2(
								$elm$core$List$map,
								A2($elm$core$Basics$composeL, $author$project$Elm$parens, $author$project$Elm$getExpression),
								args)))),
				imports: _Utils_ap(
					exp.imports,
					A2($elm$core$List$concatMap, $author$project$Elm$getImports, args)),
				skip: false
			});
	});
var $author$project$Internal$Compiler$Annotation = function (a) {
	return {$: 'Annotation', a: a};
};
var $author$project$Internal$Compiler$getAnnotationImports = function (_v0) {
	var details = _v0.a;
	return details.imports;
};
var $author$project$Internal$Compiler$getInnerAnnotation = function (_v0) {
	var details = _v0.a;
	return details.annotation;
};
var $author$project$Elm$Annotation$function = F2(
	function (anns, _return) {
		return $author$project$Internal$Compiler$Annotation(
			{
				annotation: A3(
					$elm$core$List$foldr,
					F2(
						function (ann, fn) {
							return A2(
								$stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$FunctionTypeAnnotation,
								$author$project$Internal$Compiler$nodify(ann),
								$author$project$Internal$Compiler$nodify(fn));
						}),
					$author$project$Internal$Compiler$getInnerAnnotation(_return),
					A2($elm$core$List$map, $author$project$Internal$Compiler$getInnerAnnotation, anns)),
				imports: _Utils_ap(
					$author$project$Internal$Compiler$getAnnotationImports(_return),
					A2($elm$core$List$concatMap, $author$project$Internal$Compiler$getAnnotationImports, anns))
			});
	});
var $author$project$Elm$Gen$Json$Decode$moduleName_ = _List_fromArray(
	['Json', 'Decode']);
var $elm$core$String$length = _String_length;
var $elm$core$String$slice = _String_slice;
var $elm$core$String$dropLeft = F2(
	function (n, string) {
		return (n < 1) ? string : A3(
			$elm$core$String$slice,
			n,
			$elm$core$String$length(string),
			string);
	});
var $elm$core$String$left = F2(
	function (n, string) {
		return (n < 1) ? '' : A3($elm$core$String$slice, 0, n, string);
	});
var $elm$core$String$toUpper = _String_toUpper;
var $author$project$Internal$Compiler$formatType = function (str) {
	return _Utils_ap(
		$elm$core$String$toUpper(
			A2($elm$core$String$left, 1, str)),
		A2($elm$core$String$dropLeft, 1, str));
};
var $author$project$Elm$Annotation$namedWith = F3(
	function (mod, name, args) {
		return $author$project$Internal$Compiler$Annotation(
			{
				annotation: A2(
					$stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Typed,
					$author$project$Internal$Compiler$nodify(
						_Utils_Tuple2(
							mod,
							$author$project$Internal$Compiler$formatType(name))),
					$author$project$Internal$Compiler$nodifyAll(
						A2($elm$core$List$map, $author$project$Internal$Compiler$getInnerAnnotation, args))),
				imports: A2(
					$elm$core$List$cons,
					mod,
					A2($elm$core$List$concatMap, $author$project$Internal$Compiler$getAnnotationImports, args))
			});
	});
var $stil4m$elm_syntax$Elm$Syntax$Expression$UnitExpr = {$: 'UnitExpr'};
var $author$project$Internal$Compiler$skip = $author$project$Internal$Compiler$Expression(
	{
		annotation: $elm$core$Result$Err(_List_Nil),
		expression: $stil4m$elm_syntax$Elm$Syntax$Expression$UnitExpr,
		imports: _List_Nil,
		skip: true
	});
var $author$project$Elm$pass = $author$project$Internal$Compiler$skip;
var $stil4m$elm_syntax$Elm$Syntax$Expression$FunctionOrValue = F2(
	function (a, b) {
		return {$: 'FunctionOrValue', a: a, b: b};
	});
var $author$project$Internal$Compiler$sanitize = function (str) {
	switch (str) {
		case 'in':
			return 'in_';
		case 'type':
			return 'type_';
		case 'case':
			return 'case_';
		case 'let':
			return 'let_';
		case 'module':
			return 'module_';
		case 'exposing':
			return 'exposing_';
		default:
			return str;
	}
};
var $author$project$Elm$valueWith = F3(
	function (mod, name, ann) {
		return $author$project$Internal$Compiler$Expression(
			{
				annotation: $elm$core$Result$Ok(
					$author$project$Internal$Compiler$getInnerAnnotation(ann)),
				expression: A2(
					$stil4m$elm_syntax$Elm$Syntax$Expression$FunctionOrValue,
					mod,
					$author$project$Internal$Compiler$sanitize(name)),
				imports: A2(
					$elm$core$List$cons,
					mod,
					$author$project$Internal$Compiler$getAnnotationImports(ann)),
				skip: false
			});
	});
var $stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$GenericType = function (a) {
	return {$: 'GenericType', a: a};
};
var $elm$core$String$toLower = _String_toLower;
var $author$project$Internal$Compiler$formatValue = function (str) {
	var formatted = _Utils_eq(
		$elm$core$String$toUpper(str),
		str) ? $elm$core$String$toLower(str) : _Utils_ap(
		$elm$core$String$toLower(
			A2($elm$core$String$left, 1, str)),
		A2($elm$core$String$dropLeft, 1, str));
	return $author$project$Internal$Compiler$sanitize(formatted);
};
var $author$project$Elm$Annotation$var = function (a) {
	return $author$project$Internal$Compiler$Annotation(
		{
			annotation: $stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$GenericType(
				$author$project$Internal$Compiler$formatValue(a)),
			imports: _List_Nil
		});
};
var $author$project$Elm$Gen$Json$Decode$andThen = F2(
	function (arg1, arg2) {
		return A2(
			$author$project$Elm$apply,
			A3(
				$author$project$Elm$valueWith,
				$author$project$Elm$Gen$Json$Decode$moduleName_,
				'andThen',
				A2(
					$author$project$Elm$Annotation$function,
					_List_fromArray(
						[
							A2(
							$author$project$Elm$Annotation$function,
							_List_fromArray(
								[
									$author$project$Elm$Annotation$var('a')
								]),
							A3(
								$author$project$Elm$Annotation$namedWith,
								_List_fromArray(
									['Json', 'Decode']),
								'Decoder',
								_List_fromArray(
									[
										$author$project$Elm$Annotation$var('b')
									]))),
							A3(
							$author$project$Elm$Annotation$namedWith,
							_List_fromArray(
								['Json', 'Decode']),
							'Decoder',
							_List_fromArray(
								[
									$author$project$Elm$Annotation$var('a')
								]))
						]),
					A3(
						$author$project$Elm$Annotation$namedWith,
						_List_fromArray(
							['Json', 'Decode']),
						'Decoder',
						_List_fromArray(
							[
								$author$project$Elm$Annotation$var('b')
							])))),
			_List_fromArray(
				[
					arg1($author$project$Elm$pass),
					arg2
				]));
	});
var $author$project$Internal$Compiler$CaseBranchesReturnDifferentTypes = {$: 'CaseBranchesReturnDifferentTypes'};
var $stil4m$elm_syntax$Elm$Syntax$Expression$CaseExpression = function (a) {
	return {$: 'CaseExpression', a: a};
};
var $author$project$Internal$Compiler$EmptyCaseStatement = {$: 'EmptyCaseStatement'};
var $author$project$Elm$caseOf = F2(
	function (_v0, cases) {
		var expr = _v0.a;
		var gathered = A3(
			$elm$core$List$foldl,
			F2(
				function (_v2, accum) {
					var pattern = _v2.a;
					var exp = _v2.b.a;
					return {
						annotation: function () {
							var _v3 = accum.annotation;
							if (_v3.$ === 'Nothing') {
								return $elm$core$Maybe$Just(exp.annotation);
							} else {
								var exist = _v3.a;
								return _Utils_eq(exist, exp.annotation) ? accum.annotation : $elm$core$Maybe$Just(
									$elm$core$Result$Err(
										_List_fromArray(
											[$author$project$Internal$Compiler$CaseBranchesReturnDifferentTypes])));
							}
						}(),
						cases: A2(
							$elm$core$List$cons,
							_Utils_Tuple2(
								$author$project$Internal$Compiler$nodify(pattern),
								$author$project$Internal$Compiler$nodify(exp.expression)),
							accum.cases),
						imports: _Utils_ap(accum.imports, exp.imports)
					};
				}),
			{annotation: $elm$core$Maybe$Nothing, cases: _List_Nil, imports: _List_Nil},
			cases);
		return $author$project$Internal$Compiler$Expression(
			{
				annotation: function () {
					var _v1 = gathered.annotation;
					if (_v1.$ === 'Nothing') {
						return $elm$core$Result$Err(
							_List_fromArray(
								[$author$project$Internal$Compiler$EmptyCaseStatement]));
					} else {
						var ann = _v1.a;
						return ann;
					}
				}(),
				expression: $stil4m$elm_syntax$Elm$Syntax$Expression$CaseExpression(
					{
						cases: $elm$core$List$reverse(gathered.cases),
						expression: $author$project$Internal$Compiler$nodify(expr.expression)
					}),
				imports: _Utils_ap(expr.imports, gathered.imports),
				skip: false
			});
	});
var $stil4m$elm_syntax$Elm$Syntax$Declaration$CustomTypeDeclaration = function (a) {
	return {$: 'CustomTypeDeclaration', a: a};
};
var $author$project$Internal$Compiler$Declaration = F3(
	function (a, b, c) {
		return {$: 'Declaration', a: a, b: b, c: c};
	});
var $author$project$Internal$Compiler$NotExposed = {$: 'NotExposed'};
var $elm$core$Basics$composeR = F3(
	function (f, g, x) {
		return g(
			f(x));
	});
var $author$project$Internal$Compiler$getGenericsHelper = function (ann) {
	switch (ann.$) {
		case 'GenericType':
			var str = ann.a;
			return _List_fromArray(
				[
					$author$project$Internal$Compiler$nodify(str)
				]);
		case 'Typed':
			var modName = ann.a;
			var anns = ann.b;
			return A2(
				$elm$core$List$concatMap,
				A2($elm$core$Basics$composeL, $author$project$Internal$Compiler$getGenericsHelper, $author$project$Internal$Compiler$denode),
				anns);
		case 'Unit':
			return _List_Nil;
		case 'Tupled':
			var tupled = ann.a;
			return A2(
				$elm$core$List$concatMap,
				A2($elm$core$Basics$composeL, $author$project$Internal$Compiler$getGenericsHelper, $author$project$Internal$Compiler$denode),
				tupled);
		case 'Record':
			var recordDefinition = ann.a;
			return A2(
				$elm$core$List$concatMap,
				function (nodedField) {
					var _v1 = $author$project$Internal$Compiler$denode(nodedField);
					var name = _v1.a;
					var field = _v1.b;
					return $author$project$Internal$Compiler$getGenericsHelper(
						$author$project$Internal$Compiler$denode(field));
				},
				recordDefinition);
		case 'GenericRecord':
			var recordName = ann.a;
			var recordDefinition = ann.b;
			return A2(
				$elm$core$List$concatMap,
				function (nodedField) {
					var _v2 = $author$project$Internal$Compiler$denode(nodedField);
					var name = _v2.a;
					var field = _v2.b;
					return $author$project$Internal$Compiler$getGenericsHelper(
						$author$project$Internal$Compiler$denode(field));
				},
				$author$project$Internal$Compiler$denode(recordDefinition));
		default:
			var one = ann.a;
			var two = ann.b;
			return A2(
				$elm$core$List$concatMap,
				$author$project$Internal$Compiler$getGenericsHelper,
				_List_fromArray(
					[
						$author$project$Internal$Compiler$denode(one),
						$author$project$Internal$Compiler$denode(two)
					]));
	}
};
var $author$project$Internal$Compiler$getGenerics = function (_v0) {
	var details = _v0.a;
	return $author$project$Internal$Compiler$getGenericsHelper(details.annotation);
};
var $author$project$Elm$customType = F2(
	function (name, variants) {
		return A3(
			$author$project$Internal$Compiler$Declaration,
			$author$project$Internal$Compiler$NotExposed,
			A2(
				$elm$core$List$concatMap,
				function (_v0) {
					var listAnn = _v0.b;
					return A2($elm$core$List$concatMap, $author$project$Internal$Compiler$getAnnotationImports, listAnn);
				},
				variants),
			$stil4m$elm_syntax$Elm$Syntax$Declaration$CustomTypeDeclaration(
				{
					constructors: A2(
						$elm$core$List$map,
						function (_v1) {
							var varName = _v1.a;
							var vars = _v1.b;
							return $author$project$Internal$Compiler$nodify(
								{
									_arguments: A2(
										$elm$core$List$map,
										A2($elm$core$Basics$composeR, $author$project$Internal$Compiler$getInnerAnnotation, $author$project$Internal$Compiler$nodify),
										vars),
									name: $author$project$Internal$Compiler$nodify(
										$author$project$Internal$Compiler$formatType(varName))
								});
						},
						variants),
					documentation: $elm$core$Maybe$Nothing,
					generics: A2(
						$elm$core$List$concatMap,
						function (_v2) {
							var listAnn = _v2.b;
							return A2($elm$core$List$concatMap, $author$project$Internal$Compiler$getGenerics, listAnn);
						},
						variants),
					name: $author$project$Internal$Compiler$nodify(
						$author$project$Internal$Compiler$formatType(name))
				}));
	});
var $stil4m$elm_syntax$Elm$Syntax$Declaration$FunctionDeclaration = function (a) {
	return {$: 'FunctionDeclaration', a: a};
};
var $author$project$Internal$Compiler$nodifyMaybe = $elm$core$Maybe$map($author$project$Internal$Compiler$nodify);
var $author$project$Elm$declaration = F2(
	function (name, _v0) {
		var body = _v0.a;
		return A3(
			$author$project$Internal$Compiler$Declaration,
			$author$project$Internal$Compiler$NotExposed,
			body.imports,
			$stil4m$elm_syntax$Elm$Syntax$Declaration$FunctionDeclaration(
				{
					declaration: $author$project$Internal$Compiler$nodify(
						{
							_arguments: _List_Nil,
							expression: $author$project$Internal$Compiler$nodify(body.expression),
							name: $author$project$Internal$Compiler$nodify(
								$author$project$Internal$Compiler$formatValue(name))
						}),
					documentation: $author$project$Internal$Compiler$nodifyMaybe($elm$core$Maybe$Nothing),
					signature: function () {
						var _v1 = body.annotation;
						if (_v1.$ === 'Ok') {
							var sig = _v1.a;
							return $elm$core$Maybe$Just(
								$author$project$Internal$Compiler$nodify(
									{
										name: $author$project$Internal$Compiler$nodify(
											$author$project$Internal$Compiler$formatValue(name)),
										typeAnnotation: $author$project$Internal$Compiler$nodify(sig)
									}));
						} else {
							return $elm$core$Maybe$Nothing;
						}
					}()
				}));
	});
var $author$project$Utils$String$formatTypename = function (name) {
	var first = A2($elm$core$String$left, 1, name);
	return _Utils_ap(
		$elm$core$String$toUpper(first),
		A2($elm$core$String$dropLeft, 1, name));
};
var $author$project$Generate$Enums$enumNameToConstructorName = $author$project$Utils$String$formatTypename;
var $author$project$Internal$Compiler$Exposed = function (a) {
	return {$: 'Exposed', a: a};
};
var $author$project$Internal$Compiler$expose = function (decl) {
	if (decl.$ === 'Comment') {
		return decl;
	} else {
		var imports = decl.b;
		var body = decl.c;
		return A3(
			$author$project$Internal$Compiler$Declaration,
			$author$project$Internal$Compiler$Exposed(
				{exposeConstructor: false, group: $elm$core$Maybe$Nothing}),
			imports,
			body);
	}
};
var $author$project$Elm$expose = $author$project$Internal$Compiler$expose;
var $author$project$Internal$Compiler$exposeConstructor = function (decl) {
	if (decl.$ === 'Comment') {
		return decl;
	} else {
		var metadata = decl.a;
		var imports = decl.b;
		var body = decl.c;
		return A3(
			$author$project$Internal$Compiler$Declaration,
			$author$project$Internal$Compiler$Exposed(
				{exposeConstructor: true, group: $elm$core$Maybe$Nothing}),
			imports,
			body);
	}
};
var $author$project$Elm$exposeConstructor = $author$project$Internal$Compiler$exposeConstructor;
var $author$project$Elm$Annotation$typed = F3(
	function (mod, name, args) {
		return $author$project$Internal$Compiler$Annotation(
			{
				annotation: A2(
					$stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Typed,
					$author$project$Internal$Compiler$nodify(
						_Utils_Tuple2(mod, name)),
					$author$project$Internal$Compiler$nodifyAll(
						A2($elm$core$List$map, $author$project$Internal$Compiler$getInnerAnnotation, args))),
				imports: A2($elm$core$List$concatMap, $author$project$Internal$Compiler$getAnnotationImports, args)
			});
	});
var $author$project$Elm$Annotation$string = A3($author$project$Elm$Annotation$typed, _List_Nil, 'String', _List_Nil);
var $author$project$Elm$Gen$Json$Decode$fail = function (arg1) {
	return A2(
		$author$project$Elm$apply,
		A3(
			$author$project$Elm$valueWith,
			$author$project$Elm$Gen$Json$Decode$moduleName_,
			'fail',
			A2(
				$author$project$Elm$Annotation$function,
				_List_fromArray(
					[$author$project$Elm$Annotation$string]),
				A3(
					$author$project$Elm$Annotation$namedWith,
					_List_fromArray(
						['Json', 'Decode']),
					'Decoder',
					_List_fromArray(
						[
							$author$project$Elm$Annotation$var('a')
						])))),
		_List_fromArray(
			[arg1]));
};
var $elm$core$Set$Set_elm_builtin = function (a) {
	return {$: 'Set_elm_builtin', a: a};
};
var $elm$core$Set$empty = $elm$core$Set$Set_elm_builtin($elm$core$Dict$empty);
var $author$project$Internal$Compiler$fullModName = function (name) {
	return A2($elm$core$String$join, '.', name);
};
var $elm$core$Set$insert = F2(
	function (key, _v0) {
		var dict = _v0.a;
		return $elm$core$Set$Set_elm_builtin(
			A3($elm$core$Dict$insert, key, _Utils_Tuple0, dict));
	});
var $elm$core$Set$member = F2(
	function (key, _v0) {
		var dict = _v0.a;
		return A2($elm$core$Dict$member, key, dict);
	});
var $author$project$Elm$addImports = F3(
	function (self, newImports, _v0) {
		addImports:
		while (true) {
			var set = _v0.a;
			var deduped = _v0.b;
			if (!newImports.b) {
				return _Utils_Tuple2(set, deduped);
			} else {
				var _new = newImports.a;
				var remain = newImports.b;
				var full = $author$project$Internal$Compiler$fullModName(_new);
				if (A2($elm$core$Set$member, full, set) || _Utils_eq(
					full,
					$author$project$Internal$Compiler$fullModName(self))) {
					var $temp$self = self,
						$temp$newImports = remain,
						$temp$_v0 = _Utils_Tuple2(set, deduped);
					self = $temp$self;
					newImports = $temp$newImports;
					_v0 = $temp$_v0;
					continue addImports;
				} else {
					var $temp$self = self,
						$temp$newImports = remain,
						$temp$_v0 = _Utils_Tuple2(
						A2($elm$core$Set$insert, full, set),
						A2($elm$core$List$cons, _new, deduped));
					self = $temp$self;
					newImports = $temp$newImports;
					_v0 = $temp$_v0;
					continue addImports;
				}
			}
		}
	});
var $author$project$Elm$reduceDeclarationImports = F3(
	function (self, decs, imports) {
		reduceDeclarationImports:
		while (true) {
			if (!decs.b) {
				return imports;
			} else {
				if (decs.a.$ === 'Comment') {
					var remain = decs.b;
					var $temp$self = self,
						$temp$decs = remain,
						$temp$imports = imports;
					self = $temp$self;
					decs = $temp$decs;
					imports = $temp$imports;
					continue reduceDeclarationImports;
				} else {
					var _v1 = decs.a;
					var newImports = _v1.b;
					var body = _v1.c;
					var remain = decs.b;
					var $temp$self = self,
						$temp$decs = remain,
						$temp$imports = A3($author$project$Elm$addImports, self, newImports, imports);
					self = $temp$self;
					decs = $temp$decs;
					imports = $temp$imports;
					continue reduceDeclarationImports;
				}
			}
		}
	});
var $stil4m$elm_syntax$Elm$Syntax$Exposing$All = function (a) {
	return {$: 'All', a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Exposing$Explicit = function (a) {
	return {$: 'Explicit', a: a};
};
var $author$project$Internal$Comments$Markdown = function (a) {
	return {$: 'Markdown', a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Module$NormalModule = function (a) {
	return {$: 'NormalModule', a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Module$PortModule = function (a) {
	return {$: 'PortModule', a: a};
};
var $author$project$Internal$Comments$Comment = function (a) {
	return {$: 'Comment', a: a};
};
var $author$project$Internal$Comments$addPart = F2(
	function (_v0, part) {
		var parts = _v0.a;
		return $author$project$Internal$Comments$Comment(
			A2($elm$core$List$cons, part, parts));
	});
var $author$project$Internal$Comments$emptyComment = $author$project$Internal$Comments$Comment(_List_Nil);
var $stil4m$elm_syntax$Elm$Syntax$Exposing$FunctionExpose = function (a) {
	return {$: 'FunctionExpose', a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Exposing$TypeExpose = function (a) {
	return {$: 'TypeExpose', a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Exposing$TypeOrAliasExpose = function (a) {
	return {$: 'TypeOrAliasExpose', a: a};
};
var $author$project$Internal$Compiler$getExposed = function (decls) {
	return A2(
		$elm$core$List$filterMap,
		function (decl) {
			if (decl.$ === 'Comment') {
				return $elm$core$Maybe$Nothing;
			} else {
				var exp = decl.a;
				var decBody = decl.c;
				if (exp.$ === 'NotExposed') {
					return $elm$core$Maybe$Nothing;
				} else {
					var details = exp.a;
					switch (decBody.$) {
						case 'FunctionDeclaration':
							var fn = decBody.a;
							var fnName = $author$project$Internal$Compiler$denode(
								function ($) {
									return $.name;
								}(
									$author$project$Internal$Compiler$denode(fn.declaration)));
							return $elm$core$Maybe$Just(
								$stil4m$elm_syntax$Elm$Syntax$Exposing$FunctionExpose(fnName));
						case 'AliasDeclaration':
							var synonym = decBody.a;
							var aliasName = $author$project$Internal$Compiler$denode(synonym.name);
							return $elm$core$Maybe$Just(
								$stil4m$elm_syntax$Elm$Syntax$Exposing$TypeOrAliasExpose(aliasName));
						case 'CustomTypeDeclaration':
							var myType = decBody.a;
							var typeName = $author$project$Internal$Compiler$denode(myType.name);
							return details.exposeConstructor ? $elm$core$Maybe$Just(
								$stil4m$elm_syntax$Elm$Syntax$Exposing$TypeExpose(
									{
										name: typeName,
										open: $elm$core$Maybe$Just($stil4m$elm_syntax$Elm$Syntax$Range$emptyRange)
									})) : $elm$core$Maybe$Just(
								$stil4m$elm_syntax$Elm$Syntax$Exposing$TypeOrAliasExpose(typeName));
						case 'PortDeclaration':
							var myPort = decBody.a;
							var typeName = $author$project$Internal$Compiler$denode(myPort.name);
							return $elm$core$Maybe$Just(
								$stil4m$elm_syntax$Elm$Syntax$Exposing$FunctionExpose(typeName));
						case 'InfixDeclaration':
							var infix = decBody.a;
							return $elm$core$Maybe$Nothing;
						default:
							return $elm$core$Maybe$Nothing;
					}
				}
			}
		},
		decls);
};
var $author$project$Internal$Compiler$declName = function (decl) {
	if (decl.$ === 'Comment') {
		return $elm$core$Maybe$Nothing;
	} else {
		var exp = decl.a;
		var decBody = decl.c;
		switch (decBody.$) {
			case 'FunctionDeclaration':
				var fn = decBody.a;
				return $elm$core$Maybe$Just(
					$author$project$Internal$Compiler$denode(
						function ($) {
							return $.name;
						}(
							$author$project$Internal$Compiler$denode(fn.declaration))));
			case 'AliasDeclaration':
				var synonym = decBody.a;
				return $elm$core$Maybe$Just(
					$author$project$Internal$Compiler$denode(synonym.name));
			case 'CustomTypeDeclaration':
				var myType = decBody.a;
				return $elm$core$Maybe$Just(
					$author$project$Internal$Compiler$denode(myType.name));
			case 'PortDeclaration':
				var myPort = decBody.a;
				return $elm$core$Maybe$Just(
					$author$project$Internal$Compiler$denode(myPort.name));
			case 'InfixDeclaration':
				var infix = decBody.a;
				return $elm$core$Maybe$Nothing;
			default:
				return $elm$core$Maybe$Nothing;
		}
	}
};
var $author$project$Internal$Compiler$matchName = F2(
	function (one, two) {
		if (one.$ === 'Nothing') {
			if (two.$ === 'Nothing') {
				return true;
			} else {
				return false;
			}
		} else {
			var oneName = one.a;
			if (two.$ === 'Nothing') {
				return false;
			} else {
				var twoName = two.a;
				return _Utils_eq(oneName, twoName);
			}
		}
	});
var $author$project$Internal$Compiler$groupExposing = function (items) {
	return A3(
		$elm$core$List$foldr,
		F2(
			function (_v0, acc) {
				var maybeGroup = _v0.a;
				var name = _v0.b;
				if (!acc.b) {
					return _List_fromArray(
						[
							{
							group: maybeGroup,
							members: _List_fromArray(
								[name])
						}
						]);
				} else {
					var top = acc.a;
					var groups = acc.b;
					return A2($author$project$Internal$Compiler$matchName, maybeGroup, top.group) ? A2(
						$elm$core$List$cons,
						{
							group: top.group,
							members: A2($elm$core$List$cons, name, top.members)
						},
						groups) : A2(
						$elm$core$List$cons,
						{
							group: maybeGroup,
							members: _List_fromArray(
								[name])
						},
						acc);
				}
			}),
		_List_Nil,
		items);
};
var $elm$core$List$sortBy = _List_sortBy;
var $author$project$Internal$Compiler$getExposedGroups = function (decls) {
	return $author$project$Internal$Compiler$groupExposing(
		A2(
			$elm$core$List$sortBy,
			function (_v3) {
				var group = _v3.a;
				if (group.$ === 'Nothing') {
					return 'zzzzzzzzz';
				} else {
					var name = group.a;
					return name;
				}
			},
			A2(
				$elm$core$List$filterMap,
				function (decl) {
					if (decl.$ === 'Comment') {
						return $elm$core$Maybe$Nothing;
					} else {
						var exp = decl.a;
						var decBody = decl.c;
						if (exp.$ === 'NotExposed') {
							return $elm$core$Maybe$Nothing;
						} else {
							var details = exp.a;
							var _v2 = $author$project$Internal$Compiler$declName(decl);
							if (_v2.$ === 'Nothing') {
								return $elm$core$Maybe$Nothing;
							} else {
								var name = _v2.a;
								return $elm$core$Maybe$Just(
									_Utils_Tuple2(details.group, name));
							}
						}
					}
				},
				decls)));
};
var $author$project$Internal$Compiler$hasPorts = function (decls) {
	return A2(
		$elm$core$List$any,
		function (decl) {
			if (decl.$ === 'Comment') {
				return false;
			} else {
				var exp = decl.a;
				var decBody = decl.c;
				if (exp.$ === 'NotExposed') {
					return false;
				} else {
					if (decBody.$ === 'PortDeclaration') {
						var myPort = decBody.a;
						return true;
					} else {
						return false;
					}
				}
			}
		},
		decls);
};
var $author$project$Internal$Compiler$builtIn = function (name) {
	_v0$4:
	while (true) {
		if (name.b && (!name.b.b)) {
			switch (name.a) {
				case 'List':
					return true;
				case 'Maybe':
					return true;
				case 'String':
					return true;
				case 'Basics':
					return true;
				default:
					break _v0$4;
			}
		} else {
			break _v0$4;
		}
	}
	return false;
};
var $author$project$Internal$Compiler$findAlias = F2(
	function (modName, aliases) {
		findAlias:
		while (true) {
			if (!aliases.b) {
				return $elm$core$Maybe$Nothing;
			} else {
				var _v1 = aliases.a;
				var aliasModName = _v1.a;
				var alias = _v1.b;
				var remain = aliases.b;
				if (_Utils_eq(modName, aliasModName)) {
					return $elm$core$Maybe$Just(alias);
				} else {
					var $temp$modName = modName,
						$temp$aliases = remain;
					modName = $temp$modName;
					aliases = $temp$aliases;
					continue findAlias;
				}
			}
		}
	});
var $author$project$Internal$Compiler$makeImport = F2(
	function (aliases, name) {
		if (!name.b) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v1 = A2($author$project$Internal$Compiler$findAlias, name, aliases);
			if (_v1.$ === 'Nothing') {
				return $author$project$Internal$Compiler$builtIn(name) ? $elm$core$Maybe$Nothing : $elm$core$Maybe$Just(
					{
						exposingList: $elm$core$Maybe$Nothing,
						moduleAlias: $elm$core$Maybe$Nothing,
						moduleName: $author$project$Internal$Compiler$nodify(name)
					});
			} else {
				var alias = _v1.a;
				return $elm$core$Maybe$Just(
					{
						exposingList: $elm$core$Maybe$Nothing,
						moduleAlias: $elm$core$Maybe$Just(
							$author$project$Internal$Compiler$nodify(
								_List_fromArray(
									[alias]))),
						moduleName: $author$project$Internal$Compiler$nodify(name)
					});
			}
		}
	});
var $the_sett$elm_pretty_printer$Internals$Concatenate = F2(
	function (a, b) {
		return {$: 'Concatenate', a: a, b: b};
	});
var $the_sett$elm_pretty_printer$Pretty$append = F2(
	function (doc1, doc2) {
		return A2(
			$the_sett$elm_pretty_printer$Internals$Concatenate,
			function (_v0) {
				return doc1;
			},
			function (_v1) {
				return doc2;
			});
	});
var $elm_community$basics_extra$Basics$Extra$flip = F3(
	function (f, b, a) {
		return A2(f, a, b);
	});
var $the_sett$elm_pretty_printer$Pretty$a = $elm_community$basics_extra$Basics$Extra$flip($the_sett$elm_pretty_printer$Pretty$append);
var $the_sett$elm_pretty_printer$Internals$Line = F2(
	function (a, b) {
		return {$: 'Line', a: a, b: b};
	});
var $the_sett$elm_pretty_printer$Pretty$line = A2($the_sett$elm_pretty_printer$Internals$Line, ' ', '');
var $the_sett$elm_pretty_printer$Internals$Empty = {$: 'Empty'};
var $the_sett$elm_pretty_printer$Pretty$empty = $the_sett$elm_pretty_printer$Internals$Empty;
var $the_sett$elm_pretty_printer$Pretty$join = F2(
	function (sep, docs) {
		join:
		while (true) {
			if (!docs.b) {
				return $the_sett$elm_pretty_printer$Pretty$empty;
			} else {
				if (docs.a.$ === 'Empty') {
					var _v1 = docs.a;
					var ds = docs.b;
					var $temp$sep = sep,
						$temp$docs = ds;
					sep = $temp$sep;
					docs = $temp$docs;
					continue join;
				} else {
					var d = docs.a;
					var ds = docs.b;
					var step = F2(
						function (x, rest) {
							if (x.$ === 'Empty') {
								return rest;
							} else {
								var doc = x;
								return A2(
									$the_sett$elm_pretty_printer$Pretty$append,
									sep,
									A2($the_sett$elm_pretty_printer$Pretty$append, doc, rest));
							}
						});
					var spersed = A3($elm$core$List$foldr, step, $the_sett$elm_pretty_printer$Pretty$empty, ds);
					return A2($the_sett$elm_pretty_printer$Pretty$append, d, spersed);
				}
			}
		}
	});
var $the_sett$elm_pretty_printer$Pretty$lines = $the_sett$elm_pretty_printer$Pretty$join($the_sett$elm_pretty_printer$Pretty$line);
var $author$project$Internal$Compiler$denodeMaybe = $elm$core$Maybe$map($author$project$Internal$Compiler$denode);
var $author$project$Internal$Compiler$denodeAll = $elm$core$List$map($author$project$Internal$Compiler$denode);
var $the_sett$elm_pretty_printer$Internals$Text = F2(
	function (a, b) {
		return {$: 'Text', a: a, b: b};
	});
var $elm$core$String$cons = _String_cons;
var $elm$core$String$fromChar = function (_char) {
	return A2($elm$core$String$cons, _char, '');
};
var $the_sett$elm_pretty_printer$Pretty$char = function (c) {
	return A2(
		$the_sett$elm_pretty_printer$Internals$Text,
		$elm$core$String$fromChar(c),
		$elm$core$Maybe$Nothing);
};
var $the_sett$elm_pretty_printer$Pretty$surround = F3(
	function (left, right, doc) {
		return A2(
			$the_sett$elm_pretty_printer$Pretty$append,
			A2($the_sett$elm_pretty_printer$Pretty$append, left, doc),
			right);
	});
var $the_sett$elm_pretty_printer$Pretty$parens = function (doc) {
	return A3(
		$the_sett$elm_pretty_printer$Pretty$surround,
		$the_sett$elm_pretty_printer$Pretty$char(
			_Utils_chr('(')),
		$the_sett$elm_pretty_printer$Pretty$char(
			_Utils_chr(')')),
		doc);
};
var $the_sett$elm_pretty_printer$Pretty$string = function (val) {
	return A2($the_sett$elm_pretty_printer$Internals$Text, val, $elm$core$Maybe$Nothing);
};
var $author$project$Internal$Write$prettyTopLevelExpose = function (tlExpose) {
	switch (tlExpose.$) {
		case 'InfixExpose':
			var val = tlExpose.a;
			return $the_sett$elm_pretty_printer$Pretty$parens(
				$the_sett$elm_pretty_printer$Pretty$string(val));
		case 'FunctionExpose':
			var val = tlExpose.a;
			return $the_sett$elm_pretty_printer$Pretty$string(val);
		case 'TypeOrAliasExpose':
			var val = tlExpose.a;
			return $the_sett$elm_pretty_printer$Pretty$string(val);
		default:
			var exposedType = tlExpose.a;
			var _v1 = exposedType.open;
			if (_v1.$ === 'Nothing') {
				return $the_sett$elm_pretty_printer$Pretty$string(exposedType.name);
			} else {
				return A2(
					$the_sett$elm_pretty_printer$Pretty$a,
					$the_sett$elm_pretty_printer$Pretty$string('(..)'),
					$the_sett$elm_pretty_printer$Pretty$string(exposedType.name));
			}
	}
};
var $author$project$Internal$Write$prettyTopLevelExposes = function (exposes) {
	return A2(
		$the_sett$elm_pretty_printer$Pretty$join,
		$the_sett$elm_pretty_printer$Pretty$string(', '),
		A2($elm$core$List$map, $author$project$Internal$Write$prettyTopLevelExpose, exposes));
};
var $stil4m$elm_syntax$Elm$Syntax$Exposing$InfixExpose = function (a) {
	return {$: 'InfixExpose', a: a};
};
var $author$project$Internal$ImportsAndExposing$combineTopLevelExposes = function (exposes) {
	if (!exposes.b) {
		return $stil4m$elm_syntax$Elm$Syntax$Exposing$InfixExpose('');
	} else {
		var hd = exposes.a;
		var tl = exposes.b;
		return A3(
			$elm$core$List$foldl,
			F2(
				function (exp, result) {
					var _v1 = _Utils_Tuple2(exp, result);
					if (_v1.a.$ === 'TypeExpose') {
						var typeExpose = _v1.a.a;
						var _v2 = typeExpose.open;
						if (_v2.$ === 'Just') {
							return exp;
						} else {
							return result;
						}
					} else {
						if (_v1.b.$ === 'TypeExpose') {
							var typeExpose = _v1.b.a;
							var _v3 = typeExpose.open;
							if (_v3.$ === 'Just') {
								return result;
							} else {
								return exp;
							}
						} else {
							return result;
						}
					}
				}),
			hd,
			tl);
	}
};
var $author$project$Internal$ImportsAndExposing$topLevelExposeName = function (tle) {
	switch (tle.$) {
		case 'InfixExpose':
			var val = tle.a;
			return val;
		case 'FunctionExpose':
			var val = tle.a;
			return val;
		case 'TypeOrAliasExpose':
			var val = tle.a;
			return val;
		default:
			var exposedType = tle.a;
			return exposedType.name;
	}
};
var $author$project$Internal$ImportsAndExposing$groupByExposingName = function (innerImports) {
	var _v0 = function () {
		if (!innerImports.b) {
			return _Utils_Tuple3(
				'',
				_List_Nil,
				_List_fromArray(
					[_List_Nil]));
		} else {
			var hd = innerImports.a;
			return A3(
				$elm$core$List$foldl,
				F2(
					function (exp, _v2) {
						var currName = _v2.a;
						var currAccum = _v2.b;
						var accum = _v2.c;
						var nextName = $author$project$Internal$ImportsAndExposing$topLevelExposeName(exp);
						return _Utils_eq(nextName, currName) ? _Utils_Tuple3(
							currName,
							A2($elm$core$List$cons, exp, currAccum),
							accum) : _Utils_Tuple3(
							nextName,
							_List_fromArray(
								[exp]),
							A2($elm$core$List$cons, currAccum, accum));
					}),
				_Utils_Tuple3(
					$author$project$Internal$ImportsAndExposing$topLevelExposeName(hd),
					_List_Nil,
					_List_Nil),
				innerImports);
		}
	}();
	var hdGroup = _v0.b;
	var remGroups = _v0.c;
	return $elm$core$List$reverse(
		A2($elm$core$List$cons, hdGroup, remGroups));
};
var $elm$core$List$sortWith = _List_sortWith;
var $author$project$Internal$ImportsAndExposing$topLevelExposeOrder = F2(
	function (tlel, tler) {
		var _v0 = _Utils_Tuple2(tlel, tler);
		if (_v0.a.$ === 'InfixExpose') {
			if (_v0.b.$ === 'InfixExpose') {
				return A2(
					$elm$core$Basics$compare,
					$author$project$Internal$ImportsAndExposing$topLevelExposeName(tlel),
					$author$project$Internal$ImportsAndExposing$topLevelExposeName(tler));
			} else {
				return $elm$core$Basics$LT;
			}
		} else {
			if (_v0.b.$ === 'InfixExpose') {
				return $elm$core$Basics$GT;
			} else {
				return A2(
					$elm$core$Basics$compare,
					$author$project$Internal$ImportsAndExposing$topLevelExposeName(tlel),
					$author$project$Internal$ImportsAndExposing$topLevelExposeName(tler));
			}
		}
	});
var $author$project$Internal$ImportsAndExposing$sortAndDedupExposings = function (tlExposings) {
	return A2(
		$elm$core$List$map,
		$author$project$Internal$ImportsAndExposing$combineTopLevelExposes,
		$author$project$Internal$ImportsAndExposing$groupByExposingName(
			A2($elm$core$List$sortWith, $author$project$Internal$ImportsAndExposing$topLevelExposeOrder, tlExposings)));
};
var $the_sett$elm_pretty_printer$Pretty$space = $the_sett$elm_pretty_printer$Pretty$char(
	_Utils_chr(' '));
var $author$project$Internal$Write$prettyExposing = function (exposing_) {
	var exposings = function () {
		if (exposing_.$ === 'All') {
			return $the_sett$elm_pretty_printer$Pretty$parens(
				$the_sett$elm_pretty_printer$Pretty$string('..'));
		} else {
			var tll = exposing_.a;
			return $the_sett$elm_pretty_printer$Pretty$parens(
				$author$project$Internal$Write$prettyTopLevelExposes(
					$author$project$Internal$ImportsAndExposing$sortAndDedupExposings(
						$author$project$Internal$Compiler$denodeAll(tll))));
		}
	}();
	return A2(
		$the_sett$elm_pretty_printer$Pretty$a,
		exposings,
		A2(
			$the_sett$elm_pretty_printer$Pretty$a,
			$the_sett$elm_pretty_printer$Pretty$space,
			$the_sett$elm_pretty_printer$Pretty$string('exposing')));
};
var $author$project$Internal$Write$prettyMaybe = F2(
	function (prettyFn, maybeVal) {
		return A2(
			$elm$core$Maybe$withDefault,
			$the_sett$elm_pretty_printer$Pretty$empty,
			A2($elm$core$Maybe$map, prettyFn, maybeVal));
	});
var $author$project$Internal$Write$dot = $the_sett$elm_pretty_printer$Pretty$string('.');
var $author$project$Internal$Write$prettyModuleName = function (name) {
	return A2(
		$the_sett$elm_pretty_printer$Pretty$join,
		$author$project$Internal$Write$dot,
		A2($elm$core$List$map, $the_sett$elm_pretty_printer$Pretty$string, name));
};
var $author$project$Internal$Write$prettyModuleNameAlias = function (name) {
	if (!name.b) {
		return $the_sett$elm_pretty_printer$Pretty$empty;
	} else {
		return A2(
			$the_sett$elm_pretty_printer$Pretty$a,
			A2(
				$the_sett$elm_pretty_printer$Pretty$join,
				$author$project$Internal$Write$dot,
				A2($elm$core$List$map, $the_sett$elm_pretty_printer$Pretty$string, name)),
			$the_sett$elm_pretty_printer$Pretty$string('as '));
	}
};
var $author$project$Internal$Write$prettyImport = function (import_) {
	return A2(
		$the_sett$elm_pretty_printer$Pretty$join,
		$the_sett$elm_pretty_printer$Pretty$space,
		_List_fromArray(
			[
				$the_sett$elm_pretty_printer$Pretty$string('import'),
				$author$project$Internal$Write$prettyModuleName(
				$author$project$Internal$Compiler$denode(import_.moduleName)),
				A2(
				$author$project$Internal$Write$prettyMaybe,
				$author$project$Internal$Write$prettyModuleNameAlias,
				$author$project$Internal$Compiler$denodeMaybe(import_.moduleAlias)),
				A2(
				$author$project$Internal$Write$prettyMaybe,
				$author$project$Internal$Write$prettyExposing,
				$author$project$Internal$Compiler$denodeMaybe(import_.exposingList))
			]));
};
var $author$project$Internal$ImportsAndExposing$denode = $stil4m$elm_syntax$Elm$Syntax$Node$value;
var $author$project$Internal$ImportsAndExposing$denodeMaybe = $elm$core$Maybe$map($author$project$Internal$ImportsAndExposing$denode);
var $author$project$Internal$ImportsAndExposing$denodeAll = $elm$core$List$map($author$project$Internal$ImportsAndExposing$denode);
var $author$project$Internal$ImportsAndExposing$nodify = function (exp) {
	return A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, exp);
};
var $author$project$Internal$ImportsAndExposing$nodifyAll = $elm$core$List$map($author$project$Internal$ImportsAndExposing$nodify);
var $author$project$Internal$ImportsAndExposing$joinExposings = F2(
	function (left, right) {
		var _v0 = _Utils_Tuple2(left, right);
		if (_v0.a.$ === 'All') {
			var range = _v0.a.a;
			return $stil4m$elm_syntax$Elm$Syntax$Exposing$All(range);
		} else {
			if (_v0.b.$ === 'All') {
				var range = _v0.b.a;
				return $stil4m$elm_syntax$Elm$Syntax$Exposing$All(range);
			} else {
				var leftNodes = _v0.a.a;
				var rightNodes = _v0.b.a;
				return $stil4m$elm_syntax$Elm$Syntax$Exposing$Explicit(
					$author$project$Internal$ImportsAndExposing$nodifyAll(
						A2(
							$elm$core$List$append,
							$author$project$Internal$ImportsAndExposing$denodeAll(leftNodes),
							$author$project$Internal$ImportsAndExposing$denodeAll(rightNodes))));
			}
		}
	});
var $author$project$Internal$ImportsAndExposing$joinMaybeExposings = F2(
	function (maybeLeft, maybeRight) {
		var _v0 = _Utils_Tuple2(maybeLeft, maybeRight);
		if (_v0.a.$ === 'Nothing') {
			if (_v0.b.$ === 'Nothing') {
				var _v1 = _v0.a;
				var _v2 = _v0.b;
				return $elm$core$Maybe$Nothing;
			} else {
				var _v4 = _v0.a;
				var right = _v0.b.a;
				return $elm$core$Maybe$Just(right);
			}
		} else {
			if (_v0.b.$ === 'Nothing') {
				var left = _v0.a.a;
				var _v3 = _v0.b;
				return $elm$core$Maybe$Just(left);
			} else {
				var left = _v0.a.a;
				var right = _v0.b.a;
				return $elm$core$Maybe$Just(
					A2($author$project$Internal$ImportsAndExposing$joinExposings, left, right));
			}
		}
	});
var $author$project$Internal$ImportsAndExposing$nodifyMaybe = $elm$core$Maybe$map($author$project$Internal$ImportsAndExposing$nodify);
var $elm_community$maybe_extra$Maybe$Extra$or = F2(
	function (ma, mb) {
		if (ma.$ === 'Nothing') {
			return mb;
		} else {
			return ma;
		}
	});
var $author$project$Internal$ImportsAndExposing$sortAndDedupExposing = function (exp) {
	if (exp.$ === 'All') {
		var range = exp.a;
		return $stil4m$elm_syntax$Elm$Syntax$Exposing$All(range);
	} else {
		var nodes = exp.a;
		return $stil4m$elm_syntax$Elm$Syntax$Exposing$Explicit(
			$author$project$Internal$ImportsAndExposing$nodifyAll(
				$author$project$Internal$ImportsAndExposing$sortAndDedupExposings(
					$author$project$Internal$ImportsAndExposing$denodeAll(nodes))));
	}
};
var $author$project$Internal$ImportsAndExposing$combineImports = function (innerImports) {
	if (!innerImports.b) {
		return {
			exposingList: $elm$core$Maybe$Nothing,
			moduleAlias: $elm$core$Maybe$Nothing,
			moduleName: $author$project$Internal$ImportsAndExposing$nodify(_List_Nil)
		};
	} else {
		var hd = innerImports.a;
		var tl = innerImports.b;
		var combinedImports = A3(
			$elm$core$List$foldl,
			F2(
				function (imp, result) {
					return {
						exposingList: $author$project$Internal$ImportsAndExposing$nodifyMaybe(
							A2(
								$author$project$Internal$ImportsAndExposing$joinMaybeExposings,
								$author$project$Internal$ImportsAndExposing$denodeMaybe(imp.exposingList),
								$author$project$Internal$ImportsAndExposing$denodeMaybe(result.exposingList))),
						moduleAlias: A2($elm_community$maybe_extra$Maybe$Extra$or, imp.moduleAlias, result.moduleAlias),
						moduleName: imp.moduleName
					};
				}),
			hd,
			tl);
		return _Utils_update(
			combinedImports,
			{
				exposingList: A2(
					$elm$core$Maybe$map,
					A2(
						$elm$core$Basics$composeR,
						$author$project$Internal$ImportsAndExposing$denode,
						A2($elm$core$Basics$composeR, $author$project$Internal$ImportsAndExposing$sortAndDedupExposing, $author$project$Internal$ImportsAndExposing$nodify)),
					combinedImports.exposingList)
			});
	}
};
var $author$project$Internal$ImportsAndExposing$groupByModuleName = function (innerImports) {
	var _v0 = function () {
		if (!innerImports.b) {
			return _Utils_Tuple3(
				_List_Nil,
				_List_Nil,
				_List_fromArray(
					[_List_Nil]));
		} else {
			var hd = innerImports.a;
			return A3(
				$elm$core$List$foldl,
				F2(
					function (imp, _v2) {
						var currName = _v2.a;
						var currAccum = _v2.b;
						var accum = _v2.c;
						var nextName = $author$project$Internal$ImportsAndExposing$denode(imp.moduleName);
						return _Utils_eq(nextName, currName) ? _Utils_Tuple3(
							currName,
							A2($elm$core$List$cons, imp, currAccum),
							accum) : _Utils_Tuple3(
							nextName,
							_List_fromArray(
								[imp]),
							A2($elm$core$List$cons, currAccum, accum));
					}),
				_Utils_Tuple3(
					$author$project$Internal$ImportsAndExposing$denode(hd.moduleName),
					_List_Nil,
					_List_Nil),
				innerImports);
		}
	}();
	var hdGroup = _v0.b;
	var remGroups = _v0.c;
	return $elm$core$List$reverse(
		A2($elm$core$List$cons, hdGroup, remGroups));
};
var $author$project$Internal$ImportsAndExposing$sortAndDedupImports = function (imports) {
	var impName = function (imp) {
		return $author$project$Internal$ImportsAndExposing$denode(imp.moduleName);
	};
	return A2(
		$elm$core$List$map,
		$author$project$Internal$ImportsAndExposing$combineImports,
		$author$project$Internal$ImportsAndExposing$groupByModuleName(
			A2($elm$core$List$sortBy, impName, imports)));
};
var $author$project$Internal$Write$prettyImports = function (imports) {
	return $the_sett$elm_pretty_printer$Pretty$lines(
		A2(
			$elm$core$List$map,
			$author$project$Internal$Write$prettyImport,
			$author$project$Internal$ImportsAndExposing$sortAndDedupImports(imports)));
};
var $author$project$Internal$Write$importsPretty = function (imports) {
	if (!imports.b) {
		return $the_sett$elm_pretty_printer$Pretty$line;
	} else {
		return A2(
			$the_sett$elm_pretty_printer$Pretty$a,
			$the_sett$elm_pretty_printer$Pretty$line,
			A2(
				$the_sett$elm_pretty_printer$Pretty$a,
				$the_sett$elm_pretty_printer$Pretty$line,
				A2(
					$the_sett$elm_pretty_printer$Pretty$a,
					$the_sett$elm_pretty_printer$Pretty$line,
					$author$project$Internal$Write$prettyImports(imports))));
	}
};
var $author$project$Internal$Write$prettyComments = function (comments) {
	if (!comments.b) {
		return $the_sett$elm_pretty_printer$Pretty$empty;
	} else {
		return A2(
			$the_sett$elm_pretty_printer$Pretty$a,
			$the_sett$elm_pretty_printer$Pretty$line,
			A2(
				$the_sett$elm_pretty_printer$Pretty$a,
				$the_sett$elm_pretty_printer$Pretty$line,
				$the_sett$elm_pretty_printer$Pretty$lines(
					A2($elm$core$List$map, $the_sett$elm_pretty_printer$Pretty$string, comments))));
	}
};
var $the_sett$elm_pretty_printer$Internals$Nest = F2(
	function (a, b) {
		return {$: 'Nest', a: a, b: b};
	});
var $the_sett$elm_pretty_printer$Pretty$nest = F2(
	function (depth, doc) {
		return A2(
			$the_sett$elm_pretty_printer$Internals$Nest,
			depth,
			function (_v0) {
				return doc;
			});
	});
var $author$project$Internal$Write$prettyDocumentation = function (docs) {
	return $the_sett$elm_pretty_printer$Pretty$string(docs);
};
var $the_sett$elm_pretty_printer$Internals$Union = F2(
	function (a, b) {
		return {$: 'Union', a: a, b: b};
	});
var $the_sett$elm_pretty_printer$Internals$flatten = function (doc) {
	flatten:
	while (true) {
		switch (doc.$) {
			case 'Concatenate':
				var doc1 = doc.a;
				var doc2 = doc.b;
				return A2(
					$the_sett$elm_pretty_printer$Internals$Concatenate,
					function (_v1) {
						return $the_sett$elm_pretty_printer$Internals$flatten(
							doc1(_Utils_Tuple0));
					},
					function (_v2) {
						return $the_sett$elm_pretty_printer$Internals$flatten(
							doc2(_Utils_Tuple0));
					});
			case 'Nest':
				var i = doc.a;
				var doc1 = doc.b;
				return A2(
					$the_sett$elm_pretty_printer$Internals$Nest,
					i,
					function (_v3) {
						return $the_sett$elm_pretty_printer$Internals$flatten(
							doc1(_Utils_Tuple0));
					});
			case 'Union':
				var doc1 = doc.a;
				var doc2 = doc.b;
				var $temp$doc = doc1;
				doc = $temp$doc;
				continue flatten;
			case 'Line':
				var hsep = doc.a;
				return A2($the_sett$elm_pretty_printer$Internals$Text, hsep, $elm$core$Maybe$Nothing);
			case 'Nesting':
				var fn = doc.a;
				var $temp$doc = fn(0);
				doc = $temp$doc;
				continue flatten;
			case 'Column':
				var fn = doc.a;
				var $temp$doc = fn(0);
				doc = $temp$doc;
				continue flatten;
			default:
				var x = doc;
				return x;
		}
	}
};
var $the_sett$elm_pretty_printer$Pretty$group = function (doc) {
	return A2(
		$the_sett$elm_pretty_printer$Internals$Union,
		$the_sett$elm_pretty_printer$Internals$flatten(doc),
		doc);
};
var $author$project$Internal$Write$isNakedCompound = function (typeAnn) {
	switch (typeAnn.$) {
		case 'Typed':
			if (!typeAnn.b.b) {
				return false;
			} else {
				var args = typeAnn.b;
				return true;
			}
		case 'FunctionTypeAnnotation':
			return true;
		default:
			return false;
	}
};
var $elm$core$Tuple$mapBoth = F3(
	function (funcA, funcB, _v0) {
		var x = _v0.a;
		var y = _v0.b;
		return _Utils_Tuple2(
			funcA(x),
			funcB(y));
	});
var $author$project$Internal$Write$prettyModuleNameDot = F2(
	function (aliases, name) {
		if (!name.b) {
			return $the_sett$elm_pretty_printer$Pretty$empty;
		} else {
			var _v1 = A2($author$project$Internal$Compiler$findAlias, name, aliases);
			if (_v1.$ === 'Nothing') {
				return A2(
					$the_sett$elm_pretty_printer$Pretty$a,
					$author$project$Internal$Write$dot,
					A2(
						$the_sett$elm_pretty_printer$Pretty$join,
						$author$project$Internal$Write$dot,
						A2($elm$core$List$map, $the_sett$elm_pretty_printer$Pretty$string, name)));
			} else {
				var alias = _v1.a;
				return A2(
					$the_sett$elm_pretty_printer$Pretty$a,
					$author$project$Internal$Write$dot,
					$the_sett$elm_pretty_printer$Pretty$string(alias));
			}
		}
	});
var $the_sett$elm_pretty_printer$Pretty$separators = function (sep) {
	return $the_sett$elm_pretty_printer$Pretty$join(
		A2($the_sett$elm_pretty_printer$Internals$Line, sep, sep));
};
var $the_sett$elm_pretty_printer$Pretty$words = $the_sett$elm_pretty_printer$Pretty$join($the_sett$elm_pretty_printer$Pretty$space);
var $author$project$Internal$Write$prettyFieldTypeAnn = F2(
	function (aliases, _v8) {
		var name = _v8.a;
		var ann = _v8.b;
		return $the_sett$elm_pretty_printer$Pretty$group(
			A2(
				$the_sett$elm_pretty_printer$Pretty$nest,
				4,
				$the_sett$elm_pretty_printer$Pretty$lines(
					_List_fromArray(
						[
							$the_sett$elm_pretty_printer$Pretty$words(
							_List_fromArray(
								[
									$the_sett$elm_pretty_printer$Pretty$string(name),
									$the_sett$elm_pretty_printer$Pretty$string(':')
								])),
							A2($author$project$Internal$Write$prettyTypeAnnotation, aliases, ann)
						]))));
	});
var $author$project$Internal$Write$prettyFunctionTypeAnnotation = F3(
	function (aliases, left, right) {
		var expandLeft = function (ann) {
			if (ann.$ === 'FunctionTypeAnnotation') {
				return A2($author$project$Internal$Write$prettyTypeAnnotationParens, aliases, ann);
			} else {
				return A2($author$project$Internal$Write$prettyTypeAnnotation, aliases, ann);
			}
		};
		var innerFnTypeAnn = F2(
			function (innerLeft, innerRight) {
				var rightSide = expandRight(
					$author$project$Internal$Compiler$denode(innerRight));
				if (rightSide.b) {
					var hd = rightSide.a;
					var tl = rightSide.b;
					return A2(
						$elm$core$List$cons,
						expandLeft(
							$author$project$Internal$Compiler$denode(innerLeft)),
						A2(
							$elm$core$List$cons,
							$the_sett$elm_pretty_printer$Pretty$words(
								_List_fromArray(
									[
										$the_sett$elm_pretty_printer$Pretty$string('->'),
										hd
									])),
							tl));
				} else {
					return _List_Nil;
				}
			});
		var expandRight = function (ann) {
			if (ann.$ === 'FunctionTypeAnnotation') {
				var innerLeft = ann.a;
				var innerRight = ann.b;
				return A2(innerFnTypeAnn, innerLeft, innerRight);
			} else {
				return _List_fromArray(
					[
						A2($author$project$Internal$Write$prettyTypeAnnotation, aliases, ann)
					]);
			}
		};
		return $the_sett$elm_pretty_printer$Pretty$group(
			$the_sett$elm_pretty_printer$Pretty$lines(
				A2(innerFnTypeAnn, left, right)));
	});
var $author$project$Internal$Write$prettyGenericRecord = F3(
	function (aliases, paramName, fields) {
		var open = A2(
			$the_sett$elm_pretty_printer$Pretty$a,
			$the_sett$elm_pretty_printer$Pretty$line,
			$the_sett$elm_pretty_printer$Pretty$words(
				_List_fromArray(
					[
						$the_sett$elm_pretty_printer$Pretty$string('{'),
						$the_sett$elm_pretty_printer$Pretty$string(paramName)
					])));
		var close = A2(
			$the_sett$elm_pretty_printer$Pretty$a,
			$the_sett$elm_pretty_printer$Pretty$string('}'),
			$the_sett$elm_pretty_printer$Pretty$line);
		var addBarToFirst = function (exprs) {
			if (!exprs.b) {
				return _List_Nil;
			} else {
				var hd = exprs.a;
				var tl = exprs.b;
				return A2(
					$elm$core$List$cons,
					A2(
						$the_sett$elm_pretty_printer$Pretty$a,
						hd,
						$the_sett$elm_pretty_printer$Pretty$string('| ')),
					tl);
			}
		};
		if (!fields.b) {
			return $the_sett$elm_pretty_printer$Pretty$string('{}');
		} else {
			return $the_sett$elm_pretty_printer$Pretty$group(
				A3(
					$the_sett$elm_pretty_printer$Pretty$surround,
					$the_sett$elm_pretty_printer$Pretty$empty,
					close,
					A2(
						$the_sett$elm_pretty_printer$Pretty$nest,
						4,
						A2(
							$the_sett$elm_pretty_printer$Pretty$a,
							A2(
								$the_sett$elm_pretty_printer$Pretty$separators,
								', ',
								addBarToFirst(
									A2(
										$elm$core$List$map,
										$author$project$Internal$Write$prettyFieldTypeAnn(aliases),
										A2(
											$elm$core$List$map,
											A2($elm$core$Tuple$mapBoth, $author$project$Internal$Compiler$denode, $author$project$Internal$Compiler$denode),
											fields)))),
							open))));
		}
	});
var $author$project$Internal$Write$prettyRecord = F2(
	function (aliases, fields) {
		var open = A2(
			$the_sett$elm_pretty_printer$Pretty$a,
			$the_sett$elm_pretty_printer$Pretty$space,
			$the_sett$elm_pretty_printer$Pretty$string('{'));
		var close = A2(
			$the_sett$elm_pretty_printer$Pretty$a,
			$the_sett$elm_pretty_printer$Pretty$string('}'),
			$the_sett$elm_pretty_printer$Pretty$line);
		if (!fields.b) {
			return $the_sett$elm_pretty_printer$Pretty$string('{}');
		} else {
			return $the_sett$elm_pretty_printer$Pretty$group(
				A3(
					$the_sett$elm_pretty_printer$Pretty$surround,
					open,
					close,
					A2(
						$the_sett$elm_pretty_printer$Pretty$separators,
						', ',
						A2(
							$elm$core$List$map,
							$author$project$Internal$Write$prettyFieldTypeAnn(aliases),
							A2(
								$elm$core$List$map,
								A2($elm$core$Tuple$mapBoth, $author$project$Internal$Compiler$denode, $author$project$Internal$Compiler$denode),
								fields)))));
		}
	});
var $author$project$Internal$Write$prettyTupled = F2(
	function (aliases, anns) {
		return $the_sett$elm_pretty_printer$Pretty$parens(
			A2(
				$the_sett$elm_pretty_printer$Pretty$a,
				$the_sett$elm_pretty_printer$Pretty$space,
				A2(
					$the_sett$elm_pretty_printer$Pretty$a,
					A2(
						$the_sett$elm_pretty_printer$Pretty$join,
						$the_sett$elm_pretty_printer$Pretty$string(', '),
						A2(
							$elm$core$List$map,
							$author$project$Internal$Write$prettyTypeAnnotation(aliases),
							$author$project$Internal$Compiler$denodeAll(anns))),
					$the_sett$elm_pretty_printer$Pretty$space)));
	});
var $author$project$Internal$Write$prettyTypeAnnotation = F2(
	function (aliases, typeAnn) {
		switch (typeAnn.$) {
			case 'GenericType':
				var val = typeAnn.a;
				return $the_sett$elm_pretty_printer$Pretty$string(val);
			case 'Typed':
				var fqName = typeAnn.a;
				var anns = typeAnn.b;
				return A3($author$project$Internal$Write$prettyTyped, aliases, fqName, anns);
			case 'Unit':
				return $the_sett$elm_pretty_printer$Pretty$string('()');
			case 'Tupled':
				var anns = typeAnn.a;
				return A2($author$project$Internal$Write$prettyTupled, aliases, anns);
			case 'Record':
				var recordDef = typeAnn.a;
				return A2(
					$author$project$Internal$Write$prettyRecord,
					aliases,
					$author$project$Internal$Compiler$denodeAll(recordDef));
			case 'GenericRecord':
				var paramName = typeAnn.a;
				var recordDef = typeAnn.b;
				return A3(
					$author$project$Internal$Write$prettyGenericRecord,
					aliases,
					$author$project$Internal$Compiler$denode(paramName),
					$author$project$Internal$Compiler$denodeAll(
						$author$project$Internal$Compiler$denode(recordDef)));
			default:
				var fromAnn = typeAnn.a;
				var toAnn = typeAnn.b;
				return A3($author$project$Internal$Write$prettyFunctionTypeAnnotation, aliases, fromAnn, toAnn);
		}
	});
var $author$project$Internal$Write$prettyTypeAnnotationParens = F2(
	function (aliases, typeAnn) {
		return $author$project$Internal$Write$isNakedCompound(typeAnn) ? $the_sett$elm_pretty_printer$Pretty$parens(
			A2($author$project$Internal$Write$prettyTypeAnnotation, aliases, typeAnn)) : A2($author$project$Internal$Write$prettyTypeAnnotation, aliases, typeAnn);
	});
var $author$project$Internal$Write$prettyTyped = F3(
	function (aliases, fqName, anns) {
		var argsDoc = $the_sett$elm_pretty_printer$Pretty$words(
			A2(
				$elm$core$List$map,
				$author$project$Internal$Write$prettyTypeAnnotationParens(aliases),
				$author$project$Internal$Compiler$denodeAll(anns)));
		var _v0 = $author$project$Internal$Compiler$denode(fqName);
		var moduleName = _v0.a;
		var typeName = _v0.b;
		var typeDoc = A2(
			$the_sett$elm_pretty_printer$Pretty$a,
			$the_sett$elm_pretty_printer$Pretty$string(typeName),
			A2($author$project$Internal$Write$prettyModuleNameDot, aliases, moduleName));
		return $the_sett$elm_pretty_printer$Pretty$words(
			_List_fromArray(
				[typeDoc, argsDoc]));
	});
var $author$project$Internal$Write$prettyValueConstructor = F2(
	function (aliases, cons) {
		return A2(
			$the_sett$elm_pretty_printer$Pretty$nest,
			4,
			$the_sett$elm_pretty_printer$Pretty$group(
				$the_sett$elm_pretty_printer$Pretty$lines(
					_List_fromArray(
						[
							$the_sett$elm_pretty_printer$Pretty$string(
							$author$project$Internal$Compiler$denode(cons.name)),
							$the_sett$elm_pretty_printer$Pretty$lines(
							A2(
								$elm$core$List$map,
								$author$project$Internal$Write$prettyTypeAnnotationParens(aliases),
								$author$project$Internal$Compiler$denodeAll(cons._arguments)))
						]))));
	});
var $author$project$Internal$Write$prettyValueConstructors = F2(
	function (aliases, constructors) {
		return A2(
			$the_sett$elm_pretty_printer$Pretty$join,
			A2(
				$the_sett$elm_pretty_printer$Pretty$a,
				$the_sett$elm_pretty_printer$Pretty$string('| '),
				$the_sett$elm_pretty_printer$Pretty$line),
			A2(
				$elm$core$List$map,
				$author$project$Internal$Write$prettyValueConstructor(aliases),
				constructors));
	});
var $author$project$Internal$Write$prettyCustomType = F2(
	function (aliases, type_) {
		var customTypePretty = A2(
			$the_sett$elm_pretty_printer$Pretty$nest,
			4,
			A2(
				$the_sett$elm_pretty_printer$Pretty$a,
				A2(
					$author$project$Internal$Write$prettyValueConstructors,
					aliases,
					$author$project$Internal$Compiler$denodeAll(type_.constructors)),
				A2(
					$the_sett$elm_pretty_printer$Pretty$a,
					$the_sett$elm_pretty_printer$Pretty$string('= '),
					A2(
						$the_sett$elm_pretty_printer$Pretty$a,
						$the_sett$elm_pretty_printer$Pretty$line,
						$the_sett$elm_pretty_printer$Pretty$words(
							_List_fromArray(
								[
									$the_sett$elm_pretty_printer$Pretty$string('type'),
									$the_sett$elm_pretty_printer$Pretty$string(
									$author$project$Internal$Compiler$denode(type_.name)),
									$the_sett$elm_pretty_printer$Pretty$words(
									A2(
										$elm$core$List$map,
										$the_sett$elm_pretty_printer$Pretty$string,
										$author$project$Internal$Compiler$denodeAll(type_.generics)))
								]))))));
		return $the_sett$elm_pretty_printer$Pretty$lines(
			_List_fromArray(
				[
					A2(
					$author$project$Internal$Write$prettyMaybe,
					$author$project$Internal$Write$prettyDocumentation,
					$author$project$Internal$Compiler$denodeMaybe(type_.documentation)),
					customTypePretty
				]));
	});
var $author$project$Internal$Write$adjustExpressionParentheses = F2(
	function (context, expression) {
		var shouldRemove = function (expr) {
			var _v3 = _Utils_Tuple3(context.isTop, context.isLeftPipe, expr);
			_v3$1:
			while (true) {
				if (_v3.a) {
					return true;
				} else {
					switch (_v3.c.$) {
						case 'Application':
							if (_v3.b) {
								break _v3$1;
							} else {
								return (context.precedence < 11) ? true : false;
							}
						case 'FunctionOrValue':
							if (_v3.b) {
								break _v3$1;
							} else {
								var _v4 = _v3.c;
								return true;
							}
						case 'Integer':
							if (_v3.b) {
								break _v3$1;
							} else {
								return true;
							}
						case 'Hex':
							if (_v3.b) {
								break _v3$1;
							} else {
								return true;
							}
						case 'Floatable':
							if (_v3.b) {
								break _v3$1;
							} else {
								return true;
							}
						case 'Negation':
							if (_v3.b) {
								break _v3$1;
							} else {
								return true;
							}
						case 'Literal':
							if (_v3.b) {
								break _v3$1;
							} else {
								return true;
							}
						case 'CharLiteral':
							if (_v3.b) {
								break _v3$1;
							} else {
								return true;
							}
						case 'TupledExpression':
							if (_v3.b) {
								break _v3$1;
							} else {
								return true;
							}
						case 'RecordExpr':
							if (_v3.b) {
								break _v3$1;
							} else {
								return true;
							}
						case 'ListExpr':
							if (_v3.b) {
								break _v3$1;
							} else {
								return true;
							}
						case 'RecordAccess':
							if (_v3.b) {
								break _v3$1;
							} else {
								var _v5 = _v3.c;
								return true;
							}
						case 'RecordAccessFunction':
							if (_v3.b) {
								break _v3$1;
							} else {
								return true;
							}
						case 'RecordUpdateExpression':
							if (_v3.b) {
								break _v3$1;
							} else {
								var _v6 = _v3.c;
								return true;
							}
						default:
							if (_v3.b) {
								break _v3$1;
							} else {
								return false;
							}
					}
				}
			}
			return true;
		};
		var removeParens = function (expr) {
			if (expr.$ === 'ParenthesizedExpression') {
				var innerExpr = expr.a;
				return shouldRemove(
					$author$project$Internal$Compiler$denode(innerExpr)) ? removeParens(
					$author$project$Internal$Compiler$denode(innerExpr)) : expr;
			} else {
				return expr;
			}
		};
		var addParens = function (expr) {
			var _v1 = _Utils_Tuple3(context.isTop, context.isLeftPipe, expr);
			_v1$4:
			while (true) {
				if ((!_v1.a) && (!_v1.b)) {
					switch (_v1.c.$) {
						case 'LetExpression':
							return $stil4m$elm_syntax$Elm$Syntax$Expression$ParenthesizedExpression(
								$author$project$Internal$Compiler$nodify(expr));
						case 'CaseExpression':
							return $stil4m$elm_syntax$Elm$Syntax$Expression$ParenthesizedExpression(
								$author$project$Internal$Compiler$nodify(expr));
						case 'LambdaExpression':
							return $stil4m$elm_syntax$Elm$Syntax$Expression$ParenthesizedExpression(
								$author$project$Internal$Compiler$nodify(expr));
						case 'IfBlock':
							var _v2 = _v1.c;
							return $stil4m$elm_syntax$Elm$Syntax$Expression$ParenthesizedExpression(
								$author$project$Internal$Compiler$nodify(expr));
						default:
							break _v1$4;
					}
				} else {
					break _v1$4;
				}
			}
			return expr;
		};
		return addParens(
			removeParens(expression));
	});
var $the_sett$elm_pretty_printer$Internals$Column = function (a) {
	return {$: 'Column', a: a};
};
var $the_sett$elm_pretty_printer$Pretty$column = $the_sett$elm_pretty_printer$Internals$Column;
var $the_sett$elm_pretty_printer$Internals$Nesting = function (a) {
	return {$: 'Nesting', a: a};
};
var $the_sett$elm_pretty_printer$Pretty$nesting = $the_sett$elm_pretty_printer$Internals$Nesting;
var $the_sett$elm_pretty_printer$Pretty$align = function (doc) {
	return $the_sett$elm_pretty_printer$Pretty$column(
		function (currentColumn) {
			return $the_sett$elm_pretty_printer$Pretty$nesting(
				function (indentLvl) {
					return A2($the_sett$elm_pretty_printer$Pretty$nest, currentColumn - indentLvl, doc);
				});
		});
};
var $Chadtech$elm_bool_extra$Bool$Extra$any = $elm$core$List$any($elm$core$Basics$identity);
var $elm$core$Basics$modBy = _Basics_modBy;
var $author$project$Internal$Write$decrementIndent = F2(
	function (currentIndent, spaces) {
		var modded = A2($elm$core$Basics$modBy, 4, currentIndent - spaces);
		return (!modded) ? 4 : modded;
	});
var $author$project$Internal$Write$doubleLines = $the_sett$elm_pretty_printer$Pretty$join(
	A2($the_sett$elm_pretty_printer$Pretty$a, $the_sett$elm_pretty_printer$Pretty$line, $the_sett$elm_pretty_printer$Pretty$line));
var $author$project$Internal$Write$escapeChar = function (val) {
	switch (val.valueOf()) {
		case '\\':
			return '\\\\';
		case '\'':
			return '\\\'';
		case '\t':
			return '\\t';
		case '\n':
			return '\\n';
		default:
			var c = val;
			return $elm$core$String$fromChar(c);
	}
};
var $elm$core$String$fromFloat = _String_fromNumber;
var $the_sett$elm_pretty_printer$Internals$copy = F2(
	function (i, s) {
		return (!i) ? '' : _Utils_ap(
			s,
			A2($the_sett$elm_pretty_printer$Internals$copy, i - 1, s));
	});
var $the_sett$elm_pretty_printer$Pretty$hang = F2(
	function (spaces, doc) {
		return $the_sett$elm_pretty_printer$Pretty$align(
			A2($the_sett$elm_pretty_printer$Pretty$nest, spaces, doc));
	});
var $the_sett$elm_pretty_printer$Pretty$indent = F2(
	function (spaces, doc) {
		return A2(
			$the_sett$elm_pretty_printer$Pretty$hang,
			spaces,
			A2(
				$the_sett$elm_pretty_printer$Pretty$append,
				$the_sett$elm_pretty_printer$Pretty$string(
					A2($the_sett$elm_pretty_printer$Internals$copy, spaces, ' ')),
				doc));
	});
var $elm$core$Tuple$mapSecond = F2(
	function (func, _v0) {
		var x = _v0.a;
		var y = _v0.b;
		return _Utils_Tuple2(
			x,
			func(y));
	});
var $author$project$Internal$Write$optionalGroup = F2(
	function (flag, doc) {
		return flag ? doc : $the_sett$elm_pretty_printer$Pretty$group(doc);
	});
var $author$project$Internal$Write$precedence = function (symbol) {
	switch (symbol) {
		case '>>':
			return 9;
		case '<<':
			return 9;
		case '^':
			return 8;
		case '*':
			return 7;
		case '/':
			return 7;
		case '//':
			return 7;
		case '%':
			return 7;
		case 'rem':
			return 7;
		case '+':
			return 6;
		case '-':
			return 6;
		case '++':
			return 5;
		case '::':
			return 5;
		case '==':
			return 4;
		case '/=':
			return 4;
		case '<':
			return 4;
		case '>':
			return 4;
		case '<=':
			return 4;
		case '>=':
			return 4;
		case '&&':
			return 3;
		case '||':
			return 2;
		case '|>':
			return 0;
		case '<|':
			return 0;
		default:
			return 0;
	}
};
var $stil4m$elm_syntax$Elm$Syntax$Pattern$ParenthesizedPattern = function (a) {
	return {$: 'ParenthesizedPattern', a: a};
};
var $author$project$Internal$Write$adjustPatternParentheses = F2(
	function (isTop, pattern) {
		var shouldRemove = function (pat) {
			var _v5 = _Utils_Tuple2(isTop, pat);
			_v5$2:
			while (true) {
				switch (_v5.b.$) {
					case 'NamedPattern':
						if (!_v5.a) {
							var _v6 = _v5.b;
							return false;
						} else {
							break _v5$2;
						}
					case 'AsPattern':
						var _v7 = _v5.b;
						return false;
					default:
						break _v5$2;
				}
			}
			return isTop;
		};
		var removeParens = function (pat) {
			if (pat.$ === 'ParenthesizedPattern') {
				var innerPat = pat.a;
				return shouldRemove(
					$author$project$Internal$Compiler$denode(innerPat)) ? removeParens(
					$author$project$Internal$Compiler$denode(innerPat)) : pat;
			} else {
				return pat;
			}
		};
		var addParens = function (pat) {
			var _v1 = _Utils_Tuple2(isTop, pat);
			_v1$2:
			while (true) {
				if (!_v1.a) {
					switch (_v1.b.$) {
						case 'NamedPattern':
							if (_v1.b.b.b) {
								var _v2 = _v1.b;
								var _v3 = _v2.b;
								return $stil4m$elm_syntax$Elm$Syntax$Pattern$ParenthesizedPattern(
									$author$project$Internal$Compiler$nodify(pat));
							} else {
								break _v1$2;
							}
						case 'AsPattern':
							var _v4 = _v1.b;
							return $stil4m$elm_syntax$Elm$Syntax$Pattern$ParenthesizedPattern(
								$author$project$Internal$Compiler$nodify(pat));
						default:
							break _v1$2;
					}
				} else {
					break _v1$2;
				}
			}
			return pat;
		};
		return addParens(
			removeParens(pattern));
	});
var $the_sett$elm_pretty_printer$Pretty$braces = function (doc) {
	return A3(
		$the_sett$elm_pretty_printer$Pretty$surround,
		$the_sett$elm_pretty_printer$Pretty$char(
			_Utils_chr('{')),
		$the_sett$elm_pretty_printer$Pretty$char(
			_Utils_chr('}')),
		doc);
};
var $author$project$Internal$Write$quotes = function (doc) {
	return A3(
		$the_sett$elm_pretty_printer$Pretty$surround,
		$the_sett$elm_pretty_printer$Pretty$char(
			_Utils_chr('\"')),
		$the_sett$elm_pretty_printer$Pretty$char(
			_Utils_chr('\"')),
		doc);
};
var $author$project$Internal$Write$singleQuotes = function (doc) {
	return A3(
		$the_sett$elm_pretty_printer$Pretty$surround,
		$the_sett$elm_pretty_printer$Pretty$char(
			_Utils_chr('\'')),
		$the_sett$elm_pretty_printer$Pretty$char(
			_Utils_chr('\'')),
		doc);
};
var $elm$core$String$fromList = _String_fromList;
var $elm$core$Basics$negate = function (n) {
	return -n;
};
var $rtfeldman$elm_hex$Hex$unsafeToDigit = function (num) {
	unsafeToDigit:
	while (true) {
		switch (num) {
			case 0:
				return _Utils_chr('0');
			case 1:
				return _Utils_chr('1');
			case 2:
				return _Utils_chr('2');
			case 3:
				return _Utils_chr('3');
			case 4:
				return _Utils_chr('4');
			case 5:
				return _Utils_chr('5');
			case 6:
				return _Utils_chr('6');
			case 7:
				return _Utils_chr('7');
			case 8:
				return _Utils_chr('8');
			case 9:
				return _Utils_chr('9');
			case 10:
				return _Utils_chr('a');
			case 11:
				return _Utils_chr('b');
			case 12:
				return _Utils_chr('c');
			case 13:
				return _Utils_chr('d');
			case 14:
				return _Utils_chr('e');
			case 15:
				return _Utils_chr('f');
			default:
				var $temp$num = num;
				num = $temp$num;
				continue unsafeToDigit;
		}
	}
};
var $rtfeldman$elm_hex$Hex$unsafePositiveToDigits = F2(
	function (digits, num) {
		unsafePositiveToDigits:
		while (true) {
			if (num < 16) {
				return A2(
					$elm$core$List$cons,
					$rtfeldman$elm_hex$Hex$unsafeToDigit(num),
					digits);
			} else {
				var $temp$digits = A2(
					$elm$core$List$cons,
					$rtfeldman$elm_hex$Hex$unsafeToDigit(
						A2($elm$core$Basics$modBy, 16, num)),
					digits),
					$temp$num = (num / 16) | 0;
				digits = $temp$digits;
				num = $temp$num;
				continue unsafePositiveToDigits;
			}
		}
	});
var $rtfeldman$elm_hex$Hex$toString = function (num) {
	return $elm$core$String$fromList(
		(num < 0) ? A2(
			$elm$core$List$cons,
			_Utils_chr('-'),
			A2($rtfeldman$elm_hex$Hex$unsafePositiveToDigits, _List_Nil, -num)) : A2($rtfeldman$elm_hex$Hex$unsafePositiveToDigits, _List_Nil, num));
};
var $author$project$Internal$Write$prettyPatternInner = F3(
	function (aliases, isTop, pattern) {
		var _v0 = A2($author$project$Internal$Write$adjustPatternParentheses, isTop, pattern);
		switch (_v0.$) {
			case 'AllPattern':
				return $the_sett$elm_pretty_printer$Pretty$string('_');
			case 'UnitPattern':
				return $the_sett$elm_pretty_printer$Pretty$string('()');
			case 'CharPattern':
				var val = _v0.a;
				return $author$project$Internal$Write$singleQuotes(
					$the_sett$elm_pretty_printer$Pretty$string(
						$author$project$Internal$Write$escapeChar(val)));
			case 'StringPattern':
				var val = _v0.a;
				return $author$project$Internal$Write$quotes(
					$the_sett$elm_pretty_printer$Pretty$string(val));
			case 'IntPattern':
				var val = _v0.a;
				return $the_sett$elm_pretty_printer$Pretty$string(
					$elm$core$String$fromInt(val));
			case 'HexPattern':
				var val = _v0.a;
				return $the_sett$elm_pretty_printer$Pretty$string(
					$rtfeldman$elm_hex$Hex$toString(val));
			case 'FloatPattern':
				var val = _v0.a;
				return $the_sett$elm_pretty_printer$Pretty$string(
					$elm$core$String$fromFloat(val));
			case 'TuplePattern':
				var vals = _v0.a;
				return $the_sett$elm_pretty_printer$Pretty$parens(
					A2(
						$the_sett$elm_pretty_printer$Pretty$a,
						$the_sett$elm_pretty_printer$Pretty$space,
						A2(
							$the_sett$elm_pretty_printer$Pretty$a,
							A2(
								$the_sett$elm_pretty_printer$Pretty$join,
								$the_sett$elm_pretty_printer$Pretty$string(', '),
								A2(
									$elm$core$List$map,
									A2($author$project$Internal$Write$prettyPatternInner, aliases, true),
									$author$project$Internal$Compiler$denodeAll(vals))),
							$the_sett$elm_pretty_printer$Pretty$space)));
			case 'RecordPattern':
				var fields = _v0.a;
				return $the_sett$elm_pretty_printer$Pretty$braces(
					A3(
						$the_sett$elm_pretty_printer$Pretty$surround,
						$the_sett$elm_pretty_printer$Pretty$space,
						$the_sett$elm_pretty_printer$Pretty$space,
						A2(
							$the_sett$elm_pretty_printer$Pretty$join,
							$the_sett$elm_pretty_printer$Pretty$string(', '),
							A2(
								$elm$core$List$map,
								$the_sett$elm_pretty_printer$Pretty$string,
								$author$project$Internal$Compiler$denodeAll(fields)))));
			case 'UnConsPattern':
				var hdPat = _v0.a;
				var tlPat = _v0.b;
				return $the_sett$elm_pretty_printer$Pretty$words(
					_List_fromArray(
						[
							A3(
							$author$project$Internal$Write$prettyPatternInner,
							aliases,
							false,
							$author$project$Internal$Compiler$denode(hdPat)),
							$the_sett$elm_pretty_printer$Pretty$string('::'),
							A3(
							$author$project$Internal$Write$prettyPatternInner,
							aliases,
							false,
							$author$project$Internal$Compiler$denode(tlPat))
						]));
			case 'ListPattern':
				var listPats = _v0.a;
				if (!listPats.b) {
					return $the_sett$elm_pretty_printer$Pretty$string('[]');
				} else {
					var open = A2(
						$the_sett$elm_pretty_printer$Pretty$a,
						$the_sett$elm_pretty_printer$Pretty$space,
						$the_sett$elm_pretty_printer$Pretty$string('['));
					var close = A2(
						$the_sett$elm_pretty_printer$Pretty$a,
						$the_sett$elm_pretty_printer$Pretty$string(']'),
						$the_sett$elm_pretty_printer$Pretty$space);
					return A3(
						$the_sett$elm_pretty_printer$Pretty$surround,
						open,
						close,
						A2(
							$the_sett$elm_pretty_printer$Pretty$join,
							$the_sett$elm_pretty_printer$Pretty$string(', '),
							A2(
								$elm$core$List$map,
								A2($author$project$Internal$Write$prettyPatternInner, aliases, false),
								$author$project$Internal$Compiler$denodeAll(listPats))));
				}
			case 'VarPattern':
				var _var = _v0.a;
				return $the_sett$elm_pretty_printer$Pretty$string(_var);
			case 'NamedPattern':
				var qnRef = _v0.a;
				var listPats = _v0.b;
				return $the_sett$elm_pretty_printer$Pretty$words(
					A2(
						$elm$core$List$cons,
						A2(
							$the_sett$elm_pretty_printer$Pretty$a,
							$the_sett$elm_pretty_printer$Pretty$string(qnRef.name),
							A2($author$project$Internal$Write$prettyModuleNameDot, aliases, qnRef.moduleName)),
						A2(
							$elm$core$List$map,
							A2($author$project$Internal$Write$prettyPatternInner, aliases, false),
							$author$project$Internal$Compiler$denodeAll(listPats))));
			case 'AsPattern':
				var pat = _v0.a;
				var name = _v0.b;
				return $the_sett$elm_pretty_printer$Pretty$words(
					_List_fromArray(
						[
							A3(
							$author$project$Internal$Write$prettyPatternInner,
							aliases,
							false,
							$author$project$Internal$Compiler$denode(pat)),
							$the_sett$elm_pretty_printer$Pretty$string('as'),
							$the_sett$elm_pretty_printer$Pretty$string(
							$author$project$Internal$Compiler$denode(name))
						]));
			default:
				var pat = _v0.a;
				return $the_sett$elm_pretty_printer$Pretty$parens(
					A3(
						$author$project$Internal$Write$prettyPatternInner,
						aliases,
						true,
						$author$project$Internal$Compiler$denode(pat)));
		}
	});
var $author$project$Internal$Write$prettyArgs = F2(
	function (aliases, args) {
		return $the_sett$elm_pretty_printer$Pretty$words(
			A2(
				$elm$core$List$map,
				A2($author$project$Internal$Write$prettyPatternInner, aliases, false),
				args));
	});
var $elm$core$String$replace = F3(
	function (before, after, string) {
		return A2(
			$elm$core$String$join,
			after,
			A2($elm$core$String$split, before, string));
	});
var $author$project$Internal$Write$escape = function (val) {
	return A3(
		$elm$core$String$replace,
		'\t',
		'\\t',
		A3(
			$elm$core$String$replace,
			'\n',
			'\\n',
			A3(
				$elm$core$String$replace,
				'\"',
				'\\\"',
				A3($elm$core$String$replace, '\\', '\\\\', val))));
};
var $author$project$Internal$Write$prettyLiteral = function (val) {
	return $author$project$Internal$Write$quotes(
		$the_sett$elm_pretty_printer$Pretty$string(
			$author$project$Internal$Write$escape(val)));
};
var $author$project$Internal$Write$prettyPattern = F2(
	function (aliases, pattern) {
		return A3($author$project$Internal$Write$prettyPatternInner, aliases, true, pattern);
	});
var $author$project$Internal$Write$prettySignature = F2(
	function (aliases, sig) {
		return $the_sett$elm_pretty_printer$Pretty$group(
			A2(
				$the_sett$elm_pretty_printer$Pretty$nest,
				4,
				$the_sett$elm_pretty_printer$Pretty$lines(
					_List_fromArray(
						[
							$the_sett$elm_pretty_printer$Pretty$words(
							_List_fromArray(
								[
									$the_sett$elm_pretty_printer$Pretty$string(
									$author$project$Internal$Compiler$denode(sig.name)),
									$the_sett$elm_pretty_printer$Pretty$string(':')
								])),
							A2(
							$author$project$Internal$Write$prettyTypeAnnotation,
							aliases,
							$author$project$Internal$Compiler$denode(sig.typeAnnotation))
						]))));
	});
var $the_sett$elm_pretty_printer$Pretty$tightline = A2($the_sett$elm_pretty_printer$Internals$Line, '', '');
var $elm$core$Bitwise$and = _Bitwise_and;
var $elm$core$Bitwise$shiftRightBy = _Bitwise_shiftRightBy;
var $elm$core$String$repeatHelp = F3(
	function (n, chunk, result) {
		return (n <= 0) ? result : A3(
			$elm$core$String$repeatHelp,
			n >> 1,
			_Utils_ap(chunk, chunk),
			(!(n & 1)) ? result : _Utils_ap(result, chunk));
	});
var $elm$core$String$repeat = F2(
	function (n, chunk) {
		return A3($elm$core$String$repeatHelp, n, chunk, '');
	});
var $elm$core$String$padLeft = F3(
	function (n, _char, string) {
		return _Utils_ap(
			A2(
				$elm$core$String$repeat,
				n - $elm$core$String$length(string),
				$elm$core$String$fromChar(_char)),
			string);
	});
var $author$project$Internal$Write$toHexString = function (val) {
	var padWithZeros = function (str) {
		var length = $elm$core$String$length(str);
		return (length < 2) ? A3(
			$elm$core$String$padLeft,
			2,
			_Utils_chr('0'),
			str) : (((length > 2) && (length < 4)) ? A3(
			$elm$core$String$padLeft,
			4,
			_Utils_chr('0'),
			str) : (((length > 4) && (length < 8)) ? A3(
			$elm$core$String$padLeft,
			8,
			_Utils_chr('0'),
			str) : str));
	};
	return '0x' + padWithZeros(
		$elm$core$String$toUpper(
			$rtfeldman$elm_hex$Hex$toString(val)));
};
var $author$project$Internal$Write$topContext = {isLeftPipe: false, isTop: true, precedence: 11};
var $elm$core$List$unzip = function (pairs) {
	var step = F2(
		function (_v0, _v1) {
			var x = _v0.a;
			var y = _v0.b;
			var xs = _v1.a;
			var ys = _v1.b;
			return _Utils_Tuple2(
				A2($elm$core$List$cons, x, xs),
				A2($elm$core$List$cons, y, ys));
		});
	return A3(
		$elm$core$List$foldr,
		step,
		_Utils_Tuple2(_List_Nil, _List_Nil),
		pairs);
};
var $author$project$Internal$Write$prettyApplication = F3(
	function (aliases, indent, exprs) {
		var _v30 = A2(
			$elm$core$Tuple$mapSecond,
			$Chadtech$elm_bool_extra$Bool$Extra$any,
			$elm$core$List$unzip(
				A2(
					$elm$core$List$map,
					A3(
						$author$project$Internal$Write$prettyExpressionInner,
						aliases,
						{isLeftPipe: false, isTop: false, precedence: 11},
						4),
					$author$project$Internal$Compiler$denodeAll(exprs))));
		var prettyExpressions = _v30.a;
		var alwaysBreak = _v30.b;
		return _Utils_Tuple2(
			A2(
				$author$project$Internal$Write$optionalGroup,
				alwaysBreak,
				$the_sett$elm_pretty_printer$Pretty$align(
					A2(
						$the_sett$elm_pretty_printer$Pretty$nest,
						indent,
						$the_sett$elm_pretty_printer$Pretty$lines(prettyExpressions)))),
			alwaysBreak);
	});
var $author$project$Internal$Write$prettyCaseBlock = F3(
	function (aliases, indent, caseBlock) {
		var prettyCase = function (_v29) {
			var pattern = _v29.a;
			var expr = _v29.b;
			return A2(
				$the_sett$elm_pretty_printer$Pretty$indent,
				indent,
				A2(
					$the_sett$elm_pretty_printer$Pretty$a,
					A2(
						$the_sett$elm_pretty_printer$Pretty$indent,
						4,
						A4(
							$author$project$Internal$Write$prettyExpressionInner,
							aliases,
							$author$project$Internal$Write$topContext,
							4,
							$author$project$Internal$Compiler$denode(expr)).a),
					A2(
						$the_sett$elm_pretty_printer$Pretty$a,
						$the_sett$elm_pretty_printer$Pretty$line,
						A2(
							$the_sett$elm_pretty_printer$Pretty$a,
							$the_sett$elm_pretty_printer$Pretty$string(' ->'),
							A2(
								$author$project$Internal$Write$prettyPattern,
								aliases,
								$author$project$Internal$Compiler$denode(pattern))))));
		};
		var patternsPart = $author$project$Internal$Write$doubleLines(
			A2($elm$core$List$map, prettyCase, caseBlock.cases));
		var casePart = function () {
			var _v28 = A4(
				$author$project$Internal$Write$prettyExpressionInner,
				aliases,
				$author$project$Internal$Write$topContext,
				4,
				$author$project$Internal$Compiler$denode(caseBlock.expression));
			var caseExpression = _v28.a;
			var alwaysBreak = _v28.b;
			return A2(
				$author$project$Internal$Write$optionalGroup,
				alwaysBreak,
				$the_sett$elm_pretty_printer$Pretty$lines(
					_List_fromArray(
						[
							A2(
							$the_sett$elm_pretty_printer$Pretty$nest,
							indent,
							A2(
								$author$project$Internal$Write$optionalGroup,
								alwaysBreak,
								$the_sett$elm_pretty_printer$Pretty$lines(
									_List_fromArray(
										[
											$the_sett$elm_pretty_printer$Pretty$string('case'),
											caseExpression
										])))),
							$the_sett$elm_pretty_printer$Pretty$string('of')
						])));
		}();
		return _Utils_Tuple2(
			$the_sett$elm_pretty_printer$Pretty$align(
				$the_sett$elm_pretty_printer$Pretty$lines(
					_List_fromArray(
						[casePart, patternsPart]))),
			true);
	});
var $author$project$Internal$Write$prettyExpression = F2(
	function (aliases, expression) {
		return A4($author$project$Internal$Write$prettyExpressionInner, aliases, $author$project$Internal$Write$topContext, 4, expression).a;
	});
var $author$project$Internal$Write$prettyExpressionInner = F4(
	function (aliases, context, indent, expression) {
		var _v26 = A2($author$project$Internal$Write$adjustExpressionParentheses, context, expression);
		switch (_v26.$) {
			case 'UnitExpr':
				return _Utils_Tuple2(
					$the_sett$elm_pretty_printer$Pretty$string('()'),
					false);
			case 'Application':
				var exprs = _v26.a;
				return A3($author$project$Internal$Write$prettyApplication, aliases, indent, exprs);
			case 'OperatorApplication':
				var symbol = _v26.a;
				var dir = _v26.b;
				var exprl = _v26.c;
				var exprr = _v26.d;
				return A6($author$project$Internal$Write$prettyOperatorApplication, aliases, indent, symbol, dir, exprl, exprr);
			case 'FunctionOrValue':
				var modl = _v26.a;
				var val = _v26.b;
				return _Utils_Tuple2(
					A2(
						$the_sett$elm_pretty_printer$Pretty$a,
						$the_sett$elm_pretty_printer$Pretty$string(val),
						A2($author$project$Internal$Write$prettyModuleNameDot, aliases, modl)),
					false);
			case 'IfBlock':
				var exprBool = _v26.a;
				var exprTrue = _v26.b;
				var exprFalse = _v26.c;
				return A5($author$project$Internal$Write$prettyIfBlock, aliases, indent, exprBool, exprTrue, exprFalse);
			case 'PrefixOperator':
				var symbol = _v26.a;
				return _Utils_Tuple2(
					$the_sett$elm_pretty_printer$Pretty$parens(
						$the_sett$elm_pretty_printer$Pretty$string(symbol)),
					false);
			case 'Operator':
				var symbol = _v26.a;
				return _Utils_Tuple2(
					$the_sett$elm_pretty_printer$Pretty$string(symbol),
					false);
			case 'Integer':
				var val = _v26.a;
				return _Utils_Tuple2(
					$the_sett$elm_pretty_printer$Pretty$string(
						$elm$core$String$fromInt(val)),
					false);
			case 'Hex':
				var val = _v26.a;
				return _Utils_Tuple2(
					$the_sett$elm_pretty_printer$Pretty$string(
						$author$project$Internal$Write$toHexString(val)),
					false);
			case 'Floatable':
				var val = _v26.a;
				return _Utils_Tuple2(
					$the_sett$elm_pretty_printer$Pretty$string(
						$elm$core$String$fromFloat(val)),
					false);
			case 'Negation':
				var expr = _v26.a;
				var _v27 = A4(
					$author$project$Internal$Write$prettyExpressionInner,
					aliases,
					$author$project$Internal$Write$topContext,
					4,
					$author$project$Internal$Compiler$denode(expr));
				var prettyExpr = _v27.a;
				var alwaysBreak = _v27.b;
				return _Utils_Tuple2(
					A2(
						$the_sett$elm_pretty_printer$Pretty$a,
						prettyExpr,
						$the_sett$elm_pretty_printer$Pretty$string('-')),
					alwaysBreak);
			case 'Literal':
				var val = _v26.a;
				return _Utils_Tuple2(
					$author$project$Internal$Write$prettyLiteral(val),
					false);
			case 'CharLiteral':
				var val = _v26.a;
				return _Utils_Tuple2(
					$author$project$Internal$Write$singleQuotes(
						$the_sett$elm_pretty_printer$Pretty$string(
							$author$project$Internal$Write$escapeChar(val))),
					false);
			case 'TupledExpression':
				var exprs = _v26.a;
				return A3($author$project$Internal$Write$prettyTupledExpression, aliases, indent, exprs);
			case 'ParenthesizedExpression':
				var expr = _v26.a;
				return A3($author$project$Internal$Write$prettyParenthesizedExpression, aliases, indent, expr);
			case 'LetExpression':
				var letBlock = _v26.a;
				return A3($author$project$Internal$Write$prettyLetBlock, aliases, indent, letBlock);
			case 'CaseExpression':
				var caseBlock = _v26.a;
				return A3($author$project$Internal$Write$prettyCaseBlock, aliases, indent, caseBlock);
			case 'LambdaExpression':
				var lambda = _v26.a;
				return A3($author$project$Internal$Write$prettyLambdaExpression, aliases, indent, lambda);
			case 'RecordExpr':
				var setters = _v26.a;
				return A2($author$project$Internal$Write$prettyRecordExpr, aliases, setters);
			case 'ListExpr':
				var exprs = _v26.a;
				return A3($author$project$Internal$Write$prettyList, aliases, indent, exprs);
			case 'RecordAccess':
				var expr = _v26.a;
				var field = _v26.b;
				return A3($author$project$Internal$Write$prettyRecordAccess, aliases, expr, field);
			case 'RecordAccessFunction':
				var field = _v26.a;
				return _Utils_Tuple2(
					$the_sett$elm_pretty_printer$Pretty$string(field),
					false);
			case 'RecordUpdateExpression':
				var _var = _v26.a;
				var setters = _v26.b;
				return A4($author$project$Internal$Write$prettyRecordUpdateExpression, aliases, indent, _var, setters);
			default:
				var val = _v26.a;
				return _Utils_Tuple2(
					$the_sett$elm_pretty_printer$Pretty$string('glsl'),
					true);
		}
	});
var $author$project$Internal$Write$prettyFun = F2(
	function (aliases, fn) {
		return $the_sett$elm_pretty_printer$Pretty$lines(
			_List_fromArray(
				[
					A2(
					$author$project$Internal$Write$prettyMaybe,
					$author$project$Internal$Write$prettyDocumentation,
					$author$project$Internal$Compiler$denodeMaybe(fn.documentation)),
					A2(
					$author$project$Internal$Write$prettyMaybe,
					$author$project$Internal$Write$prettySignature(aliases),
					$author$project$Internal$Compiler$denodeMaybe(fn.signature)),
					A2(
					$author$project$Internal$Write$prettyFunctionImplementation,
					aliases,
					$author$project$Internal$Compiler$denode(fn.declaration))
				]));
	});
var $author$project$Internal$Write$prettyFunctionImplementation = F2(
	function (aliases, impl) {
		return A2(
			$the_sett$elm_pretty_printer$Pretty$nest,
			4,
			A2(
				$the_sett$elm_pretty_printer$Pretty$a,
				A2(
					$author$project$Internal$Write$prettyExpression,
					aliases,
					$author$project$Internal$Compiler$denode(impl.expression)),
				A2(
					$the_sett$elm_pretty_printer$Pretty$a,
					$the_sett$elm_pretty_printer$Pretty$line,
					$the_sett$elm_pretty_printer$Pretty$words(
						_List_fromArray(
							[
								$the_sett$elm_pretty_printer$Pretty$string(
								$author$project$Internal$Compiler$denode(impl.name)),
								A2(
								$author$project$Internal$Write$prettyArgs,
								aliases,
								$author$project$Internal$Compiler$denodeAll(impl._arguments)),
								$the_sett$elm_pretty_printer$Pretty$string('=')
							])))));
	});
var $author$project$Internal$Write$prettyIfBlock = F5(
	function (aliases, indent, exprBool, exprTrue, exprFalse) {
		var innerIfBlock = F3(
			function (innerExprBool, innerExprTrue, innerExprFalse) {
				var truePart = A2(
					$the_sett$elm_pretty_printer$Pretty$indent,
					indent,
					A4(
						$author$project$Internal$Write$prettyExpressionInner,
						aliases,
						$author$project$Internal$Write$topContext,
						4,
						$author$project$Internal$Compiler$denode(innerExprTrue)).a);
				var ifPart = function () {
					var _v25 = A4(
						$author$project$Internal$Write$prettyExpressionInner,
						aliases,
						$author$project$Internal$Write$topContext,
						4,
						$author$project$Internal$Compiler$denode(innerExprBool));
					var prettyBoolExpr = _v25.a;
					var alwaysBreak = _v25.b;
					return A2(
						$author$project$Internal$Write$optionalGroup,
						alwaysBreak,
						$the_sett$elm_pretty_printer$Pretty$lines(
							_List_fromArray(
								[
									A2(
									$the_sett$elm_pretty_printer$Pretty$nest,
									indent,
									A2(
										$author$project$Internal$Write$optionalGroup,
										alwaysBreak,
										$the_sett$elm_pretty_printer$Pretty$lines(
											_List_fromArray(
												[
													$the_sett$elm_pretty_printer$Pretty$string('if'),
													A4(
													$author$project$Internal$Write$prettyExpressionInner,
													aliases,
													$author$project$Internal$Write$topContext,
													4,
													$author$project$Internal$Compiler$denode(innerExprBool)).a
												])))),
									$the_sett$elm_pretty_printer$Pretty$string('then')
								])));
				}();
				var falsePart = function () {
					var _v24 = $author$project$Internal$Compiler$denode(innerExprFalse);
					if (_v24.$ === 'IfBlock') {
						var nestedExprBool = _v24.a;
						var nestedExprTrue = _v24.b;
						var nestedExprFalse = _v24.c;
						return A3(innerIfBlock, nestedExprBool, nestedExprTrue, nestedExprFalse);
					} else {
						return _List_fromArray(
							[
								A2(
								$the_sett$elm_pretty_printer$Pretty$indent,
								indent,
								A4(
									$author$project$Internal$Write$prettyExpressionInner,
									aliases,
									$author$project$Internal$Write$topContext,
									4,
									$author$project$Internal$Compiler$denode(innerExprFalse)).a)
							]);
					}
				}();
				var elsePart = A2(
					$the_sett$elm_pretty_printer$Pretty$a,
					$the_sett$elm_pretty_printer$Pretty$string('else'),
					$the_sett$elm_pretty_printer$Pretty$line);
				var context = $author$project$Internal$Write$topContext;
				if (!falsePart.b) {
					return _List_Nil;
				} else {
					if (!falsePart.b.b) {
						var falseExpr = falsePart.a;
						return _List_fromArray(
							[ifPart, truePart, elsePart, falseExpr]);
					} else {
						var hd = falsePart.a;
						var tl = falsePart.b;
						return A2(
							$elm$core$List$append,
							_List_fromArray(
								[
									ifPart,
									truePart,
									$the_sett$elm_pretty_printer$Pretty$words(
									_List_fromArray(
										[elsePart, hd]))
								]),
							tl);
					}
				}
			});
		var prettyExpressions = A3(innerIfBlock, exprBool, exprTrue, exprFalse);
		return _Utils_Tuple2(
			$the_sett$elm_pretty_printer$Pretty$align(
				$the_sett$elm_pretty_printer$Pretty$lines(prettyExpressions)),
			true);
	});
var $author$project$Internal$Write$prettyLambdaExpression = F3(
	function (aliases, indent, lambda) {
		var _v22 = A4(
			$author$project$Internal$Write$prettyExpressionInner,
			aliases,
			$author$project$Internal$Write$topContext,
			4,
			$author$project$Internal$Compiler$denode(lambda.expression));
		var prettyExpr = _v22.a;
		var alwaysBreak = _v22.b;
		return _Utils_Tuple2(
			A2(
				$author$project$Internal$Write$optionalGroup,
				alwaysBreak,
				$the_sett$elm_pretty_printer$Pretty$align(
					A2(
						$the_sett$elm_pretty_printer$Pretty$nest,
						indent,
						$the_sett$elm_pretty_printer$Pretty$lines(
							_List_fromArray(
								[
									A2(
									$the_sett$elm_pretty_printer$Pretty$a,
									$the_sett$elm_pretty_printer$Pretty$string(' ->'),
									A2(
										$the_sett$elm_pretty_printer$Pretty$a,
										$the_sett$elm_pretty_printer$Pretty$words(
											A2(
												$elm$core$List$map,
												A2($author$project$Internal$Write$prettyPatternInner, aliases, false),
												$author$project$Internal$Compiler$denodeAll(lambda.args))),
										$the_sett$elm_pretty_printer$Pretty$string('\\'))),
									prettyExpr
								]))))),
			alwaysBreak);
	});
var $author$project$Internal$Write$prettyLetBlock = F3(
	function (aliases, indent, letBlock) {
		return _Utils_Tuple2(
			$the_sett$elm_pretty_printer$Pretty$align(
				$the_sett$elm_pretty_printer$Pretty$lines(
					_List_fromArray(
						[
							$the_sett$elm_pretty_printer$Pretty$string('let'),
							A2(
							$the_sett$elm_pretty_printer$Pretty$indent,
							indent,
							$author$project$Internal$Write$doubleLines(
								A2(
									$elm$core$List$map,
									A2($author$project$Internal$Write$prettyLetDeclaration, aliases, indent),
									$author$project$Internal$Compiler$denodeAll(letBlock.declarations)))),
							$the_sett$elm_pretty_printer$Pretty$string('in'),
							A4(
							$author$project$Internal$Write$prettyExpressionInner,
							aliases,
							$author$project$Internal$Write$topContext,
							4,
							$author$project$Internal$Compiler$denode(letBlock.expression)).a
						]))),
			true);
	});
var $author$project$Internal$Write$prettyLetDeclaration = F3(
	function (aliases, indent, letDecl) {
		if (letDecl.$ === 'LetFunction') {
			var fn = letDecl.a;
			return A2($author$project$Internal$Write$prettyFun, aliases, fn);
		} else {
			var pattern = letDecl.a;
			var expr = letDecl.b;
			return A2(
				$the_sett$elm_pretty_printer$Pretty$a,
				A2(
					$the_sett$elm_pretty_printer$Pretty$indent,
					indent,
					A4(
						$author$project$Internal$Write$prettyExpressionInner,
						aliases,
						$author$project$Internal$Write$topContext,
						4,
						$author$project$Internal$Compiler$denode(expr)).a),
				A2(
					$the_sett$elm_pretty_printer$Pretty$a,
					$the_sett$elm_pretty_printer$Pretty$line,
					$the_sett$elm_pretty_printer$Pretty$words(
						_List_fromArray(
							[
								A3(
								$author$project$Internal$Write$prettyPatternInner,
								aliases,
								false,
								$author$project$Internal$Compiler$denode(pattern)),
								$the_sett$elm_pretty_printer$Pretty$string('=')
							]))));
		}
	});
var $author$project$Internal$Write$prettyList = F3(
	function (aliases, indent, exprs) {
		var open = A2(
			$the_sett$elm_pretty_printer$Pretty$a,
			$the_sett$elm_pretty_printer$Pretty$space,
			$the_sett$elm_pretty_printer$Pretty$string('['));
		var close = A2(
			$the_sett$elm_pretty_printer$Pretty$a,
			$the_sett$elm_pretty_printer$Pretty$string(']'),
			$the_sett$elm_pretty_printer$Pretty$line);
		if (!exprs.b) {
			return _Utils_Tuple2(
				$the_sett$elm_pretty_printer$Pretty$string('[]'),
				false);
		} else {
			var _v20 = A2(
				$elm$core$Tuple$mapSecond,
				$Chadtech$elm_bool_extra$Bool$Extra$any,
				$elm$core$List$unzip(
					A2(
						$elm$core$List$map,
						A3(
							$author$project$Internal$Write$prettyExpressionInner,
							aliases,
							$author$project$Internal$Write$topContext,
							A2($author$project$Internal$Write$decrementIndent, indent, 2)),
						$author$project$Internal$Compiler$denodeAll(exprs))));
			var prettyExpressions = _v20.a;
			var alwaysBreak = _v20.b;
			return _Utils_Tuple2(
				A2(
					$author$project$Internal$Write$optionalGroup,
					alwaysBreak,
					$the_sett$elm_pretty_printer$Pretty$align(
						A3(
							$the_sett$elm_pretty_printer$Pretty$surround,
							open,
							close,
							A2($the_sett$elm_pretty_printer$Pretty$separators, ', ', prettyExpressions)))),
				alwaysBreak);
		}
	});
var $author$project$Internal$Write$prettyOperatorApplication = F6(
	function (aliases, indent, symbol, dir, exprl, exprr) {
		return (symbol === '<|') ? A6($author$project$Internal$Write$prettyOperatorApplicationLeft, aliases, indent, symbol, dir, exprl, exprr) : A6($author$project$Internal$Write$prettyOperatorApplicationRight, aliases, indent, symbol, dir, exprl, exprr);
	});
var $author$project$Internal$Write$prettyOperatorApplicationLeft = F6(
	function (aliases, indent, symbol, _v16, exprl, exprr) {
		var context = {
			isLeftPipe: true,
			isTop: false,
			precedence: $author$project$Internal$Write$precedence(symbol)
		};
		var _v17 = A4(
			$author$project$Internal$Write$prettyExpressionInner,
			aliases,
			context,
			4,
			$author$project$Internal$Compiler$denode(exprr));
		var prettyExpressionRight = _v17.a;
		var alwaysBreakRight = _v17.b;
		var _v18 = A4(
			$author$project$Internal$Write$prettyExpressionInner,
			aliases,
			context,
			4,
			$author$project$Internal$Compiler$denode(exprl));
		var prettyExpressionLeft = _v18.a;
		var alwaysBreakLeft = _v18.b;
		var alwaysBreak = alwaysBreakLeft || alwaysBreakRight;
		return _Utils_Tuple2(
			A2(
				$the_sett$elm_pretty_printer$Pretty$nest,
				4,
				A2(
					$author$project$Internal$Write$optionalGroup,
					alwaysBreak,
					$the_sett$elm_pretty_printer$Pretty$lines(
						_List_fromArray(
							[
								$the_sett$elm_pretty_printer$Pretty$words(
								_List_fromArray(
									[
										prettyExpressionLeft,
										$the_sett$elm_pretty_printer$Pretty$string(symbol)
									])),
								prettyExpressionRight
							])))),
			alwaysBreak);
	});
var $author$project$Internal$Write$prettyOperatorApplicationRight = F6(
	function (aliases, indent, symbol, _v11, exprl, exprr) {
		var expandExpr = F3(
			function (innerIndent, context, expr) {
				if (expr.$ === 'OperatorApplication') {
					var sym = expr.a;
					var left = expr.c;
					var right = expr.d;
					return A4(innerOpApply, false, sym, left, right);
				} else {
					return _List_fromArray(
						[
							A4($author$project$Internal$Write$prettyExpressionInner, aliases, context, innerIndent, expr)
						]);
				}
			});
		var innerOpApply = F4(
			function (isTop, sym, left, right) {
				var innerIndent = A2(
					$author$project$Internal$Write$decrementIndent,
					4,
					$elm$core$String$length(symbol) + 1);
				var leftIndent = isTop ? indent : innerIndent;
				var context = {
					isLeftPipe: '<|' === sym,
					isTop: false,
					precedence: $author$project$Internal$Write$precedence(sym)
				};
				var rightSide = A3(
					expandExpr,
					innerIndent,
					context,
					$author$project$Internal$Compiler$denode(right));
				if (rightSide.b) {
					var _v14 = rightSide.a;
					var hdExpr = _v14.a;
					var hdBreak = _v14.b;
					var tl = rightSide.b;
					return A2(
						$elm$core$List$append,
						A3(
							expandExpr,
							leftIndent,
							context,
							$author$project$Internal$Compiler$denode(left)),
						A2(
							$elm$core$List$cons,
							_Utils_Tuple2(
								A2(
									$the_sett$elm_pretty_printer$Pretty$a,
									hdExpr,
									A2(
										$the_sett$elm_pretty_printer$Pretty$a,
										$the_sett$elm_pretty_printer$Pretty$space,
										$the_sett$elm_pretty_printer$Pretty$string(sym))),
								hdBreak),
							tl));
				} else {
					return _List_Nil;
				}
			});
		var _v12 = A2(
			$elm$core$Tuple$mapSecond,
			$Chadtech$elm_bool_extra$Bool$Extra$any,
			$elm$core$List$unzip(
				A4(innerOpApply, true, symbol, exprl, exprr)));
		var prettyExpressions = _v12.a;
		var alwaysBreak = _v12.b;
		return _Utils_Tuple2(
			A2(
				$author$project$Internal$Write$optionalGroup,
				alwaysBreak,
				$the_sett$elm_pretty_printer$Pretty$align(
					A2(
						$the_sett$elm_pretty_printer$Pretty$join,
						A2($the_sett$elm_pretty_printer$Pretty$nest, indent, $the_sett$elm_pretty_printer$Pretty$line),
						prettyExpressions))),
			alwaysBreak);
	});
var $author$project$Internal$Write$prettyParenthesizedExpression = F3(
	function (aliases, indent, expr) {
		var open = $the_sett$elm_pretty_printer$Pretty$string('(');
		var close = A2(
			$the_sett$elm_pretty_printer$Pretty$a,
			$the_sett$elm_pretty_printer$Pretty$string(')'),
			$the_sett$elm_pretty_printer$Pretty$tightline);
		var _v10 = A4(
			$author$project$Internal$Write$prettyExpressionInner,
			aliases,
			$author$project$Internal$Write$topContext,
			A2($author$project$Internal$Write$decrementIndent, indent, 1),
			$author$project$Internal$Compiler$denode(expr));
		var prettyExpr = _v10.a;
		var alwaysBreak = _v10.b;
		return _Utils_Tuple2(
			A2(
				$author$project$Internal$Write$optionalGroup,
				alwaysBreak,
				$the_sett$elm_pretty_printer$Pretty$align(
					A3(
						$the_sett$elm_pretty_printer$Pretty$surround,
						open,
						close,
						A2($the_sett$elm_pretty_printer$Pretty$nest, 1, prettyExpr)))),
			alwaysBreak);
	});
var $author$project$Internal$Write$prettyRecordAccess = F3(
	function (aliases, expr, field) {
		var _v9 = A4(
			$author$project$Internal$Write$prettyExpressionInner,
			aliases,
			$author$project$Internal$Write$topContext,
			4,
			$author$project$Internal$Compiler$denode(expr));
		var prettyExpr = _v9.a;
		var alwaysBreak = _v9.b;
		return _Utils_Tuple2(
			A2(
				$the_sett$elm_pretty_printer$Pretty$a,
				$the_sett$elm_pretty_printer$Pretty$string(
					$author$project$Internal$Compiler$denode(field)),
				A2($the_sett$elm_pretty_printer$Pretty$a, $author$project$Internal$Write$dot, prettyExpr)),
			alwaysBreak);
	});
var $author$project$Internal$Write$prettyRecordExpr = F2(
	function (aliases, setters) {
		var open = A2(
			$the_sett$elm_pretty_printer$Pretty$a,
			$the_sett$elm_pretty_printer$Pretty$space,
			$the_sett$elm_pretty_printer$Pretty$string('{'));
		var close = A2(
			$the_sett$elm_pretty_printer$Pretty$a,
			$the_sett$elm_pretty_printer$Pretty$string('}'),
			$the_sett$elm_pretty_printer$Pretty$line);
		if (!setters.b) {
			return _Utils_Tuple2(
				$the_sett$elm_pretty_printer$Pretty$string('{}'),
				false);
		} else {
			var _v8 = A2(
				$elm$core$Tuple$mapSecond,
				$Chadtech$elm_bool_extra$Bool$Extra$any,
				$elm$core$List$unzip(
					A2(
						$elm$core$List$map,
						$author$project$Internal$Write$prettySetter(aliases),
						$author$project$Internal$Compiler$denodeAll(setters))));
			var prettyExpressions = _v8.a;
			var alwaysBreak = _v8.b;
			return _Utils_Tuple2(
				A2(
					$author$project$Internal$Write$optionalGroup,
					alwaysBreak,
					$the_sett$elm_pretty_printer$Pretty$align(
						A3(
							$the_sett$elm_pretty_printer$Pretty$surround,
							open,
							close,
							A2($the_sett$elm_pretty_printer$Pretty$separators, ', ', prettyExpressions)))),
				alwaysBreak);
		}
	});
var $author$project$Internal$Write$prettyRecordUpdateExpression = F4(
	function (aliases, indent, _var, setters) {
		var open = A2(
			$the_sett$elm_pretty_printer$Pretty$a,
			$the_sett$elm_pretty_printer$Pretty$line,
			$the_sett$elm_pretty_printer$Pretty$words(
				_List_fromArray(
					[
						$the_sett$elm_pretty_printer$Pretty$string('{'),
						$the_sett$elm_pretty_printer$Pretty$string(
						$author$project$Internal$Compiler$denode(_var))
					])));
		var close = A2(
			$the_sett$elm_pretty_printer$Pretty$a,
			$the_sett$elm_pretty_printer$Pretty$string('}'),
			$the_sett$elm_pretty_printer$Pretty$line);
		var addBarToFirst = function (exprs) {
			if (!exprs.b) {
				return _List_Nil;
			} else {
				var hd = exprs.a;
				var tl = exprs.b;
				return A2(
					$elm$core$List$cons,
					A2(
						$the_sett$elm_pretty_printer$Pretty$a,
						hd,
						$the_sett$elm_pretty_printer$Pretty$string('| ')),
					tl);
			}
		};
		if (!setters.b) {
			return _Utils_Tuple2(
				$the_sett$elm_pretty_printer$Pretty$string('{}'),
				false);
		} else {
			var _v5 = A2(
				$elm$core$Tuple$mapSecond,
				$Chadtech$elm_bool_extra$Bool$Extra$any,
				$elm$core$List$unzip(
					A2(
						$elm$core$List$map,
						$author$project$Internal$Write$prettySetter(aliases),
						$author$project$Internal$Compiler$denodeAll(setters))));
			var prettyExpressions = _v5.a;
			var alwaysBreak = _v5.b;
			return _Utils_Tuple2(
				A2(
					$author$project$Internal$Write$optionalGroup,
					alwaysBreak,
					$the_sett$elm_pretty_printer$Pretty$align(
						A3(
							$the_sett$elm_pretty_printer$Pretty$surround,
							$the_sett$elm_pretty_printer$Pretty$empty,
							close,
							A2(
								$the_sett$elm_pretty_printer$Pretty$nest,
								indent,
								A2(
									$the_sett$elm_pretty_printer$Pretty$a,
									A2(
										$the_sett$elm_pretty_printer$Pretty$separators,
										', ',
										addBarToFirst(prettyExpressions)),
									open))))),
				alwaysBreak);
		}
	});
var $author$project$Internal$Write$prettySetter = F2(
	function (aliases, _v2) {
		var fld = _v2.a;
		var val = _v2.b;
		var _v3 = A4(
			$author$project$Internal$Write$prettyExpressionInner,
			aliases,
			$author$project$Internal$Write$topContext,
			4,
			$author$project$Internal$Compiler$denode(val));
		var prettyExpr = _v3.a;
		var alwaysBreak = _v3.b;
		return _Utils_Tuple2(
			A2(
				$the_sett$elm_pretty_printer$Pretty$nest,
				4,
				A2(
					$author$project$Internal$Write$optionalGroup,
					alwaysBreak,
					$the_sett$elm_pretty_printer$Pretty$lines(
						_List_fromArray(
							[
								$the_sett$elm_pretty_printer$Pretty$words(
								_List_fromArray(
									[
										$the_sett$elm_pretty_printer$Pretty$string(
										$author$project$Internal$Compiler$denode(fld)),
										$the_sett$elm_pretty_printer$Pretty$string('=')
									])),
								prettyExpr
							])))),
			alwaysBreak);
	});
var $author$project$Internal$Write$prettyTupledExpression = F3(
	function (aliases, indent, exprs) {
		var open = A2(
			$the_sett$elm_pretty_printer$Pretty$a,
			$the_sett$elm_pretty_printer$Pretty$space,
			$the_sett$elm_pretty_printer$Pretty$string('('));
		var close = A2(
			$the_sett$elm_pretty_printer$Pretty$a,
			$the_sett$elm_pretty_printer$Pretty$string(')'),
			$the_sett$elm_pretty_printer$Pretty$line);
		if (!exprs.b) {
			return _Utils_Tuple2(
				$the_sett$elm_pretty_printer$Pretty$string('()'),
				false);
		} else {
			var _v1 = A2(
				$elm$core$Tuple$mapSecond,
				$Chadtech$elm_bool_extra$Bool$Extra$any,
				$elm$core$List$unzip(
					A2(
						$elm$core$List$map,
						A3(
							$author$project$Internal$Write$prettyExpressionInner,
							aliases,
							$author$project$Internal$Write$topContext,
							A2($author$project$Internal$Write$decrementIndent, indent, 2)),
						$author$project$Internal$Compiler$denodeAll(exprs))));
			var prettyExpressions = _v1.a;
			var alwaysBreak = _v1.b;
			return _Utils_Tuple2(
				A2(
					$author$project$Internal$Write$optionalGroup,
					alwaysBreak,
					$the_sett$elm_pretty_printer$Pretty$align(
						A3(
							$the_sett$elm_pretty_printer$Pretty$surround,
							open,
							close,
							A2($the_sett$elm_pretty_printer$Pretty$separators, ', ', prettyExpressions)))),
				alwaysBreak);
		}
	});
var $author$project$Internal$Write$prettyDestructuring = F3(
	function (aliases, pattern, expr) {
		return A2(
			$the_sett$elm_pretty_printer$Pretty$nest,
			4,
			$the_sett$elm_pretty_printer$Pretty$lines(
				_List_fromArray(
					[
						$the_sett$elm_pretty_printer$Pretty$words(
						_List_fromArray(
							[
								A2($author$project$Internal$Write$prettyPattern, aliases, pattern),
								$the_sett$elm_pretty_printer$Pretty$string('=')
							])),
						A2($author$project$Internal$Write$prettyExpression, aliases, expr)
					])));
	});
var $author$project$Internal$Write$prettyInfix = function (infix_) {
	var dirToString = function (direction) {
		switch (direction.$) {
			case 'Left':
				return 'left';
			case 'Right':
				return 'right';
			default:
				return 'non';
		}
	};
	return $the_sett$elm_pretty_printer$Pretty$words(
		_List_fromArray(
			[
				$the_sett$elm_pretty_printer$Pretty$string('infix'),
				$the_sett$elm_pretty_printer$Pretty$string(
				dirToString(
					$author$project$Internal$Compiler$denode(infix_.direction))),
				$the_sett$elm_pretty_printer$Pretty$string(
				$elm$core$String$fromInt(
					$author$project$Internal$Compiler$denode(infix_.precedence))),
				$the_sett$elm_pretty_printer$Pretty$parens(
				$the_sett$elm_pretty_printer$Pretty$string(
					$author$project$Internal$Compiler$denode(infix_.operator))),
				$the_sett$elm_pretty_printer$Pretty$string('='),
				$the_sett$elm_pretty_printer$Pretty$string(
				$author$project$Internal$Compiler$denode(infix_._function))
			]));
};
var $author$project$Internal$Write$prettyPortDeclaration = F2(
	function (aliases, sig) {
		return $the_sett$elm_pretty_printer$Pretty$words(
			_List_fromArray(
				[
					$the_sett$elm_pretty_printer$Pretty$string('port'),
					A2($author$project$Internal$Write$prettySignature, aliases, sig)
				]));
	});
var $author$project$Internal$Write$prettyTypeAlias = F2(
	function (aliases, tAlias) {
		var typeAliasPretty = A2(
			$the_sett$elm_pretty_printer$Pretty$nest,
			4,
			A2(
				$the_sett$elm_pretty_printer$Pretty$a,
				A2(
					$author$project$Internal$Write$prettyTypeAnnotation,
					aliases,
					$author$project$Internal$Compiler$denode(tAlias.typeAnnotation)),
				A2(
					$the_sett$elm_pretty_printer$Pretty$a,
					$the_sett$elm_pretty_printer$Pretty$line,
					$the_sett$elm_pretty_printer$Pretty$words(
						_List_fromArray(
							[
								$the_sett$elm_pretty_printer$Pretty$string('type alias'),
								$the_sett$elm_pretty_printer$Pretty$string(
								$author$project$Internal$Compiler$denode(tAlias.name)),
								$the_sett$elm_pretty_printer$Pretty$words(
								A2(
									$elm$core$List$map,
									$the_sett$elm_pretty_printer$Pretty$string,
									$author$project$Internal$Compiler$denodeAll(tAlias.generics))),
								$the_sett$elm_pretty_printer$Pretty$string('=')
							])))));
		return $the_sett$elm_pretty_printer$Pretty$lines(
			_List_fromArray(
				[
					A2(
					$author$project$Internal$Write$prettyMaybe,
					$author$project$Internal$Write$prettyDocumentation,
					$author$project$Internal$Compiler$denodeMaybe(tAlias.documentation)),
					typeAliasPretty
				]));
	});
var $author$project$Internal$Write$prettyElmSyntaxDeclaration = F2(
	function (aliases, decl) {
		switch (decl.$) {
			case 'FunctionDeclaration':
				var fn = decl.a;
				return A2($author$project$Internal$Write$prettyFun, aliases, fn);
			case 'AliasDeclaration':
				var tAlias = decl.a;
				return A2($author$project$Internal$Write$prettyTypeAlias, aliases, tAlias);
			case 'CustomTypeDeclaration':
				var type_ = decl.a;
				return A2($author$project$Internal$Write$prettyCustomType, aliases, type_);
			case 'PortDeclaration':
				var sig = decl.a;
				return A2($author$project$Internal$Write$prettyPortDeclaration, aliases, sig);
			case 'InfixDeclaration':
				var infix_ = decl.a;
				return $author$project$Internal$Write$prettyInfix(infix_);
			default:
				var pattern = decl.a;
				var expr = decl.b;
				return A3(
					$author$project$Internal$Write$prettyDestructuring,
					aliases,
					$author$project$Internal$Compiler$denode(pattern),
					$author$project$Internal$Compiler$denode(expr));
		}
	});
var $author$project$Internal$Write$prettyDeclarations = F2(
	function (aliases, decls) {
		return A3(
			$elm$core$List$foldl,
			F2(
				function (decl, doc) {
					if (decl.$ === 'Comment') {
						var content = decl.a;
						return A2(
							$the_sett$elm_pretty_printer$Pretty$a,
							$the_sett$elm_pretty_printer$Pretty$line,
							A2(
								$the_sett$elm_pretty_printer$Pretty$a,
								$the_sett$elm_pretty_printer$Pretty$string(content + '\n\n'),
								doc));
					} else {
						var innerDecl = decl.c;
						return A2(
							$the_sett$elm_pretty_printer$Pretty$a,
							$the_sett$elm_pretty_printer$Pretty$line,
							A2(
								$the_sett$elm_pretty_printer$Pretty$a,
								$the_sett$elm_pretty_printer$Pretty$line,
								A2(
									$the_sett$elm_pretty_printer$Pretty$a,
									$the_sett$elm_pretty_printer$Pretty$line,
									A2(
										$the_sett$elm_pretty_printer$Pretty$a,
										A2($author$project$Internal$Write$prettyElmSyntaxDeclaration, aliases, innerDecl),
										doc))));
					}
				}),
			$the_sett$elm_pretty_printer$Pretty$empty,
			decls);
	});
var $author$project$Internal$Comments$delimeters = function (doc) {
	return A2(
		$the_sett$elm_pretty_printer$Pretty$a,
		$the_sett$elm_pretty_printer$Pretty$string('-}'),
		A2(
			$the_sett$elm_pretty_printer$Pretty$a,
			$the_sett$elm_pretty_printer$Pretty$line,
			A2(
				$the_sett$elm_pretty_printer$Pretty$a,
				doc,
				$the_sett$elm_pretty_printer$Pretty$string('{-| '))));
};
var $author$project$Internal$Comments$getParts = function (_v0) {
	var parts = _v0.a;
	return $elm$core$List$reverse(parts);
};
var $author$project$Internal$Comments$DocTags = function (a) {
	return {$: 'DocTags', a: a};
};
var $author$project$Internal$Comments$fitAndSplit = F2(
	function (width, tags) {
		if (!tags.b) {
			return _List_Nil;
		} else {
			var t = tags.a;
			var ts = tags.b;
			var _v1 = A3(
				$elm$core$List$foldl,
				F2(
					function (tag, _v2) {
						var allSplits = _v2.a;
						var curSplit = _v2.b;
						var remaining = _v2.c;
						return (_Utils_cmp(
							$elm$core$String$length(tag),
							remaining) < 1) ? _Utils_Tuple3(
							allSplits,
							A2($elm$core$List$cons, tag, curSplit),
							remaining - $elm$core$String$length(tag)) : _Utils_Tuple3(
							_Utils_ap(
								allSplits,
								_List_fromArray(
									[
										$elm$core$List$reverse(curSplit)
									])),
							_List_fromArray(
								[tag]),
							width - $elm$core$String$length(tag));
					}),
				_Utils_Tuple3(
					_List_Nil,
					_List_fromArray(
						[t]),
					width - $elm$core$String$length(t)),
				ts);
			var splitsExceptLast = _v1.a;
			var lastSplit = _v1.b;
			return _Utils_ap(
				splitsExceptLast,
				_List_fromArray(
					[
						$elm$core$List$reverse(lastSplit)
					]));
		}
	});
var $elm$core$List$sort = function (xs) {
	return A2($elm$core$List$sortBy, $elm$core$Basics$identity, xs);
};
var $author$project$Internal$Comments$mergeDocTags = function (innerParts) {
	var _v0 = A3(
		$elm$core$List$foldr,
		F2(
			function (part, _v1) {
				var accum = _v1.a;
				var context = _v1.b;
				if (context.$ === 'Nothing') {
					if (part.$ === 'DocTags') {
						var tags = part.a;
						return _Utils_Tuple2(
							accum,
							$elm$core$Maybe$Just(tags));
					} else {
						var otherPart = part;
						return _Utils_Tuple2(
							A2($elm$core$List$cons, otherPart, accum),
							$elm$core$Maybe$Nothing);
					}
				} else {
					var contextTags = context.a;
					if (part.$ === 'DocTags') {
						var tags = part.a;
						return _Utils_Tuple2(
							accum,
							$elm$core$Maybe$Just(
								_Utils_ap(contextTags, tags)));
					} else {
						var otherPart = part;
						return _Utils_Tuple2(
							A2(
								$elm$core$List$cons,
								otherPart,
								A2(
									$elm$core$List$cons,
									$author$project$Internal$Comments$DocTags(
										$elm$core$List$sort(contextTags)),
									accum)),
							$elm$core$Maybe$Nothing);
					}
				}
			}),
		_Utils_Tuple2(_List_Nil, $elm$core$Maybe$Nothing),
		innerParts);
	var partsExceptMaybeFirst = _v0.a;
	var maybeFirstPart = _v0.b;
	if (maybeFirstPart.$ === 'Nothing') {
		return partsExceptMaybeFirst;
	} else {
		var tags = maybeFirstPart.a;
		return A2(
			$elm$core$List$cons,
			$author$project$Internal$Comments$DocTags(
				$elm$core$List$sort(tags)),
			partsExceptMaybeFirst);
	}
};
var $author$project$Internal$Comments$layoutTags = F2(
	function (width, parts) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (part, _v0) {
					var accumParts = _v0.a;
					var accumDocTags = _v0.b;
					if (part.$ === 'DocTags') {
						var tags = part.a;
						var splits = A2($author$project$Internal$Comments$fitAndSplit, width, tags);
						return _Utils_Tuple2(
							_Utils_ap(
								A2($elm$core$List$map, $author$project$Internal$Comments$DocTags, splits),
								accumParts),
							_Utils_ap(accumDocTags, splits));
					} else {
						var otherPart = part;
						return _Utils_Tuple2(
							A2($elm$core$List$cons, otherPart, accumParts),
							accumDocTags);
					}
				}),
			_Utils_Tuple2(_List_Nil, _List_Nil),
			$author$project$Internal$Comments$mergeDocTags(parts));
	});
var $the_sett$elm_pretty_printer$Internals$NLine = F3(
	function (a, b, c) {
		return {$: 'NLine', a: a, b: b, c: c};
	});
var $the_sett$elm_pretty_printer$Internals$NNil = {$: 'NNil'};
var $the_sett$elm_pretty_printer$Internals$NText = F3(
	function (a, b, c) {
		return {$: 'NText', a: a, b: b, c: c};
	});
var $the_sett$elm_pretty_printer$Internals$fits = F2(
	function (w, normal) {
		fits:
		while (true) {
			if (w < 0) {
				return false;
			} else {
				switch (normal.$) {
					case 'NNil':
						return true;
					case 'NText':
						var text = normal.a;
						var innerNormal = normal.b;
						var $temp$w = w - $elm$core$String$length(text),
							$temp$normal = innerNormal(_Utils_Tuple0);
						w = $temp$w;
						normal = $temp$normal;
						continue fits;
					default:
						return true;
				}
			}
		}
	});
var $the_sett$elm_pretty_printer$Internals$better = F4(
	function (w, k, doc, doc2Fn) {
		return A2($the_sett$elm_pretty_printer$Internals$fits, w - k, doc) ? doc : doc2Fn(_Utils_Tuple0);
	});
var $the_sett$elm_pretty_printer$Internals$best = F3(
	function (width, startCol, x) {
		var be = F3(
			function (w, k, docs) {
				be:
				while (true) {
					if (!docs.b) {
						return $the_sett$elm_pretty_printer$Internals$NNil;
					} else {
						switch (docs.a.b.$) {
							case 'Empty':
								var _v1 = docs.a;
								var i = _v1.a;
								var _v2 = _v1.b;
								var ds = docs.b;
								var $temp$w = w,
									$temp$k = k,
									$temp$docs = ds;
								w = $temp$w;
								k = $temp$k;
								docs = $temp$docs;
								continue be;
							case 'Concatenate':
								var _v3 = docs.a;
								var i = _v3.a;
								var _v4 = _v3.b;
								var doc = _v4.a;
								var doc2 = _v4.b;
								var ds = docs.b;
								var $temp$w = w,
									$temp$k = k,
									$temp$docs = A2(
									$elm$core$List$cons,
									_Utils_Tuple2(
										i,
										doc(_Utils_Tuple0)),
									A2(
										$elm$core$List$cons,
										_Utils_Tuple2(
											i,
											doc2(_Utils_Tuple0)),
										ds));
								w = $temp$w;
								k = $temp$k;
								docs = $temp$docs;
								continue be;
							case 'Nest':
								var _v5 = docs.a;
								var i = _v5.a;
								var _v6 = _v5.b;
								var j = _v6.a;
								var doc = _v6.b;
								var ds = docs.b;
								var $temp$w = w,
									$temp$k = k,
									$temp$docs = A2(
									$elm$core$List$cons,
									_Utils_Tuple2(
										i + j,
										doc(_Utils_Tuple0)),
									ds);
								w = $temp$w;
								k = $temp$k;
								docs = $temp$docs;
								continue be;
							case 'Text':
								var _v7 = docs.a;
								var i = _v7.a;
								var _v8 = _v7.b;
								var text = _v8.a;
								var maybeTag = _v8.b;
								var ds = docs.b;
								return A3(
									$the_sett$elm_pretty_printer$Internals$NText,
									text,
									function (_v9) {
										return A3(
											be,
											w,
											k + $elm$core$String$length(text),
											ds);
									},
									maybeTag);
							case 'Line':
								var _v10 = docs.a;
								var i = _v10.a;
								var _v11 = _v10.b;
								var vsep = _v11.b;
								var ds = docs.b;
								return A3(
									$the_sett$elm_pretty_printer$Internals$NLine,
									i,
									vsep,
									function (_v12) {
										return A3(
											be,
											w,
											i + $elm$core$String$length(vsep),
											ds);
									});
							case 'Union':
								var _v13 = docs.a;
								var i = _v13.a;
								var _v14 = _v13.b;
								var doc = _v14.a;
								var doc2 = _v14.b;
								var ds = docs.b;
								return A4(
									$the_sett$elm_pretty_printer$Internals$better,
									w,
									k,
									A3(
										be,
										w,
										k,
										A2(
											$elm$core$List$cons,
											_Utils_Tuple2(i, doc),
											ds)),
									function (_v15) {
										return A3(
											be,
											w,
											k,
											A2(
												$elm$core$List$cons,
												_Utils_Tuple2(i, doc2),
												ds));
									});
							case 'Nesting':
								var _v16 = docs.a;
								var i = _v16.a;
								var fn = _v16.b.a;
								var ds = docs.b;
								var $temp$w = w,
									$temp$k = k,
									$temp$docs = A2(
									$elm$core$List$cons,
									_Utils_Tuple2(
										i,
										fn(i)),
									ds);
								w = $temp$w;
								k = $temp$k;
								docs = $temp$docs;
								continue be;
							default:
								var _v17 = docs.a;
								var i = _v17.a;
								var fn = _v17.b.a;
								var ds = docs.b;
								var $temp$w = w,
									$temp$k = k,
									$temp$docs = A2(
									$elm$core$List$cons,
									_Utils_Tuple2(
										i,
										fn(k)),
									ds);
								w = $temp$w;
								k = $temp$k;
								docs = $temp$docs;
								continue be;
						}
					}
				}
			});
		return A3(
			be,
			width,
			startCol,
			_List_fromArray(
				[
					_Utils_Tuple2(0, x)
				]));
	});
var $elm$core$String$concat = function (strings) {
	return A2($elm$core$String$join, '', strings);
};
var $the_sett$elm_pretty_printer$Internals$layout = function (normal) {
	var layoutInner = F2(
		function (normal2, acc) {
			layoutInner:
			while (true) {
				switch (normal2.$) {
					case 'NNil':
						return acc;
					case 'NText':
						var text = normal2.a;
						var innerNormal = normal2.b;
						var maybeTag = normal2.c;
						var $temp$normal2 = innerNormal(_Utils_Tuple0),
							$temp$acc = A2($elm$core$List$cons, text, acc);
						normal2 = $temp$normal2;
						acc = $temp$acc;
						continue layoutInner;
					default:
						var i = normal2.a;
						var sep = normal2.b;
						var innerNormal = normal2.c;
						var norm = innerNormal(_Utils_Tuple0);
						if (norm.$ === 'NLine') {
							var $temp$normal2 = innerNormal(_Utils_Tuple0),
								$temp$acc = A2($elm$core$List$cons, '\n' + sep, acc);
							normal2 = $temp$normal2;
							acc = $temp$acc;
							continue layoutInner;
						} else {
							var $temp$normal2 = innerNormal(_Utils_Tuple0),
								$temp$acc = A2(
								$elm$core$List$cons,
								'\n' + (A2($the_sett$elm_pretty_printer$Internals$copy, i, ' ') + sep),
								acc);
							normal2 = $temp$normal2;
							acc = $temp$acc;
							continue layoutInner;
						}
				}
			}
		});
	return $elm$core$String$concat(
		$elm$core$List$reverse(
			A2(layoutInner, normal, _List_Nil)));
};
var $the_sett$elm_pretty_printer$Pretty$pretty = F2(
	function (w, doc) {
		return $the_sett$elm_pretty_printer$Internals$layout(
			A3($the_sett$elm_pretty_printer$Internals$best, w, 0, doc));
	});
var $author$project$Internal$Comments$prettyCode = function (val) {
	return A2(
		$the_sett$elm_pretty_printer$Pretty$indent,
		4,
		$the_sett$elm_pretty_printer$Pretty$string(val));
};
var $author$project$Internal$Comments$prettyMarkdown = function (val) {
	return $the_sett$elm_pretty_printer$Pretty$string(val);
};
var $author$project$Internal$Comments$prettyTags = function (tags) {
	return $the_sett$elm_pretty_printer$Pretty$words(
		_List_fromArray(
			[
				$the_sett$elm_pretty_printer$Pretty$string('@docs'),
				A2(
				$the_sett$elm_pretty_printer$Pretty$join,
				$the_sett$elm_pretty_printer$Pretty$string(', '),
				A2($elm$core$List$map, $the_sett$elm_pretty_printer$Pretty$string, tags))
			]));
};
var $author$project$Internal$Comments$prettyCommentPart = function (part) {
	switch (part.$) {
		case 'Markdown':
			var val = part.a;
			return $author$project$Internal$Comments$prettyMarkdown(val);
		case 'Code':
			var val = part.a;
			return $author$project$Internal$Comments$prettyCode(val);
		default:
			var tags = part.a;
			return $author$project$Internal$Comments$prettyTags(tags);
	}
};
var $author$project$Internal$Comments$prettyFileComment = F2(
	function (width, comment) {
		var _v0 = A2(
			$author$project$Internal$Comments$layoutTags,
			width,
			$author$project$Internal$Comments$getParts(comment));
		var parts = _v0.a;
		var splits = _v0.b;
		return _Utils_Tuple2(
			A2(
				$the_sett$elm_pretty_printer$Pretty$pretty,
				width,
				$author$project$Internal$Comments$delimeters(
					$the_sett$elm_pretty_printer$Pretty$lines(
						A2($elm$core$List$map, $author$project$Internal$Comments$prettyCommentPart, parts)))),
			splits);
	});
var $author$project$Internal$Write$prettyDefaultModuleData = function (moduleData) {
	return $the_sett$elm_pretty_printer$Pretty$words(
		_List_fromArray(
			[
				$the_sett$elm_pretty_printer$Pretty$string('module'),
				$author$project$Internal$Write$prettyModuleName(
				$author$project$Internal$Compiler$denode(moduleData.moduleName)),
				$author$project$Internal$Write$prettyExposing(
				$author$project$Internal$Compiler$denode(moduleData.exposingList))
			]));
};
var $author$project$Internal$Write$prettyEffectModuleData = function (moduleData) {
	var prettyCmdAndSub = F2(
		function (maybeCmd, maybeSub) {
			var _v0 = _Utils_Tuple2(maybeCmd, maybeSub);
			if (_v0.a.$ === 'Just') {
				if (_v0.b.$ === 'Just') {
					var cmdName = _v0.a.a;
					var subName = _v0.b.a;
					return $elm$core$Maybe$Just(
						$the_sett$elm_pretty_printer$Pretty$words(
							_List_fromArray(
								[
									$the_sett$elm_pretty_printer$Pretty$string('where { command ='),
									$the_sett$elm_pretty_printer$Pretty$string(cmdName),
									$the_sett$elm_pretty_printer$Pretty$string(','),
									$the_sett$elm_pretty_printer$Pretty$string('subscription ='),
									$the_sett$elm_pretty_printer$Pretty$string(subName),
									$the_sett$elm_pretty_printer$Pretty$string('}')
								])));
				} else {
					var cmdName = _v0.a.a;
					var _v3 = _v0.b;
					return $elm$core$Maybe$Just(
						$the_sett$elm_pretty_printer$Pretty$words(
							_List_fromArray(
								[
									$the_sett$elm_pretty_printer$Pretty$string('where { command ='),
									$the_sett$elm_pretty_printer$Pretty$string(cmdName),
									$the_sett$elm_pretty_printer$Pretty$string('}')
								])));
				}
			} else {
				if (_v0.b.$ === 'Nothing') {
					var _v1 = _v0.a;
					var _v2 = _v0.b;
					return $elm$core$Maybe$Nothing;
				} else {
					var _v4 = _v0.a;
					var subName = _v0.b.a;
					return $elm$core$Maybe$Just(
						$the_sett$elm_pretty_printer$Pretty$words(
							_List_fromArray(
								[
									$the_sett$elm_pretty_printer$Pretty$string('where { subscription ='),
									$the_sett$elm_pretty_printer$Pretty$string(subName),
									$the_sett$elm_pretty_printer$Pretty$string('}')
								])));
				}
			}
		});
	return $the_sett$elm_pretty_printer$Pretty$words(
		_List_fromArray(
			[
				$the_sett$elm_pretty_printer$Pretty$string('effect module'),
				$author$project$Internal$Write$prettyModuleName(
				$author$project$Internal$Compiler$denode(moduleData.moduleName)),
				A2(
				$author$project$Internal$Write$prettyMaybe,
				$elm$core$Basics$identity,
				A2(
					prettyCmdAndSub,
					$author$project$Internal$Compiler$denodeMaybe(moduleData.command),
					$author$project$Internal$Compiler$denodeMaybe(moduleData.subscription))),
				$author$project$Internal$Write$prettyExposing(
				$author$project$Internal$Compiler$denode(moduleData.exposingList))
			]));
};
var $author$project$Internal$Write$prettyPortModuleData = function (moduleData) {
	return $the_sett$elm_pretty_printer$Pretty$words(
		_List_fromArray(
			[
				$the_sett$elm_pretty_printer$Pretty$string('port module'),
				$author$project$Internal$Write$prettyModuleName(
				$author$project$Internal$Compiler$denode(moduleData.moduleName)),
				$author$project$Internal$Write$prettyExposing(
				$author$project$Internal$Compiler$denode(moduleData.exposingList))
			]));
};
var $author$project$Internal$Write$prettyModule = function (mod) {
	switch (mod.$) {
		case 'NormalModule':
			var defaultModuleData = mod.a;
			return $author$project$Internal$Write$prettyDefaultModuleData(defaultModuleData);
		case 'PortModule':
			var defaultModuleData = mod.a;
			return $author$project$Internal$Write$prettyPortModuleData(defaultModuleData);
		default:
			var effectModuleData = mod.a;
			return $author$project$Internal$Write$prettyEffectModuleData(effectModuleData);
	}
};
var $author$project$Internal$Write$prepareLayout = F2(
	function (width, file) {
		return A2(
			$the_sett$elm_pretty_printer$Pretty$a,
			A2($author$project$Internal$Write$prettyDeclarations, file.aliases, file.declarations),
			A2(
				$the_sett$elm_pretty_printer$Pretty$a,
				$author$project$Internal$Write$importsPretty(file.imports),
				function (doc) {
					var _v0 = file.comments;
					if (_v0.$ === 'Nothing') {
						return doc;
					} else {
						var fileComment = _v0.a;
						var _v1 = A2($author$project$Internal$Comments$prettyFileComment, width, fileComment);
						var fileCommentStr = _v1.a;
						var innerTags = _v1.b;
						return A2(
							$the_sett$elm_pretty_printer$Pretty$a,
							$the_sett$elm_pretty_printer$Pretty$line,
							A2(
								$the_sett$elm_pretty_printer$Pretty$a,
								$author$project$Internal$Write$prettyComments(
									_List_fromArray(
										[fileCommentStr])),
								doc));
					}
				}(
					A2(
						$the_sett$elm_pretty_printer$Pretty$a,
						$the_sett$elm_pretty_printer$Pretty$line,
						A2(
							$the_sett$elm_pretty_printer$Pretty$a,
							$the_sett$elm_pretty_printer$Pretty$line,
							$author$project$Internal$Write$prettyModule(file.moduleDefinition))))));
	});
var $author$project$Internal$Write$pretty = F2(
	function (width, file) {
		return A2(
			$the_sett$elm_pretty_printer$Pretty$pretty,
			width,
			A2($author$project$Internal$Write$prepareLayout, width, file));
	});
var $author$project$Internal$Write$write = $author$project$Internal$Write$pretty(80);
var $author$project$Elm$render = F2(
	function (toDocComment, fileDetails) {
		var mod = fileDetails.moduleDefinition;
		var exposedGroups = $author$project$Internal$Compiler$getExposedGroups(fileDetails.body);
		var exposed = $author$project$Internal$Compiler$getExposed(fileDetails.body);
		var body = $author$project$Internal$Write$write(
			{
				aliases: fileDetails.aliases,
				comments: $elm$core$Maybe$Just(
					A2(
						$author$project$Internal$Comments$addPart,
						$author$project$Internal$Comments$emptyComment,
						$author$project$Internal$Comments$Markdown(
							toDocComment(exposedGroups)))),
				declarations: fileDetails.body,
				imports: A2(
					$elm$core$List$filterMap,
					$author$project$Internal$Compiler$makeImport(fileDetails.aliases),
					fileDetails.imports),
				moduleDefinition: ($author$project$Internal$Compiler$hasPorts(fileDetails.body) ? $stil4m$elm_syntax$Elm$Syntax$Module$PortModule : $stil4m$elm_syntax$Elm$Syntax$Module$NormalModule)(
					{
						exposingList: function () {
							if (!exposed.b) {
								return $author$project$Internal$Compiler$nodify(
									$stil4m$elm_syntax$Elm$Syntax$Exposing$All($stil4m$elm_syntax$Elm$Syntax$Range$emptyRange));
							} else {
								return $author$project$Internal$Compiler$nodify(
									$stil4m$elm_syntax$Elm$Syntax$Exposing$Explicit(
										$author$project$Internal$Compiler$nodifyAll(exposed)));
							}
						}(),
						moduleName: $author$project$Internal$Compiler$nodify(mod)
					})
			});
		return {
			contents: body,
			path: A2($elm$core$String$join, '/', mod) + '.elm'
		};
	});
var $elm$core$List$isEmpty = function (xs) {
	if (!xs.b) {
		return true;
	} else {
		return false;
	}
};
var $author$project$Elm$renderStandardComment = function (groups) {
	return $elm$core$List$isEmpty(groups) ? '' : A3(
		$elm$core$List$foldl,
		F2(
			function (grouped, str) {
				return str + ('@docs ' + (A2($elm$core$String$join, ', ', grouped.members) + '\n\n'));
			}),
		'\n\n',
		groups);
};
var $elm$core$Tuple$second = function (_v0) {
	var y = _v0.b;
	return y;
};
var $author$project$Elm$file = F2(
	function (mod, decs) {
		return A2(
			$author$project$Elm$render,
			$author$project$Elm$renderStandardComment,
			{
				aliases: _List_Nil,
				body: decs,
				imports: A3(
					$author$project$Elm$reduceDeclarationImports,
					mod,
					decs,
					_Utils_Tuple2($elm$core$Set$empty, _List_Nil)).b,
				moduleComment: '',
				moduleDefinition: mod
			});
	});
var $stil4m$elm_syntax$Elm$Syntax$Pattern$VarPattern = function (a) {
	return {$: 'VarPattern', a: a};
};
var $author$project$Internal$Compiler$noImports = function (tipe) {
	return $author$project$Internal$Compiler$Annotation(
		{annotation: tipe, imports: _List_Nil});
};
var $author$project$Elm$fn = F3(
	function (name, _v0, toBody) {
		var oneName = _v0.a;
		var oneType = _v0.b;
		var arg1 = A3($author$project$Elm$valueWith, _List_Nil, oneName, oneType);
		var _v1 = toBody(arg1);
		var body = _v1.a;
		return A3(
			$author$project$Internal$Compiler$Declaration,
			$author$project$Internal$Compiler$NotExposed,
			_Utils_ap(
				$author$project$Internal$Compiler$getAnnotationImports(oneType),
				body.imports),
			$stil4m$elm_syntax$Elm$Syntax$Declaration$FunctionDeclaration(
				{
					declaration: $author$project$Internal$Compiler$nodify(
						{
							_arguments: _List_fromArray(
								[
									$author$project$Internal$Compiler$nodify(
									$stil4m$elm_syntax$Elm$Syntax$Pattern$VarPattern(oneName))
								]),
							expression: $author$project$Internal$Compiler$nodify(body.expression),
							name: $author$project$Internal$Compiler$nodify(
								$author$project$Internal$Compiler$formatValue(name))
						}),
					documentation: $author$project$Internal$Compiler$nodifyMaybe($elm$core$Maybe$Nothing),
					signature: function () {
						var _v2 = body.annotation;
						if (_v2.$ === 'Ok') {
							var _return = _v2.a;
							return $elm$core$Maybe$Just(
								$author$project$Internal$Compiler$nodify(
									{
										name: $author$project$Internal$Compiler$nodify(
											$author$project$Internal$Compiler$formatValue(name)),
										typeAnnotation: $author$project$Internal$Compiler$nodify(
											$author$project$Internal$Compiler$getInnerAnnotation(
												A2(
													$author$project$Elm$Annotation$function,
													_List_fromArray(
														[oneType]),
													$author$project$Internal$Compiler$noImports(_return))))
									}));
						} else {
							return $elm$core$Maybe$Nothing;
						}
					}()
				}));
	});
var $stil4m$elm_syntax$Elm$Syntax$Expression$LambdaExpression = function (a) {
	return {$: 'LambdaExpression', a: a};
};
var $author$project$Elm$lambda = F3(
	function (argBaseName, argType, toExpression) {
		var arg1 = A3($author$project$Elm$valueWith, _List_Nil, argBaseName, argType);
		var _v0 = toExpression(arg1);
		var expr = _v0.a;
		return $author$project$Internal$Compiler$Expression(
			{
				annotation: function () {
					var _v1 = expr.annotation;
					if (_v1.$ === 'Err') {
						var err = _v1.a;
						return $elm$core$Result$Err(err);
					} else {
						var _return = _v1.a;
						return $elm$core$Result$Ok(
							A3(
								$elm$core$List$foldr,
								F2(
									function (ann, fnbody) {
										return A2(
											$stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$FunctionTypeAnnotation,
											$author$project$Internal$Compiler$nodify(ann),
											$author$project$Internal$Compiler$nodify(fnbody));
									}),
								_return,
								_List_fromArray(
									[
										$author$project$Internal$Compiler$getInnerAnnotation(argType)
									])));
					}
				}(),
				expression: $stil4m$elm_syntax$Elm$Syntax$Expression$LambdaExpression(
					{
						args: _List_fromArray(
							[
								$author$project$Internal$Compiler$nodify(
								$stil4m$elm_syntax$Elm$Syntax$Pattern$VarPattern(argBaseName))
							]),
						expression: $author$project$Internal$Compiler$nodify(expr.expression)
					}),
				imports: expr.imports,
				skip: false
			});
	});
var $stil4m$elm_syntax$Elm$Syntax$Expression$ListExpr = function (a) {
	return {$: 'ListExpr', a: a};
};
var $elm$core$Result$map = F2(
	function (func, ra) {
		if (ra.$ === 'Ok') {
			var a = ra.a;
			return $elm$core$Result$Ok(
				func(a));
		} else {
			var e = ra.a;
			return $elm$core$Result$Err(e);
		}
	});
var $author$project$Elm$toList = function (_v0) {
	var exp = _v0.a;
	return $author$project$Internal$Compiler$nodify(exp.expression);
};
var $author$project$Internal$Compiler$MismatchedList = F2(
	function (a, b) {
		return {$: 'MismatchedList', a: a, b: b};
	});
var $author$project$Internal$Compiler$unifyHelper = F2(
	function (exps, existing) {
		unifyHelper:
		while (true) {
			if (!exps.b) {
				return $elm$core$Result$Ok(existing);
			} else {
				var top = exps.a.a;
				var remain = exps.b;
				var _v1 = top.annotation;
				if (_v1.$ === 'Ok') {
					var ann = _v1.a;
					var _v2 = A2($author$project$Internal$Compiler$unifiable, ann, existing);
					if (_v2.$ === 'Err') {
						return $elm$core$Result$Err(
							_List_fromArray(
								[
									A2($author$project$Internal$Compiler$MismatchedList, ann, existing)
								]));
					} else {
						var _new = _v2.a;
						var $temp$exps = remain,
							$temp$existing = _new;
						exps = $temp$exps;
						existing = $temp$existing;
						continue unifyHelper;
					}
				} else {
					var err = _v1.a;
					return $elm$core$Result$Err(err);
				}
			}
		}
	});
var $author$project$Internal$Compiler$unify = function (exps) {
	if (!exps.b) {
		return $elm$core$Result$Ok(
			$stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$GenericType('a'));
	} else {
		var top = exps.a.a;
		var remain = exps.b;
		var _v1 = top.annotation;
		if (_v1.$ === 'Ok') {
			var ann = _v1.a;
			return A2($author$project$Internal$Compiler$unifyHelper, remain, ann);
		} else {
			var err = _v1.a;
			return $elm$core$Result$Err(err);
		}
	}
};
var $author$project$Elm$list = function (exprs) {
	return $author$project$Internal$Compiler$Expression(
		{
			annotation: A2(
				$elm$core$Result$map,
				function (inner) {
					return A2(
						$stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Typed,
						$author$project$Internal$Compiler$nodify(
							_Utils_Tuple2(_List_Nil, 'List')),
						_List_fromArray(
							[
								$author$project$Internal$Compiler$nodify(inner)
							]));
				},
				$author$project$Internal$Compiler$unify(exprs)),
			expression: $stil4m$elm_syntax$Elm$Syntax$Expression$ListExpr(
				A2($elm$core$List$map, $author$project$Elm$toList, exprs)),
			imports: A2($elm$core$List$concatMap, $author$project$Elm$getImports, exprs),
			skip: false
		});
};
var $author$project$Generate$Common$modules = {
	_enum: F2(
		function (namespace, enumName) {
			return _List_fromArray(
				[
					namespace,
					'Enum',
					$author$project$Utils$String$formatTypename(enumName)
				]);
		}),
	input: F2(
		function (namespace, name) {
			return _List_fromArray(
				[
					namespace,
					$author$project$Utils$String$formatTypename(name)
				]);
		}),
	mutation: F2(
		function (namespace, mutationName) {
			return _List_fromArray(
				[
					namespace,
					'Mutations',
					$author$project$Utils$String$formatTypename(mutationName)
				]);
		}),
	query: F2(
		function (namespace, queryName) {
			return _List_fromArray(
				[
					namespace,
					'Queries',
					$author$project$Utils$String$formatTypename(queryName)
				]);
		})
};
var $author$project$Elm$Annotation$named = F2(
	function (mod, name) {
		return $author$project$Internal$Compiler$Annotation(
			{
				annotation: A2(
					$stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Typed,
					$author$project$Internal$Compiler$nodify(
						_Utils_Tuple2(
							mod,
							$author$project$Internal$Compiler$formatType(name))),
					_List_Nil),
				imports: _List_fromArray(
					[mod])
			});
	});
var $stil4m$elm_syntax$Elm$Syntax$Pattern$NamedPattern = F2(
	function (a, b) {
		return {$: 'NamedPattern', a: a, b: b};
	});
var $author$project$Elm$Pattern$parens = function (pattern) {
	return $stil4m$elm_syntax$Elm$Syntax$Pattern$ParenthesizedPattern(
		$author$project$Internal$Compiler$nodify(pattern));
};
var $author$project$Elm$Pattern$parensIf = F2(
	function (on, pattern) {
		return on ? $author$project$Elm$Pattern$parens(pattern) : pattern;
	});
var $author$project$Elm$Pattern$named = F2(
	function (name, patterns) {
		return A2(
			$author$project$Elm$Pattern$parensIf,
			!$elm$core$List$isEmpty(patterns),
			A2(
				$stil4m$elm_syntax$Elm$Syntax$Pattern$NamedPattern,
				{moduleName: _List_Nil, name: name},
				$author$project$Internal$Compiler$nodifyAll(patterns)));
	});
var $stil4m$elm_syntax$Elm$Syntax$Expression$Literal = function (a) {
	return {$: 'Literal', a: a};
};
var $author$project$Elm$string = function (literal) {
	return $author$project$Internal$Compiler$Expression(
		{
			annotation: $elm$core$Result$Ok(
				$author$project$Internal$Compiler$getInnerAnnotation($author$project$Elm$Annotation$string)),
			expression: $stil4m$elm_syntax$Elm$Syntax$Expression$Literal(literal),
			imports: _List_Nil,
			skip: false
		});
};
var $author$project$Elm$Gen$Json$Decode$string = A3(
	$author$project$Elm$valueWith,
	$author$project$Elm$Gen$Json$Decode$moduleName_,
	'string',
	A3(
		$author$project$Elm$Annotation$namedWith,
		_List_fromArray(
			['Json', 'Decode']),
		'Decoder',
		_List_fromArray(
			[$author$project$Elm$Annotation$string])));
var $author$project$Elm$Gen$Json$Encode$moduleName_ = _List_fromArray(
	['Json', 'Encode']);
var $author$project$Elm$Gen$Json$Encode$string = function (arg1) {
	return A2(
		$author$project$Elm$apply,
		A3(
			$author$project$Elm$valueWith,
			$author$project$Elm$Gen$Json$Encode$moduleName_,
			'string',
			A2(
				$author$project$Elm$Annotation$function,
				_List_fromArray(
					[$author$project$Elm$Annotation$string]),
				A3(
					$author$project$Elm$Annotation$namedWith,
					_List_fromArray(
						['Json', 'Encode']),
					'Value',
					_List_Nil))),
		_List_fromArray(
			[arg1]));
};
var $stil4m$elm_syntax$Elm$Syntax$Pattern$StringPattern = function (a) {
	return {$: 'StringPattern', a: a};
};
var $author$project$Elm$Pattern$string = function (literal) {
	return $stil4m$elm_syntax$Elm$Syntax$Pattern$StringPattern(literal);
};
var $author$project$Elm$Gen$Json$Decode$succeed = function (arg1) {
	return A2(
		$author$project$Elm$apply,
		A3(
			$author$project$Elm$valueWith,
			$author$project$Elm$Gen$Json$Decode$moduleName_,
			'succeed',
			A2(
				$author$project$Elm$Annotation$function,
				_List_fromArray(
					[
						$author$project$Elm$Annotation$var('a')
					]),
				A3(
					$author$project$Elm$Annotation$namedWith,
					_List_fromArray(
						['Json', 'Decode']),
					'Decoder',
					_List_fromArray(
						[
							$author$project$Elm$Annotation$var('a')
						])))),
		_List_fromArray(
			[arg1]));
};
var $author$project$Elm$Gen$Json$Decode$types_ = {
	decoder: function (arg0) {
		return A3(
			$author$project$Elm$Annotation$namedWith,
			$author$project$Elm$Gen$Json$Decode$moduleName_,
			'Decoder',
			_List_fromArray(
				[arg0]));
	},
	error: A2($author$project$Elm$Annotation$named, $author$project$Elm$Gen$Json$Decode$moduleName_, 'Error'),
	value: A2($author$project$Elm$Annotation$named, $author$project$Elm$Gen$Json$Decode$moduleName_, 'Value')
};
var $author$project$Elm$Variant = F2(
	function (a, b) {
		return {$: 'Variant', a: a, b: b};
	});
var $author$project$Elm$variantWith = $author$project$Elm$Variant;
var $stil4m$elm_syntax$Elm$Syntax$Pattern$AllPattern = {$: 'AllPattern'};
var $author$project$Elm$Pattern$wildcard = $stil4m$elm_syntax$Elm$Syntax$Pattern$AllPattern;
var $author$project$Elm$withType = F2(
	function (ann, _v0) {
		var exp = _v0.a;
		return $author$project$Internal$Compiler$Expression(
			_Utils_update(
				exp,
				{
					annotation: $elm$core$Result$Ok(
						$author$project$Internal$Compiler$getInnerAnnotation(ann)),
					imports: _Utils_ap(
						exp.imports,
						$author$project$Internal$Compiler$getAnnotationImports(ann))
				}));
	});
var $author$project$Generate$Enums$generateFiles = F2(
	function (namespace, graphQLSchema) {
		return A2(
			$elm$core$List$map,
			function (_v0) {
				var enumDefinition = _v0.b;
				var enumEncoder = A3(
					$author$project$Elm$fn,
					'encode',
					_Utils_Tuple2(
						'val',
						A2($author$project$Elm$Annotation$named, _List_Nil, enumDefinition.name)),
					function (val) {
						return A2(
							$author$project$Elm$caseOf,
							val,
							A2(
								$elm$core$List$map,
								function (variant) {
									return _Utils_Tuple2(
										A2(
											$author$project$Elm$Pattern$named,
											$author$project$Generate$Enums$enumNameToConstructorName(variant.name),
											_List_Nil),
										$author$project$Elm$Gen$Json$Encode$string(
											$author$project$Elm$string(variant.name)));
								},
								enumDefinition.values));
					});
				var constructors = A2(
					$elm$core$List$map,
					function (name) {
						return _Utils_Tuple2(
							$author$project$Generate$Enums$enumNameToConstructorName(name),
							_List_Nil);
					},
					A2(
						$elm$core$List$map,
						function ($) {
							return $.name;
						},
						enumDefinition.values));
				var enumDecoder = A2(
					$author$project$Elm$declaration,
					'decoder',
					A2(
						$author$project$Elm$withType,
						$author$project$Elm$Gen$Json$Decode$types_.decoder(
							A2($author$project$Elm$Annotation$named, _List_Nil, enumDefinition.name)),
						A2(
							$author$project$Elm$Gen$Json$Decode$andThen,
							function (_v3) {
								return A3(
									$author$project$Elm$lambda,
									'string',
									$author$project$Elm$Annotation$string,
									function (str) {
										return A2(
											$author$project$Elm$caseOf,
											str,
											_Utils_ap(
												A2(
													$elm$core$List$map,
													function (_v4) {
														var name = _v4.a;
														return _Utils_Tuple2(
															$author$project$Elm$Pattern$string(name),
															$author$project$Elm$Gen$Json$Decode$succeed(
																A3(
																	$author$project$Elm$valueWith,
																	_List_Nil,
																	name,
																	A2($author$project$Elm$Annotation$named, _List_Nil, enumDefinition.name))));
													},
													constructors),
												_List_fromArray(
													[
														_Utils_Tuple2(
														$author$project$Elm$Pattern$wildcard,
														$author$project$Elm$Gen$Json$Decode$fail(
															$author$project$Elm$string('Invalid type')))
													])));
									});
							},
							$author$project$Elm$Gen$Json$Decode$string)));
				var enumTypeDeclaration = A2(
					$author$project$Elm$customType,
					enumDefinition.name,
					A2(
						$elm$core$List$map,
						function (_v2) {
							var name = _v2.a;
							var vals = _v2.b;
							return A2($author$project$Elm$variantWith, name, vals);
						},
						constructors));
				var listOfValues = A2(
					$author$project$Elm$declaration,
					'list',
					$author$project$Elm$list(
						A2(
							$elm$core$List$map,
							function (_v1) {
								var enumName = _v1.a;
								return A3(
									$author$project$Elm$valueWith,
									_List_Nil,
									enumName,
									A2($author$project$Elm$Annotation$named, _List_Nil, enumDefinition.name));
							},
							constructors)));
				return A2(
					$author$project$Elm$file,
					A2($author$project$Generate$Common$modules._enum, namespace, enumDefinition.name),
					_List_fromArray(
						[
							$author$project$Elm$exposeConstructor(enumTypeDeclaration),
							$author$project$Elm$expose(listOfValues),
							$author$project$Elm$expose(enumDecoder),
							$author$project$Elm$expose(enumEncoder)
						]));
			},
			$elm$core$Dict$toList(graphQLSchema.enums));
	});
var $stil4m$elm_syntax$Elm$Syntax$Declaration$AliasDeclaration = function (a) {
	return {$: 'AliasDeclaration', a: a};
};
var $author$project$Elm$alias = F2(
	function (name, innerAnnotation) {
		return A3(
			$author$project$Internal$Compiler$Declaration,
			$author$project$Internal$Compiler$NotExposed,
			$author$project$Internal$Compiler$getAnnotationImports(innerAnnotation),
			$stil4m$elm_syntax$Elm$Syntax$Declaration$AliasDeclaration(
				{
					documentation: $elm$core$Maybe$Nothing,
					generics: $author$project$Internal$Compiler$getGenerics(innerAnnotation),
					name: $author$project$Internal$Compiler$nodify(
						$author$project$Internal$Compiler$formatType(name)),
					typeAnnotation: $author$project$Internal$Compiler$nodify(
						$author$project$Internal$Compiler$getInnerAnnotation(innerAnnotation))
				}));
	});
var $author$project$Generate$Common$ref = F2(
	function (namespace, name) {
		return A2(
			$author$project$Elm$Annotation$named,
			_List_fromArray(
				[namespace]),
			name);
	});
var $author$project$Elm$Gen$GraphQL$Engine$moduleName_ = _List_fromArray(
	['GraphQL', 'Engine']);
var $author$project$Elm$Gen$GraphQL$Engine$types_ = {
	argument: function (arg0) {
		return A3(
			$author$project$Elm$Annotation$namedWith,
			$author$project$Elm$Gen$GraphQL$Engine$moduleName_,
			'Argument',
			_List_fromArray(
				[arg0]));
	},
	error: A2($author$project$Elm$Annotation$named, $author$project$Elm$Gen$GraphQL$Engine$moduleName_, 'Error'),
	mutation: A2($author$project$Elm$Annotation$named, $author$project$Elm$Gen$GraphQL$Engine$moduleName_, 'Mutation'),
	optional: function (arg0) {
		return A3(
			$author$project$Elm$Annotation$namedWith,
			$author$project$Elm$Gen$GraphQL$Engine$moduleName_,
			'Optional',
			_List_fromArray(
				[arg0]));
	},
	query: A2($author$project$Elm$Annotation$named, $author$project$Elm$Gen$GraphQL$Engine$moduleName_, 'Query'),
	selection: F2(
		function (arg0, arg1) {
			return A3(
				$author$project$Elm$Annotation$namedWith,
				$author$project$Elm$Gen$GraphQL$Engine$moduleName_,
				'Selection',
				_List_fromArray(
					[arg0, arg1]));
		})
};
var $author$project$Generate$Args$annotations = {
	arg: F2(
		function (namespace, name) {
			return A2($author$project$Generate$Common$ref, namespace, name);
		}),
	ergonomicOptional: F2(
		function (namespace, name) {
			return A2(
				$author$project$Elm$Annotation$named,
				_List_fromArray(
					[namespace, name]),
				'Optional');
		}),
	localOptional: F2(
		function (namespace, name) {
			return $author$project$Elm$Gen$GraphQL$Engine$types_.optional(
				A3($author$project$Elm$Annotation$namedWith, _List_Nil, 'Optional', _List_Nil));
		}),
	optional: F2(
		function (namespace, name) {
			return A3(
				$author$project$Elm$Annotation$namedWith,
				A2($author$project$Generate$Common$modules.input, namespace, name),
				'Optional',
				_List_Nil);
		}),
	safeOptional: F2(
		function (namespace, name) {
			return $author$project$Elm$Gen$GraphQL$Engine$types_.optional(
				A2(
					$author$project$Elm$Annotation$named,
					_List_fromArray(
						[namespace]),
					name));
		})
};
var $author$project$Elm$Gen$GraphQL$Engine$arg = F2(
	function (arg1, arg2) {
		return A2(
			$author$project$Elm$apply,
			A3(
				$author$project$Elm$valueWith,
				$author$project$Elm$Gen$GraphQL$Engine$moduleName_,
				'arg',
				A2(
					$author$project$Elm$Annotation$function,
					_List_fromArray(
						[
							A3(
							$author$project$Elm$Annotation$namedWith,
							_List_fromArray(
								['Json', 'Encode']),
							'Value',
							_List_Nil),
							$author$project$Elm$Annotation$string
						]),
					A3(
						$author$project$Elm$Annotation$namedWith,
						_List_fromArray(
							['GraphQL', 'Engine']),
						'Argument',
						_List_fromArray(
							[
								$author$project$Elm$Annotation$var('obj')
							])))),
			_List_fromArray(
				[arg1, arg2]));
	});
var $author$project$Elm$Field = F2(
	function (a, b) {
		return {$: 'Field', a: a, b: b};
	});
var $author$project$Elm$field = $author$project$Elm$Field;
var $author$project$Utils$String$elmify = F2(
	function (_char, _v0) {
		var passedLower = _v0.a;
		var gathered = _v0.b;
		return ($elm$core$Char$isUpper(_char) && passedLower) ? _Utils_Tuple2(
			$elm$core$Char$isLower(_char),
			_Utils_ap(
				gathered,
				$elm$core$String$fromChar(_char))) : _Utils_Tuple2(
			$elm$core$Char$isLower(_char),
			_Utils_ap(
				gathered,
				$elm$core$String$toLower(
					$elm$core$String$fromChar(_char))));
	});
var $elm$core$String$foldl = _String_foldl;
var $author$project$Utils$String$sanitize = function (name) {
	switch (name) {
		case 'in':
			return 'in_';
		case 'type':
			return 'type_';
		case 'case':
			return 'case_';
		case 'let':
			return 'let_';
		case 'module':
			return 'module_';
		case 'exposing':
			return 'exposing_';
		default:
			return name;
	}
};
var $author$project$Utils$String$formatValue = function (name) {
	var remaining = A2($elm$core$String$dropLeft, 1, name);
	var first = A2($elm$core$String$left, 1, name);
	var body = A3(
		$elm$core$String$foldl,
		$author$project$Utils$String$elmify,
		_Utils_Tuple2(false, ''),
		remaining).b;
	return $author$project$Utils$String$sanitize(
		_Utils_ap(
			$elm$core$String$toLower(first),
			body));
};
var $author$project$Generate$Args$inputTypeToString = function (type_) {
	inputTypeToString:
	while (true) {
		switch (type_.$) {
			case 'Nullable':
				var newType = type_.a;
				var $temp$type_ = newType;
				type_ = $temp$type_;
				continue inputTypeToString;
			case 'List_':
				var newType = type_.a;
				return '[' + ($author$project$Generate$Args$inputTypeToString(newType) + ']');
			case 'Scalar':
				var scalarName = type_.a;
				return scalarName;
			case 'Enum':
				var enumName = type_.a;
				return enumName;
			case 'InputObject':
				var inputName = type_.a;
				return inputName;
			case 'Union':
				var unionName = type_.a;
				return 'Unions cant be nested in inputs';
			case 'Object':
				var nestedObjectName = type_.a;
				return 'Objects cant be nested in inputs';
			default:
				var interfaceName = type_.a;
				return 'Interfaces cant be in inputs';
		}
	}
};
var $author$project$Elm$Gen$Json$Encode$null = A3(
	$author$project$Elm$valueWith,
	$author$project$Elm$Gen$Json$Encode$moduleName_,
	'null',
	A3(
		$author$project$Elm$Annotation$namedWith,
		_List_fromArray(
			['Json', 'Encode']),
		'Value',
		_List_Nil));
var $author$project$Elm$Gen$GraphQL$Engine$optional = F2(
	function (arg1, arg2) {
		return A2(
			$author$project$Elm$apply,
			A3(
				$author$project$Elm$valueWith,
				$author$project$Elm$Gen$GraphQL$Engine$moduleName_,
				'optional',
				A2(
					$author$project$Elm$Annotation$function,
					_List_fromArray(
						[
							$author$project$Elm$Annotation$string,
							A3(
							$author$project$Elm$Annotation$namedWith,
							_List_fromArray(
								['GraphQL', 'Engine']),
							'Argument',
							_List_fromArray(
								[
									$author$project$Elm$Annotation$var('arg')
								]))
						]),
					A3(
						$author$project$Elm$Annotation$namedWith,
						_List_fromArray(
							['GraphQL', 'Engine']),
						'Optional',
						_List_fromArray(
							[
								$author$project$Elm$Annotation$var('arg')
							])))),
			_List_fromArray(
				[arg1, arg2]));
	});
var $author$project$Internal$Compiler$DuplicateFieldInRecord = function (a) {
	return {$: 'DuplicateFieldInRecord', a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$RecordExpr = function (a) {
	return {$: 'RecordExpr', a: a};
};
var $author$project$Internal$Compiler$SomeOtherIssue = {$: 'SomeOtherIssue'};
var $author$project$Elm$record = function (fields) {
	var unified = A3(
		$elm$core$List$foldl,
		F2(
			function (_v2, found) {
				var unformattedFieldName = _v2.a;
				var exp = _v2.b.a;
				var fieldName = $author$project$Internal$Compiler$formatValue(unformattedFieldName);
				return {
					errors: function () {
						if (A2($elm$core$Set$member, fieldName, found.passed)) {
							return A2(
								$elm$core$List$cons,
								$author$project$Internal$Compiler$DuplicateFieldInRecord(fieldName),
								found.errors);
						} else {
							var _v3 = exp.annotation;
							if (_v3.$ === 'Err') {
								if (!_v3.a.b) {
									return A2($elm$core$List$cons, $author$project$Internal$Compiler$SomeOtherIssue, found.errors);
								} else {
									var errs = _v3.a;
									return _Utils_ap(errs, found.errors);
								}
							} else {
								var ann = _v3.a;
								return found.errors;
							}
						}
					}(),
					fieldAnnotations: function () {
						var _v4 = exp.annotation;
						if (_v4.$ === 'Err') {
							var err = _v4.a;
							return found.fieldAnnotations;
						} else {
							var ann = _v4.a;
							return A2(
								$elm$core$List$cons,
								_Utils_Tuple2(
									$author$project$Internal$Compiler$formatValue(fieldName),
									ann),
								found.fieldAnnotations);
						}
					}(),
					fields: A2(
						$elm$core$List$cons,
						_Utils_Tuple2(
							$author$project$Internal$Compiler$nodify(fieldName),
							$author$project$Internal$Compiler$nodify(exp.expression)),
						found.fields),
					imports: _Utils_ap(exp.imports, found.imports),
					passed: A2($elm$core$Set$insert, fieldName, found.passed)
				};
			}),
		{errors: _List_Nil, fieldAnnotations: _List_Nil, fields: _List_Nil, imports: _List_Nil, passed: $elm$core$Set$empty},
		fields);
	return $author$project$Internal$Compiler$Expression(
		{
			annotation: function () {
				var _v0 = unified.errors;
				if (!_v0.b) {
					return $elm$core$Result$Ok(
						$stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Record(
							$author$project$Internal$Compiler$nodifyAll(
								A2(
									$elm$core$List$map,
									function (_v1) {
										var name = _v1.a;
										var ann = _v1.b;
										return _Utils_Tuple2(
											$author$project$Internal$Compiler$nodify(name),
											$author$project$Internal$Compiler$nodify(ann));
									},
									$elm$core$List$reverse(unified.fieldAnnotations)))));
				} else {
					var errs = _v0;
					return $elm$core$Result$Err(errs);
				}
			}(),
			expression: $stil4m$elm_syntax$Elm$Syntax$Expression$RecordExpr(
				$author$project$Internal$Compiler$nodifyAll(
					$elm$core$List$reverse(unified.fields))),
			imports: unified.imports,
			skip: false
		});
};
var $author$project$Generate$Args$nullsRecord = F3(
	function (namespace, name, fields) {
		return $author$project$Elm$record(
			A2(
				$elm$core$List$map,
				function (field) {
					return A2(
						$author$project$Elm$field,
						$author$project$Utils$String$formatValue(field.name),
						A2(
							$author$project$Elm$withType,
							A2($author$project$Generate$Args$annotations.localOptional, namespace, name),
							A2(
								$author$project$Elm$Gen$GraphQL$Engine$optional,
								$author$project$Elm$string(field.name),
								A2(
									$author$project$Elm$Gen$GraphQL$Engine$arg,
									$author$project$Elm$Gen$Json$Encode$null,
									$author$project$Elm$string(
										$author$project$Generate$Args$inputTypeToString(field.type_))))));
				},
				fields));
	});
var $author$project$Generate$Input$InList = function (a) {
	return {$: 'InList', a: a};
};
var $author$project$Generate$Input$InMaybe = function (a) {
	return {$: 'InMaybe', a: a};
};
var $author$project$Generate$Input$UnwrappedValue = {$: 'UnwrappedValue'};
var $author$project$Generate$Input$getWrap = function (type_) {
	switch (type_.$) {
		case 'Nullable':
			var newType = type_.a;
			return $author$project$Generate$Input$InMaybe(
				$author$project$Generate$Input$getWrap(newType));
		case 'List_':
			var newType = type_.a;
			return $author$project$Generate$Input$InList(
				$author$project$Generate$Input$getWrap(newType));
		default:
			return $author$project$Generate$Input$UnwrappedValue;
	}
};
var $author$project$Generate$Args$embeddedOptionsFieldName = 'with_';
var $author$project$Elm$Annotation$list = function (inner) {
	return A3(
		$author$project$Elm$Annotation$typed,
		_List_Nil,
		'List',
		_List_fromArray(
			[inner]));
};
var $author$project$Elm$Annotation$record = function (fields) {
	return $author$project$Internal$Compiler$Annotation(
		{
			annotation: $stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Record(
				$author$project$Internal$Compiler$nodifyAll(
					A2(
						$elm$core$List$map,
						function (_v0) {
							var name = _v0.a;
							var ann = _v0.b;
							return _Utils_Tuple2(
								$author$project$Internal$Compiler$nodify(
									$author$project$Internal$Compiler$formatValue(name)),
								$author$project$Internal$Compiler$nodify(
									$author$project$Internal$Compiler$getInnerAnnotation(ann)));
						},
						fields))),
			imports: A2(
				$elm$core$List$concatMap,
				A2($elm$core$Basics$composeR, $elm$core$Tuple$second, $author$project$Internal$Compiler$getAnnotationImports),
				fields)
		});
};
var $author$project$Elm$Annotation$bool = A3($author$project$Elm$Annotation$typed, _List_Nil, 'Bool', _List_Nil);
var $author$project$Elm$Annotation$float = A3($author$project$Elm$Annotation$typed, _List_Nil, 'Float', _List_Nil);
var $author$project$Utils$String$formatScalar = function (name) {
	var remaining = A2($elm$core$String$dropLeft, 1, name);
	var first = A2($elm$core$String$left, 1, name);
	var body = A3(
		$elm$core$String$foldl,
		$author$project$Utils$String$elmify,
		_Utils_Tuple2(false, ''),
		remaining).b;
	return _Utils_ap(
		$elm$core$String$toUpper(first),
		body);
};
var $author$project$Elm$Annotation$int = A3($author$project$Elm$Annotation$typed, _List_Nil, 'Int', _List_Nil);
var $author$project$Elm$Annotation$maybe = function (maybeArg) {
	return A3(
		$author$project$Elm$Annotation$typed,
		_List_Nil,
		'Maybe',
		_List_fromArray(
			[maybeArg]));
};
var $author$project$Generate$Args$scalarType = F2(
	function (wrapped, scalarName) {
		switch (wrapped.$) {
			case 'InList':
				var inner = wrapped.a;
				return $author$project$Elm$Annotation$list(
					A2($author$project$Generate$Args$scalarType, inner, scalarName));
			case 'InMaybe':
				var inner = wrapped.a;
				return $author$project$Elm$Annotation$maybe(
					A2($author$project$Generate$Args$scalarType, inner, scalarName));
			default:
				var lowered = $elm$core$String$toLower(scalarName);
				switch (lowered) {
					case 'int':
						return $author$project$Elm$Annotation$int;
					case 'float':
						return $author$project$Elm$Annotation$float;
					case 'string':
						return $author$project$Elm$Annotation$string;
					case 'boolean':
						return $author$project$Elm$Annotation$bool;
					default:
						return A2(
							$author$project$Elm$Annotation$named,
							_List_fromArray(
								['Scalar']),
							$author$project$Utils$String$formatScalar(scalarName));
				}
		}
	});
var $author$project$Generate$Common$selection = F3(
	function (namespace, name, data) {
		return A3(
			$author$project$Elm$Annotation$namedWith,
			_List_fromArray(
				[namespace]),
			name,
			_List_fromArray(
				[data]));
	});
var $author$project$Generate$Input$isOptional = function (arg) {
	var _v0 = arg.type_;
	if (_v0.$ === 'Nullable') {
		return true;
	} else {
		return false;
	}
};
var $elm$core$List$partition = F2(
	function (pred, list) {
		var step = F2(
			function (x, _v0) {
				var trues = _v0.a;
				var falses = _v0.b;
				return pred(x) ? _Utils_Tuple2(
					A2($elm$core$List$cons, x, trues),
					falses) : _Utils_Tuple2(
					trues,
					A2($elm$core$List$cons, x, falses));
			});
		return A3(
			$elm$core$List$foldr,
			step,
			_Utils_Tuple2(_List_Nil, _List_Nil),
			list);
	});
var $author$project$Generate$Input$splitRequired = function (args) {
	return A2(
		$elm$core$List$partition,
		A2($elm$core$Basics$composeL, $elm$core$Basics$not, $author$project$Generate$Input$isOptional),
		args);
};
var $author$project$Elm$Annotation$unit = $author$project$Internal$Compiler$Annotation(
	{annotation: $stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Unit, imports: _List_Nil});
var $author$project$Generate$Args$unwrapWith = F2(
	function (wrapped, expression) {
		switch (wrapped.$) {
			case 'InList':
				var inner = wrapped.a;
				return $author$project$Elm$Annotation$list(
					A2($author$project$Generate$Args$unwrapWith, inner, expression));
			case 'InMaybe':
				var inner = wrapped.a;
				return $author$project$Elm$Annotation$maybe(
					A2($author$project$Generate$Args$unwrapWith, inner, expression));
			default:
				return expression;
		}
	});
var $author$project$Generate$Args$inputAnnotationRecursive = F4(
	function (namespace, schema, type_, wrapped) {
		inputAnnotationRecursive:
		while (true) {
			switch (type_.$) {
				case 'Nullable':
					var newType = type_.a;
					var $temp$namespace = namespace,
						$temp$schema = schema,
						$temp$type_ = newType,
						$temp$wrapped = wrapped;
					namespace = $temp$namespace;
					schema = $temp$schema;
					type_ = $temp$type_;
					wrapped = $temp$wrapped;
					continue inputAnnotationRecursive;
				case 'List_':
					var newType = type_.a;
					var $temp$namespace = namespace,
						$temp$schema = schema,
						$temp$type_ = newType,
						$temp$wrapped = wrapped;
					namespace = $temp$namespace;
					schema = $temp$schema;
					type_ = $temp$type_;
					wrapped = $temp$wrapped;
					continue inputAnnotationRecursive;
				case 'Scalar':
					var scalarName = type_.a;
					return A2($author$project$Generate$Args$scalarType, wrapped, scalarName);
				case 'Enum':
					var enumName = type_.a;
					return A2(
						$author$project$Generate$Args$unwrapWith,
						wrapped,
						A2(
							$author$project$Elm$Annotation$named,
							A2($author$project$Generate$Common$modules._enum, namespace, enumName),
							enumName));
				case 'InputObject':
					var inputName = type_.a;
					var _v2 = A2($elm$core$Dict$get, inputName, schema.inputObjects);
					if (_v2.$ === 'Nothing') {
						return A2(
							$author$project$Generate$Args$unwrapWith,
							wrapped,
							A2($author$project$Generate$Args$annotations.arg, namespace, inputName));
					} else {
						var input = _v2.a;
						return A5(
							$author$project$Generate$Args$inputObjectAnnotation,
							namespace,
							schema,
							input,
							wrapped,
							{ergonomicOptionType: false});
					}
				case 'Object':
					var nestedObjectName = type_.a;
					return A3(
						$author$project$Generate$Common$selection,
						namespace,
						nestedObjectName,
						$author$project$Elm$Annotation$var('data'));
				case 'Union':
					var unionName = type_.a;
					return A2(
						$author$project$Generate$Args$unwrapWith,
						wrapped,
						A3(
							$author$project$Generate$Common$selection,
							namespace,
							unionName,
							$author$project$Elm$Annotation$var('data')));
				default:
					var interfaceName = type_.a;
					return $author$project$Elm$Annotation$unit;
			}
		}
	});
var $author$project$Generate$Args$inputObjectAnnotation = F5(
	function (namespace, schema, input, wrapped, optForm) {
		var inputName = input.name;
		var _v0 = $author$project$Generate$Input$splitRequired(input.fields);
		if (!_v0.a.b) {
			if (!_v0.b.b) {
				return A2(
					$author$project$Generate$Args$unwrapWith,
					wrapped,
					A2($author$project$Generate$Args$annotations.arg, namespace, inputName));
			} else {
				var optional = _v0.b;
				return optForm.ergonomicOptionType ? A2(
					$author$project$Generate$Args$unwrapWith,
					wrapped,
					$author$project$Elm$Annotation$list(
						A2($author$project$Generate$Args$annotations.ergonomicOptional, namespace, inputName))) : A2(
					$author$project$Generate$Args$unwrapWith,
					wrapped,
					$author$project$Elm$Annotation$list(
						A2($author$project$Generate$Args$annotations.safeOptional, namespace, inputName)));
			}
		} else {
			if (!_v0.b.b) {
				var required = _v0.a;
				return A2(
					$author$project$Generate$Args$unwrapWith,
					wrapped,
					$author$project$Elm$Annotation$record(
						A2(
							$elm$core$List$map,
							function (field) {
								return _Utils_Tuple2(
									field.name,
									A4(
										$author$project$Generate$Args$inputAnnotationRecursive,
										namespace,
										schema,
										field.type_,
										$author$project$Generate$Input$getWrap(field.type_)));
							},
							input.fields)));
			} else {
				var required = _v0.a;
				var optional = _v0.b;
				return A2(
					$author$project$Generate$Args$unwrapWith,
					wrapped,
					$author$project$Elm$Annotation$record(
						_Utils_ap(
							A2(
								$elm$core$List$map,
								function (field) {
									return _Utils_Tuple2(
										field.name,
										A4(
											$author$project$Generate$Args$inputAnnotationRecursive,
											namespace,
											schema,
											field.type_,
											$author$project$Generate$Input$getWrap(field.type_)));
								},
								required),
							_List_fromArray(
								[
									_Utils_Tuple2(
									$author$project$Generate$Args$embeddedOptionsFieldName,
									$author$project$Elm$Annotation$list(
										A2($author$project$Generate$Args$annotations.optional, namespace, inputName)))
								]))));
			}
		}
	});
var $elm$core$List$all = F2(
	function (isOkay, list) {
		return !A2(
			$elm$core$List$any,
			A2($elm$core$Basics$composeL, $elm$core$Basics$not, isOkay),
			list);
	});
var $author$project$Elm$Gen$List$moduleName_ = _List_fromArray(
	['List']);
var $author$project$Elm$Gen$List$append = F2(
	function (arg1, arg2) {
		return A2(
			$author$project$Elm$apply,
			A3(
				$author$project$Elm$valueWith,
				$author$project$Elm$Gen$List$moduleName_,
				'append',
				A2(
					$author$project$Elm$Annotation$function,
					_List_fromArray(
						[
							$author$project$Elm$Annotation$list(
							$author$project$Elm$Annotation$var('a')),
							$author$project$Elm$Annotation$list(
							$author$project$Elm$Annotation$var('a'))
						]),
					$author$project$Elm$Annotation$list(
						$author$project$Elm$Annotation$var('a')))),
			_List_fromArray(
				[arg1, arg2]));
	});
var $author$project$Elm$Annotation$tuple = F2(
	function (one, two) {
		return $author$project$Internal$Compiler$Annotation(
			{
				annotation: $stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Tupled(
					$author$project$Internal$Compiler$nodifyAll(
						_List_fromArray(
							[
								$author$project$Internal$Compiler$getInnerAnnotation(one),
								$author$project$Internal$Compiler$getInnerAnnotation(two)
							]))),
				imports: _Utils_ap(
					$author$project$Internal$Compiler$getAnnotationImports(one),
					$author$project$Internal$Compiler$getAnnotationImports(two))
			});
	});
var $author$project$Elm$Gen$GraphQL$Engine$encodeInputObject = F2(
	function (arg1, arg2) {
		return A2(
			$author$project$Elm$apply,
			A3(
				$author$project$Elm$valueWith,
				$author$project$Elm$Gen$GraphQL$Engine$moduleName_,
				'encodeInputObject',
				A2(
					$author$project$Elm$Annotation$function,
					_List_fromArray(
						[
							$author$project$Elm$Annotation$list(
							A2(
								$author$project$Elm$Annotation$tuple,
								$author$project$Elm$Annotation$string,
								A3(
									$author$project$Elm$Annotation$namedWith,
									_List_fromArray(
										['GraphQL', 'Engine']),
									'Argument',
									_List_fromArray(
										[
											$author$project$Elm$Annotation$var('obj')
										])))),
							$author$project$Elm$Annotation$string
						]),
					A3(
						$author$project$Elm$Annotation$namedWith,
						_List_fromArray(
							['GraphQL', 'Engine']),
						'Argument',
						_List_fromArray(
							[
								$author$project$Elm$Annotation$var('input')
							])))),
			_List_fromArray(
				[arg1, arg2]));
	});
var $author$project$Elm$Gen$GraphQL$Engine$encodeArgument = function (arg1) {
	return A2(
		$author$project$Elm$apply,
		A3(
			$author$project$Elm$valueWith,
			$author$project$Elm$Gen$GraphQL$Engine$moduleName_,
			'encodeArgument',
			A2(
				$author$project$Elm$Annotation$function,
				_List_fromArray(
					[
						A3(
						$author$project$Elm$Annotation$namedWith,
						_List_fromArray(
							['GraphQL', 'Engine']),
						'Argument',
						_List_fromArray(
							[
								$author$project$Elm$Annotation$var('obj')
							]))
					]),
				A3(
					$author$project$Elm$Annotation$namedWith,
					_List_fromArray(
						['Json', 'Encode']),
					'Value',
					_List_Nil))),
		_List_fromArray(
			[arg1]));
};
var $author$project$Elm$Gen$GraphQL$Engine$encodeOptionals = function (arg1) {
	return A2(
		$author$project$Elm$apply,
		A3(
			$author$project$Elm$valueWith,
			$author$project$Elm$Gen$GraphQL$Engine$moduleName_,
			'encodeOptionals',
			A2(
				$author$project$Elm$Annotation$function,
				_List_fromArray(
					[
						$author$project$Elm$Annotation$list(
						A3(
							$author$project$Elm$Annotation$namedWith,
							_List_fromArray(
								['GraphQL', 'Engine']),
							'Optional',
							_List_fromArray(
								[
									$author$project$Elm$Annotation$var('arg')
								])))
					]),
				$author$project$Elm$Annotation$list(
					A2(
						$author$project$Elm$Annotation$tuple,
						$author$project$Elm$Annotation$string,
						A3(
							$author$project$Elm$Annotation$namedWith,
							_List_fromArray(
								['GraphQL', 'Engine']),
							'Argument',
							_List_fromArray(
								[
									$author$project$Elm$Annotation$var('arg')
								])))))),
		_List_fromArray(
			[arg1]));
};
var $author$project$Elm$Gen$Json$Encode$list = F2(
	function (arg1, arg2) {
		return A2(
			$author$project$Elm$apply,
			A3(
				$author$project$Elm$valueWith,
				$author$project$Elm$Gen$Json$Encode$moduleName_,
				'list',
				A2(
					$author$project$Elm$Annotation$function,
					_List_fromArray(
						[
							A2(
							$author$project$Elm$Annotation$function,
							_List_fromArray(
								[
									$author$project$Elm$Annotation$var('a')
								]),
							A3(
								$author$project$Elm$Annotation$namedWith,
								_List_fromArray(
									['Json', 'Encode']),
								'Value',
								_List_Nil)),
							$author$project$Elm$Annotation$list(
							$author$project$Elm$Annotation$var('a'))
						]),
					A3(
						$author$project$Elm$Annotation$namedWith,
						_List_fromArray(
							['Json', 'Encode']),
						'Value',
						_List_Nil))),
			_List_fromArray(
				[
					arg1($author$project$Elm$pass),
					arg2
				]));
	});
var $author$project$Elm$Gen$GraphQL$Engine$maybeScalarEncode = F2(
	function (arg1, arg2) {
		return A2(
			$author$project$Elm$apply,
			A3(
				$author$project$Elm$valueWith,
				$author$project$Elm$Gen$GraphQL$Engine$moduleName_,
				'maybeScalarEncode',
				A2(
					$author$project$Elm$Annotation$function,
					_List_fromArray(
						[
							A2(
							$author$project$Elm$Annotation$function,
							_List_fromArray(
								[
									$author$project$Elm$Annotation$var('a')
								]),
							A3(
								$author$project$Elm$Annotation$namedWith,
								_List_fromArray(
									['Json', 'Encode']),
								'Value',
								_List_Nil)),
							$author$project$Elm$Annotation$maybe(
							$author$project$Elm$Annotation$var('a'))
						]),
					A3(
						$author$project$Elm$Annotation$namedWith,
						_List_fromArray(
							['Json', 'Encode']),
						'Value',
						_List_Nil))),
			_List_fromArray(
				[
					arg1($author$project$Elm$pass),
					arg2
				]));
	});
var $author$project$Generate$Args$encodeInputObjectArg = F4(
	function (inputName, wrapper, val, level) {
		switch (wrapper.$) {
			case 'UnwrappedValue':
				return $author$project$Elm$Gen$GraphQL$Engine$encodeArgument(
					A2(
						$author$project$Elm$Gen$GraphQL$Engine$encodeInputObject,
						$author$project$Elm$Gen$GraphQL$Engine$encodeOptionals(val),
						$author$project$Elm$string(inputName)));
			case 'InMaybe':
				var inner = wrapper.a;
				return A2(
					$author$project$Elm$Gen$GraphQL$Engine$maybeScalarEncode,
					function (_v1) {
						return A3(
							$author$project$Elm$lambda,
							'o' + $elm$core$String$fromInt(level),
							$author$project$Elm$Annotation$unit,
							function (o) {
								return A4($author$project$Generate$Args$encodeInputObjectArg, inputName, inner, o, level + 1);
							});
					},
					val);
			default:
				var inner = wrapper.a;
				return A2(
					$author$project$Elm$Gen$Json$Encode$list,
					function (_v2) {
						return A3(
							$author$project$Elm$lambda,
							'o' + $elm$core$String$fromInt(level),
							$author$project$Elm$Annotation$unit,
							function (o) {
								return A4($author$project$Generate$Args$encodeInputObjectArg, inputName, inner, o, level + 1);
							});
					},
					val);
		}
	});
var $author$project$Elm$Gen$Json$Encode$bool = function (arg1) {
	return A2(
		$author$project$Elm$apply,
		A3(
			$author$project$Elm$valueWith,
			$author$project$Elm$Gen$Json$Encode$moduleName_,
			'bool',
			A2(
				$author$project$Elm$Annotation$function,
				_List_fromArray(
					[$author$project$Elm$Annotation$bool]),
				A3(
					$author$project$Elm$Annotation$namedWith,
					_List_fromArray(
						['Json', 'Encode']),
					'Value',
					_List_Nil))),
		_List_fromArray(
			[arg1]));
};
var $author$project$Elm$Gen$Json$Encode$float = function (arg1) {
	return A2(
		$author$project$Elm$apply,
		A3(
			$author$project$Elm$valueWith,
			$author$project$Elm$Gen$Json$Encode$moduleName_,
			'float',
			A2(
				$author$project$Elm$Annotation$function,
				_List_fromArray(
					[$author$project$Elm$Annotation$float]),
				A3(
					$author$project$Elm$Annotation$namedWith,
					_List_fromArray(
						['Json', 'Encode']),
					'Value',
					_List_Nil))),
		_List_fromArray(
			[arg1]));
};
var $author$project$Internal$Compiler$CouldNotFindField = function (a) {
	return {$: 'CouldNotFindField', a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$RecordAccess = F2(
	function (a, b) {
		return {$: 'RecordAccess', a: a, b: b};
	});
var $author$project$Elm$getField = F2(
	function (selector, fields) {
		getField:
		while (true) {
			if (!fields.b) {
				return $elm$core$Maybe$Nothing;
			} else {
				var nodifiedTop = fields.a;
				var remain = fields.b;
				var _v1 = $author$project$Internal$Compiler$denode(nodifiedTop);
				var fieldname = _v1.a;
				var contents = _v1.b;
				if (_Utils_eq(
					$author$project$Internal$Compiler$denode(fieldname),
					selector)) {
					return $elm$core$Maybe$Just(
						$author$project$Internal$Compiler$denode(contents));
				} else {
					var $temp$selector = selector,
						$temp$fields = remain;
					selector = $temp$selector;
					fields = $temp$fields;
					continue getField;
				}
			}
		}
	});
var $author$project$Elm$get = F2(
	function (selector, _v0) {
		var expr = _v0.a;
		return $author$project$Internal$Compiler$Expression(
			{
				annotation: function () {
					var _v1 = expr.annotation;
					_v1$2:
					while (true) {
						if (_v1.$ === 'Ok') {
							switch (_v1.a.$) {
								case 'Record':
									var fields = _v1.a.a;
									var _v2 = A2(
										$author$project$Elm$getField,
										$author$project$Internal$Compiler$formatValue(selector),
										fields);
									if (_v2.$ === 'Just') {
										var ann = _v2.a;
										return $elm$core$Result$Ok(ann);
									} else {
										return $elm$core$Result$Err(
											_List_fromArray(
												[
													$author$project$Internal$Compiler$CouldNotFindField(selector)
												]));
									}
								case 'GenericRecord':
									var _v3 = _v1.a;
									var name = _v3.a;
									var fields = _v3.b;
									var _v4 = A2(
										$author$project$Elm$getField,
										$author$project$Internal$Compiler$formatValue(selector),
										$author$project$Internal$Compiler$denode(fields));
									if (_v4.$ === 'Just') {
										var ann = _v4.a;
										return $elm$core$Result$Ok(ann);
									} else {
										return $elm$core$Result$Err(
											_List_fromArray(
												[
													$author$project$Internal$Compiler$CouldNotFindField(selector)
												]));
									}
								default:
									break _v1$2;
							}
						} else {
							break _v1$2;
						}
					}
					var otherwise = _v1;
					return otherwise;
				}(),
				expression: A2(
					$stil4m$elm_syntax$Elm$Syntax$Expression$RecordAccess,
					$author$project$Internal$Compiler$nodify(expr.expression),
					$author$project$Internal$Compiler$nodify(
						$author$project$Internal$Compiler$formatValue(selector))),
				imports: expr.imports,
				skip: false
			});
	});
var $author$project$Elm$Gen$Json$Encode$int = function (arg1) {
	return A2(
		$author$project$Elm$apply,
		A3(
			$author$project$Elm$valueWith,
			$author$project$Elm$Gen$Json$Encode$moduleName_,
			'int',
			A2(
				$author$project$Elm$Annotation$function,
				_List_fromArray(
					[$author$project$Elm$Annotation$int]),
				A3(
					$author$project$Elm$Annotation$namedWith,
					_List_fromArray(
						['Json', 'Encode']),
					'Value',
					_List_Nil))),
		_List_fromArray(
			[arg1]));
};
var $author$project$Elm$valueFrom = F2(
	function (mod, name) {
		return $author$project$Internal$Compiler$Expression(
			{
				annotation: $elm$core$Result$Err(_List_Nil),
				expression: A2(
					$stil4m$elm_syntax$Elm$Syntax$Expression$FunctionOrValue,
					mod,
					$author$project$Internal$Compiler$sanitize(name)),
				imports: _List_fromArray(
					[mod]),
				skip: false
			});
	});
var $author$project$Generate$Args$encodeScalar = F2(
	function (scalarName, wrapped) {
		switch (wrapped.$) {
			case 'InList':
				var inner = wrapped.a;
				return $author$project$Elm$Gen$Json$Encode$list(
					A2($author$project$Generate$Args$encodeScalar, scalarName, inner));
			case 'InMaybe':
				var inner = wrapped.a;
				return $author$project$Elm$Gen$GraphQL$Engine$maybeScalarEncode(
					A2($author$project$Generate$Args$encodeScalar, scalarName, inner));
			default:
				var lowered = $elm$core$String$toLower(scalarName);
				switch (lowered) {
					case 'int':
						return $author$project$Elm$Gen$Json$Encode$int;
					case 'float':
						return $author$project$Elm$Gen$Json$Encode$float;
					case 'string':
						return $author$project$Elm$Gen$Json$Encode$string;
					case 'boolean':
						return $author$project$Elm$Gen$Json$Encode$bool;
					default:
						return function (val) {
							return A2(
								$author$project$Elm$apply,
								A2(
									$author$project$Elm$get,
									'encode',
									A2(
										$author$project$Elm$valueFrom,
										_List_fromArray(
											['Scalar']),
										$author$project$Utils$String$formatValue(scalarName))),
								_List_fromArray(
									[val]));
						};
				}
		}
	});
var $author$project$Generate$Args$countRemainingDepth = F2(
	function (wrapped, i) {
		countRemainingDepth:
		while (true) {
			switch (wrapped.$) {
				case 'UnwrappedValue':
					return i;
				case 'InMaybe':
					var inner = wrapped.a;
					var $temp$wrapped = inner,
						$temp$i = i + 1;
					wrapped = $temp$wrapped;
					i = $temp$i;
					continue countRemainingDepth;
				default:
					var inner = wrapped.a;
					var $temp$wrapped = inner,
						$temp$i = i + 1;
					wrapped = $temp$wrapped;
					i = $temp$i;
					continue countRemainingDepth;
			}
		}
	});
var $author$project$Generate$Args$addCount = F2(
	function (wrapped, str) {
		return _Utils_ap(
			str,
			$elm$core$String$fromInt(
				A2($author$project$Generate$Args$countRemainingDepth, wrapped, 1)));
	});
var $author$project$Elm$Gen$GraphQL$Engine$argList = F2(
	function (arg1, arg2) {
		return A2(
			$author$project$Elm$apply,
			A3(
				$author$project$Elm$valueWith,
				$author$project$Elm$Gen$GraphQL$Engine$moduleName_,
				'argList',
				A2(
					$author$project$Elm$Annotation$function,
					_List_fromArray(
						[
							$author$project$Elm$Annotation$list(
							A3(
								$author$project$Elm$Annotation$namedWith,
								_List_fromArray(
									['GraphQL', 'Engine']),
								'Argument',
								_List_fromArray(
									[
										$author$project$Elm$Annotation$var('obj')
									]))),
							$author$project$Elm$Annotation$string
						]),
					A3(
						$author$project$Elm$Annotation$namedWith,
						_List_fromArray(
							['GraphQL', 'Engine']),
						'Argument',
						_List_fromArray(
							[
								$author$project$Elm$Annotation$var('input')
							])))),
			_List_fromArray(
				[arg1, arg2]));
	});
var $author$project$Generate$Input$gqlTypeHelper = F2(
	function (wrapped, base) {
		gqlTypeHelper:
		while (true) {
			switch (wrapped.$) {
				case 'UnwrappedValue':
					return base;
				case 'InList':
					var inner = wrapped.a;
					return '[' + (A2($author$project$Generate$Input$gqlTypeHelper, inner, base) + ']');
				default:
					var inner = wrapped.a;
					var $temp$wrapped = inner,
						$temp$base = base;
					wrapped = $temp$wrapped;
					base = $temp$base;
					continue gqlTypeHelper;
			}
		}
	});
var $author$project$Generate$Input$gqlType = F2(
	function (wrapped, base) {
		switch (wrapped.$) {
			case 'UnwrappedValue':
				return base + '!';
			case 'InList':
				var inner = wrapped.a;
				return '[' + (A2($author$project$Generate$Input$gqlType, inner, base) + ']');
			default:
				var inner = wrapped.a;
				return A2($author$project$Generate$Input$gqlTypeHelper, inner, base);
		}
	});
var $author$project$Elm$Gen$List$map = F2(
	function (arg1, arg2) {
		return A2(
			$author$project$Elm$apply,
			A3(
				$author$project$Elm$valueWith,
				$author$project$Elm$Gen$List$moduleName_,
				'map',
				A2(
					$author$project$Elm$Annotation$function,
					_List_fromArray(
						[
							A2(
							$author$project$Elm$Annotation$function,
							_List_fromArray(
								[
									$author$project$Elm$Annotation$var('a')
								]),
							$author$project$Elm$Annotation$var('b')),
							$author$project$Elm$Annotation$list(
							$author$project$Elm$Annotation$var('a'))
						]),
					$author$project$Elm$Annotation$list(
						$author$project$Elm$Annotation$var('b')))),
			_List_fromArray(
				[
					arg1($author$project$Elm$pass),
					arg2
				]));
	});
var $author$project$Elm$value = $author$project$Elm$valueFrom(_List_Nil);
var $author$project$Elm$Pattern$var = function (name) {
	return $stil4m$elm_syntax$Elm$Syntax$Pattern$VarPattern(name);
};
var $author$project$Generate$Args$encodeWrappedArgument = F4(
	function (inputName, wrapper, encoder, val) {
		switch (wrapper.$) {
			case 'UnwrappedValue':
				return encoder(val);
			case 'InMaybe':
				var inner = wrapper.a;
				var valName = A2(
					$author$project$Generate$Args$addCount,
					inner,
					$author$project$Utils$String$formatValue(inputName));
				return A2(
					$author$project$Elm$caseOf,
					val,
					_List_fromArray(
						[
							_Utils_Tuple2(
							A2(
								$author$project$Elm$Pattern$named,
								'Just',
								_List_fromArray(
									[
										$author$project$Elm$Pattern$var('item')
									])),
							A4(
								$author$project$Generate$Args$encodeWrappedArgument,
								valName,
								inner,
								encoder,
								$author$project$Elm$value('item'))),
							_Utils_Tuple2(
							A2($author$project$Elm$Pattern$named, 'Nothing', _List_Nil),
							A2(
								$author$project$Elm$Gen$GraphQL$Engine$arg,
								$author$project$Elm$Gen$Json$Encode$null,
								$author$project$Elm$string(
									A2($author$project$Generate$Input$gqlType, wrapper, inputName))))
						]));
			default:
				var inner = wrapper.a;
				var valName = A2(
					$author$project$Generate$Args$addCount,
					inner,
					$author$project$Utils$String$formatValue(inputName));
				return A2(
					$author$project$Elm$Gen$GraphQL$Engine$argList,
					A2(
						$author$project$Elm$Gen$List$map,
						function (v) {
							return A3(
								$author$project$Elm$lambda,
								valName,
								$author$project$Elm$Annotation$unit,
								function (within) {
									return A4($author$project$Generate$Args$encodeWrappedArgument, valName, inner, encoder, within);
								});
						},
						val),
					$author$project$Elm$string(
						A2($author$project$Generate$Input$gqlType, wrapper, inputName)));
		}
	});
var $author$project$Generate$Args$encodeWrappedInverted = F3(
	function (wrapper, encoder, val) {
		switch (wrapper.$) {
			case 'UnwrappedValue':
				return encoder(val);
			case 'InMaybe':
				var inner = wrapper.a;
				return A2(
					$author$project$Elm$Gen$GraphQL$Engine$maybeScalarEncode,
					A2($author$project$Generate$Args$encodeWrappedInverted, inner, encoder),
					val);
			default:
				var inner = wrapper.a;
				return A2(
					$author$project$Elm$Gen$Json$Encode$list,
					A2($author$project$Generate$Args$encodeWrappedInverted, inner, encoder),
					val);
		}
	});
var $stil4m$elm_syntax$Elm$Syntax$Expression$TupledExpression = function (a) {
	return {$: 'TupledExpression', a: a};
};
var $elm$core$Result$map2 = F3(
	function (func, ra, rb) {
		if (ra.$ === 'Err') {
			var x = ra.a;
			return $elm$core$Result$Err(x);
		} else {
			var a = ra.a;
			if (rb.$ === 'Err') {
				var x = rb.a;
				return $elm$core$Result$Err(x);
			} else {
				var b = rb.a;
				return $elm$core$Result$Ok(
					A2(func, a, b));
			}
		}
	});
var $author$project$Elm$tuple = F2(
	function (_v0, _v1) {
		var one = _v0.a;
		var two = _v1.a;
		return $author$project$Internal$Compiler$Expression(
			{
				annotation: A3(
					$elm$core$Result$map2,
					F2(
						function (oneA, twoA) {
							return $author$project$Internal$Compiler$getInnerAnnotation(
								A2(
									$author$project$Elm$Annotation$tuple,
									$author$project$Internal$Compiler$noImports(oneA),
									$author$project$Internal$Compiler$noImports(twoA)));
						}),
					one.annotation,
					two.annotation),
				expression: $stil4m$elm_syntax$Elm$Syntax$Expression$TupledExpression(
					$author$project$Internal$Compiler$nodifyAll(
						_List_fromArray(
							[one.expression, two.expression]))),
				imports: _Utils_ap(one.imports, two.imports),
				skip: false
			});
	});
var $author$project$Generate$Args$toEngineArg = F5(
	function (namespace, schema, fieldType, wrapped, val) {
		toEngineArg:
		while (true) {
			switch (fieldType.$) {
				case 'Nullable':
					var newType = fieldType.a;
					var $temp$namespace = namespace,
						$temp$schema = schema,
						$temp$fieldType = newType,
						$temp$wrapped = wrapped,
						$temp$val = val;
					namespace = $temp$namespace;
					schema = $temp$schema;
					fieldType = $temp$fieldType;
					wrapped = $temp$wrapped;
					val = $temp$val;
					continue toEngineArg;
				case 'List_':
					var newType = fieldType.a;
					var $temp$namespace = namespace,
						$temp$schema = schema,
						$temp$fieldType = newType,
						$temp$wrapped = wrapped,
						$temp$val = val;
					namespace = $temp$namespace;
					schema = $temp$schema;
					fieldType = $temp$fieldType;
					wrapped = $temp$wrapped;
					val = $temp$val;
					continue toEngineArg;
				case 'Scalar':
					var scalarName = fieldType.a;
					return A2(
						$author$project$Elm$Gen$GraphQL$Engine$arg,
						A3($author$project$Generate$Args$encodeScalar, scalarName, wrapped, val),
						$author$project$Elm$string(
							A2($author$project$Generate$Input$gqlType, wrapped, scalarName)));
				case 'Enum':
					var enumName = fieldType.a;
					return A2(
						$author$project$Elm$Gen$GraphQL$Engine$arg,
						A3(
							$author$project$Generate$Args$encodeWrappedInverted,
							wrapped,
							function (v) {
								return A2(
									$author$project$Elm$apply,
									A2(
										$author$project$Elm$valueFrom,
										_List_fromArray(
											[namespace, 'Enum', enumName]),
										'encode'),
									_List_fromArray(
										[v]));
							},
							val),
						$author$project$Elm$string(
							A2($author$project$Generate$Input$gqlType, wrapped, enumName)));
				case 'InputObject':
					var inputName = fieldType.a;
					var _v1 = A2($elm$core$Dict$get, inputName, schema.inputObjects);
					if (_v1.$ === 'Nothing') {
						return A2(
							$author$project$Elm$Gen$GraphQL$Engine$arg,
							A4($author$project$Generate$Args$encodeInputObjectArg, inputName, wrapped, val, 0),
							$author$project$Elm$string(inputName));
					} else {
						var input = _v1.a;
						if (A2($elm$core$List$all, $author$project$Generate$Input$isOptional, input.fields)) {
							return A2(
								$author$project$Elm$Gen$GraphQL$Engine$arg,
								A4($author$project$Generate$Args$encodeInputObjectArg, inputName, wrapped, val, 0),
								$author$project$Elm$string(
									A2($author$project$Generate$Input$gqlType, wrapped, inputName)));
						} else {
							var _v2 = input.fields;
							if (!_v2.b) {
								return A2(
									$author$project$Elm$Gen$GraphQL$Engine$arg,
									A4($author$project$Generate$Args$encodeInputObjectArg, inputName, wrapped, val, 0),
									$author$project$Elm$string(
										A2($author$project$Generate$Input$gqlType, wrapped, input.name)));
							} else {
								var many = _v2;
								return A4(
									$author$project$Generate$Args$encodeWrappedArgument,
									input.name,
									wrapped,
									function (v) {
										var requiredVals = $author$project$Elm$list(
											A2(
												$elm$core$List$map,
												function (field) {
													return A2(
														$author$project$Elm$tuple,
														$author$project$Elm$string(field.name),
														A5(
															$author$project$Generate$Args$toEngineArg,
															namespace,
															schema,
															field.type_,
															$author$project$Generate$Input$getWrap(field.type_),
															A2($author$project$Elm$get, field.name, v)));
												},
												A2(
													$elm$core$List$filter,
													A2($elm$core$Basics$composeL, $elm$core$Basics$not, $author$project$Generate$Input$isOptional),
													many)));
										return A2(
											$author$project$Elm$Gen$GraphQL$Engine$encodeInputObject,
											A2($elm$core$List$any, $author$project$Generate$Input$isOptional, input.fields) ? A2(
												$author$project$Elm$Gen$List$append,
												requiredVals,
												$author$project$Elm$Gen$GraphQL$Engine$encodeOptionals(
													A2($author$project$Elm$get, $author$project$Generate$Args$embeddedOptionsFieldName, v))) : requiredVals,
											$author$project$Elm$string(
												A2($author$project$Generate$Input$gqlType, $author$project$Generate$Input$UnwrappedValue, input.name)));
									},
									val);
							}
						}
					}
				case 'Union':
					var unionName = fieldType.a;
					return $author$project$Elm$string('Unions cant be nested in inputs');
				case 'Object':
					var nestedObjectName = fieldType.a;
					return $author$project$Elm$string('Objects cant be nested in inputs');
				default:
					var interfaceName = fieldType.a;
					return $author$project$Elm$string('Interfaces cant be in inputs');
			}
		}
	});
var $author$project$Generate$Args$optionsRecursiveHelper = F5(
	function (namespace, schema, name, options, fields) {
		optionsRecursiveHelper:
		while (true) {
			if (!options.b) {
				return fields;
			} else {
				var arg = options.a;
				var remain = options.b;
				var wrapping = function () {
					var _v1 = $author$project$Generate$Input$getWrap(arg.type_);
					if (_v1.$ === 'InMaybe') {
						var inner = _v1.a;
						return inner;
					} else {
						var otherwise = _v1;
						return otherwise;
					}
				}();
				var $temp$namespace = namespace,
					$temp$schema = schema,
					$temp$name = name,
					$temp$options = remain,
					$temp$fields = A2(
					$elm$core$List$cons,
					$author$project$Elm$expose(
						A3(
							$author$project$Elm$fn,
							$author$project$Utils$String$formatValue(arg.name),
							_Utils_Tuple2(
								'val',
								A4($author$project$Generate$Args$inputAnnotationRecursive, namespace, schema, arg.type_, wrapping)),
							function (val) {
								return A2(
									$author$project$Elm$withType,
									A2($author$project$Generate$Args$annotations.localOptional, namespace, name),
									A2(
										$author$project$Elm$Gen$GraphQL$Engine$optional,
										$author$project$Elm$string(arg.name),
										A2(
											$author$project$Elm$withType,
											A2($author$project$Generate$Args$annotations.arg, namespace, name),
											A5($author$project$Generate$Args$toEngineArg, namespace, schema, arg.type_, wrapping, val))));
							})),
					fields);
				namespace = $temp$namespace;
				schema = $temp$schema;
				name = $temp$name;
				options = $temp$options;
				fields = $temp$fields;
				continue optionsRecursiveHelper;
			}
		}
	});
var $author$project$Generate$Args$optionsRecursive = F4(
	function (namespace, schema, name, options) {
		return A5($author$project$Generate$Args$optionsRecursiveHelper, namespace, schema, name, options, _List_Nil);
	});
var $author$project$Generate$InputObjects$inputObjectToOptionalBuilders = F3(
	function (namespace, schema, input) {
		var optionalTypeAlias = $author$project$Elm$expose(
			A2(
				$author$project$Elm$alias,
				'Optional',
				$author$project$Elm$Gen$GraphQL$Engine$types_.optional(
					A2(
						$author$project$Elm$Annotation$named,
						_List_fromArray(
							[namespace]),
						input.name))));
		var _v0 = A2(
			$elm$core$List$partition,
			function (arg) {
				var _v1 = arg.type_;
				if (_v1.$ === 'Nullable') {
					var innerType = _v1.a;
					return false;
				} else {
					return true;
				}
			},
			input.fields);
		var required = _v0.a;
		var optional = _v0.b;
		var hasOptionalArgs = function () {
			if (!optional.b) {
				return false;
			} else {
				return true;
			}
		}();
		return hasOptionalArgs ? _List_fromArray(
			[
				A2(
				$author$project$Elm$file,
				_List_fromArray(
					[
						namespace,
						$author$project$Utils$String$formatTypename(input.name)
					]),
				A2(
					$elm$core$List$cons,
					optionalTypeAlias,
					_Utils_ap(
						A4($author$project$Generate$Args$optionsRecursive, namespace, schema, input.name, optional),
						_List_fromArray(
							[
								$author$project$Elm$expose(
								A2(
									$author$project$Elm$declaration,
									'null',
									A3($author$project$Generate$Args$nullsRecord, namespace, input.name, optional)))
							]))))
			]) : _List_Nil;
	});
var $author$project$Generate$InputObjects$generateFiles = F2(
	function (namespace, schema) {
		var objects = A2(
			$elm$core$List$map,
			$elm$core$Tuple$second,
			$elm$core$Dict$toList(schema.inputObjects));
		var optionalFiles = A2(
			$elm$core$List$concatMap,
			A2($author$project$Generate$InputObjects$inputObjectToOptionalBuilders, namespace, schema),
			objects);
		return optionalFiles;
	});
var $author$project$Generate$Objects$formatName = function (str) {
	if (str === '_') {
		return 'underscore';
	} else {
		return str;
	}
};
var $author$project$Elm$Gen$GraphQL$Engine$decodeNullable = function (arg1) {
	return A2(
		$author$project$Elm$apply,
		A3(
			$author$project$Elm$valueWith,
			$author$project$Elm$Gen$GraphQL$Engine$moduleName_,
			'decodeNullable',
			A2(
				$author$project$Elm$Annotation$function,
				_List_fromArray(
					[
						A3(
						$author$project$Elm$Annotation$namedWith,
						_List_fromArray(
							['Json', 'Decode']),
						'Decoder',
						_List_fromArray(
							[
								$author$project$Elm$Annotation$var('data')
							]))
					]),
				A3(
					$author$project$Elm$Annotation$namedWith,
					_List_fromArray(
						['Json', 'Decode']),
					'Decoder',
					_List_fromArray(
						[
							$author$project$Elm$Annotation$maybe(
							$author$project$Elm$Annotation$var('data'))
						])))),
		_List_fromArray(
			[arg1]));
};
var $author$project$Elm$Gen$Json$Decode$list = function (arg1) {
	return A2(
		$author$project$Elm$apply,
		A3(
			$author$project$Elm$valueWith,
			$author$project$Elm$Gen$Json$Decode$moduleName_,
			'list',
			A2(
				$author$project$Elm$Annotation$function,
				_List_fromArray(
					[
						A3(
						$author$project$Elm$Annotation$namedWith,
						_List_fromArray(
							['Json', 'Decode']),
						'Decoder',
						_List_fromArray(
							[
								$author$project$Elm$Annotation$var('a')
							]))
					]),
				A3(
					$author$project$Elm$Annotation$namedWith,
					_List_fromArray(
						['Json', 'Decode']),
					'Decoder',
					_List_fromArray(
						[
							$author$project$Elm$Annotation$list(
							$author$project$Elm$Annotation$var('a'))
						])))),
		_List_fromArray(
			[arg1]));
};
var $author$project$Generate$Objects$decodeWrapper = F2(
	function (wrap, exp) {
		switch (wrap.$) {
			case 'UnwrappedValue':
				return exp;
			case 'InList':
				var inner = wrap.a;
				return $author$project$Elm$Gen$Json$Decode$list(
					A2($author$project$Generate$Objects$decodeWrapper, inner, exp));
			default:
				var inner = wrap.a;
				return $author$project$Elm$Gen$GraphQL$Engine$decodeNullable(
					A2($author$project$Generate$Objects$decodeWrapper, inner, exp));
		}
	});
var $author$project$Elm$Gen$GraphQL$Engine$field = F2(
	function (arg1, arg2) {
		return A2(
			$author$project$Elm$apply,
			A3(
				$author$project$Elm$valueWith,
				$author$project$Elm$Gen$GraphQL$Engine$moduleName_,
				'field',
				A2(
					$author$project$Elm$Annotation$function,
					_List_fromArray(
						[
							$author$project$Elm$Annotation$string,
							A3(
							$author$project$Elm$Annotation$namedWith,
							_List_fromArray(
								['Json', 'Decode']),
							'Decoder',
							_List_fromArray(
								[
									$author$project$Elm$Annotation$var('data')
								]))
						]),
					A3(
						$author$project$Elm$Annotation$namedWith,
						_List_fromArray(
							['GraphQL', 'Engine']),
						'Selection',
						_List_fromArray(
							[
								$author$project$Elm$Annotation$var('source'),
								$author$project$Elm$Annotation$var('data')
							])))),
			_List_fromArray(
				[arg1, arg2]));
	});
var $author$project$Generate$Common$gqlTypeToElmTypeAnnotation = F3(
	function (namespace, gqlType, maybeAppliedToTypes) {
		var appliedToTypes = A2($elm$core$Maybe$withDefault, _List_Nil, maybeAppliedToTypes);
		switch (gqlType.$) {
			case 'Scalar':
				var scalarName = gqlType.a;
				var _v1 = $elm$core$String$toLower(scalarName);
				switch (_v1) {
					case 'string':
						return $author$project$Elm$Annotation$string;
					case 'int':
						return $author$project$Elm$Annotation$int;
					case 'float':
						return $author$project$Elm$Annotation$float;
					case 'boolean':
						return $author$project$Elm$Annotation$bool;
					default:
						return A3(
							$author$project$Elm$Annotation$namedWith,
							_List_fromArray(
								['Scalar']),
							$author$project$Utils$String$formatScalar(scalarName),
							appliedToTypes);
				}
			case 'Enum':
				var enumName = gqlType.a;
				return A3(
					$author$project$Elm$Annotation$namedWith,
					_List_fromArray(
						[namespace, 'Enum', enumName]),
					enumName,
					appliedToTypes);
			case 'List_':
				var listElementType = gqlType.a;
				var innerType = A3($author$project$Generate$Common$gqlTypeToElmTypeAnnotation, namespace, listElementType, maybeAppliedToTypes);
				return $author$project$Elm$Annotation$list(innerType);
			case 'Nullable':
				var nonNullType = gqlType.a;
				var innerType = A3($author$project$Generate$Common$gqlTypeToElmTypeAnnotation, namespace, nonNullType, maybeAppliedToTypes);
				return $author$project$Elm$Annotation$maybe(innerType);
			case 'InputObject':
				var inputObjectName = gqlType.a;
				return A2($author$project$Generate$Common$ref, namespace, inputObjectName);
			case 'Object':
				var objectName = gqlType.a;
				return A2($author$project$Generate$Common$ref, namespace, objectName);
			case 'Union':
				var unionName = gqlType.a;
				return A2($author$project$Generate$Common$ref, namespace, unionName);
			default:
				var interfaceName = gqlType.a;
				return A2($author$project$Generate$Common$ref, namespace, interfaceName);
		}
	});
var $author$project$Generate$Common$local = F2(
	function (namespace, name) {
		return A2($author$project$Elm$Annotation$named, _List_Nil, name);
	});
var $author$project$Generate$Common$localAnnotation = F3(
	function (namespace, gqlType, maybeAppliedToTypes) {
		var appliedToTypes = A2($elm$core$Maybe$withDefault, _List_Nil, maybeAppliedToTypes);
		switch (gqlType.$) {
			case 'Scalar':
				var scalarName = gqlType.a;
				var _v1 = $elm$core$String$toLower(scalarName);
				switch (_v1) {
					case 'string':
						return $author$project$Elm$Annotation$string;
					case 'int':
						return $author$project$Elm$Annotation$int;
					case 'float':
						return $author$project$Elm$Annotation$float;
					case 'boolean':
						return $author$project$Elm$Annotation$bool;
					default:
						return A3(
							$author$project$Elm$Annotation$namedWith,
							_List_fromArray(
								['Scalar']),
							$author$project$Utils$String$formatScalar(scalarName),
							appliedToTypes);
				}
			case 'Enum':
				var enumName = gqlType.a;
				return A3(
					$author$project$Elm$Annotation$namedWith,
					_List_fromArray(
						[namespace, 'Enum', enumName]),
					enumName,
					appliedToTypes);
			case 'List_':
				var listElementType = gqlType.a;
				var innerType = A3($author$project$Generate$Common$gqlTypeToElmTypeAnnotation, namespace, listElementType, maybeAppliedToTypes);
				return $author$project$Elm$Annotation$list(innerType);
			case 'Nullable':
				var nonNullType = gqlType.a;
				var innerType = A3($author$project$Generate$Common$gqlTypeToElmTypeAnnotation, namespace, nonNullType, maybeAppliedToTypes);
				return $author$project$Elm$Annotation$maybe(innerType);
			case 'InputObject':
				var inputObjectName = gqlType.a;
				return A2($author$project$Generate$Common$local, namespace, inputObjectName);
			case 'Object':
				var objectName = gqlType.a;
				return A2($author$project$Generate$Common$local, namespace, objectName);
			case 'Union':
				var unionName = gqlType.a;
				return A2($author$project$Generate$Common$local, namespace, unionName);
			default:
				var interfaceName = gqlType.a;
				return A2($author$project$Generate$Common$local, namespace, interfaceName);
		}
	});
var $author$project$Generate$Common$selectionLocal = F3(
	function (namespace, name, data) {
		return A3(
			$author$project$Elm$Annotation$namedWith,
			_List_Nil,
			name,
			_List_fromArray(
				[data]));
	});
var $author$project$Generate$Objects$wrapAnnotation = F2(
	function (wrap, signature) {
		switch (wrap.$) {
			case 'UnwrappedValue':
				return signature;
			case 'InList':
				var inner = wrap.a;
				return $author$project$Elm$Annotation$list(
					A2($author$project$Generate$Objects$wrapAnnotation, inner, signature));
			default:
				var inner = wrap.a;
				return $author$project$Elm$Annotation$maybe(
					A2($author$project$Generate$Objects$wrapAnnotation, inner, signature));
		}
	});
var $author$project$Generate$Objects$fieldSignature = F4(
	function (namespace, objectName, wrapped, fieldType) {
		var dataType = A2(
			$author$project$Generate$Objects$wrapAnnotation,
			wrapped,
			A3($author$project$Generate$Common$localAnnotation, namespace, fieldType, $elm$core$Maybe$Nothing));
		var typeAnnotation = A3($author$project$Generate$Common$selectionLocal, namespace, objectName, dataType);
		return {annotation: typeAnnotation};
	});
var $author$project$Elm$Gen$GraphQL$Engine$object = F2(
	function (arg1, arg2) {
		return A2(
			$author$project$Elm$apply,
			A3(
				$author$project$Elm$valueWith,
				$author$project$Elm$Gen$GraphQL$Engine$moduleName_,
				'object',
				A2(
					$author$project$Elm$Annotation$function,
					_List_fromArray(
						[
							$author$project$Elm$Annotation$string,
							A3(
							$author$project$Elm$Annotation$namedWith,
							_List_fromArray(
								['GraphQL', 'Engine']),
							'Selection',
							_List_fromArray(
								[
									$author$project$Elm$Annotation$var('source'),
									$author$project$Elm$Annotation$var('data')
								]))
						]),
					A3(
						$author$project$Elm$Annotation$namedWith,
						_List_fromArray(
							['GraphQL', 'Engine']),
						'Selection',
						_List_fromArray(
							[
								$author$project$Elm$Annotation$var('otherSource'),
								$author$project$Elm$Annotation$var('data')
							])))),
			_List_fromArray(
				[arg1, arg2]));
	});
var $author$project$Elm$Gen$Json$Decode$bool = A3(
	$author$project$Elm$valueWith,
	$author$project$Elm$Gen$Json$Decode$moduleName_,
	'bool',
	A3(
		$author$project$Elm$Annotation$namedWith,
		_List_fromArray(
			['Json', 'Decode']),
		'Decoder',
		_List_fromArray(
			[$author$project$Elm$Annotation$bool])));
var $author$project$Generate$Decode$decodeWrapper = F2(
	function (wrap, exp) {
		switch (wrap.$) {
			case 'UnwrappedValue':
				return exp;
			case 'InList':
				var inner = wrap.a;
				return $author$project$Elm$Gen$Json$Decode$list(
					A2($author$project$Generate$Decode$decodeWrapper, inner, exp));
			default:
				var inner = wrap.a;
				return $author$project$Elm$Gen$GraphQL$Engine$decodeNullable(
					A2($author$project$Generate$Decode$decodeWrapper, inner, exp));
		}
	});
var $author$project$Elm$Gen$Json$Decode$float = A3(
	$author$project$Elm$valueWith,
	$author$project$Elm$Gen$Json$Decode$moduleName_,
	'float',
	A3(
		$author$project$Elm$Annotation$namedWith,
		_List_fromArray(
			['Json', 'Decode']),
		'Decoder',
		_List_fromArray(
			[$author$project$Elm$Annotation$float])));
var $author$project$Elm$Gen$Json$Decode$int = A3(
	$author$project$Elm$valueWith,
	$author$project$Elm$Gen$Json$Decode$moduleName_,
	'int',
	A3(
		$author$project$Elm$Annotation$namedWith,
		_List_fromArray(
			['Json', 'Decode']),
		'Decoder',
		_List_fromArray(
			[$author$project$Elm$Annotation$int])));
var $author$project$Generate$Decode$scalar = F2(
	function (scalarName, wrapped) {
		var lowered = $elm$core$String$toLower(scalarName);
		var decoder = function () {
			switch (lowered) {
				case 'string':
					return $author$project$Elm$Gen$Json$Decode$string;
				case 'int':
					return $author$project$Elm$Gen$Json$Decode$int;
				case 'float':
					return $author$project$Elm$Gen$Json$Decode$float;
				case 'boolean':
					return $author$project$Elm$Gen$Json$Decode$bool;
				default:
					return A2(
						$author$project$Elm$get,
						'decoder',
						A2(
							$author$project$Elm$valueFrom,
							_List_fromArray(
								['Scalar']),
							$author$project$Utils$String$formatValue(scalarName)));
			}
		}();
		return A2($author$project$Generate$Decode$decodeWrapper, wrapped, decoder);
	});
var $author$project$Elm$Gen$GraphQL$Engine$list = function (arg1) {
	return A2(
		$author$project$Elm$apply,
		A3(
			$author$project$Elm$valueWith,
			$author$project$Elm$Gen$GraphQL$Engine$moduleName_,
			'list',
			A2(
				$author$project$Elm$Annotation$function,
				_List_fromArray(
					[
						A3(
						$author$project$Elm$Annotation$namedWith,
						_List_fromArray(
							['GraphQL', 'Engine']),
						'Selection',
						_List_fromArray(
							[
								$author$project$Elm$Annotation$var('source'),
								$author$project$Elm$Annotation$var('data')
							]))
					]),
				A3(
					$author$project$Elm$Annotation$namedWith,
					_List_fromArray(
						['GraphQL', 'Engine']),
					'Selection',
					_List_fromArray(
						[
							$author$project$Elm$Annotation$var('source'),
							$author$project$Elm$Annotation$list(
							$author$project$Elm$Annotation$var('data'))
						])))),
		_List_fromArray(
			[arg1]));
};
var $author$project$Elm$Gen$GraphQL$Engine$nullable = function (arg1) {
	return A2(
		$author$project$Elm$apply,
		A3(
			$author$project$Elm$valueWith,
			$author$project$Elm$Gen$GraphQL$Engine$moduleName_,
			'nullable',
			A2(
				$author$project$Elm$Annotation$function,
				_List_fromArray(
					[
						A3(
						$author$project$Elm$Annotation$namedWith,
						_List_fromArray(
							['GraphQL', 'Engine']),
						'Selection',
						_List_fromArray(
							[
								$author$project$Elm$Annotation$var('source'),
								$author$project$Elm$Annotation$var('data')
							]))
					]),
				A3(
					$author$project$Elm$Annotation$namedWith,
					_List_fromArray(
						['GraphQL', 'Engine']),
					'Selection',
					_List_fromArray(
						[
							$author$project$Elm$Annotation$var('source'),
							$author$project$Elm$Annotation$maybe(
							$author$project$Elm$Annotation$var('data'))
						])))),
		_List_fromArray(
			[arg1]));
};
var $author$project$Generate$Objects$wrapExpression = F2(
	function (wrap, exp) {
		switch (wrap.$) {
			case 'UnwrappedValue':
				return exp;
			case 'InList':
				var inner = wrap.a;
				return $author$project$Elm$Gen$GraphQL$Engine$list(
					A2($author$project$Generate$Objects$wrapExpression, inner, exp));
			default:
				var inner = wrap.a;
				return $author$project$Elm$Gen$GraphQL$Engine$nullable(
					A2($author$project$Generate$Objects$wrapExpression, inner, exp));
		}
	});
var $author$project$Generate$Objects$implementField = F5(
	function (namespace, objectName, fieldName, fieldType, wrapped) {
		implementField:
		while (true) {
			switch (fieldType.$) {
				case 'Nullable':
					var newType = fieldType.a;
					var $temp$namespace = namespace,
						$temp$objectName = objectName,
						$temp$fieldName = fieldName,
						$temp$fieldType = newType,
						$temp$wrapped = wrapped;
					namespace = $temp$namespace;
					objectName = $temp$objectName;
					fieldName = $temp$fieldName;
					fieldType = $temp$fieldType;
					wrapped = $temp$wrapped;
					continue implementField;
				case 'List_':
					var newType = fieldType.a;
					var $temp$namespace = namespace,
						$temp$objectName = objectName,
						$temp$fieldName = fieldName,
						$temp$fieldType = newType,
						$temp$wrapped = wrapped;
					namespace = $temp$namespace;
					objectName = $temp$objectName;
					fieldName = $temp$fieldName;
					fieldType = $temp$fieldType;
					wrapped = $temp$wrapped;
					continue implementField;
				case 'Scalar':
					var scalarName = fieldType.a;
					var signature = A4($author$project$Generate$Objects$fieldSignature, namespace, objectName, wrapped, fieldType);
					return {
						annotation: signature.annotation,
						expression: A2(
							$author$project$Elm$Gen$GraphQL$Engine$field,
							$author$project$Elm$string(fieldName),
							A2($author$project$Generate$Decode$scalar, scalarName, wrapped))
					};
				case 'Enum':
					var enumName = fieldType.a;
					var signature = A4($author$project$Generate$Objects$fieldSignature, namespace, objectName, wrapped, fieldType);
					return {
						annotation: signature.annotation,
						expression: A2(
							$author$project$Elm$Gen$GraphQL$Engine$field,
							$author$project$Elm$string(fieldName),
							A2(
								$author$project$Generate$Objects$decodeWrapper,
								wrapped,
								A2(
									$author$project$Elm$valueFrom,
									_List_fromArray(
										[namespace, 'Enum', enumName]),
									'decoder')))
					};
				case 'Object':
					var nestedObjectName = fieldType.a;
					return {
						annotation: A2(
							$author$project$Elm$Annotation$function,
							_List_fromArray(
								[
									A3(
									$author$project$Generate$Common$selectionLocal,
									namespace,
									nestedObjectName,
									$author$project$Elm$Annotation$var('data'))
								]),
							A3(
								$author$project$Generate$Common$selectionLocal,
								namespace,
								objectName,
								A2(
									$author$project$Generate$Objects$wrapAnnotation,
									wrapped,
									$author$project$Elm$Annotation$var('data')))),
						expression: A3(
							$author$project$Elm$lambda,
							'selection_',
							A3(
								$author$project$Generate$Common$selectionLocal,
								namespace,
								nestedObjectName,
								$author$project$Elm$Annotation$var('data')),
							function (sel) {
								return A2(
									$author$project$Elm$Gen$GraphQL$Engine$object,
									$author$project$Elm$string(fieldName),
									A2($author$project$Generate$Objects$wrapExpression, wrapped, sel));
							})
					};
				case 'Interface':
					var interfaceName = fieldType.a;
					return {
						annotation: A2(
							$author$project$Elm$Annotation$function,
							_List_fromArray(
								[
									A3(
									$author$project$Generate$Common$selectionLocal,
									namespace,
									interfaceName,
									$author$project$Elm$Annotation$var('data'))
								]),
							A3(
								$author$project$Generate$Common$selectionLocal,
								namespace,
								objectName,
								A2(
									$author$project$Generate$Objects$wrapAnnotation,
									wrapped,
									$author$project$Elm$Annotation$var('data')))),
						expression: A3(
							$author$project$Elm$lambda,
							'selection_',
							A3(
								$author$project$Generate$Common$selectionLocal,
								namespace,
								interfaceName,
								$author$project$Elm$Annotation$var('data')),
							function (sel) {
								return A2(
									$author$project$Elm$Gen$GraphQL$Engine$object,
									$author$project$Elm$string(fieldName),
									A2($author$project$Generate$Objects$wrapExpression, wrapped, sel));
							})
					};
				case 'InputObject':
					var inputName = fieldType.a;
					var signature = A4($author$project$Generate$Objects$fieldSignature, namespace, objectName, wrapped, fieldType);
					return {
						annotation: signature.annotation,
						expression: $author$project$Elm$string('unimplemented: ' + inputName)
					};
				default:
					var unionName = fieldType.a;
					return {
						annotation: A2(
							$author$project$Elm$Annotation$function,
							_List_fromArray(
								[
									A3(
									$author$project$Generate$Common$selectionLocal,
									namespace,
									unionName,
									$author$project$Elm$Annotation$var('data'))
								]),
							A3(
								$author$project$Generate$Common$selectionLocal,
								namespace,
								objectName,
								A2(
									$author$project$Generate$Objects$wrapAnnotation,
									wrapped,
									$author$project$Elm$Annotation$var('data')))),
						expression: A3(
							$author$project$Elm$lambda,
							'union_',
							A3(
								$author$project$Generate$Common$selectionLocal,
								namespace,
								unionName,
								$author$project$Elm$Annotation$var('data')),
							function (un) {
								return A2(
									$author$project$Elm$Gen$GraphQL$Engine$object,
									$author$project$Elm$string(fieldName),
									A2($author$project$Generate$Objects$wrapExpression, wrapped, un));
							})
					};
			}
		}
	});
var $author$project$Generate$Objects$objectToModule = F2(
	function (namespace, object) {
		var fieldTypesAndImpls = A3(
			$elm$core$List$foldl,
			F2(
				function (field, accDecls) {
					var implemented = A5(
						$author$project$Generate$Objects$implementField,
						namespace,
						object.name,
						field.name,
						field.type_,
						$author$project$Generate$Input$getWrap(field.type_));
					return A2(
						$elm$core$List$cons,
						_Utils_Tuple3(field.name, implemented.annotation, implemented.expression),
						accDecls);
				}),
			_List_Nil,
			object.fields);
		var objectImplementation = $author$project$Elm$record(
			A2(
				$elm$core$List$map,
				function (_v1) {
					var name = _v1.a;
					var expression = _v1.c;
					return A2(
						$author$project$Elm$field,
						$author$project$Generate$Objects$formatName(name),
						expression);
				},
				fieldTypesAndImpls));
		var objectTypeAnnotation = $author$project$Elm$Annotation$record(
			A2(
				$elm$core$List$map,
				function (_v0) {
					var name = _v0.a;
					var typeAnnotation = _v0.b;
					return _Utils_Tuple2(
						$author$project$Generate$Objects$formatName(name),
						typeAnnotation);
				},
				fieldTypesAndImpls));
		return A2(
			$author$project$Elm$declaration,
			$author$project$Utils$String$formatValue(object.name),
			A2($author$project$Elm$withType, objectTypeAnnotation, objectImplementation));
	});
var $author$project$Elm$variant = function (name) {
	return A2($author$project$Elm$Variant, name, _List_Nil);
};
var $author$project$Generate$Objects$generateFiles = F2(
	function (namespace, graphQLSchema) {
		var unionTypeDeclarations = A2(
			$elm$core$List$map,
			A2(
				$elm$core$Basics$composeR,
				$elm$core$Tuple$second,
				function ($) {
					return $.name;
				}),
			$elm$core$Dict$toList(graphQLSchema.unions));
		var queryOptionNames = A2(
			$elm$core$List$map,
			function (_v1) {
				var q = _v1.b;
				return q.name + '_Option';
			},
			$elm$core$Dict$toList(graphQLSchema.queries));
		var objects = A2(
			$elm$core$List$map,
			$elm$core$Tuple$second,
			$elm$core$Dict$toList(graphQLSchema.objects));
		var phantomTypeDeclarations = A2(
			$elm$core$List$map,
			function ($) {
				return $.name;
			},
			objects);
		var mutationOptionNames = A2(
			$elm$core$List$map,
			function (_v0) {
				var q = _v0.b;
				return q.name + '_MutOption';
			},
			$elm$core$Dict$toList(graphQLSchema.mutations));
		var optionNames = _Utils_ap(queryOptionNames, mutationOptionNames);
		var interfaces = A2(
			$elm$core$List$map,
			$elm$core$Tuple$second,
			$elm$core$Dict$toList(graphQLSchema.interfaces));
		var renderedObjects = _Utils_ap(
			A2(
				$elm$core$List$map,
				$author$project$Generate$Objects$objectToModule(namespace),
				objects),
			A2(
				$elm$core$List$map,
				$author$project$Generate$Objects$objectToModule(namespace),
				interfaces));
		var interfaceTypeDeclarations = A2(
			$elm$core$List$map,
			A2(
				$elm$core$Basics$composeR,
				$elm$core$Tuple$second,
				function ($) {
					return $.name;
				}),
			$elm$core$Dict$toList(graphQLSchema.interfaces));
		var names = _Utils_ap(
			phantomTypeDeclarations,
			_Utils_ap(unionTypeDeclarations, interfaceTypeDeclarations));
		var proofsAndAliases = A2(
			$elm$core$List$concatMap,
			function (name) {
				return _List_fromArray(
					[
						A2(
						$author$project$Elm$alias,
						name,
						A2(
							$author$project$Elm$Gen$GraphQL$Engine$types_.selection,
							A2($author$project$Elm$Annotation$named, _List_Nil, name + '_'),
							$author$project$Elm$Annotation$var('data'))),
						A2(
						$author$project$Elm$customType,
						name + '_',
						_List_fromArray(
							[
								$author$project$Elm$variant(name)
							]))
					]);
			},
			names);
		var inputTypeDeclarations = A2(
			$elm$core$List$map,
			A2(
				$elm$core$Basics$composeR,
				$elm$core$Tuple$second,
				function ($) {
					return $.name;
				}),
			$elm$core$Dict$toList(graphQLSchema.inputObjects));
		var inputHelpers = _Utils_ap(
			A2(
				$elm$core$List$concatMap,
				function (name) {
					return _List_fromArray(
						[
							A2(
							$author$project$Elm$alias,
							name,
							$author$project$Elm$Gen$GraphQL$Engine$types_.argument(
								A2($author$project$Elm$Annotation$named, _List_Nil, name + '_'))),
							A2(
							$author$project$Elm$customType,
							name + '_',
							_List_fromArray(
								[
									$author$project$Elm$variant(name)
								]))
						]);
				},
				inputTypeDeclarations),
			A2(
				$elm$core$List$map,
				function (name) {
					return A2(
						$author$project$Elm$customType,
						name,
						_List_fromArray(
							[
								$author$project$Elm$variant(name)
							]));
				},
				optionNames));
		var engine = _List_fromArray(
			[
				A2(
				$author$project$Elm$declaration,
				'select',
				A2($author$project$Elm$valueFrom, $author$project$Elm$Gen$GraphQL$Engine$moduleName_, 'select')),
				A2(
				$author$project$Elm$declaration,
				'with',
				A2($author$project$Elm$valueFrom, $author$project$Elm$Gen$GraphQL$Engine$moduleName_, 'with')),
				A2(
				$author$project$Elm$declaration,
				'map',
				A2($author$project$Elm$valueFrom, $author$project$Elm$Gen$GraphQL$Engine$moduleName_, 'map')),
				A2(
				$author$project$Elm$declaration,
				'map2',
				A2($author$project$Elm$valueFrom, $author$project$Elm$Gen$GraphQL$Engine$moduleName_, 'map2')),
				A2(
				$author$project$Elm$declaration,
				'batch',
				A2($author$project$Elm$valueFrom, $author$project$Elm$Gen$GraphQL$Engine$moduleName_, 'batch')),
				A2(
				$author$project$Elm$declaration,
				'recover',
				A2($author$project$Elm$valueFrom, $author$project$Elm$Gen$GraphQL$Engine$moduleName_, 'recover')),
				A2(
				$author$project$Elm$alias,
				'Selection',
				A2(
					$author$project$Elm$Gen$GraphQL$Engine$types_.selection,
					$author$project$Elm$Annotation$var('source'),
					$author$project$Elm$Annotation$var('data'))),
				A2(
				$author$project$Elm$alias,
				'Query',
				A2(
					$author$project$Elm$Gen$GraphQL$Engine$types_.selection,
					$author$project$Elm$Gen$GraphQL$Engine$types_.query,
					$author$project$Elm$Annotation$var('data'))),
				A2(
				$author$project$Elm$declaration,
				'query',
				A2($author$project$Elm$valueFrom, $author$project$Elm$Gen$GraphQL$Engine$moduleName_, 'query')),
				A2(
				$author$project$Elm$alias,
				'Mutation',
				A2(
					$author$project$Elm$Gen$GraphQL$Engine$types_.selection,
					$author$project$Elm$Gen$GraphQL$Engine$types_.mutation,
					$author$project$Elm$Annotation$var('data'))),
				A2(
				$author$project$Elm$declaration,
				'mutation',
				A2($author$project$Elm$valueFrom, $author$project$Elm$Gen$GraphQL$Engine$moduleName_, 'mutation'))
			]);
		return _List_fromArray(
			[
				A2(
				$author$project$Elm$file,
				_List_fromArray(
					[namespace]),
				_Utils_ap(
					engine,
					_Utils_ap(
						renderedObjects,
						_Utils_ap(proofsAndAliases, inputHelpers))))
			]);
	});
var $author$project$Elm$Gen$GraphQL$Engine$decode = function (arg1) {
	return A2(
		$author$project$Elm$apply,
		A3(
			$author$project$Elm$valueWith,
			$author$project$Elm$Gen$GraphQL$Engine$moduleName_,
			'decode',
			A2(
				$author$project$Elm$Annotation$function,
				_List_fromArray(
					[
						A3(
						$author$project$Elm$Annotation$namedWith,
						_List_fromArray(
							['Json', 'Decode']),
						'Decoder',
						_List_fromArray(
							[
								$author$project$Elm$Annotation$var('data')
							]))
					]),
				A3(
					$author$project$Elm$Annotation$namedWith,
					_List_fromArray(
						['GraphQL', 'Engine']),
					'Selection',
					_List_fromArray(
						[
							$author$project$Elm$Annotation$var('source'),
							$author$project$Elm$Annotation$var('data')
						])))),
		_List_fromArray(
			[arg1]));
};
var $author$project$Elm$functionWith = F3(
	function (name, args, _v0) {
		var body = _v0.a;
		return A3(
			$author$project$Internal$Compiler$Declaration,
			$author$project$Internal$Compiler$NotExposed,
			_Utils_ap(
				A2(
					$elm$core$List$concatMap,
					A2($elm$core$Basics$composeR, $elm$core$Tuple$first, $author$project$Internal$Compiler$getAnnotationImports),
					args),
				body.imports),
			$stil4m$elm_syntax$Elm$Syntax$Declaration$FunctionDeclaration(
				{
					declaration: $author$project$Internal$Compiler$nodify(
						{
							_arguments: $author$project$Internal$Compiler$nodifyAll(
								A2($elm$core$List$map, $elm$core$Tuple$second, args)),
							expression: $author$project$Internal$Compiler$nodify(body.expression),
							name: $author$project$Internal$Compiler$nodify(
								$author$project$Internal$Compiler$formatValue(name))
						}),
					documentation: $author$project$Internal$Compiler$nodifyMaybe($elm$core$Maybe$Nothing),
					signature: function () {
						var _v1 = body.annotation;
						if (_v1.$ === 'Ok') {
							var _return = _v1.a;
							return $elm$core$Maybe$Just(
								$author$project$Internal$Compiler$nodify(
									{
										name: $author$project$Internal$Compiler$nodify(
											$author$project$Internal$Compiler$formatValue(name)),
										typeAnnotation: $author$project$Internal$Compiler$nodify(
											$author$project$Internal$Compiler$getInnerAnnotation(
												A2(
													$author$project$Elm$Annotation$function,
													A2($elm$core$List$map, $elm$core$Tuple$first, args),
													$author$project$Internal$Compiler$noImports(_return))))
									}));
						} else {
							return $elm$core$Maybe$Nothing;
						}
					}()
				}));
	});
var $author$project$Generate$Args$justIf = F2(
	function (condition, val) {
		return condition ? $elm$core$Maybe$Just(val) : $elm$core$Maybe$Nothing;
	});
var $author$project$Generate$Args$needsInnerSelection = function (type_) {
	needsInnerSelection:
	while (true) {
		switch (type_.$) {
			case 'Scalar':
				var name = type_.a;
				return false;
			case 'InputObject':
				var name = type_.a;
				return true;
			case 'Object':
				var name = type_.a;
				return true;
			case 'Enum':
				var name = type_.a;
				return false;
			case 'Union':
				var name = type_.a;
				return true;
			case 'Interface':
				var name = type_.a;
				return true;
			case 'List_':
				var inner = type_.a;
				var $temp$type_ = inner;
				type_ = $temp$type_;
				continue needsInnerSelection;
			default:
				var inner = type_.a;
				var $temp$type_ = inner;
				type_ = $temp$type_;
				continue needsInnerSelection;
		}
	}
};
var $author$project$Elm$Gen$GraphQL$Engine$objectWith = F3(
	function (arg1, arg2, arg3) {
		return A2(
			$author$project$Elm$apply,
			A3(
				$author$project$Elm$valueWith,
				$author$project$Elm$Gen$GraphQL$Engine$moduleName_,
				'objectWith',
				A2(
					$author$project$Elm$Annotation$function,
					_List_fromArray(
						[
							$author$project$Elm$Annotation$list(
							A2(
								$author$project$Elm$Annotation$tuple,
								$author$project$Elm$Annotation$string,
								A3(
									$author$project$Elm$Annotation$namedWith,
									_List_fromArray(
										['GraphQL', 'Engine']),
									'Argument',
									_List_fromArray(
										[
											$author$project$Elm$Annotation$var('arg')
										])))),
							$author$project$Elm$Annotation$string,
							A3(
							$author$project$Elm$Annotation$namedWith,
							_List_fromArray(
								['GraphQL', 'Engine']),
							'Selection',
							_List_fromArray(
								[
									$author$project$Elm$Annotation$var('source'),
									$author$project$Elm$Annotation$var('data')
								]))
						]),
					A3(
						$author$project$Elm$Annotation$namedWith,
						_List_fromArray(
							['GraphQL', 'Engine']),
						'Selection',
						_List_fromArray(
							[
								$author$project$Elm$Annotation$var('otherSource'),
								$author$project$Elm$Annotation$var('data')
							])))),
			_List_fromArray(
				[arg1, arg2, arg3]));
	});
var $author$project$Generate$Input$operationToString = function (op) {
	if (op.$ === 'Query') {
		return 'Query';
	} else {
		return 'Mutation';
	}
};
var $author$project$Generate$Args$prepareRequiredRecursive = F3(
	function (namespace, schema, argument) {
		return A2(
			$author$project$Elm$tuple,
			$author$project$Elm$string(argument.name),
			A5(
				$author$project$Generate$Args$toEngineArg,
				namespace,
				schema,
				argument.type_,
				$author$project$Generate$Input$getWrap(argument.type_),
				A2(
					$author$project$Elm$get,
					argument.name,
					$author$project$Elm$value('required'))));
	});
var $author$project$Generate$Args$recursiveRequiredAnnotation = F3(
	function (namespace, schema, reqs) {
		return $author$project$Elm$Annotation$record(
			A2(
				$elm$core$List$map,
				function (field) {
					return _Utils_Tuple2(
						field.name,
						A4(
							$author$project$Generate$Args$inputAnnotationRecursive,
							namespace,
							schema,
							field.type_,
							$author$project$Generate$Input$getWrap(field.type_)));
				},
				reqs));
	});
var $author$project$GraphQL$Schema$Type$toString = function (t) {
	toString:
	while (true) {
		switch (t.$) {
			case 'Scalar':
				var name = t.a;
				return name;
			case 'InputObject':
				var name = t.a;
				return name;
			case 'Object':
				var name = t.a;
				return name;
			case 'Enum':
				var name = t.a;
				return name;
			case 'Union':
				var name = t.a;
				return name;
			case 'Interface':
				var name = t.a;
				return name;
			case 'List_':
				var inner = t.a;
				var $temp$t = inner;
				t = $temp$t;
				continue toString;
			default:
				var inner = t.a;
				var $temp$t = inner;
				t = $temp$t;
				continue toString;
		}
	}
};
var $author$project$GraphQL$Schema$Type$toElmString = function (t) {
	switch (t.$) {
		case 'Scalar':
			var name = t.a;
			return name;
		case 'InputObject':
			var name = t.a;
			return name;
		case 'Object':
			var name = t.a;
			return name;
		case 'Enum':
			var name = t.a;
			return name;
		case 'Union':
			var name = t.a;
			return name;
		case 'Interface':
			var name = t.a;
			return name;
		case 'List_':
			var inner = t.a;
			return '(List ' + ($author$project$GraphQL$Schema$Type$toString(inner) + ')');
		default:
			var inner = t.a;
			return '(Maybe ' + ($author$project$GraphQL$Schema$Type$toString(inner) + ')');
	}
};
var $author$project$Generate$Args$createBuilder = F6(
	function (namespace, schema, name, _arguments, returnType, operation) {
		var selectionArg = $author$project$Generate$Args$needsInnerSelection(returnType) ? $elm$core$Maybe$Just(
			_Utils_Tuple2(
				A3(
					$author$project$Generate$Common$selection,
					namespace,
					$author$project$GraphQL$Schema$Type$toString(returnType),
					$author$project$Elm$Annotation$var('data')),
				$author$project$Elm$Pattern$var('selection'))) : $elm$core$Maybe$Nothing;
		var returnSelection = $author$project$Generate$Args$needsInnerSelection(returnType) ? A3(
			$author$project$Elm$valueWith,
			_List_Nil,
			'selection',
			A3(
				$author$project$Generate$Common$selection,
				namespace,
				$author$project$GraphQL$Schema$Type$toString(returnType),
				$author$project$Elm$Annotation$var('data'))) : $author$project$Elm$Gen$GraphQL$Engine$decode(
			A2(
				$author$project$Generate$Decode$scalar,
				$author$project$GraphQL$Schema$Type$toString(returnType),
				$author$project$Generate$Input$getWrap(returnType)));
		var returnAnnotation = $author$project$Generate$Args$needsInnerSelection(returnType) ? A3(
			$author$project$Generate$Common$selection,
			namespace,
			$author$project$Generate$Input$operationToString(operation),
			$author$project$Elm$Annotation$var('data')) : A3(
			$author$project$Generate$Common$selection,
			namespace,
			$author$project$Generate$Input$operationToString(operation),
			A2(
				$author$project$Elm$Annotation$named,
				_List_Nil,
				$author$project$GraphQL$Schema$Type$toElmString(returnType)));
		var _v0 = $author$project$Generate$Input$splitRequired(_arguments);
		var required = _v0.a;
		var optional = _v0.b;
		var hasOptionalArgs = function () {
			if (!optional.b) {
				return false;
			} else {
				return true;
			}
		}();
		var optionalArgs = hasOptionalArgs ? $author$project$Elm$Gen$GraphQL$Engine$encodeOptionals(
			A3(
				$author$project$Elm$valueWith,
				_List_Nil,
				$author$project$Generate$Args$embeddedOptionsFieldName,
				$author$project$Elm$Annotation$list(
					A2($author$project$Generate$Args$annotations.localOptional, namespace, name)))) : $author$project$Elm$list(_List_Nil);
		var hasRequiredArgs = function () {
			if (!required.b) {
				return false;
			} else {
				return true;
			}
		}();
		var requiredArgs = $author$project$Elm$list(
			A2(
				$elm$core$List$map,
				A2($author$project$Generate$Args$prepareRequiredRecursive, namespace, schema),
				required));
		var _return = A2(
			$author$project$Elm$withType,
			returnAnnotation,
			A3(
				$author$project$Elm$Gen$GraphQL$Engine$objectWith,
				(hasRequiredArgs && hasOptionalArgs) ? A2($author$project$Elm$Gen$List$append, requiredArgs, optionalArgs) : (hasRequiredArgs ? requiredArgs : (hasOptionalArgs ? optionalArgs : $author$project$Elm$list(_List_Nil))),
				$author$project$Elm$string(name),
				returnSelection));
		return $author$project$Elm$expose(
			A3(
				$author$project$Elm$functionWith,
				$author$project$Utils$String$formatValue(name),
				A2(
					$elm$core$List$filterMap,
					$elm$core$Basics$identity,
					_List_fromArray(
						[
							A2(
							$author$project$Generate$Args$justIf,
							hasRequiredArgs,
							_Utils_Tuple2(
								A3($author$project$Generate$Args$recursiveRequiredAnnotation, namespace, schema, required),
								$author$project$Elm$Pattern$var('required'))),
							A2(
							$author$project$Generate$Args$justIf,
							hasOptionalArgs,
							_Utils_Tuple2(
								$author$project$Elm$Annotation$list(
									A2($author$project$Generate$Args$annotations.localOptional, namespace, name)),
								$author$project$Elm$Pattern$var($author$project$Generate$Args$embeddedOptionsFieldName))),
							selectionArg
						])),
				_return));
	});
var $author$project$Generate$Operations$directory = function (op) {
	if (op.$ === 'Query') {
		return 'Queries';
	} else {
		return 'Mutations';
	}
};
var $author$project$Generate$Example$denullable = function (type_) {
	if (type_.$ === 'Nullable') {
		var inner = type_.a;
		return inner;
	} else {
		return type_;
	}
};
var $author$project$Generate$Example$enumExample = F3(
	function (namespace, schema, enumName) {
		var _v0 = A2($elm$core$Dict$get, enumName, schema.enums);
		if (_v0.$ === 'Nothing') {
			return $author$project$Elm$value(enumName);
		} else {
			var _enum = _v0.a;
			var _v1 = _enum.values;
			if (!_v1.b) {
				return $author$project$Elm$value(enumName);
			} else {
				var top = _v1.a;
				return A2(
					$author$project$Elm$valueFrom,
					A2($author$project$Generate$Common$modules._enum, namespace, enumName),
					$author$project$Utils$String$formatTypename(top.name));
			}
		}
	});
var $author$project$Elm$bool = function (on) {
	return A3(
		$author$project$Elm$valueWith,
		_List_Nil,
		on ? 'True' : 'False',
		$author$project$Elm$Annotation$bool);
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$Floatable = function (a) {
	return {$: 'Floatable', a: a};
};
var $author$project$Elm$float = function (floatVal) {
	return $author$project$Internal$Compiler$Expression(
		{
			annotation: $elm$core$Result$Ok(
				$author$project$Internal$Compiler$getInnerAnnotation($author$project$Elm$Annotation$float)),
			expression: $stil4m$elm_syntax$Elm$Syntax$Expression$Floatable(floatVal),
			imports: _List_Nil,
			skip: false
		});
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$Integer = function (a) {
	return {$: 'Integer', a: a};
};
var $author$project$Elm$int = function (intVal) {
	return $author$project$Internal$Compiler$Expression(
		{
			annotation: $elm$core$Result$Ok(
				$author$project$Internal$Compiler$getInnerAnnotation($author$project$Elm$Annotation$int)),
			expression: $stil4m$elm_syntax$Elm$Syntax$Expression$Integer(intVal),
			imports: _List_Nil,
			skip: false
		});
};
var $author$project$Generate$Example$scalarExample = function (scalarName) {
	var _v0 = $elm$core$String$toLower(scalarName);
	switch (_v0) {
		case 'int':
			return $author$project$Elm$int(10);
		case 'float':
			return $author$project$Elm$float(10);
		case 'string':
			return $author$project$Elm$string('Example...');
		case 'boolean':
			return $author$project$Elm$bool(true);
		case 'datetime':
			return A2(
				$author$project$Elm$apply,
				A2(
					$author$project$Elm$valueFrom,
					_List_fromArray(
						['Time']),
					'millisToPosix'),
				_List_fromArray(
					[
						$author$project$Elm$int(0)
					]));
		case 'presence':
			return A2(
				$author$project$Elm$valueFrom,
				_List_fromArray(
					['Scalar']),
				'Present');
		case 'url':
			return A2(
				$author$project$Elm$valueFrom,
				_List_fromArray(
					['Scalar']),
				'fakeUrl');
		default:
			return A2(
				$author$project$Elm$apply,
				A2(
					$author$project$Elm$valueFrom,
					_List_fromArray(
						['Scalar']),
					$author$project$Utils$String$formatScalar(scalarName)),
				_List_fromArray(
					[
						$author$project$Elm$string('placeholder')
					]));
	}
};
var $elm$core$List$takeReverse = F3(
	function (n, list, kept) {
		takeReverse:
		while (true) {
			if (n <= 0) {
				return kept;
			} else {
				if (!list.b) {
					return kept;
				} else {
					var x = list.a;
					var xs = list.b;
					var $temp$n = n - 1,
						$temp$list = xs,
						$temp$kept = A2($elm$core$List$cons, x, kept);
					n = $temp$n;
					list = $temp$list;
					kept = $temp$kept;
					continue takeReverse;
				}
			}
		}
	});
var $elm$core$List$takeTailRec = F2(
	function (n, list) {
		return $elm$core$List$reverse(
			A3($elm$core$List$takeReverse, n, list, _List_Nil));
	});
var $elm$core$List$takeFast = F3(
	function (ctr, n, list) {
		if (n <= 0) {
			return _List_Nil;
		} else {
			var _v0 = _Utils_Tuple2(n, list);
			_v0$1:
			while (true) {
				_v0$5:
				while (true) {
					if (!_v0.b.b) {
						return list;
					} else {
						if (_v0.b.b.b) {
							switch (_v0.a) {
								case 1:
									break _v0$1;
								case 2:
									var _v2 = _v0.b;
									var x = _v2.a;
									var _v3 = _v2.b;
									var y = _v3.a;
									return _List_fromArray(
										[x, y]);
								case 3:
									if (_v0.b.b.b.b) {
										var _v4 = _v0.b;
										var x = _v4.a;
										var _v5 = _v4.b;
										var y = _v5.a;
										var _v6 = _v5.b;
										var z = _v6.a;
										return _List_fromArray(
											[x, y, z]);
									} else {
										break _v0$5;
									}
								default:
									if (_v0.b.b.b.b && _v0.b.b.b.b.b) {
										var _v7 = _v0.b;
										var x = _v7.a;
										var _v8 = _v7.b;
										var y = _v8.a;
										var _v9 = _v8.b;
										var z = _v9.a;
										var _v10 = _v9.b;
										var w = _v10.a;
										var tl = _v10.b;
										return (ctr > 1000) ? A2(
											$elm$core$List$cons,
											x,
											A2(
												$elm$core$List$cons,
												y,
												A2(
													$elm$core$List$cons,
													z,
													A2(
														$elm$core$List$cons,
														w,
														A2($elm$core$List$takeTailRec, n - 4, tl))))) : A2(
											$elm$core$List$cons,
											x,
											A2(
												$elm$core$List$cons,
												y,
												A2(
													$elm$core$List$cons,
													z,
													A2(
														$elm$core$List$cons,
														w,
														A3($elm$core$List$takeFast, ctr + 1, n - 4, tl)))));
									} else {
										break _v0$5;
									}
							}
						} else {
							if (_v0.a === 1) {
								break _v0$1;
							} else {
								break _v0$5;
							}
						}
					}
				}
				return list;
			}
			var _v1 = _v0.b;
			var x = _v1.a;
			return _List_fromArray(
				[x]);
		}
	});
var $elm$core$List$take = F2(
	function (n, list) {
		return A3($elm$core$List$takeFast, 0, n, list);
	});
var $author$project$Internal$Compiler$getAnnotation = function (_v0) {
	var exp = _v0.a;
	return exp.annotation;
};
var $author$project$Internal$Compiler$getInnerExpression = function (_v0) {
	var exp = _v0.a;
	return exp.expression;
};
var $author$project$Elm$maybe = function (content) {
	return $author$project$Internal$Compiler$Expression(
		{
			annotation: function () {
				if (content.$ === 'Nothing') {
					return $elm$core$Result$Ok(
						$author$project$Internal$Compiler$getInnerAnnotation(
							$author$project$Elm$Annotation$maybe(
								$author$project$Elm$Annotation$var('a'))));
				} else {
					var inner = content.a;
					return A2(
						$elm$core$Result$map,
						function (ann) {
							return A2(
								$stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Typed,
								$author$project$Internal$Compiler$nodify(
									_Utils_Tuple2(_List_Nil, 'Maybe')),
								_List_fromArray(
									[
										$author$project$Internal$Compiler$nodify(ann)
									]));
						},
						$author$project$Internal$Compiler$getAnnotation(inner));
				}
			}(),
			expression: function () {
				if (content.$ === 'Nothing') {
					return A2($stil4m$elm_syntax$Elm$Syntax$Expression$FunctionOrValue, _List_Nil, 'Nothing');
				} else {
					var inner = content.a;
					return $stil4m$elm_syntax$Elm$Syntax$Expression$Application(
						_List_fromArray(
							[
								$author$project$Internal$Compiler$nodify(
								A2($stil4m$elm_syntax$Elm$Syntax$Expression$FunctionOrValue, _List_Nil, 'Just')),
								$author$project$Internal$Compiler$nodify(
								$stil4m$elm_syntax$Elm$Syntax$Expression$ParenthesizedExpression(
									$author$project$Internal$Compiler$nodify(
										$author$project$Internal$Compiler$getInnerExpression(inner))))
							]));
				}
			}(),
			imports: A2(
				$elm$core$Maybe$withDefault,
				_List_Nil,
				A2($elm$core$Maybe$map, $author$project$Elm$getImports, content)),
			skip: false
		});
};
var $author$project$Generate$Input$wrapExpression = F2(
	function (wrapper, exp) {
		switch (wrapper.$) {
			case 'InList':
				var inner = wrapper.a;
				return $author$project$Elm$list(
					_List_fromArray(
						[
							A2($author$project$Generate$Input$wrapExpression, inner, exp)
						]));
			case 'InMaybe':
				var inner = wrapper.a;
				return $author$project$Elm$maybe(
					$elm$core$Maybe$Just(
						A2($author$project$Generate$Input$wrapExpression, inner, exp)));
			default:
				return exp;
		}
	});
var $author$project$Generate$Example$createEmbedded = F5(
	function (namespace, schema, called, name, fields) {
		var _v13 = $author$project$Generate$Input$splitRequired(fields);
		var required = _v13.a;
		var optional = _v13.b;
		var hasOptionalArgs = function () {
			if (!optional.b) {
				return false;
			} else {
				return true;
			}
		}();
		var hasRequiredArgs = function () {
			if (!required.b) {
				return false;
			} else {
				return true;
			}
		}();
		return hasRequiredArgs ? A5($author$project$Generate$Example$requiredArgsExample, namespace, schema, name, called, fields) : (hasOptionalArgs ? A8(
			$author$project$Generate$Example$optionalArgsExample,
			namespace,
			schema,
			called,
			name,
			A2($elm$core$List$take, 5, optional),
			$elm$core$Maybe$Nothing,
			$elm$core$Set$empty,
			_List_Nil) : $author$project$Elm$list(_List_Nil));
	});
var $author$project$Generate$Example$optionalArgsExample = F8(
	function (namespace, schema, called, parentName, fields, isTopLevel, calledType, prepared) {
		optionalArgsExample:
		while (true) {
			if (!fields.b) {
				return $author$project$Elm$list(
					$elm$core$List$reverse(prepared));
			} else {
				var field = fields.a;
				var remaining = fields.b;
				var typeString = $author$project$GraphQL$Schema$Type$toString(field.type_);
				if (A2($elm$core$Set$member, typeString, calledType)) {
					var $temp$namespace = namespace,
						$temp$schema = schema,
						$temp$called = called,
						$temp$parentName = parentName,
						$temp$fields = remaining,
						$temp$isTopLevel = isTopLevel,
						$temp$calledType = calledType,
						$temp$prepared = prepared;
					namespace = $temp$namespace;
					schema = $temp$schema;
					called = $temp$called;
					parentName = $temp$parentName;
					fields = $temp$fields;
					isTopLevel = $temp$isTopLevel;
					calledType = $temp$calledType;
					prepared = $temp$prepared;
					continue optionalArgsExample;
				} else {
					var unnullifiedType = $author$project$Generate$Example$denullable(field.type_);
					var optionalModule = function () {
						if (isTopLevel.$ === 'Nothing') {
							return _List_fromArray(
								[
									namespace,
									$author$project$Utils$String$formatTypename(parentName)
								]);
						} else {
							if (isTopLevel.a.$ === 'Mutation') {
								var _v11 = isTopLevel.a;
								return A2($author$project$Generate$Common$modules.mutation, namespace, parentName);
							} else {
								var _v12 = isTopLevel.a;
								return A2($author$project$Generate$Common$modules.query, namespace, parentName);
							}
						}
					}();
					var maybePrep = function () {
						var innerRequired = A5($author$project$Generate$Example$requiredArgsExampleHelper, namespace, schema, called, unnullifiedType, $author$project$Generate$Input$UnwrappedValue);
						if (innerRequired.$ === 'Nothing') {
							return $elm$core$Maybe$Nothing;
						} else {
							var inner = innerRequired.a;
							return $elm$core$Maybe$Just(
								A2(
									$author$project$Elm$apply,
									A2(
										$author$project$Elm$valueFrom,
										optionalModule,
										$author$project$Utils$String$formatValue(field.name)),
									_List_fromArray(
										[inner])));
						}
					}();
					var $temp$namespace = namespace,
						$temp$schema = schema,
						$temp$called = called,
						$temp$parentName = parentName,
						$temp$fields = remaining,
						$temp$isTopLevel = isTopLevel,
						$temp$calledType = A2($elm$core$Set$insert, typeString, calledType),
						$temp$prepared = function () {
						if (maybePrep.$ === 'Nothing') {
							return prepared;
						} else {
							var prep = maybePrep.a;
							return A2($elm$core$List$cons, prep, prepared);
						}
					}();
					namespace = $temp$namespace;
					schema = $temp$schema;
					called = $temp$called;
					parentName = $temp$parentName;
					fields = $temp$fields;
					isTopLevel = $temp$isTopLevel;
					calledType = $temp$calledType;
					prepared = $temp$prepared;
					continue optionalArgsExample;
				}
			}
		}
	});
var $author$project$Generate$Example$requiredArgsExample = F5(
	function (namespace, schema, name, called, fields) {
		var _v4 = $author$project$Generate$Input$splitRequired(fields);
		var required = _v4.a;
		var optional = _v4.b;
		return $author$project$Elm$record(
			_Utils_ap(
				A2(
					$elm$core$List$filterMap,
					function (field) {
						var innerContent = A5($author$project$Generate$Example$requiredArgsExampleHelper, namespace, schema, called, field.type_, $author$project$Generate$Input$UnwrappedValue);
						if (innerContent.$ === 'Nothing') {
							return $elm$core$Maybe$Nothing;
						} else {
							var inner = innerContent.a;
							return $elm$core$Maybe$Just(
								A2($author$project$Elm$field, field.name, inner));
						}
					},
					required),
				function () {
					if (!optional.b) {
						return _List_Nil;
					} else {
						return _List_fromArray(
							[
								A2(
								$author$project$Elm$field,
								'with_',
								A8(
									$author$project$Generate$Example$optionalArgsExample,
									namespace,
									schema,
									called,
									name,
									A2($elm$core$List$take, 5, optional),
									$elm$core$Maybe$Nothing,
									$elm$core$Set$empty,
									_List_Nil))
							]);
					}
				}()));
	});
var $author$project$Generate$Example$requiredArgsExampleHelper = F5(
	function (namespace, schema, called, type_, wrapped) {
		requiredArgsExampleHelper:
		while (true) {
			switch (type_.$) {
				case 'Nullable':
					var newType = type_.a;
					var $temp$namespace = namespace,
						$temp$schema = schema,
						$temp$called = called,
						$temp$type_ = newType,
						$temp$wrapped = $author$project$Generate$Input$InMaybe(wrapped);
					namespace = $temp$namespace;
					schema = $temp$schema;
					called = $temp$called;
					type_ = $temp$type_;
					wrapped = $temp$wrapped;
					continue requiredArgsExampleHelper;
				case 'List_':
					var newType = type_.a;
					var $temp$namespace = namespace,
						$temp$schema = schema,
						$temp$called = called,
						$temp$type_ = newType,
						$temp$wrapped = $author$project$Generate$Input$InList(wrapped);
					namespace = $temp$namespace;
					schema = $temp$schema;
					called = $temp$called;
					type_ = $temp$type_;
					wrapped = $temp$wrapped;
					continue requiredArgsExampleHelper;
				case 'Scalar':
					var scalarName = type_.a;
					return $elm$core$Maybe$Just(
						A2(
							$author$project$Generate$Input$wrapExpression,
							wrapped,
							$author$project$Generate$Example$scalarExample(scalarName)));
				case 'Enum':
					var enumName = type_.a;
					return $elm$core$Maybe$Just(
						A2(
							$author$project$Generate$Input$wrapExpression,
							wrapped,
							A3($author$project$Generate$Example$enumExample, namespace, schema, enumName)));
				case 'Object':
					var nestedObjectName = type_.a;
					return $elm$core$Maybe$Nothing;
				case 'InputObject':
					var inputName = type_.a;
					if (A2($elm$core$Set$member, inputName, called)) {
						return $elm$core$Maybe$Nothing;
					} else {
						var _v1 = A2($elm$core$Dict$get, inputName, schema.inputObjects);
						if (_v1.$ === 'Nothing') {
							return $elm$core$Maybe$Nothing;
						} else {
							var input = _v1.a;
							var newCalled = A2($elm$core$Set$insert, inputName, called);
							var _v2 = $author$project$Generate$Input$splitRequired(input.fields);
							if (!_v2.b.b) {
								var required = _v2.a;
								return $elm$core$Maybe$Just(
									A2(
										$author$project$Generate$Input$wrapExpression,
										wrapped,
										$author$project$Elm$record(
											A2(
												$elm$core$List$filterMap,
												function (field) {
													var innerContent = A5($author$project$Generate$Example$requiredArgsExampleHelper, namespace, schema, newCalled, field.type_, $author$project$Generate$Input$UnwrappedValue);
													if (innerContent.$ === 'Nothing') {
														return $elm$core$Maybe$Nothing;
													} else {
														var inner = innerContent.a;
														return $elm$core$Maybe$Just(
															A2($author$project$Elm$field, field.name, inner));
													}
												},
												required))));
							} else {
								var otherwise = _v2;
								return $elm$core$Maybe$Just(
									A2(
										$author$project$Generate$Input$wrapExpression,
										wrapped,
										A5($author$project$Generate$Example$createEmbedded, namespace, schema, newCalled, inputName, input.fields)));
							}
						}
					}
				case 'Union':
					var unionName = type_.a;
					return $elm$core$Maybe$Nothing;
				default:
					var interfaceName = type_.a;
					return $elm$core$Maybe$Nothing;
			}
		}
	});
var $author$project$Generate$Example$create = F8(
	function (namespace, schema, called, name, operationType, base, fields, _return) {
		var _v0 = $author$project$Generate$Input$splitRequired(fields);
		var required = _v0.a;
		var optional = _v0.b;
		var hasOptionalArgs = function () {
			if (!optional.b) {
				return false;
			} else {
				return true;
			}
		}();
		var optionalArgs = hasOptionalArgs ? $elm$core$Maybe$Just(
			A8(
				$author$project$Generate$Example$optionalArgsExample,
				namespace,
				schema,
				called,
				name,
				A2($elm$core$List$take, 5, optional),
				$elm$core$Maybe$Just(operationType),
				$elm$core$Set$empty,
				_List_Nil)) : $elm$core$Maybe$Nothing;
		var hasRequiredArgs = function () {
			if (!required.b) {
				return false;
			} else {
				return true;
			}
		}();
		var requiredArgs = hasRequiredArgs ? $elm$core$Maybe$Just(
			A5($author$project$Generate$Example$requiredArgsExample, namespace, schema, name, called, required)) : $elm$core$Maybe$Nothing;
		return A2(
			$author$project$Elm$apply,
			base,
			A2(
				$elm$core$List$filterMap,
				$elm$core$Basics$identity,
				_List_fromArray(
					[
						requiredArgs,
						optionalArgs,
						$elm$core$Maybe$Just(_return)
					])));
	});
var $author$project$Generate$Example$example = F6(
	function (namespace, schema, name, _arguments, returnType, op) {
		return A8(
			$author$project$Generate$Example$create,
			namespace,
			schema,
			$elm$core$Set$empty,
			name,
			op,
			A2(
				$author$project$Elm$valueFrom,
				function () {
					if (op.$ === 'Mutation') {
						return A2($author$project$Generate$Common$modules.mutation, namespace, name);
					} else {
						return A2($author$project$Generate$Common$modules.query, namespace, name);
					}
				}(),
				$author$project$Utils$String$formatValue(name)),
			_arguments,
			$author$project$Elm$value(
				'select' + $author$project$GraphQL$Schema$Type$toString(returnType)));
	});
var $author$project$Internal$Write$writeImports = function (imports) {
	return A2(
		$the_sett$elm_pretty_printer$Pretty$pretty,
		80,
		$author$project$Internal$Write$prettyImports(imports));
};
var $author$project$Elm$expressionImports = function (_v0) {
	var exp = _v0.a;
	return $author$project$Internal$Write$writeImports(
		A2(
			$elm$core$List$filterMap,
			$author$project$Internal$Compiler$makeImport(_List_Nil),
			exp.imports));
};
var $author$project$Elm$fileWith = F3(
	function (mod, options, decs) {
		return A2(
			$author$project$Elm$render,
			options.docs,
			{
				aliases: options.aliases,
				body: decs,
				imports: A3(
					$author$project$Elm$reduceDeclarationImports,
					mod,
					decs,
					_Utils_Tuple2($elm$core$Set$empty, _List_Nil)).b,
				moduleComment: '',
				moduleDefinition: mod
			});
	});
var $author$project$Internal$Write$noAliases = _List_Nil;
var $author$project$Internal$Write$writeExpression = function (exp) {
	return A2(
		$the_sett$elm_pretty_printer$Pretty$pretty,
		80,
		A2($author$project$Internal$Write$prettyExpression, $author$project$Internal$Write$noAliases, exp));
};
var $author$project$Elm$toString = function (_v0) {
	var exp = _v0.a;
	return $author$project$Internal$Write$writeExpression(exp.expression);
};
var $author$project$Generate$Operations$queryToModule = F4(
	function (namespace, op, schema, operation) {
		var queryFunction = A6($author$project$Generate$Args$createBuilder, namespace, schema, operation.name, operation._arguments, operation.type_, op);
		var optionalHelpers = function () {
			if (A2($elm$core$List$any, $author$project$Generate$Input$isOptional, operation._arguments)) {
				var topLevelAlias = $author$project$Elm$expose(
					A2(
						$author$project$Elm$alias,
						'Optional',
						$author$project$Elm$Gen$GraphQL$Engine$types_.optional(
							A2(
								$author$project$Elm$Annotation$named,
								_List_fromArray(
									[namespace]),
								function () {
									if (op.$ === 'Query') {
										return operation.name + '_Option';
									} else {
										return operation.name + '_MutOption';
									}
								}()))));
				var optional = A2($elm$core$List$filter, $author$project$Generate$Input$isOptional, operation._arguments);
				return A2(
					$elm$core$List$cons,
					topLevelAlias,
					_Utils_ap(
						A4($author$project$Generate$Args$optionsRecursive, namespace, schema, operation.name, optional),
						_List_fromArray(
							[
								$author$project$Elm$expose(
								A2(
									$author$project$Elm$declaration,
									'null',
									A3($author$project$Generate$Args$nullsRecord, namespace, operation.name, optional)))
							])));
			} else {
				return _List_Nil;
			}
		}();
		var example = A6($author$project$Generate$Example$example, namespace, schema, operation.name, operation._arguments, operation.type_, op);
		var dir = $author$project$Generate$Operations$directory(op);
		return A3(
			$author$project$Elm$fileWith,
			_List_fromArray(
				[
					namespace,
					dir,
					$author$project$Utils$String$formatTypename(operation.name)
				]),
			{
				aliases: _List_Nil,
				docs: function (docs) {
					return '\n\nExample usage:\n\n' + ($author$project$Elm$expressionImports(example) + ('\n\n\n' + $author$project$Elm$toString(example)));
				}
			},
			A2($elm$core$List$cons, queryFunction, optionalHelpers));
	});
var $author$project$Generate$Operations$generateFiles = F3(
	function (namespace, op, schema) {
		if (op.$ === 'Mutation') {
			return A2(
				$elm$core$List$map,
				function (_v1) {
					var oper = _v1.b;
					return A4($author$project$Generate$Operations$queryToModule, namespace, op, schema, oper);
				},
				$elm$core$Dict$toList(schema.mutations));
		} else {
			return A2(
				$elm$core$List$map,
				function (_v2) {
					var oper = _v2.b;
					return A4($author$project$Generate$Operations$queryToModule, namespace, op, schema, oper);
				},
				$elm$core$Dict$toList(schema.queries));
		}
	});
var $elm$core$List$singleton = function (value) {
	return _List_fromArray(
		[value]);
};
var $author$project$GraphQL$Schema$Kind$toString = function (kind) {
	switch (kind.$) {
		case 'Object':
			var name_ = kind.a;
			return name_;
		case 'Scalar':
			var name_ = kind.a;
			return name_;
		case 'InputObject':
			var name_ = kind.a;
			return name_;
		case 'Enum':
			var name_ = kind.a;
			return name_;
		case 'Union':
			var name_ = kind.a;
			return name_;
		default:
			var name_ = kind.a;
			return name_;
	}
};
var $author$project$Elm$Gen$GraphQL$Engine$union = function (arg1) {
	return A2(
		$author$project$Elm$apply,
		A3(
			$author$project$Elm$valueWith,
			$author$project$Elm$Gen$GraphQL$Engine$moduleName_,
			'union',
			A2(
				$author$project$Elm$Annotation$function,
				_List_fromArray(
					[
						$author$project$Elm$Annotation$list(
						A2(
							$author$project$Elm$Annotation$tuple,
							$author$project$Elm$Annotation$string,
							A3(
								$author$project$Elm$Annotation$namedWith,
								_List_fromArray(
									['GraphQL', 'Engine']),
								'Selection',
								_List_fromArray(
									[
										$author$project$Elm$Annotation$var('source'),
										$author$project$Elm$Annotation$var('data')
									]))))
					]),
				A3(
					$author$project$Elm$Annotation$namedWith,
					_List_fromArray(
						['GraphQL', 'Engine']),
					'Selection',
					_List_fromArray(
						[
							$author$project$Elm$Annotation$var('source'),
							$author$project$Elm$Annotation$var('data')
						])))),
		_List_fromArray(
			[arg1]));
};
var $author$project$Elm$Gen$GraphQL$Engine$unsafe = function (arg1) {
	return A2(
		$author$project$Elm$apply,
		A3(
			$author$project$Elm$valueWith,
			$author$project$Elm$Gen$GraphQL$Engine$moduleName_,
			'unsafe',
			A2(
				$author$project$Elm$Annotation$function,
				_List_fromArray(
					[
						A3(
						$author$project$Elm$Annotation$namedWith,
						_List_fromArray(
							['GraphQL', 'Engine']),
						'Selection',
						_List_fromArray(
							[
								$author$project$Elm$Annotation$var('source'),
								$author$project$Elm$Annotation$var('selected')
							]))
					]),
				A3(
					$author$project$Elm$Annotation$namedWith,
					_List_fromArray(
						['GraphQL', 'Engine']),
					'Selection',
					_List_fromArray(
						[
							$author$project$Elm$Annotation$var('unsafe'),
							$author$project$Elm$Annotation$var('selected')
						])))),
		_List_fromArray(
			[arg1]));
};
var $author$project$Generate$Unions$generateFiles = F2(
	function (namespace, graphQLSchema) {
		return $elm$core$List$singleton(
			A2(
				$author$project$Elm$file,
				_List_fromArray(
					[namespace, 'Unions']),
				A2(
					$elm$core$List$concatMap,
					function (_v0) {
						var unionDefinition = _v0.b;
						var record = A3(
							$author$project$Elm$fn,
							unionDefinition.name,
							_Utils_Tuple2(
								'fragments',
								$author$project$Elm$Annotation$record(
									A2(
										$elm$core$List$map,
										function (_var) {
											return _Utils_Tuple2(
												$author$project$GraphQL$Schema$Kind$toString(_var.kind),
												A3(
													$author$project$Generate$Common$selection,
													namespace,
													$author$project$GraphQL$Schema$Kind$toString(_var.kind),
													$author$project$Elm$Annotation$var('data')));
										},
										unionDefinition.variants))),
							function (fragments) {
								return A2(
									$author$project$Elm$withType,
									A3(
										$author$project$Generate$Common$selection,
										namespace,
										unionDefinition.name,
										$author$project$Elm$Annotation$var('data')),
									$author$project$Elm$Gen$GraphQL$Engine$union(
										$author$project$Elm$list(
											A2(
												$elm$core$List$map,
												function (_var) {
													return A2(
														$author$project$Elm$tuple,
														$author$project$Elm$string(
															$author$project$GraphQL$Schema$Kind$toString(_var.kind)),
														$author$project$Elm$Gen$GraphQL$Engine$unsafe(
															A2(
																$author$project$Elm$get,
																$author$project$GraphQL$Schema$Kind$toString(_var.kind),
																fragments)));
												},
												unionDefinition.variants))));
							});
						return _List_fromArray(
							[
								$author$project$Elm$expose(record)
							]);
					},
					$elm$core$Dict$toList(graphQLSchema.unions))));
	});
var $author$project$Generate$generateSchema = F2(
	function (namespace, schema) {
		var unionFiles = A2($author$project$Generate$Unions$generateFiles, namespace, schema);
		var queryFiles = A3($author$project$Generate$Operations$generateFiles, namespace, $author$project$Generate$Input$Query, schema);
		var objectFiles = A2($author$project$Generate$Objects$generateFiles, namespace, schema);
		var mutationFiles = A3($author$project$Generate$Operations$generateFiles, namespace, $author$project$Generate$Input$Mutation, schema);
		var inputFiles = A2($author$project$Generate$InputObjects$generateFiles, namespace, schema);
		var enumFiles = A2($author$project$Generate$Enums$generateFiles, namespace, schema);
		return $author$project$Elm$Gen$files(
			_Utils_ap(
				unionFiles,
				_Utils_ap(
					enumFiles,
					_Utils_ap(
						objectFiles,
						_Utils_ap(
							queryFiles,
							_Utils_ap(mutationFiles, inputFiles))))));
	});
var $elm$json$Json$Decode$decodeString = _Json_runOnString;
var $elm$http$Http$BadStatus_ = F2(
	function (a, b) {
		return {$: 'BadStatus_', a: a, b: b};
	});
var $elm$http$Http$BadUrl_ = function (a) {
	return {$: 'BadUrl_', a: a};
};
var $elm$http$Http$GoodStatus_ = F2(
	function (a, b) {
		return {$: 'GoodStatus_', a: a, b: b};
	});
var $elm$http$Http$NetworkError_ = {$: 'NetworkError_'};
var $elm$http$Http$Receiving = function (a) {
	return {$: 'Receiving', a: a};
};
var $elm$http$Http$Sending = function (a) {
	return {$: 'Sending', a: a};
};
var $elm$http$Http$Timeout_ = {$: 'Timeout_'};
var $elm$core$Maybe$isJust = function (maybe) {
	if (maybe.$ === 'Just') {
		return true;
	} else {
		return false;
	}
};
var $elm$core$Platform$sendToSelf = _Platform_sendToSelf;
var $elm$core$Dict$getMin = function (dict) {
	getMin:
	while (true) {
		if ((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) {
			var left = dict.d;
			var $temp$dict = left;
			dict = $temp$dict;
			continue getMin;
		} else {
			return dict;
		}
	}
};
var $elm$core$Dict$moveRedLeft = function (dict) {
	if (((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) && (dict.e.$ === 'RBNode_elm_builtin')) {
		if ((dict.e.d.$ === 'RBNode_elm_builtin') && (dict.e.d.a.$ === 'Red')) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v1 = dict.d;
			var lClr = _v1.a;
			var lK = _v1.b;
			var lV = _v1.c;
			var lLeft = _v1.d;
			var lRight = _v1.e;
			var _v2 = dict.e;
			var rClr = _v2.a;
			var rK = _v2.b;
			var rV = _v2.c;
			var rLeft = _v2.d;
			var _v3 = rLeft.a;
			var rlK = rLeft.b;
			var rlV = rLeft.c;
			var rlL = rLeft.d;
			var rlR = rLeft.e;
			var rRight = _v2.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				$elm$core$Dict$Red,
				rlK,
				rlV,
				A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					rlL),
				A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, rK, rV, rlR, rRight));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v4 = dict.d;
			var lClr = _v4.a;
			var lK = _v4.b;
			var lV = _v4.c;
			var lLeft = _v4.d;
			var lRight = _v4.e;
			var _v5 = dict.e;
			var rClr = _v5.a;
			var rK = _v5.b;
			var rV = _v5.c;
			var rLeft = _v5.d;
			var rRight = _v5.e;
			if (clr.$ === 'Black') {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var $elm$core$Dict$moveRedRight = function (dict) {
	if (((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) && (dict.e.$ === 'RBNode_elm_builtin')) {
		if ((dict.d.d.$ === 'RBNode_elm_builtin') && (dict.d.d.a.$ === 'Red')) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v1 = dict.d;
			var lClr = _v1.a;
			var lK = _v1.b;
			var lV = _v1.c;
			var _v2 = _v1.d;
			var _v3 = _v2.a;
			var llK = _v2.b;
			var llV = _v2.c;
			var llLeft = _v2.d;
			var llRight = _v2.e;
			var lRight = _v1.e;
			var _v4 = dict.e;
			var rClr = _v4.a;
			var rK = _v4.b;
			var rV = _v4.c;
			var rLeft = _v4.d;
			var rRight = _v4.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				$elm$core$Dict$Red,
				lK,
				lV,
				A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, llK, llV, llLeft, llRight),
				A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					lRight,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight)));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v5 = dict.d;
			var lClr = _v5.a;
			var lK = _v5.b;
			var lV = _v5.c;
			var lLeft = _v5.d;
			var lRight = _v5.e;
			var _v6 = dict.e;
			var rClr = _v6.a;
			var rK = _v6.b;
			var rV = _v6.c;
			var rLeft = _v6.d;
			var rRight = _v6.e;
			if (clr.$ === 'Black') {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var $elm$core$Dict$removeHelpPrepEQGT = F7(
	function (targetKey, dict, color, key, value, left, right) {
		if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) {
			var _v1 = left.a;
			var lK = left.b;
			var lV = left.c;
			var lLeft = left.d;
			var lRight = left.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				color,
				lK,
				lV,
				lLeft,
				A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, key, value, lRight, right));
		} else {
			_v2$2:
			while (true) {
				if ((right.$ === 'RBNode_elm_builtin') && (right.a.$ === 'Black')) {
					if (right.d.$ === 'RBNode_elm_builtin') {
						if (right.d.a.$ === 'Black') {
							var _v3 = right.a;
							var _v4 = right.d;
							var _v5 = _v4.a;
							return $elm$core$Dict$moveRedRight(dict);
						} else {
							break _v2$2;
						}
					} else {
						var _v6 = right.a;
						var _v7 = right.d;
						return $elm$core$Dict$moveRedRight(dict);
					}
				} else {
					break _v2$2;
				}
			}
			return dict;
		}
	});
var $elm$core$Dict$removeMin = function (dict) {
	if ((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) {
		var color = dict.a;
		var key = dict.b;
		var value = dict.c;
		var left = dict.d;
		var lColor = left.a;
		var lLeft = left.d;
		var right = dict.e;
		if (lColor.$ === 'Black') {
			if ((lLeft.$ === 'RBNode_elm_builtin') && (lLeft.a.$ === 'Red')) {
				var _v3 = lLeft.a;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					color,
					key,
					value,
					$elm$core$Dict$removeMin(left),
					right);
			} else {
				var _v4 = $elm$core$Dict$moveRedLeft(dict);
				if (_v4.$ === 'RBNode_elm_builtin') {
					var nColor = _v4.a;
					var nKey = _v4.b;
					var nValue = _v4.c;
					var nLeft = _v4.d;
					var nRight = _v4.e;
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						$elm$core$Dict$removeMin(nLeft),
						nRight);
				} else {
					return $elm$core$Dict$RBEmpty_elm_builtin;
				}
			}
		} else {
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				color,
				key,
				value,
				$elm$core$Dict$removeMin(left),
				right);
		}
	} else {
		return $elm$core$Dict$RBEmpty_elm_builtin;
	}
};
var $elm$core$Dict$removeHelp = F2(
	function (targetKey, dict) {
		if (dict.$ === 'RBEmpty_elm_builtin') {
			return $elm$core$Dict$RBEmpty_elm_builtin;
		} else {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_cmp(targetKey, key) < 0) {
				if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Black')) {
					var _v4 = left.a;
					var lLeft = left.d;
					if ((lLeft.$ === 'RBNode_elm_builtin') && (lLeft.a.$ === 'Red')) {
						var _v6 = lLeft.a;
						return A5(
							$elm$core$Dict$RBNode_elm_builtin,
							color,
							key,
							value,
							A2($elm$core$Dict$removeHelp, targetKey, left),
							right);
					} else {
						var _v7 = $elm$core$Dict$moveRedLeft(dict);
						if (_v7.$ === 'RBNode_elm_builtin') {
							var nColor = _v7.a;
							var nKey = _v7.b;
							var nValue = _v7.c;
							var nLeft = _v7.d;
							var nRight = _v7.e;
							return A5(
								$elm$core$Dict$balance,
								nColor,
								nKey,
								nValue,
								A2($elm$core$Dict$removeHelp, targetKey, nLeft),
								nRight);
						} else {
							return $elm$core$Dict$RBEmpty_elm_builtin;
						}
					}
				} else {
					return A5(
						$elm$core$Dict$RBNode_elm_builtin,
						color,
						key,
						value,
						A2($elm$core$Dict$removeHelp, targetKey, left),
						right);
				}
			} else {
				return A2(
					$elm$core$Dict$removeHelpEQGT,
					targetKey,
					A7($elm$core$Dict$removeHelpPrepEQGT, targetKey, dict, color, key, value, left, right));
			}
		}
	});
var $elm$core$Dict$removeHelpEQGT = F2(
	function (targetKey, dict) {
		if (dict.$ === 'RBNode_elm_builtin') {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_eq(targetKey, key)) {
				var _v1 = $elm$core$Dict$getMin(right);
				if (_v1.$ === 'RBNode_elm_builtin') {
					var minKey = _v1.b;
					var minValue = _v1.c;
					return A5(
						$elm$core$Dict$balance,
						color,
						minKey,
						minValue,
						left,
						$elm$core$Dict$removeMin(right));
				} else {
					return $elm$core$Dict$RBEmpty_elm_builtin;
				}
			} else {
				return A5(
					$elm$core$Dict$balance,
					color,
					key,
					value,
					left,
					A2($elm$core$Dict$removeHelp, targetKey, right));
			}
		} else {
			return $elm$core$Dict$RBEmpty_elm_builtin;
		}
	});
var $elm$core$Dict$remove = F2(
	function (key, dict) {
		var _v0 = A2($elm$core$Dict$removeHelp, key, dict);
		if ((_v0.$ === 'RBNode_elm_builtin') && (_v0.a.$ === 'Red')) {
			var _v1 = _v0.a;
			var k = _v0.b;
			var v = _v0.c;
			var l = _v0.d;
			var r = _v0.e;
			return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, k, v, l, r);
		} else {
			var x = _v0;
			return x;
		}
	});
var $elm$core$Dict$update = F3(
	function (targetKey, alter, dictionary) {
		var _v0 = alter(
			A2($elm$core$Dict$get, targetKey, dictionary));
		if (_v0.$ === 'Just') {
			var value = _v0.a;
			return A3($elm$core$Dict$insert, targetKey, value, dictionary);
		} else {
			return A2($elm$core$Dict$remove, targetKey, dictionary);
		}
	});
var $elm$http$Http$expectStringResponse = F2(
	function (toMsg, toResult) {
		return A3(
			_Http_expect,
			'',
			$elm$core$Basics$identity,
			A2($elm$core$Basics$composeR, toResult, toMsg));
	});
var $elm$core$Result$mapError = F2(
	function (f, result) {
		if (result.$ === 'Ok') {
			var v = result.a;
			return $elm$core$Result$Ok(v);
		} else {
			var e = result.a;
			return $elm$core$Result$Err(
				f(e));
		}
	});
var $elm$http$Http$BadBody = function (a) {
	return {$: 'BadBody', a: a};
};
var $elm$http$Http$BadStatus = function (a) {
	return {$: 'BadStatus', a: a};
};
var $elm$http$Http$BadUrl = function (a) {
	return {$: 'BadUrl', a: a};
};
var $elm$http$Http$NetworkError = {$: 'NetworkError'};
var $elm$http$Http$Timeout = {$: 'Timeout'};
var $elm$http$Http$resolve = F2(
	function (toResult, response) {
		switch (response.$) {
			case 'BadUrl_':
				var url = response.a;
				return $elm$core$Result$Err(
					$elm$http$Http$BadUrl(url));
			case 'Timeout_':
				return $elm$core$Result$Err($elm$http$Http$Timeout);
			case 'NetworkError_':
				return $elm$core$Result$Err($elm$http$Http$NetworkError);
			case 'BadStatus_':
				var metadata = response.a;
				return $elm$core$Result$Err(
					$elm$http$Http$BadStatus(metadata.statusCode));
			default:
				var body = response.b;
				return A2(
					$elm$core$Result$mapError,
					$elm$http$Http$BadBody,
					toResult(body));
		}
	});
var $elm$http$Http$expectJson = F2(
	function (toMsg, decoder) {
		return A2(
			$elm$http$Http$expectStringResponse,
			toMsg,
			$elm$http$Http$resolve(
				function (string) {
					return A2(
						$elm$core$Result$mapError,
						$elm$json$Json$Decode$errorToString,
						A2($elm$json$Json$Decode$decodeString, decoder, string));
				}));
	});
var $author$project$GraphQL$Schema$introspection = '\nquery IntrospectionQuery {\n    __schema {\n      queryType {\n        name\n      }\n      mutationType {\n        name\n      }\n      subscriptionType {\n        name\n      }\n      types {\n        ...FullType\n      }\n    }\n  }\n  fragment FullType on __Type {\n    kind\n    name\n    description\n    fields(includeDeprecated: true) {\n      name\n      description\n      args {\n        ...InputValue\n      }\n      type {\n        ...TypeRef\n      }\n      isDeprecated\n      deprecationReason\n    }\n    inputFields {\n      ...InputValue\n    }\n    interfaces {\n      ...TypeRef\n    }\n    enumValues(includeDeprecated: true) {\n      name\n      description\n      isDeprecated\n      deprecationReason\n    }\n    possibleTypes {\n      ...TypeRef\n    }\n  }\n  fragment InputValue on __InputValue {\n    name\n    description\n    type {\n      ...TypeRef\n    }\n    defaultValue\n  }\n  fragment TypeRef on __Type {\n    kind\n    name\n    ofType {\n      kind\n      name\n      ofType {\n        kind\n        name\n        ofType {\n          kind\n          name\n          ofType {\n            kind\n            name\n            ofType {\n              kind\n              name\n              ofType {\n                kind\n                name\n                ofType {\n                  kind\n                  name\n                }\n              }\n            }\n          }\n        }\n      }\n    }\n  }\n';
var $elm$http$Http$jsonBody = function (value) {
	return A2(
		_Http_pair,
		'application/json',
		A2($elm$json$Json$Encode$encode, 0, value));
};
var $elm$http$Http$Request = function (a) {
	return {$: 'Request', a: a};
};
var $elm$http$Http$State = F2(
	function (reqs, subs) {
		return {reqs: reqs, subs: subs};
	});
var $elm$core$Task$succeed = _Scheduler_succeed;
var $elm$http$Http$init = $elm$core$Task$succeed(
	A2($elm$http$Http$State, $elm$core$Dict$empty, _List_Nil));
var $elm$core$Task$andThen = _Scheduler_andThen;
var $elm$core$Process$kill = _Scheduler_kill;
var $elm$core$Platform$sendToApp = _Platform_sendToApp;
var $elm$core$Process$spawn = _Scheduler_spawn;
var $elm$http$Http$updateReqs = F3(
	function (router, cmds, reqs) {
		updateReqs:
		while (true) {
			if (!cmds.b) {
				return $elm$core$Task$succeed(reqs);
			} else {
				var cmd = cmds.a;
				var otherCmds = cmds.b;
				if (cmd.$ === 'Cancel') {
					var tracker = cmd.a;
					var _v2 = A2($elm$core$Dict$get, tracker, reqs);
					if (_v2.$ === 'Nothing') {
						var $temp$router = router,
							$temp$cmds = otherCmds,
							$temp$reqs = reqs;
						router = $temp$router;
						cmds = $temp$cmds;
						reqs = $temp$reqs;
						continue updateReqs;
					} else {
						var pid = _v2.a;
						return A2(
							$elm$core$Task$andThen,
							function (_v3) {
								return A3(
									$elm$http$Http$updateReqs,
									router,
									otherCmds,
									A2($elm$core$Dict$remove, tracker, reqs));
							},
							$elm$core$Process$kill(pid));
					}
				} else {
					var req = cmd.a;
					return A2(
						$elm$core$Task$andThen,
						function (pid) {
							var _v4 = req.tracker;
							if (_v4.$ === 'Nothing') {
								return A3($elm$http$Http$updateReqs, router, otherCmds, reqs);
							} else {
								var tracker = _v4.a;
								return A3(
									$elm$http$Http$updateReqs,
									router,
									otherCmds,
									A3($elm$core$Dict$insert, tracker, pid, reqs));
							}
						},
						$elm$core$Process$spawn(
							A3(
								_Http_toTask,
								router,
								$elm$core$Platform$sendToApp(router),
								req)));
				}
			}
		}
	});
var $elm$http$Http$onEffects = F4(
	function (router, cmds, subs, state) {
		return A2(
			$elm$core$Task$andThen,
			function (reqs) {
				return $elm$core$Task$succeed(
					A2($elm$http$Http$State, reqs, subs));
			},
			A3($elm$http$Http$updateReqs, router, cmds, state.reqs));
	});
var $elm$http$Http$maybeSend = F4(
	function (router, desiredTracker, progress, _v0) {
		var actualTracker = _v0.a;
		var toMsg = _v0.b;
		return _Utils_eq(desiredTracker, actualTracker) ? $elm$core$Maybe$Just(
			A2(
				$elm$core$Platform$sendToApp,
				router,
				toMsg(progress))) : $elm$core$Maybe$Nothing;
	});
var $elm$core$Task$map2 = F3(
	function (func, taskA, taskB) {
		return A2(
			$elm$core$Task$andThen,
			function (a) {
				return A2(
					$elm$core$Task$andThen,
					function (b) {
						return $elm$core$Task$succeed(
							A2(func, a, b));
					},
					taskB);
			},
			taskA);
	});
var $elm$core$Task$sequence = function (tasks) {
	return A3(
		$elm$core$List$foldr,
		$elm$core$Task$map2($elm$core$List$cons),
		$elm$core$Task$succeed(_List_Nil),
		tasks);
};
var $elm$http$Http$onSelfMsg = F3(
	function (router, _v0, state) {
		var tracker = _v0.a;
		var progress = _v0.b;
		return A2(
			$elm$core$Task$andThen,
			function (_v1) {
				return $elm$core$Task$succeed(state);
			},
			$elm$core$Task$sequence(
				A2(
					$elm$core$List$filterMap,
					A3($elm$http$Http$maybeSend, router, tracker, progress),
					state.subs)));
	});
var $elm$http$Http$Cancel = function (a) {
	return {$: 'Cancel', a: a};
};
var $elm$http$Http$cmdMap = F2(
	function (func, cmd) {
		if (cmd.$ === 'Cancel') {
			var tracker = cmd.a;
			return $elm$http$Http$Cancel(tracker);
		} else {
			var r = cmd.a;
			return $elm$http$Http$Request(
				{
					allowCookiesFromOtherDomains: r.allowCookiesFromOtherDomains,
					body: r.body,
					expect: A2(_Http_mapExpect, func, r.expect),
					headers: r.headers,
					method: r.method,
					timeout: r.timeout,
					tracker: r.tracker,
					url: r.url
				});
		}
	});
var $elm$http$Http$MySub = F2(
	function (a, b) {
		return {$: 'MySub', a: a, b: b};
	});
var $elm$http$Http$subMap = F2(
	function (func, _v0) {
		var tracker = _v0.a;
		var toMsg = _v0.b;
		return A2(
			$elm$http$Http$MySub,
			tracker,
			A2($elm$core$Basics$composeR, toMsg, func));
	});
_Platform_effectManagers['Http'] = _Platform_createManager($elm$http$Http$init, $elm$http$Http$onEffects, $elm$http$Http$onSelfMsg, $elm$http$Http$cmdMap, $elm$http$Http$subMap);
var $elm$http$Http$command = _Platform_leaf('Http');
var $elm$http$Http$subscription = _Platform_leaf('Http');
var $elm$http$Http$request = function (r) {
	return $elm$http$Http$command(
		$elm$http$Http$Request(
			{allowCookiesFromOtherDomains: false, body: r.body, expect: r.expect, headers: r.headers, method: r.method, timeout: r.timeout, tracker: r.tracker, url: r.url}));
};
var $elm$http$Http$post = function (r) {
	return $elm$http$Http$request(
		{body: r.body, expect: r.expect, headers: _List_Nil, method: 'POST', timeout: $elm$core$Maybe$Nothing, tracker: $elm$core$Maybe$Nothing, url: r.url});
};
var $author$project$GraphQL$Schema$get = F2(
	function (url, toMsg) {
		return $elm$http$Http$post(
			{
				body: $elm$http$Http$jsonBody(
					$elm$json$Json$Encode$object(
						_List_fromArray(
							[
								_Utils_Tuple2(
								'query',
								$elm$json$Json$Encode$string($author$project$GraphQL$Schema$introspection))
							]))),
				expect: A2(
					$elm$http$Http$expectJson,
					toMsg,
					A2($elm$json$Json$Decode$field, 'data', $author$project$GraphQL$Schema$decoder)),
				url: url
			});
	});
var $author$project$Generate$httpErrorToString = function (err) {
	switch (err.$) {
		case 'BadUrl':
			var msg = err.a;
			return 'Bad Url: ' + msg;
		case 'Timeout':
			return 'Timeout';
		case 'NetworkError':
			return 'Network Error';
		case 'BadStatus':
			var status = err.a;
			return 'Bad Status: ' + $elm$core$String$fromInt(status);
		default:
			var msg = err.a;
			return 'Bad Body: ' + msg;
	}
};
var $elm$core$Platform$Sub$batch = _Platform_batch;
var $elm$core$Platform$Sub$none = $elm$core$Platform$Sub$batch(_List_Nil);
var $elm$core$Platform$worker = _Platform_worker;
var $author$project$Generate$main = $elm$core$Platform$worker(
	{
		init: function (flags) {
			var decoded = A2($elm$json$Json$Decode$decodeValue, $author$project$Generate$flagsDecoder, flags);
			if (decoded.$ === 'Err') {
				var err = decoded.a;
				return _Utils_Tuple2(
					{flags: flags, input: $author$project$Generate$InputError, namespace: 'Api'},
					$author$project$Elm$Gen$error(
						{
							description: $elm$json$Json$Decode$errorToString(err),
							title: 'Error decoding flags'
						}));
			} else {
				var input = decoded.a;
				switch (input.$) {
					case 'InputError':
						return _Utils_Tuple2(
							{flags: flags, input: $author$project$Generate$InputError, namespace: 'Api'},
							$author$project$Elm$Gen$error(
								{description: '', title: 'Error decoding flags'}));
					case 'SchemaInline':
						var schema = input.a;
						return _Utils_Tuple2(
							{flags: flags, input: input, namespace: 'Api'},
							A2($author$project$Generate$generateSchema, 'Api', schema));
					default:
						var details = input.a;
						return _Utils_Tuple2(
							{flags: flags, input: input, namespace: details.namespace},
							A2($author$project$GraphQL$Schema$get, details.schema, $author$project$Generate$SchemaReceived));
				}
			}
		},
		subscriptions: function (_v2) {
			return $elm$core$Platform$Sub$none;
		},
		update: F2(
			function (msg, model) {
				if (msg.a.$ === 'Ok') {
					var schema = msg.a.a;
					return _Utils_Tuple2(
						model,
						A2($author$project$Generate$generateSchema, model.namespace, schema));
				} else {
					var err = msg.a.a;
					return _Utils_Tuple2(
						model,
						$author$project$Elm$Gen$error(
							{
								description: 'Something went wrong with retrieving the schema.\n\n    ' + $author$project$Generate$httpErrorToString(err),
								title: 'Error retieving schema'
							}));
				}
			})
	});
_Platform_export({'Generate':{'init':$author$project$Generate$main($elm$json$Json$Decode$value)(0)}});}(this));