util.AddNetworkString("ud_funk_sys")

hook.Add("PlayerSay", "Underdog Funksys PlayerSay", function(ply, msg) 

    local lowermsg = string.lower( msg )
    if string.StartsWith(lowermsg, ud_funksys.cmdtable.gfunk.cmd) then
        ud_funksys.gfunk.Send(ply, string.sub(msg, string.len(ud_funksys.cmdtable.gfunk.cmd) + 1))
        return ""
    elseif string.StartsWith(lowermsg, ud_funksys.cmdtable.pfunk.cmd) then
        ud_funksys.pfunk.Send(ply, string.sub(msg, string.len(ud_funksys.cmdtable.pfunk.cmd) + 2))
        return ""
    elseif string.StartsWith(lowermsg, ud_funksys.cmdtable.ffunk.cmd) then
        ud_funksys.ffunk.Send(ply, string.sub(msg, string.len(ud_funksys.cmdtable.ffunk.cmd) + 2))
        return ""
    elseif string.StartsWith(lowermsg, ud_funksys.cmdtable.werbung.cmd) then
        ud_funksys.werbung.Send(ply, string.sub(msg, string.len(ud_funksys.cmdtable.werbung.cmd) + 2))
        return ""
    elseif string.StartsWith(lowermsg, ud_funksys.cmdtable.looc.cmd) then
        ud_funksys.looc.Send(ply, string.sub(msg, string.len(ud_funksys.cmdtable.looc.cmd) + 2))
        return ""
    elseif string.StartsWith(lowermsg, ud_funksys.cmdtable.akt.cmd) then
        ud_funksys.akt.Send(ply, string.sub(msg, string.len(ud_funksys.cmdtable.akt.cmd) + 2))
        return ""
    end
end)

function ud_funksys.gfunk.Send(ply, text)
    net.Start("ud_funk_sys")
    net.WriteInt(1, 5)
    net.WriteEntity(ply)
    net.WriteString(text)
    net.Broadcast()
end

function ud_funksys.ffunk.Send(ply, text)
    if !table.HasValue(ud_funksys.fractionblacklist, ply:Team()) then
        if table.HasValue(ud_funksys.cpfractions, ply:Team()) && ud_funksys.cpfractions.noffunk then
            ply:SendNotification("Die Polizei hat keinen Direktionsfunk! Benutze "..ud_funksys.cmdtable.pfunk.cmd.."!", NOTIFY_ERROR, 5)
        else
            net.Start("ud_funk_sys")
            net.WriteInt(2, 5)
            net.WriteEntity(ply)
            net.WriteString(text)
            net.Send(team.GetPlayers(ply:Team()))
        end
    else
        ply:SendNotification("Du hast keinen Zugriff auf diesen Funk!", NOTIFY_ERROR, 5)
    end

    local function SendTheMessage()
        
    end
end

function ud_funksys.pfunk.Send(ply, text)
    if table.HasValue(ud_funksys.cpfractions, ply:Team()) then
        local TeamTable = {}
        for _, v in pairs(ud_funksys.cpfractions) do
            for k, v in pairs( team.GetPlayers( v ) ) do
                table.insert(TeamTable, v)
            end
        end
        net.Start("ud_funk_sys")
        net.WriteInt(3, 5)
        net.WriteEntity(ply)
        net.WriteString(text)
        net.Send(TeamTable)
    else
        ply:SendNotification("Du hast keinen Zugriff auf den Polizeifunk", NOTIFY_ERROR, 5)
    end
end

function ud_funksys.werbung.Send(ply, text)
    net.Start("ud_funk_sys")
    net.WriteInt(4, 5)
    net.WriteEntity(ply)
    net.WriteString(text)
    net.Broadcast()
end

function ud_funksys.looc.Send(ply, text)
    net.Start("ud_funk_sys")
    net.WriteInt(5,5)
    net.WriteEntity(ply)
    net.WriteString(text)
    net.SendPAS(ply:GetPos())
end

function ud_funksys.akt.Send(ply, text)
    net.Start("ud_funk_sys")
    net.WriteInt(6,5)
    net.WriteEntity(ply)
    net.WriteString(text)
    net.Broadcast()
end
