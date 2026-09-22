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
function get_percentage(attribute, rating, level, penName, penFactor, namePlayerToShow)
    local statName = attribute;
    local capped = 0;
    local playerData = PlayerDatas[namePlayerToShow];

    if statName == "PhyMit" or statName == "TacMit" then
        local classId = playerData and playerData.cla or nil;
        if classId == 185 or classId == 31 or classId == 193 then
            statName = statName .. "L";
        elseif classId == 40 or classId == 162 or classId == 194 then
            statName = statName .. "M";
        elseif classId == 214 or classId == 24 or classId == 172 or classId == 23 then
            statName = statName .. "H";
        end
    end

    local percentage = CalcStat(statName .. "PRatP", level, rating)
        + 0.0002
        + CalcStat(statName .. "PBonus", level);
    local ratingCap = CalcStat(statName .. "PRatPCapR", level);

    if penName == nil then
        if rating >= ratingCap then capped = 1; end
    else
        local factor = penFactor or 1;
        local penValue = CalcStat("TPen" .. penName, level, 3) * factor;
        if rating + penValue >= ratingCap then
            capped = 4;
        else
            penValue = CalcStat("TPen" .. penName, level, 2) * factor;
            if rating + penValue >= ratingCap then
                capped = 3;
            else
                penValue = CalcStat("T2Pen" .. penName, level) * factor;
                if rating + penValue >= ratingCap then
                    capped = 2;
                elseif rating >= ratingCap then
                    capped = 1;
                end
            end
        end
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
