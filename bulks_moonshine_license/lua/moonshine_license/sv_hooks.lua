include("moonshine_license/sv_moonshine_config.lua")

hook.Add("PlayerSay", "MoonshineCMD", function( sender, msg )
    local text = string.lower( msg )
    local givecmdsub = string.sub(text, 1, string.len(moonshineconfig.givecommand))
    local removecmdsub = string.sub(text, 1, string.len(moonshineconfig.removecommand))
    local updatecmdsub = string.sub(text, 1, string.len(moonshineconfig.updatecommand))
    if givecmdsub == moonshineconfig.givecommand then
        if CheckTeam(sender) == true then
            CheckGive(sender, text)
        end
        return " "
    elseif removecmdsub == moonshineconfig.removecommand then
        if CheckTeam(sender) == true then
            CheckRemove(sender, text)
        end
        return " "
    elseif updatecmdsub == moonshineconfig.updatecommand then
        if CheckTeam(sender) == true then
            CheckUpdate(sender, text)
        end
        return " "
    end
end)

function CheckGive(sender, text)
    local subname = string.sub(text, string.len(moonshineconfig.givecommand) + 2)
    local ply = FindbyName( subname, sender )
    if ply != nil then
        local haslicense = ply:GetMoonshineLicense()
        if haslicense then
            sender:ChatPrint(ply:Nick().." besitzt bereits eine Bierbraulizenz.")
        else
            sender:ChatPrint("Die Bierbraulizenz für "..ply:Nick().." wurde erfolgreich ausgestellt.")
            ply:ChatPrint("Dir wurde eine Bierbraulizenz von "..sender:Nick().." ausgestellt.")
            ply:SetMoonshineLicense(true)
            ply:SetMoonshineLicenseData( sender:Nick() )
        end
    end
end

function CheckRemove(sender, text)
    local subname = string.sub(text, string.len(moonshineconfig.removecommand) + 2)
    local ply = FindbyName( subname, sender )
    if ply != nil then
        local haslicense = ply:GetMoonshineLicense()
        if !haslicense then
            sender:ChatPrint(ply:Nick().." besitzt keine Bierbraulizenz.")
        else
            sender:ChatPrint("Du hast die Bierbraulizenz von "..ply:Nick().." entzogen.")
            ply:ChatPrint("Deine Bierbraulizenz wurde von "..sender:Nick().." entzogen!")
            ply:SetMoonshineLicense( false )
            ply:SetMoonshineLicenseData( nil, nil )
        end
    end
end

function CheckUpdate(sender, text)
    local subname = string.sub(text, string.len(moonshineconfig.updatecommand) + 2)
    local ply = FindbyName( subname, sender )
    if ply != nil then
        local haslicense = ply:GetMoonshineLicense()
        if !haslicense then
            sender:ChatPrint(ply:Nick().." besitzt keine Bierbraulizenz.")
        else
            sender:ChatPrint("Du hast die Bierbraulizenz von "..ply:Nick().." erneuert.")
            ply:ChatPrint("Deine Bierbraulizenz wurde von "..sender:Nick().." erneuert!")
            ply:SetMoonshineLicenseData(sender:Nick())
        end
    end
end

function CheckTeam( ply )
    if table.HasValue(moonshineconfig.allowedteams, ply:Team()) then
        return true
    else
        ply:ChatPrint("Du hast nicht den benötigten Job um Bierlizenzen auszustellen.")
        return false
    end
end

function FindbyName( subname, sender )
    local counter = 0
    local foundply = nil 
    for k,v in pairs( player.GetAll() ) do
        local name = string.lower(v:Nick())
        local f1, f2, f3 = string.find(name, subname)
        if f1 != nil then
            counter = counter + 1
            foundply = v
        end
    end
    if counter > 1 then
        sender:ChatPrint("Es gibt zu viele mögliche Spieler.")
    elseif counter < 1 then
        sender:ChatPrint("Es wurde kein Spieler mit dem Namen gefunden.")
    else
        return foundply
    end
end

hook.Add("PlayerDeath", "MoonshineDeath", function(ply)
    if moonshineconfig.shouldremoveondeath == true then
        if ply:GetMoonshineLicense() == true then
            ply:SetMoonshineLicense(false)
        end
    end
end)