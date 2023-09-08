// Command beim Ingame auswählen von einem Spieler

function ulx.access_whitelist_ply( calling_ply, target_ply )
    local target_ply_64 = target_ply:SteamID64()
    if !Access_Whitelist.Check_SteamID64(target_ply_64) then
        Access_Whitelist.Register(target_ply_64, target_ply:Name())
        ulx.fancyLogAdmin( calling_ply, "#A added #T to the Whitelist", target_ply)
    else
        Access_Whitelist.Remove(target_ply_64)
        ulx.fancyLogAdmin( calling_ply, "#A removed #T from the Whitelist", target_ply)
    end
end

local access_whitelist_ply = ulx.command("UD Systems", "ulx ud_access_whitelist", ulx.access_whitelist_ply, "!addwhitelist")
access_whitelist_ply:addParam{ type=ULib.cmds.PlayerArg }
access_whitelist_ply:defaultAccess( ULib.ACCESS_SUPERADMIN )
access_whitelist_ply:help( "Adds a player to the whitelist or removes him if he is already on it." )

// Command zum SteamID64 hinzufügen

function ulx.access_whitelist_id( calling_ply, target_ply_64, target_ply_name )
    if string.StartsWith(target_ply_64, "STEAM_") == true then
        target_ply_64 = util.SteamIDTo64(target_ply_64)
    end

    local match_for_letters = string.match(target_ply_name, "%a", 0)
    local ulx_target
    if match_for_letters != nil then
        ulx_target = target_ply_name
    else
        ulx_target = target_ply_64
    end
    if !Access_Whitelist.Check_SteamID64(target_ply_64) then
        Access_Whitelist.Register(target_ply_64, ulx_target)
        ulx.fancyLogAdmin( calling_ply, "#A added "..ulx_target.." to the Whitelist")
    else
        Access_Whitelist.Remove(target_ply_64)
        ulx.fancyLogAdmin( calling_ply, "#A removed "..ulx_target.." from the Whitelist")
    end
end

local access_whitelist_64 = ulx.command("UD Systems", "ulx ud_access_whitelist_id", ulx.access_whitelist_id)
access_whitelist_64:addParam{ type=ULib.cmds.StringArg, hint="SteamID or SteamID64" }
access_whitelist_64:addParam{ type=ULib.cmds.StringArg, hint="Name (Optional)", ULib.cmds.optional }
access_whitelist_64:defaultAccess( ULib.ACCESS_SUPERADMIN )
access_whitelist_64:help( "Adds a Player by its SteamID or SteamID64 to the whitelist or removes him if he is already on it." )



// Command zum Anzeigen der Whitelist

function ulx.access_whitelist_list(calling_ply)
    local SQL_DATA = sql.Query("SELECT * FROM ud_access_table")
    if calling_ply:IsPlayer() then
        calling_ply:PrintMessage(HUD_PRINTCENTER, "Look into your Console to View the List.")
        calling_ply:PrintMessage(HUD_PRINTCONSOLE, "START OF LIST")
        for k, v in pairs(SQL_DATA) do
            calling_ply:PrintMessage(HUD_PRINTCONSOLE, v["Steam64"].."  :  "..v["PlayerName"])
        end
        calling_ply:PrintMessage(HUD_PRINTCONSOLE, "END OF LIST")
    else
        Msg("START OF LIST\n\n")
        for k, v in pairs(SQL_DATA) do
            Msg(v["Steam64"].."  :  "..v["PlayerName"].."\n")
        end
        Msg("\nEND OF LIST\n")
    end
end

local access_whitelist_list = ulx.command("UD Systems", "ulx ud_access_whitelist_list", ulx.access_whitelist_list)
access_whitelist_list:defaultAccess( ULib.ACCESS_SUPERADMIN )
access_whitelist_list:help( "Shows the whole List of Players on the Whitelist." )