------------------------------------------------------------------------------------------
-- FCT_Utility file
-- Written by Homeopatix
-- 19 march 2022
-- Refactored for AltHolic 4.80
------------------------------------------------------------------------------------------
-- Small, dependency-light utility functions used throughout the plugin.
-- Keep these global names for compatibility with the existing codebase, but avoid
-- leaking temporary values into the global namespace.
------------------------------------------------------------------------------------------

local floor = math.floor;
local ceil = math.ceil;
local random = math.random;
local randomseed = math.randomseed;
local format = string.format;
local match = string.match;
local insert = table.insert;

------------------------------------------------------------------------------------------
-- Random helper
-- Seed once at module load instead of reseeding for every call. Repeated randomseed()
-- calls reduce randomness and do unnecessary work.
------------------------------------------------------------------------------------------
do
    local date = Turbine.Engine.GetDate();
    local seed = floor((Turbine.Engine.GetLocalTime() or 0) * 1000)
        + (date.Second or 0)
        + ((date.Minute or 0) * 60)
        + ((date.Hour or 0) * 3600);
    randomseed(seed);
    -- Discard a few initial values; older Lua PRNGs can have weak first outputs.
    random(); random(); random();
end

function Random(minValue, maxValue)
    if minValue ~= nil and maxValue ~= nil then
        minValue = tonumber(minValue) or 0;
        maxValue = tonumber(maxValue) or minValue;
        if minValue > maxValue then
            minValue, maxValue = maxValue, minValue;
        end
        return random(minValue, maxValue);
    end
    return random(0, 99);
end

------------------------------------------------------------------------------------------
-- Round a numeric value to the nearest integer.
------------------------------------------------------------------------------------------
function Round(value)
    value = tonumber(value);
    if value == nil then return value; end
    if value >= 0 then
        return floor(value + 0.5);
    end
    return ceil(value - 0.5);
end

------------------------------------------------------------------------------------------
-- Rating percentage helper.
-- Formula/data originally based on LOTRO Wiki work credited by the original author.
------------------------------------------------------------------------------------------
-- Mitigation curve per class ID. Matches CalcStat's own <Class>CDArmourType data
-- (1 = light, 2 = medium, 3 = heavy). Brawler (215) and Mariner (216) were missing,
-- which made their mitigation rows show 0.0%.
local MITIGATION_SUFFIX = {
    [185] = "L", [31] = "L", [193] = "L",                -- Lore-master, Minstrel, Rune-keeper
    [40] = "M", [162] = "M", [194] = "M", [216] = "M",   -- Burglar, Hunter, Warden, Mariner
    [23] = "H", [24] = "H", [172] = "H", [214] = "H", [215] = "H", -- Guardian, Captain, Champion, Beorning, Brawler
};

function get_percentage(attribute, rating, level, penName, penFactor, namePlayerToShow)
    local statName = attribute;
    local capped = 0;
    local playerData = PlayerDatas[namePlayerToShow];

    if statName == "PhyMit" or statName == "TacMit" then
        local suffix = MITIGATION_SUFFIX[playerData and playerData.cla or 0];
        if suffix then statName = statName .. suffix; end
    end

    local percentage = CalcStat(statName .. "PRatP", level, rating)
        + 0.0002
        + CalcStat(statName .. "PBonus", level);
    local ratingCap = CalcStat(statName .. "PRatPCapR", level);

    if penName == nil then
        if rating >= ratingCap then capped = 1; end
    else
        -- Still capped after tier 3 / 2 / 1 penetration? (TPen values are negative.)
        -- Tier 1 used to query "T2Pen..", which CalcStat does not define (always 0), so
        -- plain-capped stats showed as tier 1 and the capped = 1 branch never ran.
        local factor = penFactor or 1;
        for tier = 3, 1, -1 do
            if rating + CalcStat("TPen" .. penName, level, tier) * factor >= ratingCap then
                capped = tier + 1;
                break;
            end
        end
        if capped == 0 and rating >= ratingCap then capped = 1; end
    end

    return rating_string(rating, percentage, attribute), capped;
end

------------------------------------------------------------------------------------------
-- Format a rating as "1,234 (25.1%)". Partial avoidance stats display percent only.
------------------------------------------------------------------------------------------
function rating_string(rating, percentage, attribute)
    local formattedRating = comma_value(floor(rating + 0.5));
    if attribute == "PartBlock" or attribute == "PartParry" or attribute == "PartEvade" then
        return format("%.1f", percentage) .. "%";
    end
    return formattedRating .. " (" .. format("%.1f", percentage) .. "%)";
end

------------------------------------------------------------------------------------------
-- Add thousands separators to a numeric/string value.
------------------------------------------------------------------------------------------
function comma_value(value)
    if value == nil then return nil; end
    local text = tostring(value);
    local left, digits, right = match(text, '^([^%d]*%d)(%d*)(.-)$');
    if left == nil then return text; end
    return left .. (digits:reverse():gsub('(%d%d%d)', '%1,'):reverse()) .. right;
end

------------------------------------------------------------------------------------------
-- Split a string by a plain-text delimiter.
------------------------------------------------------------------------------------------
function Split(value, delimiter)
    local result = {};
    if value == nil or value == "" then return result; end
    delimiter = tostring(delimiter or " ");
    if delimiter == "" then
        result[1] = tostring(value);
        return result;
    end

    local startIndex = 1;
    local text = tostring(value);
    while true do
        local foundStart, foundEnd = string.find(text, delimiter, startIndex, true);
        if foundStart == nil then
            insert(result, string.sub(text, startIndex));
            break;
        end
        insert(result, string.sub(text, startIndex, foundStart - 1));
        startIndex = foundEnd + 1;
    end
    return result;
end

------------------------------------------------------------------------------------------
-- Return the number of keys in a table.
------------------------------------------------------------------------------------------
function tablelength(value)
    if type(value) ~= "table" then return 0; end
    local count = 0;
    for _ in pairs(value) do count = count + 1; end
    return count;
end
