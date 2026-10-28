------------------------------------------------------------------------------------------
-- AltHolic core helpers
-- Added in 4.69 to centralize small utility routines that were duplicated throughout
-- the plugin. Kept intentionally conservative for LOTRO's Lua 5.1 environment.
------------------------------------------------------------------------------------------
AltHolicUtil = AltHolicUtil or {};

function AltHolicUtil.DeepMergeDefaults(target, defaults)
    if type(target) ~= "table" then target = {}; end
    if type(defaults) ~= "table" then return target; end

    for key, defaultValue in pairs(defaults) do
        local currentValue = target[key];
        if currentValue == nil then
            if type(defaultValue) == "table" then
                target[key] = AltHolicUtil.DeepMergeDefaults({}, defaultValue);
            else
                target[key] = defaultValue;
            end
        elseif type(defaultValue) == "table" and type(currentValue) == "table" then
            AltHolicUtil.DeepMergeDefaults(currentValue, defaultValue);
        end
    end

    return target;
end

local availablePluginCache = nil;
local loadedPluginCache = nil;

local function BuildPluginNameSet(list)
    local result = {};
    if list == nil then return result; end
    for index = 1, #list do
        local plugin = list[index];
        if plugin ~= nil and plugin.Name ~= nil then
            result[plugin.Name] = true;
        end
    end
    return result;
end

function AltHolicUtil.RefreshPluginCache()
    availablePluginCache = BuildPluginNameSet(Turbine.PluginManager.GetAvailablePlugins());
    loadedPluginCache = BuildPluginNameSet(Turbine.PluginManager.GetLoadedPlugins());
end

function AltHolicUtil.IsPluginAvailable(name)
    if availablePluginCache == nil then AltHolicUtil.RefreshPluginCache(); end
    return availablePluginCache[name] == true;
end

function AltHolicUtil.IsPluginLoaded(name)
    if loadedPluginCache == nil then AltHolicUtil.RefreshPluginCache(); end
    return loadedPluginCache[name] == true;
end

function AltHolicUtil.IsPluginReady(name, refresh)
    if refresh == true then AltHolicUtil.RefreshPluginCache(); end
    return AltHolicUtil.IsPluginAvailable(name) and AltHolicUtil.IsPluginLoaded(name);
end

-- Detach one UI control defensively. Rebuilt on-demand windows use this before
-- replacing their global handle so stale C-side controls cannot remain visible.
function AltHolicUtil.DetachControl(control)
    if control == nil then return; end
    pcall(function() control:SetVisible(false); end);
    pcall(function() control:SetParent(nil); end);
end

-- Detach a table of UI controls from their parents so the Turbine UI framework
-- releases its C-side references and stops rendering them. Call this before
-- discarding a table of controls that were parented to a live container (e.g.
-- viewport1.map or AltHolicWindow). Both flat tables and tables of tables are
-- accepted; keys can be any type. Skips nil entries silently.
function AltHolicUtil.DetachControls(controlTable)
    if type(controlTable) ~= "table" then return; end
    for _, value in pairs(controlTable) do
        -- Turbine controls are tables too; only recurse into plain lists of controls.
        if type(value) == "table" and value.SetParent == nil then
            AltHolicUtil.DetachControls(value);
        elseif value ~= nil then
            AltHolicUtil.DetachControl(value);
        end
    end
end

function AltHolicUtil.Join(values, separator)
    separator = separator or ", ";
    local parts = {};
    if values == nil then return ""; end
    for index = 1, #values do
        if values[index] ~= nil and tostring(values[index]) ~= "" then
            parts[#parts + 1] = tostring(values[index]);
        end
    end
    return table.concat(parts, separator);
end



------------------------------------------------------------------------------------------
-- Shared character/equipment schema
------------------------------------------------------------------------------------------
-- LOTRO equipment indexes are stable and are used by both persistence and runtime caches.
-- Keeping the mapping in one place removes several hundred lines of repeated per-slot code.
AltHolicUtil.EquipmentSlots = {
    { index = 1,  key = "Head" },
    { index = 2,  key = "Chest" },
    { index = 3,  key = "Legs" },
    { index = 4,  key = "Gloves" },
    { index = 5,  key = "Boots" },
    { index = 6,  key = "Shoulder" },
    { index = 7,  key = "Back" },
    { index = 8,  key = "Bracelet1" },
    { index = 9,  key = "Bracelet2" },
    { index = 10, key = "Necklace" },
    { index = 11, key = "Ring1" },
    { index = 12, key = "Ring2" },
    { index = 13, key = "Earring1" },
    { index = 14, key = "Earring2" },
    { index = 15, key = "Pocket" },
    { index = 16, key = "PrimaryWeapon" },
    { index = 17, key = "Shield" },
    { index = 18, key = "RangedWeapon" },
    { index = 19, key = "CraftTool" },
    { index = 20, key = "ClassE" },
};

function AltHolicUtil.EnsureTable(parent, key)
    if type(parent) ~= "table" then return nil; end
    if type(parent[key]) ~= "table" then parent[key] = {}; end
    return parent[key];
end

-- Return storage slot keys sorted by item name, preserving duplicate names by sorting
-- the slot keys themselves instead of doing the old O(n^2) name-to-slot lookup.
function AltHolicUtil.SortedItemSlots(storage)
    local slots = {};
    if type(storage) ~= "table" then return slots; end
    for key, item in pairs(storage) do
        if type(item) == "table" or item ~= nil then
            slots[#slots + 1] = key;
        end
    end
    table.sort(slots, function(a, b)
        local itemA = storage[a] or storage[tostring(a)];
        local itemB = storage[b] or storage[tostring(b)];
        local nameA = itemA and tostring(itemA.N or "") or "";
        local nameB = itemB and tostring(itemB.N or "") or "";
        nameA = string.lower(nameA);
        nameB = string.lower(nameB);
        if nameA == nameB then
            return tostring(a) < tostring(b);
        end
        return nameA < nameB;
    end);
    return slots;
end


------------------------------------------------------------------------------------------
-- Search helpers
------------------------------------------------------------------------------------------
function AltHolicUtil.NormalizeSearchQuery(query)
    query = string.lower(tostring(query or ""));
    if query == "" or query == "**" then return nil; end
    return query;
end

function AltHolicUtil.MatchesSearch(value, query)
    local normalizedQuery = AltHolicUtil.NormalizeSearchQuery(query);
    if normalizedQuery == nil then return true; end
    local normalizedValue = string.lower(tostring(value or ""));
    return string.find(normalizedValue, normalizedQuery, 1, true) ~= nil;
end

------------------------------------------------------------------------------------------
-- UI / money helpers
------------------------------------------------------------------------------------------
local MONEY_GOLD_TEXTURE = 0x41007e7b;
local MONEY_SILVER_TEXTURE = 0x41007e7c;
local MONEY_COPPER_TEXTURE = 0x41007e7d;

-- Split a copper amount into gold/silver/copper. The fourth return value is true when the
-- input was negative (e.g. a net session loss); the parts themselves are always positive.
function AltHolicUtil.MoneyParts(value)
    value = math.floor(tonumber(value) or 0);
    local negative = value < 0;
    if negative then value = -value; end
    local gold = math.floor(value / 100000);
    local silver = math.floor(value / 100) - (gold * 1000);
    local copper = value - (gold * 100000) - (silver * 100);
    return gold, silver, copper, negative;
end

function AltHolicUtil.CreateLabel(parent, text, x, y, width, height, options)
    options = options or {};
    local label = Turbine.UI.Label();
    label:SetParent(parent);
    label:SetPosition(x or 0, y or 0);
    label:SetSize(width or 100, height or 20);
    label:SetText(text or "");
    label:SetTextAlignment(options.align or Turbine.UI.ContentAlignment.MiddleLeft);
    label:SetFont(options.font or Turbine.UI.Lotro.Font.Verdana14);
    label:SetForeColor(options.color or Turbine.UI.Color.White);
    if options.mouseVisible ~= nil then
        label:SetMouseVisible(options.mouseVisible);
    else
        label:SetMouseVisible(false);
    end
    return label;
end

function AltHolicUtil.CreateTexture(parent, texture, x, y, width, height, options)
    options = options or {};
    local control = Turbine.UI.Control();
    control:SetParent(parent);
    control:SetPosition(x or 0, y or 0);
    control:SetSize(width or 16, height or 16);
    control:SetBackground(texture);
    -- Numeric LOTRO resource IDs generally expect Overlay. External file textures do not;
    -- defaulting file paths to Overlay caused the profession-icon rendering bug in older builds.
    if options.blendMode ~= false then
        local blendMode = options.blendMode;
        if blendMode == nil and type(texture) == "number" then
            blendMode = Turbine.UI.BlendMode.Overlay;
        end
        if blendMode ~= nil then control:SetBlendMode(blendMode); end
    end
    if options.mouseVisible ~= nil then
        control:SetMouseVisible(options.mouseVisible);
    else
        control:SetMouseVisible(false);
    end
    return control;
end

-- Compact native LOTRO money display. The three coin icons are the same internal
-- resources used by AltHolic's main-window cash display.
function AltHolicUtil.CreateMoneyDisplay(parent, value, x, y, width, height, options)
    options = options or {};
    width = width or 180;
    height = height or 24;

    local gold, silver, copper, negative = AltHolicUtil.MoneyParts(value);
    local iconWidth = options.iconWidth or options.iconSize or 27;
    local iconHeight = options.iconHeight or options.iconSize or 21;
    local gap = options.gap or 2;
    local groupGap = options.groupGap or 3;
    local font = options.font or Turbine.UI.Lotro.Font.Verdana14;
    local colors = options.colors or {
        Turbine.UI.Color.Gold,
        Turbine.UI.Color.Silver,
        Turbine.UI.Color(0.8, 0.4, 0.2),
    };
    local digitWidths = options.digitWidths or { 44, 34, 28 };

    local container = Turbine.UI.Control();
    container:SetParent(parent);
    container:SetPosition(x or 0, y or 0);
    container:SetSize(width, height);
    container:SetMouseVisible(false);

    -- Work right-to-left so all three denominations remain aligned even when
    -- character wealth varies wildly in digit count.
    local right = width;
    -- A net loss is shown as "-12g 34s 56c" instead of being clamped to zero.
    local goldText = negative and ("-" .. tostring(gold)) or tostring(gold);
    local parts = {
        { value = copper,   texture = MONEY_COPPER_TEXTURE, color = colors[3], digits = digitWidths[3] },
        { value = silver,   texture = MONEY_SILVER_TEXTURE, color = colors[2], digits = digitWidths[2] },
        { value = goldText, texture = MONEY_GOLD_TEXTURE,   color = colors[1], digits = digitWidths[1] },
    };

    for index = 1, #parts do
        local part = parts[index];
        right = right - iconWidth;
        AltHolicUtil.CreateTexture(
            container,
            part.texture,
            right,
            math.floor((height - iconHeight) / 2),
            iconWidth,
            iconHeight
        );

        right = right - gap - part.digits;
        local label = AltHolicUtil.CreateLabel(container, tostring(part.value), right, 0, part.digits, height, {
            align = Turbine.UI.ContentAlignment.MiddleRight,
            font = font,
            color = part.color,
        });
        label:SetMouseVisible(false);
        right = right - groupGap;
    end

    return container;
end

-- Shared UI/layout helpers used by the remaining legacy windows. Keeping these
-- patterns here prevents each window from rebuilding the same controls by hand.
function AltHolicUtil.CreateDisplayModeButtons(parent, windowWidth, y, showIcons, onLines, onIcons)
    local lineButton = Turbine.UI.Label();
    lineButton:SetParent(parent);
    lineButton:SetSize(21, 21);
    lineButton:SetPosition(windowWidth / 2 - 41, y or 40);
    lineButton:SetBackground(showIcons and 0x4110C76F or 0x4110C76D);
    lineButton:SetMouseVisible(true);
    lineButton:SetBlendMode(Turbine.UI.BlendMode.Overlay);

    local iconButton = Turbine.UI.Label();
    iconButton:SetParent(parent);
    iconButton:SetSize(21, 21);
    iconButton:SetPosition(windowWidth / 2 + 20, y or 40);
    iconButton:SetBackground(showIcons and 0x4110C76A or 0x4110C76C);
    iconButton:SetMouseVisible(true);
    iconButton:SetBlendMode(Turbine.UI.BlendMode.Overlay);

    lineButton.MouseClick = function() if onLines ~= nil then onLines(); end end;
    iconButton.MouseClick = function() if onIcons ~= nil then onIcons(); end end;
    return lineButton, iconButton;
end

function AltHolicUtil.CreateCloseButton(parent, text, y, onClick, width, x)
    width = width or 300;
    local button = Turbine.UI.Lotro.GoldButton();
    button:SetParent(parent);
    button:SetPosition(x or ((parent:GetWidth() - width) / 2), y);
    button:SetSize(width, 20);
    button:SetFont(Turbine.UI.Lotro.Font.Verdana16);
    button:SetText(text or T["PluginCloseButton"]);
    button:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    button:SetVisible(true);
    button:SetMouseVisible(true);
    button.MouseClick = function() if onClick ~= nil then onClick(); end end;
    return button;
end

-- Build the four standard layers used by AltHolic's saved inventory/equipment icons.
-- Returns the top icon layer, which is the control callers normally attach tooltips to.
function AltHolicUtil.CreateStoredItemIcon(parent, itemData, x, y, options)
    options = options or {};
    local size = options.size or 32;
    local offset = options.offset or 1;
    local z = options.zOrder or ((parent.GetZOrder ~= nil and parent:GetZOrder() or 0) + 1);

    local quality = tonumber(itemData and itemData.Q) or 0;
    local base = tonumber(itemData and itemData.B) or 0;
    local stack = tonumber(itemData and itemData.S) or 0;
    local icon = tonumber(itemData and itemData.I) or 0;
    local qualityRank = tonumber(itemData and itemData.QA) or 0;
    if options.useStackFallback ~= false and stack == 0 and qualityRank >= 1 and qualityRank <= 5 then
        stack = 0x410030C4;
    end

    local layers = { quality, base, stack, icon };
    local controls = {};
    for index, texture in ipairs(layers) do
        local layer = Turbine.UI.Control();
        layer:SetParent(parent);
        layer:SetPosition(x or offset, y or offset);
        layer:SetSize(size, size);
        layer:SetZOrder(z);
        if texture ~= 0 then layer:SetBackground(texture); end
        layer:SetBlendMode(Turbine.UI.BlendMode.Overlay);
        layer:SetVisible(true);
        layer:SetMouseVisible(index == 4);
        controls[index] = layer;
    end
    return controls[4], controls;
end

function AltHolicUtil.ShouldDisplayCharacter(playerName)
    if PlayerDatas == nil or PlayerDatas[playerName] == nil then return false; end
    if settings == nil or settings["displayServers"] == nil or settings["displayServers"]["value"] ~= true then
        return true;
    end
    local selected = settings["serversToDisplay"] and settings["serversToDisplay"]["value"] or "";
    return selected == "" or selected == T["ServerNamesAll"] or selected == PlayerDatas[playerName].serverName;
end


-- Standard framed hover tooltip used throughout AltHolic's icon rows and toolbar.
function AltHolicUtil.AttachFramedTooltip(trigger, parent, x, y, width, height, text, options)
    options = options or {};
    width = width or 180;
    height = height or 30;

    local tooltip = Turbine.UI.Extensions.SimpleWindow();
    tooltip:SetParent(parent);
    tooltip:SetPosition(x or 0, y or 0);
    tooltip:SetSize(width, height);
    tooltip:SetVisible(false);
    tooltip:SetZOrder(options.zOrder or 20);
    tooltip:SetBackground(options.background or (ResourcePath .. "/Cadre_180_30.tga"));

    local label = Turbine.UI.Label();
    label:SetParent(tooltip);
    label:SetPosition(2, 2);
    label:SetSize(width - 4, height - 4);
    -- font = false keeps the Label's built-in default font (used by the small "+" helpers).
    if options.font ~= false then label:SetFont(options.font or Turbine.UI.Lotro.Font.Verdana20); end
    label:SetText(text or "");
    label:SetTextAlignment(options.align or Turbine.UI.ContentAlignment.MiddleCenter);
    label:SetZOrder((options.zOrder or 20) + 1);
    if options.backColor ~= false then
        label:SetBackColor(options.backColor or Turbine.UI.Color(0.8, 0.1, 0.4, 0.9));
    end
    if options.foreColor ~= nil then label:SetForeColor(options.foreColor); end

    if options.labelZOrder ~= nil then label:SetZOrder(options.labelZOrder); end

    trigger.MouseEnter = function(sender, args)
        tooltip:SetVisible(true);
        if options.onEnter ~= nil then options.onEnter(sender, args); end
    end;
    trigger.MouseLeave = function(sender, args)
        tooltip:SetVisible(false);
        if options.onLeave ~= nil then options.onLeave(sender, args); end
    end;
    return tooltip, label;
end

------------------------------------------------------------------------------------------
-- Window helpers
------------------------------------------------------------------------------------------
-- Toggle an on-demand window that is (re)built by `create`. Visibility is taken from the
-- window itself rather than the saved flag, so a window closed with Esc/F12/the X button
-- reopens on the very next click instead of needing a "phantom close" click first.
-- `key` identifies what the window shows (usually a character name): clicking another
-- character's icon while the window is open switches to that character instead of closing.
function AltHolicUtil.ToggleWindow(getWindow, create, settingGroup, settingField, key)
    local window = getWindow();
    local field = settingField or "value";
    if window ~= nil and window:IsVisible() and (key == nil or window.altHolicKey == key) then
        window:SetVisible(false);
        if settingGroup ~= nil then settings[settingGroup][field] = false; end
        return false;
    end
    if create ~= nil then create(); end
    window = getWindow();
    if window ~= nil then
        window.altHolicKey = key;
        window:SetVisible(true);
    end
    if settingGroup ~= nil then settings[settingGroup][field] = true; end
    return true;
end

-- Offset of `control` inside `ancestor`, walking the parent chain. Returns nil when the
-- control is not a descendant (e.g. an item owned by a ListBox).
function AltHolicUtil.GetOffsetWithin(control, ancestor)
    local x, y = 0, 0;
    local current = control;
    while current ~= nil and current ~= ancestor do
        x = x + current:GetLeft();
        y = y + current:GetTop();
        current = current:GetParent();
    end
    if current == nil then return nil, nil; end
    return x, y;
end

------------------------------------------------------------------------------------------
-- Deferred work. Bursts of inventory events (looting ten items, sorting the vault) used to
-- serialize the whole data file once per event; now each burst is written once, a moment
-- after the last event. Run(key) executes a pending task immediately (e.g. on unload).
------------------------------------------------------------------------------------------
local deferredTasks = {};
local deferredScheduler = nil;

local function RunDeferredTask(key)
    local task = deferredTasks[key];
    if task == nil then return; end
    deferredTasks[key] = nil;
    task.fn();
end

function AltHolicUtil.Defer(key, delaySeconds, fn)
    deferredTasks[key] = { due = Turbine.Engine.GetGameTime() + (delaySeconds or 1), fn = fn };
    if deferredScheduler == nil then
        deferredScheduler = Turbine.UI.Control();
        deferredScheduler.Update = function()
            local now = Turbine.Engine.GetGameTime();
            local due = {};
            for taskKey, task in pairs(deferredTasks) do
                if now >= task.due then due[#due + 1] = taskKey; end
            end
            for _, taskKey in ipairs(due) do RunDeferredTask(taskKey); end
            if next(deferredTasks) == nil then
                deferredScheduler:SetWantsUpdates(false);
            end
        end
    end
    deferredScheduler:SetWantsUpdates(true);
end

function AltHolicUtil.RunDeferred(key)
    if key ~= nil then
        RunDeferredTask(key);
        return;
    end
    local keys = {};
    for taskKey in pairs(deferredTasks) do keys[#keys + 1] = taskKey; end
    for _, taskKey in ipairs(keys) do RunDeferredTask(taskKey); end
end

------------------------------------------------------------------------------------------
-- Character / account helpers
------------------------------------------------------------------------------------------
-- Total of wallet + backpack coin bags + vault coin bags for every character currently
-- shown by the server filter, plus the account's shared-storage coin bags.
function AltHolicUtil.ComputeAccountCash()
    local total = 0;
    for name, data in pairs(PlayerDatas or {}) do
        if AltHolicUtil.ShouldDisplayCharacter(name) then
            total = total + (tonumber(data.cash) or 0) + (tonumber(data.bagCash) or 0) + (tonumber(data.vaultCash) or 0);
        end
    end
    return total + (tonumber(settings["sharedStorageCash"]["value"]) or 0);
end

-- Character names that pass the server filter, sorted alphabetically.
function AltHolicUtil.GetDisplayedCharacterNames(filter)
    local names = {};
    for name, data in pairs(PlayerDatas or {}) do
        if AltHolicUtil.ShouldDisplayCharacter(name) and (filter == nil or filter(name, data)) then
            names[#names + 1] = name;
        end
    end
    table.sort(names);
    return names;
end

-- Experience needed to go from `level` to `level + 1`, or nil at the level cap.
function AltHolicUtil.GetLevelXPRequirement(level)
    level = tonumber(level) or 1;
    if LevelMax ~= nil and level >= LevelMax then return nil; end
    local current = PlayerLevelXP[level];
    if current == nil then return nil; end
    if level <= 1 then return current; end
    local previous = PlayerLevelXP[level - 1] or 0;
    return current - previous;
end

------------------------------------------------------------------------------------------
-- Race / class artwork (single source for the main list, toolbar, stats and gender windows)
------------------------------------------------------------------------------------------
AltHolicUtil.RaceIcons = {
    [81]  = { male = 0x4110894A, female = 0x41108949 },               -- Elf
    [23]  = { male = 0x41108945, female = 0x4110894B },               -- Man
    [65]  = { male = 0x41108947, female = 0x41108948 },               -- Hobbit
    [114] = { male = 0x4115920D, female = 0x4115920A },               -- Beorning
    [120] = { male = 0x411DAE7E, female = 0x411DAE7E },               -- Stout-axe
    [73]  = { male = 0x41108946, female = 0x41108946, maleOnly = true }, -- Dwarf
    [117] = { male = 0x411C8D6B, female = 0x411C8D6A },               -- High Elf
    [125] = { male = 0x4110894A, female = 0x41108949 },               -- River Hobbit
};

AltHolicUtil.MonsterRaces = { [7] = true, [12] = true, [6] = true, [66] = true };

AltHolicUtil.ClassIcons = {
    [162] = 0x410095C2, [31] = 0x4110867A, [214] = 0x41153604,
    [24] = 0x410095C5, [193] = 0x4110867B, [40] = 0x410095BB,
    [185] = 0x410095BF, [23] = 0x410095B8, [172] = 0x410095B5,
    [194] = 0x41108673, [215] = 0x4120fcd9, [216] = 0x4122f860,
};

-- Monster-play classes use bundled artwork; "<name>_red.tga" highlights the logged-in character.
AltHolicUtil.MonsterClassIcons = {
    [71] = "Faucheur", [128] = "Profanateur", [127] = "Araignee",
    [179] = "FlecheNoire", [52] = "ChefDeGuerre", [126] = "Ouargue",
};

function AltHolicUtil.GetRaceTexture(playerData, highlight)
    if playerData == nil then return nil; end
    if AltHolicUtil.MonsterRaces[playerData.rac] then
        return ResourcePath .. (highlight and "Mordor_red.tga" or "Mordor.tga");
    end
    local icons = AltHolicUtil.RaceIcons[playerData.rac];
    if icons == nil then return nil; end
    return icons[playerData.sexe] or icons.male;
end

function AltHolicUtil.GetClassTexture(playerData, highlight)
    if playerData == nil then return nil; end
    local texture = AltHolicUtil.ClassIcons[playerData.cla];
    if texture ~= nil then return texture; end
    local monsterName = AltHolicUtil.MonsterClassIcons[playerData.cla];
    if monsterName ~= nil then
        return ResourcePath .. monsterName .. (highlight and "_red.tga" or ".tga");
    end
    return nil;
end

function AltHolicUtil.ApplyTexture(control, texture)
    if control ~= nil and texture ~= nil then control:SetBackground(texture); end
end

------------------------------------------------------------------------------------------
-- Equipment helpers
------------------------------------------------------------------------------------------
-- Turbine.Gameplay.ItemWearState -> displayed durability percentage (-1 = no durability).
local WEAR_STATE_PERCENT = { [0] = -1, [3] = 0, [1] = 20, [4] = 99, [2] = 100 };

function AltHolicUtil.WearStatePercent(wearState)
    return WEAR_STATE_PERCENT[tonumber(wearState) or 0] or 0;
end
