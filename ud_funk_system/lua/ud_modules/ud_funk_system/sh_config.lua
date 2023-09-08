ud_funksys = {}
ud_funksys.gfunk = {}
ud_funksys.ffunk = {}
ud_funksys.pfunk = {}
ud_funksys.werbung = {}
ud_funksys.looc = {}
ud_funksys.akt = {}

ud_funksys.cmdtable = {}
ud_funksys.cmdtable.gfunk = {}
ud_funksys.cmdtable.gfunk.cmd = "/funk"
ud_funksys.cmdtable.gfunk.prefix = "[Funk]"
ud_funksys.cmdtable.gfunk.color = Color(255,255,0)
ud_funksys.cmdtable.ffunk = {}
ud_funksys.cmdtable.ffunk.cmd = "/ffunk"
ud_funksys.cmdtable.ffunk.prefix = "[Fraktions-Funk]"
ud_funksys.cmdtable.ffunk.color = Color(255,0,0)
ud_funksys.cmdtable.pfunk = {}
ud_funksys.cmdtable.pfunk.cmd = "/pfunk"
ud_funksys.cmdtable.pfunk.prefix = "[Polizei-Funk]"
ud_funksys.cmdtable.pfunk.color = Color(0,0,255)
ud_funksys.cmdtable.werbung = {}
ud_funksys.cmdtable.werbung.cmd = "/werbung"
ud_funksys.cmdtable.werbung.prefix = "[Werbung]"
ud_funksys.cmdtable.werbung.color = Color(255,255,0)
ud_funksys.cmdtable.looc = {}
ud_funksys.cmdtable.looc.cmd = "/looc"
ud_funksys.cmdtable.looc.prefix = "(LOOC)"
ud_funksys.cmdtable.looc.color = Color(0,200,0)
ud_funksys.cmdtable.akt = {}
ud_funksys.cmdtable.akt.cmd = "/akt"
ud_funksys.cmdtable.akt.prefix = "[AKT]"
ud_funksys.cmdtable.akt.color = Color(150,0,0)

// Teams die keinen Fraktionsfunk haben ( Polizei wird in ud_funksys.cpfractions.noffunk geregelt! )
ud_funksys.fractionblacklist = {
    TEAM_HOBO,
    TEAM_GUN,
    TEAM_CITIZEN
}

// Teams die zur Polizei gehören
ud_funksys.cpfractions = {
    TEAM_POLICE,
    TEAM_CHIEF,
    TEAM_MAYOR
}

// Haben die Direktionen keinen eigenen Direktionsfunk?
ud_funksys.cpfractions.noffunk = true