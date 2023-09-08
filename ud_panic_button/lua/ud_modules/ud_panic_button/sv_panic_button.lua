include("ud_modules/ud_panic_button/sh_config.lua")
util.AddNetworkString("ud_panic_button")
resource.AddSingleFile("sound/ud_panic_button/panic_button.mp3")

function ud_panic_button.server.CheckPlayer( ply )
    for k, v in pairs(ud_panic_button.cpteams) do
        if v != ply:Team() then
            continue
        else
            return true
        end
    end
end

function ud_panic_button.server.GetPlayers()
    local ReturnTable = {}
    for _, CurTeam in pairs(ud_panic_button.cpteams) do
        for k, v in pairs( team.GetPlayers( CurTeam ) ) do
            table.insert(ReturnTable, v)
        end
    end
    return ReturnTable
end

function ud_panic_button.server.SendPlayers( ply )
    ply.lastpanicbutton = CurTime() + ud_panic_button.cooldown
    local TeamTable = ud_panic_button.server.GetPlayers()
    net.Start("ud_panic_button")
    net.WriteEntity( ply )
    net.Send( TeamTable )
end

net.Receive("ud_panic_button", function( len, real_ply)
    local ply = net.ReadEntity()
    if ud_panic_button.server.CheckPlayer( real_ply ) == true && real_ply:Alive() then
        real_ply.lastpanicbutton = ply.lastpanicbutton or CurTime() - 1
        if real_ply.lastpanicbutton < CurTime() then
            ud_panic_button.server.SendPlayers( real_ply )
        else
           real_ply:SendNotification("Dein Panic-Button ist noch auf Cooldown für: "..tostring(math.Round(ply.lastpanicbutton - CurTime())).." Sekunden!", NOTIFY_ERROR, 5) 
        end
    else
        real_ply:SendNotification("Du hast keinen Zugriff auf den Panic Button!", NOTIFY_ERROR, 5) 
    end
end)