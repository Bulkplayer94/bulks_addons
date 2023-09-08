Access_Whitelist = {}

function Access_Whitelist.PrintMSG(ErrMsg)
	MsgC(Color(255,0,0), "[UD_Access_Whitelist] "..ErrMsg.."\n")
end

function Access_Whitelist.IsActive()
	return true
end

// Funktion zum Erstellen des Tables und weiterem.
function Access_Whitelist.Start()
	local IsSQLError = sql.Query("CREATE TABLE IF NOT EXISTS ud_access_table( Steam64 Text, PlayerName Text )")
	local SQL_Bot_Exec = sql.Query([[
		INSERT INTO ud_access_table (Steam64, PlayerName)
		SELECT '0', 'Bot'
		WHERE NOT EXISTS (SELECT * FROM ud_access_table WHERE Steam64 = '0')
	]])
	if IsSQLError == false then
		Access_Whitelist.PrintMSG(sql.LastError())
	end
end
Access_Whitelist.Start()

// Funktion zum Registrieren von einem Spieler in der Tabelle.
function Access_Whitelist.Register(Steam64, PlayerName)
	if !PlayerName then
		PlayerName = "n.A."
	end
	local IsSQLError = sql.Query("INSERT INTO ud_access_table ( Steam64, PlayerName ) VALUES ( "..Steam64..", '"..PlayerName.."' )")
	if IsSQLError == false then
		Access_Whitelist.PrintMSG(sql.LastError())
	end
end

// Funktion zum Entfernen eine SteamID64 aus der Tabelle
function Access_Whitelist.Remove(Steam64)
	local IsSQLError = sql.Query("DELETE FROM ud_access_table WHERE Steam64 = "..Steam64)
	if IsSQLError == false then
		Access_Whitelist.PrintMSG(sql.LastError())
	end
end

// Checke ob ein Spieler Registriert wurde.
function Access_Whitelist.Check_SteamID64(Steam64ToCheck)
	local SQL_Out = sql.Query("SELECT Steam64 FROM ud_access_table")
	if SQL_Out == false then
		Access_Whitelist.PrintMSG(sql.LastError())
		return false
	elseif SQL_Out == nil then
		return false
	else
		for k,v in pairs(SQL_Out) do
			if v["Steam64"] == Steam64ToCheck then
				return true
			end
		end
		return false
	end
end

// ULX besitzt keine Funktion zum überprüfen ob eine SteamID64 eine Usergroup besitzt, also schreibe ich das Selber.
function Access_Whitelist.Check_ULX_Group_64(Steam64ToCheck)
	local SteamIDfrom64 = util.SteamIDFrom64(Steam64ToCheck)
	local SQLite_Output = sql.Query("SELECT * FROM FAdmin_PlayerGroup")
	for k, v in pairs(SQLite_Output) do
		if v["steamid"] == SteamIDfrom64 && v["groupname"] == "superadmin" then
			return true
		else
			continue
		end
	end
	return false
end
Access_Whitelist.Check_ULX_Group_64("76561198305930130")

// Hook zum überprüfen, ob der sich verbindende Spieler Registriert ist.
// oder das Passwort Valide ist.
local RefusedText = [[
	          Connection Failed
	You dont have Access to this Server
	       or Password is Wrong.
	    - Underdog Gaming Team -
]]

hook.Add( "CheckPassword", "access_whitelist", function( steamID64, IP, sv_pw, cl_pw )
	if Access_Whitelist.IsActive() == true then
		if Access_Whitelist.Check_SteamID64( steamID64 ) == true then
		 	return true
		elseif Access_Whitelist.Check_ULX_Group_64( steamID64 ) == true then
		 	return true
		elseif sv_pw == cl_pw then
			return true
    	else
			return false, RefusedText
		end
	end
end)