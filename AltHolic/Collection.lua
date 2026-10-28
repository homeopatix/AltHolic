AltHolicCollection = AltHolicCollection or {};
local C = AltHolicCollection;
local D = AltHolicCollectionData;

C.KINDS = { "mounts", "pets" };

local known = { mounts = {}, pets = {} };
if type(D) == "table" then
    for _, icon in ipairs(D.mounts or {}) do known.mounts[icon] = true; end
    for _, icon in ipairs(D.pets or {}) do known.pets[icon] = true; end
end

local petsByName = {};
if type(D) == "table" then
    for icon, names in pairs(D.petsByName or {}) do
        petsByName[icon] = {};
        for _, name in ipairs(names or {}) do petsByName[icon][name] = true; end
    end
end

local lastCount = nil;
local skillIcons = {};

local function Learned()
    if settings == nil then return { mounts = {}, pets = {} }; end
    settings.collection = settings.collection or {};
    settings.collection.learned = settings.collection.learned or {};
    settings.collection.learned.mounts = settings.collection.learned.mounts or {};
    settings.collection.learned.pets = settings.collection.learned.pets or {};
    return settings.collection.learned;
end

function C.Kind(icon, name)
    icon = tonumber(icon);
    if icon == nil then return nil; end
    if known.mounts[icon] then return "mounts"; end
    if known.pets[icon] then return "pets"; end
    local shared = petsByName[icon];
    if shared and shared[name] then return "pets"; end
    local learned = Learned();
    if learned.mounts[tostring(icon)] then return "mounts"; end
    if learned.pets[tostring(icon)] then return "pets"; end
    return nil;
end

local function ByName(a, b)
    return string.lower(tostring(a.n or "")) < string.lower(tostring(b.n or ""));
end

function C.Scan(force)
    if Player == nil then return false; end
    local trainedSkills = Player.GetTrainedSkills and Player:GetTrainedSkills() or nil;
    if trainedSkills == nil then return false; end
    local count = tonumber(trainedSkills:GetCount()) or 0;
    if not force and count == lastCount then return false; end
    lastCount = count;

    local base = (count > 0 and trainedSkills:GetItem(0) ~= nil) and 0 or 1;
    local found = { mounts = {}, pets = {} };
    skillIcons = {};

    for index = base, base + count - 1 do
        local skill = trainedSkills:GetItem(index);
        local info = skill and skill:GetSkillInfo();
        if info ~= nil then
            local name = info:GetName();
            local icon = info:GetIconImageID();
            if name ~= nil and icon ~= nil then
                local nameText = tostring(name);
                local iconText = tonumber(icon);
                skillIcons[nameText] = iconText;
                local kind = C.Kind(iconText, nameText);
                if kind ~= nil then
                    found[kind][#found[kind] + 1] = { n = nameText, i = iconText };
                end
            end
        end
    end

    table.sort(found.mounts, ByName);
    table.sort(found.pets, ByName);

    if PlayerDatas ~= nil then
        PlayerDatas[PlayerName] = PlayerDatas[PlayerName] or {};
        local record = PlayerDatas[PlayerName];
        local beforeMounts = record.mounts or {};
        local beforePets = record.pets or {};
        record.mounts = found.mounts;
        record.pets = found.pets;

        if beforeMounts ~= record.mounts or beforePets ~= record.pets then
            if MarkPlayerDatasDirty ~= nil then
                MarkPlayerDatasDirty();
            end
        end
    end

    return true;
end

local function LearnFrom(object, kind)
    if object == nil then return false; end
    local name = object.GetName and object:GetName() or nil;
    if name == nil then return false; end
    local icon = skillIcons[tostring(name)];
    if icon == nil or C.Kind(icon, tostring(name)) ~= nil then return false; end

    local learned = Learned();
    learned[kind][tostring(icon)] = true;
    settings.collection.learned = learned;
    return true;
end

function C.Poll()
    if Player == nil then return false; end
    local changed = false;
    if C.Scan(false) then changed = true; end

    local mountObject = Player.GetMount and Player:GetMount() or nil;
    if mountObject ~= nil then
        if LearnFrom(mountObject, \"mounts\") then changed = true; end
    end

    if Player.GetPet ~= nil then
        local classId = tonumber(PlayerClass) or -1;
        if classId ~= 24 and classId ~= 185 then
            local petObject = Player:GetPet();
            if petObject ~= nil then
                if LearnFrom(petObject, \"pets\") then changed = true; end
            end
        end
    end

    if changed then
        C.Scan(true);
    end

    return changed;
end

function C.ResetLearned()
    local learned = Learned();
    learned.mounts = {};
    learned.pets = {};
    settings.collection.learned = learned;
end

function C.GetCharacterCollection(playerName)
    playerName = playerName or PlayerName;
    if PlayerDatas == nil then return { mounts = {}, pets = {} }; end
    local record = PlayerDatas[playerName] or {};
    return {
        mounts = record.mounts or {},
        pets = record.pets or {},
    };
end