SWEP.PrintName		= "Bier Lizenz Checker"
SWEP.Author			= "Bulkplayer94"
SWEP.Contact		= ""
SWEP.Purpose		= "Überprüfen der Bierlizenzen"
SWEP.Instructions	= "Mit Linklick auf die Person die Lizenz begutachten"
SWEP.Category = "Bulks SWEPs"

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.WorldModel = ""
SWEP.Spawnable = true 

SWEP.Primary.ClipSize		= -1		
SWEP.Primary.DefaultClip	= -1		
SWEP.Primary.Automatic		= false		
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1		
SWEP.Secondary.DefaultClip	= -1		
SWEP.Secondary.Automatic	= false		
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()
    self:SetHoldType( "normal" )
end

function SWEP:Holster()
    return true
end

function SWEP:PreDrawViewModel()
    return true
end