local Input = script.Parent.Parent
local Display = Input.Parent.display

local Colors = {
	[Color3.fromRGB(248, 109, 124)] = {'local'},
	[Color3.fromRGB(97, 161, 241)] = {'Transparency'},
	[Color3.fromRGB(255, 198, 0)] = {'1'}
}

local ColorizePattern = '<font color="rgb(%d, %d, %d)">%s</font>'

local function Colorize(keyword, color)
	return string.format(ColorizePattern, color.r*255, color.g*255, color.b*255, keyword)
end

local function ProcessText(text)
	for color, keywords in pairs(Colors) do
		for _, keyword in pairs(keywords) do
			text = string.gsub(text, keyword, Colorize(keyword, color))
		end
	end
	
	return text
end

local function InputChanged()
	local text = Input.Text
	
	task.defer(function()
		Display.Text = ProcessText(text)
		return
	end)
end

Input.FocusLost:ConnectParallel(InputChanged)