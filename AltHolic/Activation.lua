------------------------------------------------------------------------------------------
-- Activation file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
-- Character data is already loaded by PlayerStats at import time; Load only announces.
------------------------------------------------------------------------------------------
Plugins[pluginName].Load = function()
	notification(T["PluginVersionLabel"] .. " " .. Plugins[pluginName]:GetVersion() .. " " .. T["PluginText"] .. ", " .. T["Loaded"]);
	notification(rgb["gold"] .. T["PluginCommandsHint"] .. rgb["clear"]);
end
------------------------------------------------------------------------------------------
-- Unload: write everything that may still be pending.
------------------------------------------------------------------------------------------
Plugins[pluginName].Unload = function()
	-- Write any debounced inventory saves still waiting for their timer.
	AltHolicUtil.RunDeferred();

	SaveSettings();

	if settings["nameAccount"]["account1"]["name"] ~= "" then
		SavePlayerBags();
		SavePlayerDatas();
		SavePlayerWallet();

		if Player:GetAlignment() == 1 then
			if vaultHasBeenUpdated == true then SavePlayerVault(); end
			if sharedStorageHasBeenUpdated == true then SaveSharedStorage(); end
			SavePlayerEquipment();
			RefreshCurrentPlayerProfessions(PlayerName, true);
		end
	end

	notification(T["Unactivated"]);
end
