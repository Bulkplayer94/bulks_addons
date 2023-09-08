-- Funktion zum Überprüfen, ob ein Türobjekt keinen Namen hat
local function IsDoorUnnamed(door)
    return door:GetName() == ""
end

-- Funktion zum Generieren eines eindeutigen Namens für ein Türobjekt
local function GenerateUniqueName(doorID)
    return "door_" .. tostring(doorID)
end

-- Funktion zum Laden des Türnamens aus der Datei
local function LoadDoorName(doorID)
    local doorData = file.Read("door_names.txt", "DATA")
    if doorData then
        local doorTable = {}
        for doorID, doorName in doorData:gmatch("(%d+)%s*=%s*([^\n]+)") do
            doorTable[tonumber(doorID)] = doorName
        end
        return doorTable[doorID]
    end
    return nil
end

-- Funktion zum Speichern des Türnamens in der Datei
local function SaveDoorName(doorID, doorName)
    local doorData = file.Read("door_names.txt", "DATA")
    local newData = ""
    if doorData then
        newData = doorData
    end
    newData = newData .. tostring(doorID) .. " = " .. doorName .. "\n"
    file.Write("door_names.txt", newData)
end

-- Haken an das Initialisierungsereignis
hook.Add("InitPostEntity", "UniqueDoorNames", function()
    -- Suche nach Türen ohne Namen und weise ihnen eindeutige Namen zu
    for _, door in ipairs(ents.FindByClass("func_door")) do
        if IsDoorUnnamed(door) then
            local doorID = door:EntIndex()
            local doorName = LoadDoorName(doorID) or GenerateUniqueName(doorID)
            door:SetKeyValue("targetname", doorName)
            SaveDoorName(doorID, doorName)
        end
    end

    for _, door in ipairs(ents.FindByClass("func_door_rotating")) do
        if IsDoorUnnamed(door) then
            local doorID = door:EntIndex()
            local doorName = LoadDoorName(doorID) or GenerateUniqueName(doorID)
            door:SetKeyValue("targetname", doorName)
            SaveDoorName(doorID, doorName)
        end
    end

    for _, door in ipairs(ents.FindByClass("prop_door_rotating")) do
        if IsDoorUnnamed(door) then
            local doorID = door:EntIndex()
            local doorName = LoadDoorName(doorID) or GenerateUniqueName(doorID)
            door:SetKeyValue("targetname", doorName)
            SaveDoorName(doorID, doorName)
        end
    end
end)