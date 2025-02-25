local mod = {}

function mod.New(
	frame: TextBox, 
	valueObject: ValueBase, 
	
	inputMustBeInt: boolean?, 
	minInput: number?, 
	maxInput: number?
)
	assert(typeof(frame) == "Instance" and frame:IsA("TextBox"), "Argument 1 must be a TextBox")
	assert(typeof(valueObject) == "Instance" and valueObject:IsA("ValueBase"), "Argument 2 must be a Value object.")
	
	if typeof(inputMustBeInt) ~= "boolean" then inputMustBeInt = false end
	if typeof(maxInput) ~= "number" then minInput = -math.huge end
	if typeof(maxInput) ~= "number" then maxInput = -math.huge end
	
	local self = {}
	self.Update = mod.Update
	
	self.Textbox = frame
	self.ValueObject = valueObject
	
	self.PreviousInput = valueObject.Value
	self.MinValue = minInput
	self.MaxValue = maxInput
	self.OnlyIntValues = inputMustBeInt
	
	self.EventConnections = {}
	
	self.EventConnections[1] = valueObject:GetPropertyChangedSignal("Value"):Connect(function()
		return self:Update()
	end)
	
	self.EventConnections[2] = self.Textbox.FocusLost:Connect(function()
		local numberInput = tonumber(self.Textbox.Text)
		if numberInput then
			if inputMustBeInt then
				valueObject.Value = math.round(numberInput)
			else
				valueObject.Value = numberInput
			end
		else
			self.Textbox.Text = valueObject.Value
		end
	end)
	
	self:Update()
	return self
end

function mod:Update()
	self.Textbox.Text = self.ValueObject.Value
end

function mod:Dispose()
	for i, connection in pairs(self.EventConnections) do
		connection:Disconnect()
		self.EventConnections[i] = nil
	end
end

return mod
