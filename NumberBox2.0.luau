local NumberBox = {}
NumberBox.__index = NumberBox

function NumberBox.new(
	inputType: "Int" | "Float",
	min: number?,
	max: number?,
	default: number?,
)
	if inputType ~= "Int" and inputType ~= "Float" then
		warn("'InputType' is not valid! Defaulting to 'Float'")
		inputType = "Float"
	end
	
	local self = {}
	setmetatable(self, NumberBox)
	
	self.Value = default or 0
	self.Min = min or -math.huge
	self.Max = max or math.huge
	self.InputType = inputType
	
	self._Textbox = nil
	self._FocusLostEnv = nil
	self._Changed = Instance.new("BindableEvent")
	
	self.Changed = {
		Connect = function(_, callback)
			assert(typeof(callback) == "function", "Attempt to connect failed: Passed value is not a function")
			return self._Changed.Event:Connect(callback)
		end
	}
	
	return self
end

function NumberBox:Bind(inputBox: TextBox)
	assert(inputBox, "Param 1 must be a TextBox")
	
	self._Textbox = inputBox
	self._FocusLostEnv = self._Textbox.FocusLost:Connect(function(enterPressed)
		local newValue = tonumber(self._Textbox.Text)
		if not newValue then
			self._Textbox.Text = self.Value
			return
		end

		if self.InputType == "Int" then
			newValue = math.round(newValue)
		end

		if newValue < self.Min then
			newValue = self.Min
		elseif newValue > self.Max then
			newValue = self.Max
		end

		self.Value = newValue
		self._Textbox.Text = self.Value
	end)
end

function NumberBox:Unbind()
	self._Textbox = nil
	
	if self._FocusLostEnv then
		self._FocusLostEnv:Disconnect()
		self._FocusLostEnv = nil
	end
end

function NumberBox:Destroy()
	self:Unbind()
	self._Changed:Destroy()
	self._Changed = nil
	self = nil
end

return NumberBox
