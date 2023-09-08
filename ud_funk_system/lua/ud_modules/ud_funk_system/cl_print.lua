net.Receive("ud_funk_sys", function()
    local messagetype = net.ReadInt(5)
    local ply = net.ReadEntity()
    local text = net.ReadString()
    if messagetype == 1 then
        chat.AddText(ud_funksys.cmdtable.gfunk.color, ud_funksys.cmdtable.gfunk.prefix.." ", team.GetColor( ply:Team() ) ,ply:Nick(), color_white, ":"..text)
    elseif messagetype == 2 then
        chat.AddText(ud_funksys.cmdtable.ffunk.color, ud_funksys.cmdtable.ffunk.prefix.." ", team.GetColor(ply:Team()), ply:Nick(), color_white, ": "..text)
    elseif messagetype == 3 then
        chat.AddText(ud_funksys.cmdtable.pfunk.color, ud_funksys.cmdtable.pfunk.prefix.." ", team.GetColor(ply:Team()), ply:Nick(), color_white, ": "..text)
    elseif messagetype == 4 then
        chat.AddText(ud_funksys.cmdtable.werbung.color, ud_funksys.cmdtable.werbung.prefix.." ", team.GetColor(ply:Team()), ply:Nick(), color_white, ": "..text)
    elseif messagetype == 5 then
        chat.AddText(ud_funksys.cmdtable.looc.color, ud_funksys.cmdtable.looc.prefix.." ", team.GetColor(ply:Team()), ply:Nick(), color_white, ": "..text)
    elseif messagetype == 6 then
        chat.AddText(ud_funksys.cmdtable.akt.color, ud_funksys.cmdtable.akt.prefix.." ", team.GetColor(ply:Team()), ply:Nick(), color_white, ": "..text)
    else
        Error("[UD Funksys] Benachrichtige bitte die Serverleitung mit dieser Nachricht: messagetype "..messagetype.." not specified!\n")
    end
end)