util.AddNetworkString("ud_confis_menu")

// Custom Nachricht senden.
local function SendMsg(ply, msg)
    ply:PrintMessage(HUD_PRINTTALK, "[UD Confiscation] "..msg)
end

// Nachricht senden, dass ein Gegenstand beschlagnahmt wurde.
local function SendEntMsg(ply)
    ud_funksys.pfunk.Send(ply, "[Info] Ich habe einen Illegalen gegenstand beschlagnahmt!")
end

// Funktion falls ein Fahrzeug beschlagnahmt wird.  
function ud_confiscation.confiscate_vehicle(ply, vehicle)
    print(vehicle:getDoorOwner())
    local VehicleOwner = vehicle:getDoorOwner()
    if VehicleOwner != nil then
        SendMsg(VehicleOwner, "Dein Fahrzeug wurde von "..ply:Nick().." beschlagnahmt!")
    end
    ud_funksys.pfunk.Send(ply, "[Info] Ich habe ein Fahrzeug beschlagnahmt!")
    vehicle:Remove()
end

// Funktion um zu überprüfen ob ein Entity mit _ endet.
local function CheckIfStartsWith(Class)
    for _,v in pairs(ud_confiscation.FindEntityNames) do
        local Found1 = string.find(Class, v, 1, true)
        if Found1 != nil then
            return true
        end
    end
    return false
end

// Funktion die Aufgerufen wird falls ein Entity beschlagnahmt wird.
function ud_confiscation.confiscate_entity(ply, entity)
    local EntName = entity:GetClass()
    if CheckIfStartsWith(EntName) || table.HasValue(ud_confiscation.ExplicitEntityNames, EntName) then
        SendEntMsg(ply)
        entity:Remove()
    else
        SendMsg(ply, "Das ist kein Illegales Entity!")
    end
end

// Allgemeiner aufruf des Commands. (Kann durch jedes Skript aufgerufen werden.)
function ud_confiscation.confiscation_check(ply)
    local Eyetrace = ply:GetEyeTrace()
    local EyetraceEnt = Eyetrace.Entity
    if Eyetrace.HitPos:Distance(ply:GetPos()) < 100 && table.HasValue(ud_confiscation.CP_Teams, ply:Team()) then
        if EyetraceEnt:IsValid() then
            if EyetraceEnt:IsVehicle() then
                ud_confiscation.confiscate_vehicle(ply, EyetraceEnt)
            elseif EyetraceEnt:IsWeapon() then
                SendEntMsg(ply)
                EyetraceEnt:Remove()
            else
                ud_confiscation.confiscate_entity(ply, EyetraceEnt)
            end
        else
            SendMsg(ply, "Das ist kein Entity!")
        end
    end
end

--concommand.Add("beschlagnahmen", ud_confiscation.confiscation_check)

net.Receive("ud_confis_menu", function(len, ply)
    if !table.HasValue(ud_confiscation.CP_Teams, ply:Team()) then return end
    ud_confiscation.confiscation_check(ply)
end)
