return {
	new = function()
		return {
			act = {pos = {}};
			pos = {};
			back = colors.white;
			text = colors.lightGray;
			write = function(self, _str)
				local act = self.act
				local selfpos = self.pos
				local append = true
				if selfpos[1] ~= act.pos[1] or selfpos[2] ~= act.pos[2] then
					act[#act + 1] = {term.setCursorPos, selfpos[1], selfpos[2]}
					append = false
				end
				if self.back ~= act.back then
					act[#act + 1] = {term.setBackgroundColor, self.back}
					act.back = self.back
					append = false
				end
				if self.text ~= act.text then
					act[#act + 1] = {term.setTextColor, self.text}
					act.text = self.text
					append = false
				end
				for line, nl in _str:gmatch("([^\n]*)(\n?)") do
					if append then
						act[#act][2] = act[#act][2]..line
						append = false
					else
						act[#act + 1] = {term.write, line}
					end
					selfpos[1] = selfpos[1] + #line
					if nl == "\n" then
						selfpos[1] = 1
						selfpos[2] = selfpos[2] + 1
						act[#act + 1] = {term.setCursorPos, 1, selfpos[2]}
					end
				end
				act.pos = {selfpos[1], selfpos[2]}
				return self
			end;
			draw = function(self)
				for i, v in ipairs(self.act) do
					if v[3] then
						v[1](v[2], v[3])
					else
						v[1](v[2])
					end
				end
				self.act = {}
				return self
			end;
		}
	end;
}