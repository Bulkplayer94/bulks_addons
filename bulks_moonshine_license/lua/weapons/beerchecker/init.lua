AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function SWEP:PrimaryAttack()
    if not self.Owner:IsValid() then return end
    local Eyetrace = self.Owner:GetEyeTrace()
    local ownerpos = self.Owner:GetPos()
    local ent = Eyetrace.Entity
    if not ent:IsValid() then return end
    if ownerpos:Distance( ent:GetPos() ) > 80 then return end
    if not ent:IsPlayer() then return end
    // Den Überprüften benachrichtigen
    ent:ChatPrint( "Deine Bierbraulizenz wurde von "..self.Owner:Nick().." überprüft." )
    // Schleife für Antworten
    if ent:GetMoonshineLicense() == true then
        self.Owner:ChatPrint( ent:Nick().." besitzt eine Bierbraulizenz." )
        local nick, time = ent:GetMoonshineLicenseData( true )
        self.Owner:ChatPrint( "Ausgestellt von: "..nick.." | Zeitstempel: "..time)
    else
        self.Owner:ChatPrint( ent:Nick().." besitzt keine Bierbraulizenz.")
    end
end