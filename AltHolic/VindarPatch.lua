--[[ Vindar, 11/2010
     A patch for the Turbine.PluginData bug for European clients. It's dirty but it seems to works :)

     AltHolic 5.06: the encoder/decoder now use string.gsub instead of rebuilding every string
     one byte at a time. The old loops were quadratic in string length and ran over the whole
     saved data set on every save/load. The on-disk format is unchanged byte-for-byte, so
     existing AltHolic save files load exactly as before.
]]--

local gsub = string.gsub;
local byte = string.byte;
local char = string.char;
local sub = string.sub;
local find = string.find;

-- Bytes the encoder escapes as "#<decimal>#": control characters (0-31) and anything above
-- 125 ("}"). A literal "#" (35) is doubled to "##".
local ESCAPE_PATTERN = "[%z\1-\31\126-\255#]";

local function EscapeByte(c)
    local value = byte(c);
    if value == 35 then return "##"; end
    return "#" .. value .. "#";
end

local function EncodeValue(value)
    if type(value) == "number" then return tostring(value); end
    if type(value) ~= "string" then return value; end

    local encoded = gsub(value, ESCAPE_PATTERN, EscapeByte);
    -- A leading "#" or a numeric-looking string gets a "#" prefix so the decoder keeps it a string.
    if byte(encoded, 1) == 35 or tonumber(encoded) ~= nil then
        return "#" .. encoded;
    end
    return encoded;
end

-- "##" is a literal "#"; "#<n>#" is the byte n. Mirrors the original tokenizer exactly,
-- including how it treats malformed (hand-edited) data.
local function UnescapeToken(token)
    if token == "" then return "#"; end
    local value = tonumber(token);
    if value == nil then error("convBack : parse error 2 !"); end
    return char(value);
end

local function DecodeValue(value)
    if type(value) ~= "string" then return value; end
    if value == "" then return ""; end

    local number = tonumber(value);
    if number ~= nil then return number; end

    if byte(value, 1) == 35 then value = sub(value, 2); end
    if find(value, "#", 1, true) == nil then return value; end

    -- An unpaired "#" left after removing the tokens means the stored string is corrupt.
    local stripped = gsub(value, "#[^#]*#", "");
    if find(stripped, "#", 1, true) ~= nil then error("convBack : parse error 1 !"); end

    local decoded = gsub(value, "#([^#]*)#", UnescapeToken);
    return decoded;
end

-- Deep-copy a value, transforming every key and leaf with the supplied converter.
local function DeepConvert(object, convert)
    local lookup = {};
    local function copy(value)
        if type(value) ~= "table" then return convert(value); end
        if lookup[value] then return lookup[value]; end
        local result = {};
        lookup[value] = result;
        for key, item in pairs(value) do
            result[copy(key)] = copy(item);
        end
        return setmetatable(result, getmetatable(value));
    end
    return copy(object);
end

-- return a copy of the object obj in a safe format
function convSafe(obj)
    return DeepConvert(obj, EncodeValue);
end

-- the inverse operation
function convBack(obj)
    return DeepConvert(obj, DecodeValue);
end

-- Replacement for Turbine.PluginData.Load
function PatchDataLoad(scope, key, default)
    local success, results = pcall(Turbine.PluginData.Load, scope, key, default);
    if not success then
        Write("Error:" .. tostring(results));
        Write("While processing Turbine.PluginData.Load(" .. tostring(scope) .. ", " .. tostring(key) .. ", " .. tostring(default) .. ")");
        return nil;
    end

    success, results = pcall(convBack, results);
    if not success then
        Write("Error:" .. tostring(results));
        Write("While processing convBack(Turbine.PluginData.Load(" .. tostring(scope) .. ", " .. tostring(key) .. ", " .. tostring(default) .. "))");
        return nil;
    end
    return results;
end

-- Replacement for Turbine.PluginData.Save
function PatchDataSave(scope, key, data, callback)
    return Turbine.PluginData.Save(scope, key, convSafe(data), callback);
end

-- end of file
