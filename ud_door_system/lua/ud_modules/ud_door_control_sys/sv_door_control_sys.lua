local doortable = {
    [1] = "func_door",
    [2] = "func_door_rotating",
    [3] = "prop_door_rotating"
}
local function DoorCheck(door, ply, typo)
    if !door:IsValid() then
        ply:ChatPrint("[DoorSys] Das ist kein Verfügbares Entity")
        return false
    else
        if !table.HasValue(doortable, door:GetClass()) then
            ply:ChatPrint("[DoorSys] Das ist keine Tür!")
            return false
        else
            if typo != nil && typo != "" then
                local ent = Entity(typo)
                if ent:IsValid() then
                    if ent:GetClass() != "remote_door_ent" then
                        ply:ChatPrint("[DoorSys] Die Nummer ist kein Door Controller.")
                        return false 
                    else
                        return true
                    end
                else
                    ply:ChatPrint("[DoorSys] Dieser Index ist nicht Definiert.")
                    return false
                end
            else
                return true
            end
        end
    end
end


hook.Add("PlayerSay", "DoorControlsys", function(ply, msg)

    local loweredtext = string.lower(msg)
    if string.StartsWith(loweredtext, "/registerdoor") && ply:IsSuperAdmin() then
        msg = string.sub(msg, 15)
        local door = ply:GetEyeTrace().Entity
        if DoorCheck(door,ply,msg) then
            Entity(msg):RegisterDoor(door, ply)
        end
        return ""

    elseif string.StartsWith(loweredtext, "/toggledooradmin") && ply:IsSuperAdmin() then
        if ply:GetNWBool("DoorSysAdminMode", false) == false then
            ply:SetNWBool("DoorSysAdminMode", true)
            ply:ChatPrint("[Door-System] Du hast den Admin-Mode eingeschaltet!")
        else
            ply:SetNWBool("DoorSysAdminMode", false)
            ply:ChatPrint("[Door-System] Du hast den Admin-Mode ausgeschaltet!")
        end
        return ""

    // Speichern, Laden und Entfernen
    elseif string.StartsWith(loweredtext, "/savedoorremotes") && ply:IsSuperAdmin() then
        hook.Run("UD_Door_Sys_Save", ply)
        return ""
    elseif string.StartsWith(loweredtext, "/loaddoorremotes") && ply:IsSuperAdmin() then
        hook.Run("UD_Door_Sys_Load", ply)
        return ""
    elseif string.StartsWith(loweredtext, "/removedoorremotes") && ply:IsSuperAdmin() then
        hook.Run("UD_Door_Sys_Clear", ply)
        return ""
    end
end)

hook.Add("UD_Door_Sys_Save", "UD_Door_Sys_Save_Internal", function(ply)
    if !file.IsDir("ud_door_sys", "DATA") then
        file.CreateDir("ud_door_sys", "DATA")
    end
    if file.Exists("ud_door_sys/"..game.GetMap()..".json", "DATA") then
        file.Delete("ud_door_sys/"..game.GetMap()..".json", "DATA")
    end
    for _, Door in pairs(ents.FindByClass("remote_door_ent")) do
        local SaveTable = {
            pos = Door:GetPos(),
            doors = Door.DoorsControlled,
            teams = Door.SendingTeams
        }
        local json = util.TableToJSON(SaveTable)
        file.Append("ud_door_sys/"..game.GetMap()..".json", json..";\n")
    end
    if ply:IsPlayer() then
        ply:ChatPrint("[DoorSys] Entities erfolgreich gespeichert!")
    end
end)

hook.Add("UD_Door_Sys_Load", "UD_Door_Sys_Load_Internal", function(ply)
    if !file.Exists("ud_door_sys/"..game.GetMap()..".json", "DATA") then
        print("[DoorSys] Es existiert keine Save-Datei für diese Map!")
        if ply != nil && ply:IsPlayer() then
            ply:ChatPrint("[DoorSys] Es existiert keine Save-Datei für die Map!")
        end
    else
        for k,v in pairs(ents.FindByClass("remote_door_ent")) do
            v:Remove()
        end
        local loadedfile = file.Read("ud_door_sys/"..game.GetMap()..".json", "DATA")
        for _,v in pairs(string.Split(loadedfile, ";")) do
            local jsondata = util.JSONToTable(v) 
            if jsondata != nil then
                local ent = ents.Create("remote_door_ent")
                ent:SetModel("models/hunter/blocks/cube025x025x025.mdl")
                ent:SetPos(jsondata.pos)
                for _, door in pairs(jsondata.doors) do
                    ent:RegisterDoor(door)
                end
                ent:Spawn()
                ent.SendingTeams = jsondata.teams
            end
        end
        if ply != nil && ply:IsPlayer() then
            ply:ChatPrint("[DoorSys] Erfolgreich geladen.")
        end
    end
end)

hook.Add("UD_Door_Sys_Clear", "UD_Door_Sys_Clear_Internal", function(ply) 
    for k,v in pairs(ents.FindByClass("remote_door_ent")) do
       v:Remove() 
    end
    if ply:IsPlayer() then
        ply:ChatPrint("[DoorSys] Entities Erfolgreich entfernt!")
    end
end)

hook.Add("InitPostEntity", "UD_Door_Sys_PostEntity", function() hook.Run("UD_Door_Sys_Load") end)
hook.Add("PostCleanupMap", "UD_Door_Sys_Cleanup", function() hook.Run("UD_Door_Sys_Load") end)

concommand.Add("opendoors", function(ply) 
    local function GetEntsByDistance(ply, maxdist, class)
        for i=0, maxdist do
            for _,v in pairs(ents.FindInSphere(ply:GetPos(), i)) do
                if v:GetClass() == class then
                    return v
                end
            end
        end
    end
    local ent = GetEntsByDistance(ply, 1000, "remote_door_ent")
    if ent != nil && ent:IsValid() then
        ent:OpenDoors(ply)
    else
        ply:ChatPrint("Kein Controller gefunden")
    end

end)