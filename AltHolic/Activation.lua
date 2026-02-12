------------------------------------------------------------------------------------------
-- Activation file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Activate Plugin --
------------------------------------------------------------------------------------------
Plugins[pluginName].Load = function()
	notification("Version " .. Plugins[pluginName]:GetVersion() .. " " .. T[ "PluginText" ] .. ", " .. T[ "Loaded" ]);

	LoadPlayerDatas();
	--Write("Player data Loaded...");
	--PlayerName = Player:GetName();
	--Write("vocation value : " .. PlayerDatas[PlayerName].voc);
end
------------------------------------------------------------------------------------------
-- Unload Plugin --
------------------------------------------------------------------------------------------
Plugins[pluginName].Unload = function()	

	SaveSettings();

	 if(settings["nameAccount"]["account1"]["name"] ~= "")then
		
		SavePlayerBags();
		SavePlayerDatas();
		SavePlayerWallet();

		if(Player:GetAlignment() == 1)then
			if(vaultHasBeenUpdated == true)then
				SavePlayerVault();
			end
			if(sharedStorageHasBeenUpdated == true)then
				SaveSharedStorage();
			end
			SavePlayerEquipment();
			GetDataForProfessions();
			SavePlayerProfessions();
		end
	 end

	notification(T[ "Unactivated" ]);
end