------------------------------------------------------------------------------------------
-- Notification file
-- Written by Henna95
------------------------------------------------------------------------------------------

-- Readable dump of any value (tables are expanded recursively).
local function Quote(value)
	return '"' .. tostring(value) .. '"';
end

local function Dump(value, indent)
	indent = indent or "";
	if type(value) ~= "table" then return Quote(value); end

	local innerIndent = indent .. "  ";
	local parts = {};
	for key, item in pairs(value) do
		if type(key) ~= "number" then key = Quote(key); end
		parts[#parts + 1] = innerIndent .. "[" .. tostring(key) .. "] = " .. Dump(item, innerIndent);
	end
	return indent .. "array {\n" .. table.concat(parts, ", \n") .. "\n" .. indent .. "}";
end

------------------------------------------------------------------------------------------
-- Sends notifications to chat. Non-string values are dumped. (The dump helper used to be
-- a global named "debug", which replaced Lua's standard debug library for the plugin.)
------------------------------------------------------------------------------------------
function notification(message)
	if message == nil then message = "nil"; end
	if type(message) ~= "string" then message = Dump(message); end
	Turbine.Shell.WriteLine(rgb["start"] .. T["PluginName"] .. rgb["clear"] .. ": " .. message);
end
