------------------------------------------------------------------------------------------
-- define librairies
------------------------------------------------------------------------------------------
import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Turbine.UI.Extensions";
import "Turbine.Gameplay";
------------------------------------------------------------------------------------------
-- Import Globals --
------------------------------------------------------------------------------------------
if Turbine.Engine.GetLanguage() == Turbine.Language.German then
	import "Homeopatix.AltHolic.Localization.GlobalsDE";
	GLocale = "de";
elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
	import "Homeopatix.AltHolic.Localization.GlobalsFR";
	GLocale = "fr";
elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
	import "Homeopatix.AltHolic.Localization.GlobalsEN";
	GLocale = "en";
end
------------------------------------------------------------------------------------------
-- Import Utility --
------------------------------------------------------------------------------------------
import "Homeopatix.AltHolic.OfflineItemInfoControl";
import "Homeopatix.AltHolic.Notification";
import "Homeopatix.AltHolic.LoadAndSave";
import "Homeopatix.AltHolic.MinimizedIcon";
import "Homeopatix.AltHolic.VindarPatch";
import "Homeopatix.AltHolic.CalcStat";
import "Homeopatix.AltHolic.DropDown";
import "Homeopatix.AltHolic.FCT";
import "Homeopatix.AltHolic.FCT_2";
import "Homeopatix.AltHolic.FCT_Display";
import "Homeopatix.AltHolic.FCT_Utility";
import "Homeopatix.AltHolic.FCT_Windows";
import "Homeopatix.AltHolic.FCT_EscapeKey";
------------------------------------------------------------------------------------------
-- Import initialization --
------------------------------------------------------------------------------------------
import "Homeopatix.AltHolic.Init";
import "Homeopatix.AltHolic.Activation";
import "Homeopatix.AltHolic.PlayerStats";
------------------------------------------------------------------------------------------
-- Import Scripts --
------------------------------------------------------------------------------------------
import "Homeopatix.AltHolic.Main";
------------------------------------------------------------------------------------------
-- Import UI elements --
------------------------------------------------------------------------------------------
import "Homeopatix.AltHolic.UI";
import "Homeopatix.AltHolic.UI_Bar";
import "Homeopatix.AltHolic.UIAddNew";
import "Homeopatix.AltHolic.UIAddNewEpique";
import "Homeopatix.AltHolic.UIAddNewReput";
import "Homeopatix.AltHolic.UIShowEquip";
import "Homeopatix.AltHolic.UIShowBag";
import "Homeopatix.AltHolic.UIShowVault";
import "Homeopatix.AltHolic.UIShowSharedStorage";
import "Homeopatix.AltHolic.UISearch";
import "Homeopatix.AltHolic.UIShowCash";
import "Homeopatix.AltHolic.UIShowEpique";
import "Homeopatix.AltHolic.UIShowWallet";
import "Homeopatix.AltHolic.HelpWindow";
import "Homeopatix.AltHolic.InfoWindow";
import "Homeopatix.AltHolic.UIInfos";
import "Homeopatix.AltHolic.GendreWindow";
import "Homeopatix.AltHolic.UIShowStats";
import "Homeopatix.AltHolic.UIShowLotro";
import "Homeopatix.AltHolic.UIShowLvlEquip";
import "Homeopatix.AltHolic.UIShowReput";
import "Homeopatix.AltHolic.OptionsWindow";
import "Homeopatix.AltHolic.OptionsWindowVocation";
import "Homeopatix.AltHolic.OptionsWindowBar";
import "Homeopatix.AltHolic.ServerNameWindow";
import "Homeopatix.AltHolic.UIToBeSur";
import "Homeopatix.AltHolic.UIShowXP";
import "Homeopatix.AltHolic.UIAddNewXP";
------------------------------------------------------------------------------------------
-- Import Commands --
------------------------------------------------------------------------------------------
import "Homeopatix.AltHolic.Commands";