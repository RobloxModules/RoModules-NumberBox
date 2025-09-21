<p align="center">
  <h1 align="center"><big>NumberBox</big></h1>
</p>

**NumberBox** is a Roblox module that handles number box input easily and bug-free for you<br>
Also comes with customization such as integer-only input, and a minimum/maximum to inputs.

Example Usage:
```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NumberBox = require(ReplicatedStorage.NumberBox)

local textBox = script.Parent
local numBox = NumberBox.new("Int", 0, 10, 1)
numBox:Bind(textBox)

numBox.Changed:Connect(function(newValue)
  print("Value changed to " .. newValue)
end)

textBox.Destroying:Connect(function()
  numBox:Destroy()
end)
```

Created by [Zalthen](https://www.roblox.com/users/1377987741/profile)
