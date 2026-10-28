------------------------------------------------------------------------------------------
-- Command file: /alt and /altholic
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
AltHolicCommand = Turbine.ShellCommand();

local function Say(textKey)
	Write(rgb["start"] .. T["PluginName"] .. rgb["clear"] .. " - " .. T[textKey]);
end

local function ToggleSetting(group, field, onKey, offKey)
	local enabled = not (settings[group][field] == true);
	settings[group][field] = enabled;
	Say(enabled and onKey or offKey);
	return enabled;
end

local function ConfirmDelete(target)
	if target == nil or target == "" then return; end
	if string.lower(target) == "all" then
		CreateToBeSurWindow("", 2);
	else
		CreateToBeSurWindow(target, 1);
	end
	ToBeSurWindow:SetVisible(true);
	settings["isToBeSurWindowVisible"]["value"] = true;
end

local COMMANDS = {
	help = commandsHelp,

	show = ShowMainWindow,
	hide = HideMainWindow,

	toggle = function()
		if AltHolicWindow ~= nil and AltHolicWindow:IsVisible() then
			Say("PluginToggleOff");
			HideMainWindow();
		else
			Say("PluginToggleOn");
			ShowMainWindow();
		end
	end,

	options = function()
		Say("PluginOptionShowWindow");
		GenerateOptionsWindow();
		OptionsWindow:SetVisible(true);
		settings["isOptionsWindowVisible"]["isOptionsWindowVisible"] = true;
		HideMainWindow();
	end,

	optionsbar = function()
		Say("PluginOptionShowWindowBar");
		GenerateOptionsWindowBar();
		OptionsWindowBar:SetVisible(true);
		settings["isOptionsWindowBarVisible"]["isOptionsWindowBarVisible"] = true;
	end,

	esc = function()
		-- Messages: "Escape disabled" when it was enabled, and vice versa.
		ToggleSetting("escEnable", "escEnable", "PluginEscEnable", "PluginEscDesable");
	end,

	alt = function()
		ToggleSetting("altEnable", "altEnable", "PluginAltEnable", "PluginAltDesable");
	end,

	-- Show or hide the floating launcher icon (for this session).
	icon = function()
		ToggleSetting("isLauncherVisible", "value", "PluginEscIconOn", "PluginEscIconOff");
		UpdateMinimizedIcon();
	end,

	server = function()
		GenerateServerNameWindow(PlayerName);
		settings["isServerWindowVisible"]["value"] = true;
		ServerNameWindow:SetVisible(true);
	end,
};

------------------------------------------------------------------------------------------
-- commands
------------------------------------------------------------------------------------------
function AltHolicCommand:Execute(command, arguments)
	arguments = arguments or "";

	-- "/alt delete Name" and "/alt clear Name" (the help text has always said "clear").
	-- The character name keeps its original case.
	local verb, target = string.match(arguments, "^%s*(%a+)%s+(.-)%s*$");
	if verb ~= nil and (string.lower(verb) == "delete" or string.lower(verb) == "clear") then
		ConfirmDelete(target);
		return;
	end

	local handler = COMMANDS[string.lower(string.match(arguments, "^%s*(.-)%s*$"))];
	if handler ~= nil then
		handler();
	else
		-- Unknown or empty command: display help.
		commandsHelp();
	end
end
------------------------------------------------------------------------------------------
-- Add command line --
------------------------------------------------------------------------------------------
Turbine.Shell.AddCommand("Alt;AltHolic", AltHolicCommand);
