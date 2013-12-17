-----------
-- API that holds miscellaneous function for CCGrapher
-- @author Symmetric, Wobbo
-- @module api
-- @alias M

local M = {}

--- Create a derivative for a function
-- This function takes two arguments, a function and a delta. The delta can be left unspecified. The function returned is an approximation for the derivative of the given function, and delta specifies the accuracy, where a smaller delta results in a higher accuracy. 
-- @tparam func _f The function to derive from
-- @tparam number delta The accuracy of the derivation, defaults to 1e-4
-- @treturn func The derivative of _f
M.derive = function(_f, _delta)
	local delta = _delta or 1e-4
	return function(x)
		return (_f(x + delta) - _f(x)) / delta
	end
end

--- Creates an equation object
-- @param f The function that the equation will use to create values
-- @return The equation
M.eq = function(_f)
	return setmetatable({f = _f}, {
		__index = function(self, _key)
			self[_key] = self.f(_key)
			return self[_key]
		end;
	})
end

--- Finds the solution to an equation using Newton-Raphson method
-- @param eq The equation that you are solving
-- @param eq_derive The derivative function of eq
-- @param var The variable you are solving for
-- @param init The initial guess
-- @param loop How many loops the approximation should go through
-- @return The solution
M.nr = function(_eq, _eq_derive, _var, _init, _loop)
	local ans = _init or 0.1
	for i = 1, _loop or 5 do
		ans = ans - _eq(ans) / _eq_derive(_eq, _ans)
	end
	return ans
end

--- Funciton for implicit equations
-- @param api The api itself (call using `:` syntactic sugar)
-- @param str The string of the equation
-- @return The equation solved for x
-- @return The equation solved for y
M.impl = function(api, _str)
	local f = loadstring("return ".._str:gsub("(.-)=(.+)", "(%1)-(%2)"))
	local fx = function(x)
		return api:nr(setfenv(f, {x = x, math = math}), api.derive, "y")
	end
	local fy = function(y)
		return api:nr(setfenv(f, {y = y, math = math}), api.derive, "x")
	end
	return api:eq(fx), api:eq(fy)
end

return M