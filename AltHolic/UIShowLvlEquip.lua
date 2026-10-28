------------------------------------------------------------------------------------------
-- Equipment level / armour editor
------------------------------------------------------------------------------------------
local EQUIPMENT_TITLE_KEYS = {
    Head = "PluginEquipement5", Chest = "PluginEquipement6", Legs = "PluginEquipement7", Gloves = "PluginEquipement8",
    Boots = "PluginEquipement9", Shoulder = "PluginEquipement10", Back = "PluginEquipement11", Bracelet1 = "PluginEquipement12",
    Bracelet2 = "PluginEquipement13", Necklace = "PluginEquipement14", Ring1 = "PluginEquipement15", Ring2 = "PluginEquipement16",
    Earring1 = "PluginEquipement17", Earring2 = "PluginEquipement18", Pocket = "PluginEquipement19", PrimaryWeapon = "PluginEquipement20",
    Shield = "PluginEquipement21", RangedWeapon = "PluginEquipement22", CraftTool = "PluginEquipement23", ClassE = "PluginEquipement24",
};
local SINGLE_VALUE_SLOTS = { Bracelet1=true, Bracelet2=true, Earring1=true, Earring2=true, Ring1=true, Ring2=true, Necklace=true, CraftTool=true, ClassE=true, Pocket=true };
local SINGLE_VALUE_WEAPON_CATEGORIES = { [19]=true, [11]=true, [48]=true, [13]=true, [106]=true };

function CreateUIShowLvlEquip(namePlayerToshow, itemName)
    if UIShowLvlEquip ~= nil then
        AltHolicUtil.DetachControl(UIShowLvlEquip);
        UIShowLvlEquip = nil;
    end
    local equipment = PlayerEquipement[namePlayerToshow] and PlayerEquipement[namePlayerToshow][itemName];
    if equipment == nil then return; end

    UIShowLvlEquip = Turbine.UI.Lotro.GoldWindow();
    UIShowLvlEquip:SetSize(350, 170);
    UIShowLvlEquip:SetText(T[EQUIPMENT_TITLE_KEYS[itemName]] or tostring(itemName));
    UIShowLvlEquip:SetPosition((Turbine.UI.Display:GetWidth() - 350) / 2, (Turbine.UI.Display:GetHeight() - 170) / 2);
    UIShowLvlEquip:SetZOrder(100);
    UIShowLvlEquip:SetWantsKeyEvents(true);

    local levelLabel = AltHolicUtil.CreateLabel(UIShowLvlEquip, T["PluginEquipement3"], 25, 30, 300, 20, {
        font=Turbine.UI.Lotro.Font.BookAntiquaBold22, color=Turbine.UI.Color.Gold, align=Turbine.UI.ContentAlignment.MiddleCenter
    });
    local levelBox = Turbine.UI.Lotro.TextBox();
    levelBox:SetParent(UIShowLvlEquip); levelBox:SetSize(150,30); levelBox:SetText(tostring(equipment.lvl or ""));
    levelBox:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); levelBox:SetForeColor(Turbine.UI.Color(0.7,0.6,0.2));
    levelBox:SetBackColor(Turbine.UI.Color(0.9,0.5,0.7,0.5));

    local armorLabel = AltHolicUtil.CreateLabel(UIShowLvlEquip, "", 25, 85, 300, 20, {
        font=Turbine.UI.Lotro.Font.BookAntiquaBold22, color=Turbine.UI.Color.Gold, align=Turbine.UI.ContentAlignment.MiddleCenter
    });
    local armorBox = Turbine.UI.Lotro.TextBox();
    armorBox:SetParent(UIShowLvlEquip); armorBox:SetSize(150,30); armorBox:SetText(tostring(equipment.armor or ""));
    armorBox:SetPosition(100,105); armorBox:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    armorBox:SetForeColor(Turbine.UI.Color(0.7,0.6,0.2)); armorBox:SetBackColor(Turbine.UI.Color(0.9,0.5,0.7,0.5));

    local category = tonumber(equipment.CAT);
    local singleValue = SINGLE_VALUE_SLOTS[itemName] == true;
    local secondLabelKey = "PluginEquipement4";
    if itemName == "PrimaryWeapon" or itemName == "RangedWeapon" then
        singleValue = SINGLE_VALUE_WEAPON_CATEGORIES[category] == true;
        if not singleValue then secondLabelKey = "PluginEquipement25"; end
    elseif itemName == "Shield" then
        secondLabelKey = (category == 33) and "PluginEquipement4" or "PluginEquipement25";
    end

    if singleValue then
        levelLabel:SetPosition(25,60); levelBox:SetPosition(100,85); armorLabel:SetVisible(false); armorBox:SetVisible(false);
    else
        levelLabel:SetPosition(25,30); levelBox:SetPosition(100,55); armorLabel:SetText(T[secondLabelKey]);
    end

    local validateButton = Turbine.UI.Lotro.GoldButton();
    validateButton:SetParent(UIShowLvlEquip); validateButton:SetPosition(75,140); validateButton:SetSize(200,20);
    validateButton:SetFont(Turbine.UI.Lotro.Font.Verdana16); validateButton:SetText(T["PluginWalletWindow7"]);
    validateButton:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    validateButton.MouseClick = function()
        PlayerEquipItems[namePlayerToshow] = PlayerEquipItems[namePlayerToshow] or {};
        PlayerEquipArmor[namePlayerToshow] = PlayerEquipArmor[namePlayerToshow] or {};
        PlayerEquipItems[namePlayerToshow][itemName] = tostring(levelBox:GetText());
        PlayerEquipArmor[namePlayerToshow][itemName] = tostring(armorBox:GetText());
        SavePlayerLvlEquipment(itemName, namePlayerToshow);
        settings["isLvlEquipWindowVisible"]["isLvlEquipWindowVisible"] = false;
        AltHolicUtil.DetachControl(UIShowLvlEquip); UIShowLvlEquip = nil;
        CreateUIShowEquip(namePlayerToshow, PlayerDatas[namePlayerToshow] and PlayerDatas[namePlayerToshow].align);
        settings["isShowEquipmentVisible"]["isShowEquipmentVisible"] = true;
        UIShowEquip:SetVisible(true);
    end
    EscapeKeyHandlerForWindows(UIShowLvlEquip, "isLvlEquipWindowVisible", "isLvlEquipWindowVisible");
end
