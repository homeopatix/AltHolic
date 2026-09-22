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
        if type(value) == "table" then
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

function AltHolicUtil.MoneyParts(value)
    value = math.max(0, math.floor(tonumber(value) or 0));
    local gold = math.floor(value / 100000);
    local silver = math.floor(value / 100) - (gold * 1000);
    local copper = value - (gold * 100000) - (silver * 100);
    return gold, silver, copper;
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

    local gold, silver, copper = AltHolicUtil.MoneyParts(value);
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
    local parts = {
        { value = copper, texture = MONEY_COPPER_TEXTURE, color = colors[3], digits = digitWidths[3] },
        { value = silver, texture = MONEY_SILVER_TEXTURE, color = colors[2], digits = digitWidths[2] },
        { value = gold,   texture = MONEY_GOLD_TEXTURE,   color = colors[1], digits = digitWidths[1] },
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
