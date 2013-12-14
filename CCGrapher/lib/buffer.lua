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
		return {
			def = {_t and _t[1] or colors.white, _t and _t[2] or colors.lightGray, _t and _t[3] or " "};
			order = {};
			cache = index({}, {});
			pos = {0, 0};
			size = {x = {1, max_x}, y = {1, max_y}};
			buffer = function(self, _n)
				local t = index({
					pos = {0, 0};
					pixel = function(buffer, _x, _y, _p)
						local p = buffer[_x + buffer.pos[1] + self.pos[1]][_y + buffer.pos[2] + self.pos[2]]
						if _q then
							for i = 1, 3 do
								p[i] = q[i] or p[i]
							end
						end
						return p
					end;
					write = function(buffer, _str, _x, _y, _text, _back)
						for x = 1, #_str do
							buffer:pixel(x + _x - 1, _y, {_back, _text, _str:sub(x, x)})
						end
						return buffer
					end;
					rect = function(buffer, _x1, _y1, _x2, _y2, _back, _text, _char)
						for x = _x1, _x2 do
							for y = _y1, _y2 do
								buffer:pixel(x, y, {_back, _text, _char})
							end
						end
					end;
				}, {})
				self.order[_n or (#self.order + 1)] = t
				return t
			end;
			render = function(self)
				local t = index({
					draw = function(buffer)
						for x = self.size.x[1], self.size.x[2] do
							local p1 = buffer[x]
							for y = self.size.y[1], self.size.y[2] do
								local p2 = p1[y]
								term.setCursorPos(x, y)
								term.setBackgroundColor(p2[1])
								term.setTextColor(p2[2])
								term.write(p2[3])
								self.cache[x][y] = p2
							end
						end
					end;
				}, self.def)
				for x = self.size.x[1], self.size.x[2] do
					local p1 = t[x]
					for y = self.size.y[1], self.size.y[2] do
						local p2 = p1[y]
						for i = #self.order, 1, -1 do
							local buffer = self.order[i]
							local pi = buffer[x + buffer.pos[1] + self.pos[1]][y + buffer.pos[2] + self.pos[2]]
							for j = 1, 3 do
								p2[j] = p2[j] or pi[j]
							end
							if p2[1] and p2[2] and p2[3] then
								break
							end
						end
					end
				end
				return t
			end;
		}
	end;
}