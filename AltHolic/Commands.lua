------------------------------------------------------------------------------------------
-- Command file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
AltHolicCommand = Turbine.ShellCommand();
------------------------------------------------------------------------------------------
-- commands
------------------------------------------------------------------------------------------
function AltHolicCommand:Execute( command, arguments )
-- Turn arguments to lower case characters --
	local args, value = arguments:match "(delete) (.*)";

	arguments = string.lower(arguments);
------------------------------------------------------------------------------------------
-- Help command--
------------------------------------------------------------------------------------------
	if ( arguments == "help" ) then
		commandsHelp();
------------------------------------------------------------------------------------------
-- show command--
------------------------------------------------------------------------------------------
	elseif ( arguments == "show" ) then
		AltHolicWindow:SetVisible(true);
		settings["isWindowVisible"]["isWindowVisible"] = true;
------------------------------------------------------------------------------------------
-- hide command--
------------------------------------------------------------------------------------------
	elseif ( arguments == "hide" ) then
		AltHolicWindow:SetVisible(false);
		settings["isWindowVisible"]["isWindowVisible"] = false;
------------------------------------------------------------------------------------------
-- options window command --
------------------------------------------------------------------------------------------
	elseif ( arguments == "options" ) then
		Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginOptionShowWindow" ]);
		GenerateOptionsWindow();
		OptionsWindow:SetVisible(true);
		AltHolicWindow:SetVisible(false);
		settings["isWindowVisible"]["isWindowVisible"] = false;
		settings["isOptionsWindowVisible"]["isOptionsWindowVisible"] = true;
------------------------------------------------------------------------------------------
-- options window Bar command --
------------------------------------------------------------------------------------------
	elseif ( arguments == "optionsbar" ) then
		Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginOptionShowWindowBar" ]);
		GenerateOptionsWindowBar();
		OptionsWindowBar:SetVisible(true);
		settings["isOptionsWindowBarVisible"]["isOptionsWindowBarVisible"] = true;
------------------------------------------------------------------------------------------
-- esc command--
------------------------------------------------------------------------------------------
	elseif ( arguments == "esc" ) then
		if(settings["escEnable"]["escEnable"] == true) then
			Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginEscDesable" ]);
			settings["escEnable"]["escEnable"] = false;
		else
			Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginEscEnable" ]);
			settings["escEnable"]["escEnable"] = true;
		end
------------------------------------------------------------------------------------------
-- alt command--
------------------------------------------------------------------------------------------
	elseif ( arguments == "alt" ) then
		if(settings["altEnable"]["altEnable"] == true) then
			Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginAltDesable" ]);
			settings["altEnable"]["altEnable"] = false;
		else
			Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginAltEnable" ]);
			settings["altEnable"]["altEnable"] = true;
		end
------------------------------------------------------------------------------------------
-- toggle command--
------------------------------------------------------------------------------------------
	elseif ( arguments == "toggle" ) then
		if (settings["isWindowVisible"]["isWindowVisible"] == true) then
			Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginToggleOff" ]);
			AltHolicWindow:SetVisible(false);
			settings["isWindowVisible"]["isWindowVisible"] = false;
		else
			Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginToggleOn" ]);
			AltHolicWindow:SetVisible(true);
			settings["isWindowVisible"]["isWindowVisible"] = true;
		end
------------------------------------------------------------------------------------------
-- icon command--
------------------------------------------------------------------------------------------
	elseif ( arguments == "icon" ) then
		if (settings["isMinimizeEnabled"]["isMinimizeEnabled"] == true) then
			Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginEscIconOff" ]);
			MainMinimizedIcon:SetVisible(false);
			settings["isMinimizeEnabled"]["isMinimizeEnabled"] = false;
		else
			Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginEscIconOn" ]);
			MainMinimizedIcon:SetVisible(true);
			settings["isMinimizeEnabled"]["isMinimizeEnabled"] = true;
		end
------------------------------------------------------------------------------------------
-- clear command--
------------------------------------------------------------------------------------------
	elseif ( args == "delete" ) then
		if(value ~= "" ) then
			if(value == "all")then
				CreateToBeSurWindow("", 2);
				ToBeSurWindow:SetVisible(true);
			else
				CreateToBeSurWindow(value, 1);
				ToBeSurWindow:SetVisible(true);
			end
		end
------------------------------------------------------------------------------------------
-- ServerNameWindow command--
------------------------------------------------------------------------------------------
	elseif ( arguments == "server" ) then
		GenerateServerNameWindow(PlayerName);
		ServerNameWindow:SetVisible(true);
------------------------------------------------------------------------------------------
-- default if nothing is right command--
------------------------------------------------------------------------------------------
	elseif ( arguments ~= "help" or 
			arguments ~= "show" or 
			arguments ~= "hide" or 
			arguments ~= "options" or 
			arguments ~= "esc" or 
			arguments ~= "alt" or 
			arguments ~= "toggle" or 
			arguments ~= "icon" or 
			arguments ~= "list") then
			-- nothing found, so display the help
		commandsHelp();
	end
end
------------------------------------------------------------------------------------------
-- Add command line --
------------------------------------------------------------------------------------------
Turbine.Shell.AddCommand( "Alt;AltHolic", AltHolicCommand );