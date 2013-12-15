return {
-- Create a derivative for a function
-- This function takes two arguments, a function and a delta. The delta can be left unspecified.The function returned is an approximation for the derivative of the given function, and delta specifies the accuracy, where a smaller delta results in a higher accuracy. 
-- @param f The function to derive from
-- @param delta The accuracy of the derivation, defaults to 1e-4
-- @return The derivative of f
derive = function(f, delta)
	delta = delta or 1e-4
	return function(x)
		return ((f(x+delta) - f(x))/delta)
	end
end,
}