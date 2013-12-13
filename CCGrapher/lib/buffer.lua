local max_x, max_y = term.getSize()
local index = function(_t, _m)
	return setmetatable(_t, {
		__index = function(self, key)
			self[key] = setmetatable({}, {
				__index = function(self2, key2)
					self2[key2] = _m
					return self2[key2]
				end;
			})
			return self[key]
		end;
	})
end
return {
	new = function(_t)
		return setmetatable({
				order = {[0] = index({pos = {0, 0}}, _t)};
				cache = index({}, {})
				pos = {0, 0};
				size = {x = {1, max_x}, y = {1, max_y}};
				buffer = function(self, _n)
					self.order[_n or #self.order + 1] = index({pos = {0, 0}}, {})
				end;
				render = function(self)
					for x = self.size.x[1], self.size.x[2] do
						for y = self.size.y[1], self.size.y[2] do
							local p = {}
							for i = #self.order, 0, -1 do
								local buffer = self.order[i]
								local pi = buffer[x + buffer.pos[1] + self.pos[1]][y + buffer.pos[2] + self.pos[2]]
								for j = 1, 3 do
									p[j] = p[j] or pi[j]
								end
								if p[1] and p[2] and p[3] then
									break
								end
							end
							term.setCursorPos(x, y)
							term.setBackgroundColor(p[1])
							term.setTextColor(p[2])
							term.write(p[3])
						end
					end
				end;
			},
			{
				__index = function(self, key)
					for k, v in pairs(self.order) do
						if k == key then
							return v
						end
					end
				end;
			}
		)
	end;
}