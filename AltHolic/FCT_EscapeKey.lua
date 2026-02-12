------------------------------------------------------------------------------------------
-- FCT file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- event handling
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
--- escape key handler for the main windows ---
------------------------------------------------------------------------------------------
function EscapeKeyHandler()
	hudVisible=true; -- the actual HUD state is not exposed to Lua so we have to assume the HUD is visible when the plugin loads
	sampleWindowVisible=false; -- used to retain the state of the window for when the HUD is toggled back on

	AltHolicWindow.KeyDown=function(sender, args)
	  if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then -- hide the window due to Escape
			if(settings["escEnable"]["escEnable"] == true) then
				AltHolicWindow:SetVisible( false );
				settings["isWindowVisible"]["isWindowVisible"] = false;
			end
	  elseif ( args.Action == 268435635 ) then -- toggle HUD (the HUD action is not defined in the Turbine.UI.Lotro.Action enumeration although it should be)
		hudVisible=not hudVisible;
		if not hudVisible then
			AltHolicWindow:SetVisible(sampleWindowVisible);
			settings["isWindowVisible"]["isWindowVisible"] = sampleWindowVisible;
			MainTinyIcon:SetVisible(sampleWindowVisible);
			MainTinyIcon24:SetVisible(sampleWindowVisible);
			MainTinyIcon16:SetVisible(sampleWindowVisible);
			MainMinimizedIcon:SetVisible(sampleWindowVisible);
		else
		  sampleWindowVisible=AltHolicWindow:IsVisible();
		  AltHolicWindow:SetVisible(true);
			settings["isWindowVisible"]["isWindowVisible"] = true;
			if(settings["iconSize"]["value"] == 64)then
				MainMinimizedIcon:SetVisible(true);
				MainTinyIcon:SetVisible(false);
				MainTinyIcon24:SetVisible(false);
				MainTinyIcon16:SetVisible(false);
				MainMinimizedIcon:SetPosition(settings["IconPosition"]["xPosIcon"], settings["IconPosition"]["yPosIcon"]);
			elseif(settings["iconSize"]["value"] == 32)then
				MainMinimizedIcon:SetVisible(false);
				MainTinyIcon:SetVisible(true);
				MainTinyIcon24:SetVisible(false);
				MainTinyIcon16:SetVisible(false);
				MainTinyIcon:SetPosition(settings["IconPosition"]["xPosIcon"], settings["IconPosition"]["yPosIcon"]);
			elseif(settings["iconSize"]["value"] == 24)then
				MainMinimizedIcon:SetVisible(false);
				MainTinyIcon:SetVisible(false);
				MainTinyIcon24:SetVisible(true);
				MainTinyIcon16:SetVisible(false);
				MainTinyIcon24:SetPosition(settings["IconPosition"]["xPosIcon"], settings["IconPosition"]["yPosIcon"]);
			elseif(settings["iconSize"]["value"] == 16)then
				MainMinimizedIcon:SetVisible(false);
				MainTinyIcon:SetVisible(false);
				MainTinyIcon24:SetVisible(false);
				MainTinyIcon16:SetVisible(true);
				MainTinyIcon16:SetPosition(settings["IconPosition"]["xPosIcon"], settings["IconPosition"]["yPosIcon"]);
			end
		end
	  end
	end
end

------------------------------------------------------------------------------------------
--- escape key handler for windows ---
------------------------------------------------------------------------------------------
function EscapeKeyHandlerForWindows(WindowsToHanlde, SettingsDatas)
	WindowsToHanlde.KeyDown=function(sender, args)
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			WindowsToHanlde:SetVisible(false);
			SettingsDatas = false;
		end
	
		if ( args.Action == 268435635 ) then
			WindowsToHanlde:SetVisible(false);
			SettingsDatas = false;
		end
	end
end