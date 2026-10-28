------------------------------------------------------------------------------------------
-- Character crafting details
-- AltHolic 4.97 (bars reworked 5.06)
------------------------------------------------------------------------------------------
local CraftingDetailsWindow = nil;

local function SafeNumber(value)
    return tonumber(value) or 0;
end

local function ProgressRatio(value, target)
    value = SafeNumber(value);
    target = SafeNumber(target);
    if target <= 0 then return 0; end
    local ratio = value / target;
    if ratio < 0 then return 0; end
    if ratio > 1 then return 1; end
    return ratio;
end

-- Same construction as the reputation bars: an opaque grey frame, an opaque black track
-- and the tiled bar texture on top, so the window background never shows through.
local BAR_HEIGHT = 15; -- height of the *Bars.tga textures (25x15, tiled horizontally)
local BAR_FRAME_COLOR = Turbine.UI.Color(1, 0.35, 0.35, 0.35);

local function CreateProgressBar(parent, x, y, width, value, target, texture)
    local frame = Turbine.UI.Control();
    frame:SetParent(parent);
    frame:SetPosition(x, y);
    frame:SetSize(width, BAR_HEIGHT + 2);
    frame:SetBackColor(BAR_FRAME_COLOR);
    frame:SetMouseVisible(false);

    local track = Turbine.UI.Control();
    track:SetParent(frame);
    track:SetPosition(1, 1);
    track:SetSize(width - 2, BAR_HEIGHT);
    track:SetBackColor(Turbine.UI.Color.Black);
    track:SetMouseVisible(false);

    local ratio = ProgressRatio(value, target);
    if ratio > 0 then
        local fill = Turbine.UI.Label(); -- Label, as the reputation bars use for textures
        fill:SetParent(track);
        fill:SetPosition(0, 0);
        fill:SetSize(math.max(1, math.floor((width - 2) * ratio)), BAR_HEIGHT);
        fill:SetBackground(ResourcePath .. texture);
        fill:SetMouseVisible(false);
    end

    return frame;
end

local function ProgressText(profession, mastery)
    if mastery then
        if profession.CurrentMastery ~= nil and tostring(profession.CurrentMastery) ~= "" then
            return tostring(profession.CurrentMastery);
        end
        local level = SafeNumber(profession.MasteryLevel);
        local value = SafeNumber(profession.MasteryExp);
        local target = SafeNumber(profession.MasteryExpTarget);
        if target > 0 then return "T" .. tostring(level) .. "  " .. tostring(value) .. " / " .. tostring(target); end
        return "T" .. tostring(level);
    end

    if profession.CurrentLvl ~= nil and tostring(profession.CurrentLvl) ~= "" then
        return tostring(profession.CurrentLvl);
    end
    local level = SafeNumber(profession.ProficiencyLevel);
    local value = SafeNumber(profession.ProficiencyExp);
    local target = SafeNumber(profession.ProficiencyExpTarget);
    if target > 0 then return "T" .. tostring(level) .. "  " .. tostring(value) .. " / " .. tostring(target); end
    return "T" .. tostring(level);
end

local function CreateProfessionRow(parent, profession, y, rowWidth, rowIndex)
    local rowHeight = 82;
    local professionWidth = 190;
    local progressWidth = math.floor((rowWidth - professionWidth) / 2);

    local rowBack = Turbine.UI.Control();
    rowBack:SetParent(parent);
    rowBack:SetPosition(0, y);
    rowBack:SetSize(rowWidth, rowHeight);
    if rowIndex % 2 == 0 then
        rowBack:SetBackColor(Turbine.UI.Color(0.84, 0.07, 0.07, 0.07));
    else
        rowBack:SetBackColor(Turbine.UI.Color(0.76, 0.03, 0.03, 0.03));
    end
    rowBack:SetMouseVisible(false);

    local iconFile = profession.Icon or GetProfessionSmallIconFile(profession.Key, profession.Name);
    if iconFile ~= nil then
        local icon = Turbine.UI.Label();
        icon:SetParent(parent);
        icon:SetPosition(14, y + 24);
        icon:SetSize(32, 32);
        icon:SetBackground(ResourcePath .. iconFile);
        icon:SetStretchMode(1);
        icon:SetMouseVisible(false);
    end

    AltHolicUtil.CreateLabel(parent, tostring(profession.Name or "?"), 56, y + 14,
        professionWidth - 64, 48,
        { font = Turbine.UI.Lotro.Font.BookAntiquaBold18,
          color = Turbine.UI.Color.Gold,
          align = Turbine.UI.ContentAlignment.MiddleLeft });

    local profX = professionWidth;
    local masteryX = professionWidth + progressWidth;

    AltHolicUtil.CreateLabel(parent, ProgressText(profession, false), profX + 12, y + 5,
        progressWidth - 24, 46,
        { font = Turbine.UI.Lotro.Font.Verdana12,
          color = Turbine.UI.Color(0.95, 0.95, 0.95),
          align = Turbine.UI.ContentAlignment.MiddleLeft });

    AltHolicUtil.CreateLabel(parent, ProgressText(profession, true), masteryX + 12, y + 5,
        progressWidth - 24, 46,
        { font = Turbine.UI.Lotro.Font.Verdana12,
          color = Turbine.UI.Color(1.0, 0.90, 0.55),
          align = Turbine.UI.ContentAlignment.MiddleLeft });

    local proficiencyTarget = SafeNumber(profession.ProficiencyExpTarget);
    if proficiencyTarget > 0 then
        CreateProgressBar(parent, profX + 12, y + 57, progressWidth - 24,
            profession.ProficiencyExp, proficiencyTarget, "GreenBars.tga");
    end

    local masteryTarget = SafeNumber(profession.MasteryExpTarget);
    if masteryTarget > 0 then
        CreateProgressBar(parent, masteryX + 12, y + 57, progressWidth - 24,
            profession.MasteryExp, masteryTarget, "YellowBars.tga");
    end

    local vertical1 = Turbine.UI.Control();
    vertical1:SetParent(parent);
    vertical1:SetPosition(professionWidth - 1, y);
    vertical1:SetSize(1, rowHeight);
    vertical1:SetBackColor(Turbine.UI.Color(0.32, 0.32, 0.32));
    vertical1:SetMouseVisible(false);

    local vertical2 = Turbine.UI.Control();
    vertical2:SetParent(parent);
    vertical2:SetPosition(masteryX - 1, y);
    vertical2:SetSize(1, rowHeight);
    vertical2:SetBackColor(Turbine.UI.Color(0.32, 0.32, 0.32));
    vertical2:SetMouseVisible(false);

    local bottom = Turbine.UI.Control();
    bottom:SetParent(parent);
    bottom:SetPosition(0, y + rowHeight - 1);
    bottom:SetSize(rowWidth, 1);
    bottom:SetBackColor(Turbine.UI.Color(0.26, 0.26, 0.26));
    bottom:SetMouseVisible(false);
end

function OpenCraftingDetails(characterName)
    if characterName == nil or PlayerDatas == nil or PlayerDatas[characterName] == nil then return; end

    -- Only the logged-in character can be refreshed live. Offline characters display
    -- the last profession snapshot AltHolic saved when they were played.
    RefreshCurrentPlayerProfessions(characterName);

    if CraftingDetailsWindow ~= nil then
        AltHolicUtil.DetachControl(CraftingDetailsWindow);
        CraftingDetailsWindow = nil;
    end

    local professions = GetSavedProfessions(characterName) or {};
    table.sort(professions, function(a, b)
        return string.lower(tostring(a.Name or a.Key or "")) < string.lower(tostring(b.Name or b.Key or ""));
    end);

    local windowWidth = 820;
    local headerHeight = 72;
    local rowHeight = 82;
    -- The scrolling viewport starts 42px down and leaves 52px at the bottom for the footer.
    -- Size the window from that so every profession fits (a full vocation plus any extra
    -- saved crafts) and only scroll when the screen is too short.
    local VIEWPORT_TOP, VIEWPORT_BOTTOM = 42, 52;
    local visibleRows = math.max(3, #professions);
    local desiredHeight = VIEWPORT_TOP + VIEWPORT_BOTTOM + headerHeight + (visibleRows * rowHeight);
    local maxHeight = math.max(360, Turbine.UI.Display:GetHeight() - 100);
    local windowHeight = math.min(desiredHeight, maxHeight);

    CraftingDetailsWindow = Turbine.UI.Lotro.GoldWindow();
    CraftingDetailsWindow:SetSize(windowWidth, windowHeight);
    CraftingDetailsWindow:SetText(T["PluginCraftDetailsTitle"] .. " - " .. tostring(characterName));
    CraftingDetailsWindow:SetPosition(
        math.floor((Turbine.UI.Display:GetWidth() - windowWidth) / 2),
        math.floor((Turbine.UI.Display:GetHeight() - windowHeight) / 2)
    );
    CraftingDetailsWindow:SetZOrder(120);
    CraftingDetailsWindow:SetWantsKeyEvents(true);

    local viewport = Turbine.UI.Control();
    viewport:SetParent(CraftingDetailsWindow);
    viewport:SetPosition(18, VIEWPORT_TOP);
    viewport:SetSize(windowWidth - 46, windowHeight - VIEWPORT_TOP - VIEWPORT_BOTTOM);
    viewport:SetBackColor(Turbine.UI.Color(0.50, 0.00, 0.00, 0.00));

    local contentWidth = viewport:GetWidth() - 2;
    local contentHeight = headerHeight + math.max(1, #professions) * rowHeight;
    local content = Turbine.UI.Control();
    content:SetParent(viewport);
    content:SetPosition(0, 0);
    content:SetSize(contentWidth, contentHeight);
    content:SetBackColor(Turbine.UI.Color(0.28, 0.01, 0.01, 0.01));

    local professionWidth = 190;
    local progressWidth = math.floor((contentWidth - professionWidth) / 2);

    local headerBack = Turbine.UI.Control();
    headerBack:SetParent(content);
    headerBack:SetPosition(0, 0);
    headerBack:SetSize(contentWidth, headerHeight - 2);
    headerBack:SetBackColor(Turbine.UI.Color(0.72, 0.05, 0.05, 0.05));
    headerBack:SetMouseVisible(false);

    AltHolicUtil.CreateLabel(content, T["PluginCraftDetailsProfession"],
        12, 0, professionWidth - 18, headerHeight - 2,
        { font = Turbine.UI.Lotro.Font.TrajanProBold16, color = Turbine.UI.Color.Gold,
          align = Turbine.UI.ContentAlignment.MiddleLeft });
    AltHolicUtil.CreateLabel(content, T["PluginCraftDetailsProficiency"],
        professionWidth, 0, progressWidth, headerHeight - 2,
        { font = Turbine.UI.Lotro.Font.TrajanProBold16, color = Turbine.UI.Color.Gold,
          align = Turbine.UI.ContentAlignment.MiddleCenter });
    AltHolicUtil.CreateLabel(content, T["PluginCraftDetailsMastery"],
        professionWidth + progressWidth, 0, progressWidth, headerHeight - 2,
        { font = Turbine.UI.Lotro.Font.TrajanProBold16, color = Turbine.UI.Color.Gold,
          align = Turbine.UI.ContentAlignment.MiddleCenter });

    local headerLine = Turbine.UI.Control();
    headerLine:SetParent(content);
    headerLine:SetPosition(0, headerHeight - 2);
    headerLine:SetSize(contentWidth, 1);
    headerLine:SetBackColor(Turbine.UI.Color.Blue);
    headerLine:SetMouseVisible(false);

    if #professions == 0 then
        AltHolicUtil.CreateLabel(content, T["PluginCraftDetailsEmpty"],
            20, headerHeight + 35, contentWidth - 40, 60,
            { font = Turbine.UI.Lotro.Font.Verdana16, color = Turbine.UI.Color.Gold,
              align = Turbine.UI.ContentAlignment.MiddleCenter });
    else
        for index, profession in ipairs(professions) do
            CreateProfessionRow(content, profession, headerHeight + ((index - 1) * rowHeight), contentWidth, index);
        end
    end

    if content:GetHeight() > viewport:GetHeight() then
        local scrollbar = Turbine.UI.Lotro.ScrollBar();
        scrollbar:SetParent(CraftingDetailsWindow);
        scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical);
        scrollbar:SetPosition(windowWidth - 23, 46);
        scrollbar:SetSize(10, viewport:GetHeight() - 8);
        scrollbar:SetMinimum(0);
        scrollbar:SetMaximum(content:GetHeight() - viewport:GetHeight());
        scrollbar:SetValue(0);
        scrollbar.ValueChanged = function(sender)
            content:SetPosition(0, -sender:GetValue());
        end;
    end

    AltHolicUtil.CreateLabel(CraftingDetailsWindow,
        T["PluginCraftDetailsFooter"],
        20, windowHeight - 43, windowWidth - 40, 20,
        { font = Turbine.UI.Lotro.Font.Verdana12, color = Turbine.UI.Color(0.75, 0.75, 0.75),
          align = Turbine.UI.ContentAlignment.MiddleCenter });

    CraftingDetailsWindow:SetVisible(true);
    EscapeKeyHandlerForWindows(CraftingDetailsWindow);
end
