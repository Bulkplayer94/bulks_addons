ud_confiscation = {}

// Entity Namen die Entfernt werden können.
// Einfach im Spawnmenu mit Rechtsklick aufs Entity hinzufügen.
// Jeder name der mit _ ended wird erweitert auf jedes Entity das damit anfängt.
// Beispiel "zmlab2_item_" wird erweitert auf "zmlab2_item_acid" und "zmlab2_item_crate" usw.

ud_confiscation.EntityNames = {
    "zmlab2_item_",
    "zmlab2_machine_",
    "zmlab2_tent",
    "zmlab2_equipment",
    "zmlab2_storage",
    "zmlab2_table",
    "item_ammo_",
    "item_rpg_round",
    "zyb_distellery",
    "zyb_fuel",
    "zyb_jar",
    "zyb_motor",
    "zyb_palette",
    "zyb_paperbag",
    "zyb_sugar",
    "zyb_upgrade",
    "zyb_water",
    "zyb_yeast",
    "zyb_yeastgrinder",
    "zwf_",
    "tierp_",
    "storerob_moneybag"
}

ud_confiscation.CP_Teams = {
    TEAM_POLICE,
    TEAM_CHIEF,
    TEAM_MAYOR
}

// Nono Edit
ud_confiscation.FindEntityNames = {}
ud_confiscation.ExplicitEntityNames = {}

for k,v in pairs(ud_confiscation.EntityNames) do
    if string.EndsWith(v, "_") then
        table.insert(ud_confiscation.FindEntityNames, v) 
    else
        table.insert(ud_confiscation.ExplicitEntityNames, v)
    end
end