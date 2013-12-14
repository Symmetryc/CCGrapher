---------------------
-- Table functions --
---------------------

--- create a deep copy of _t.
-- This functions creates a deep copy of _t
-- @param _t The table to be copied
-- @return A deep copy of _t
function copy(_t)
	local t = {}
	for k, v in pairs(_t) do
		t[k] = (type(v) == "table" and copy(v)) or v
	end
	return t
end

--- Check two tables for equality.
-- This function checks whether two tables are equal, by checking if the fields are equal
-- @param t1 The first table to be checked for equality
-- @param t2 The second table to be checked for equality
-- @return Whether or not t1 and t2 are equal
function equal(t1, t2)
	if #t1 ~= #t2 then
		return false
	end
	local i, eq = 1, true
	while i <= #t1 and eq do
		if type(t1[i]) ~= type(t2[i]) then
			eq = false
		else
			eq = (type(t1[i]) == "table" and equal(t1[i], t2[i])) or (t1[i] == t2[i])
		end
		i = i + 1
	end
	return eq
end

--------------------
-- Math Functions --
--------------------

--- Round to the nearest integer.
-- This function takes a number, and rounds it to the nearest integer
-- @param num The number to be rounded
-- @return The integer nearest to num
function round(num)
	return math.floor(num+0.5)
end

--- Create a derivative for a function
-- This function takes two arguments, a function and a delta. The delta can be left unspecified.The function returned is an approximation for the derivative of the given function, and delta specifies the accuracy, where a smaller delta results in a higher accuracy. 
-- @param f The function to derive from
-- @param delta The accuracy of the derivation, defaults to 1e-4
-- @return The derivative of f
function derive(f, delta)
	delta = delta or 1e-4
	return function(x)
		return ((f(x+delta) - f(x))/delta)
	end
end

