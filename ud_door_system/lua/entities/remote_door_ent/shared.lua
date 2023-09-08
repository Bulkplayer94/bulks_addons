ENT.Base = "base_gmodentity";
ENT.Type = "anim";
ENT.PrintName = "Door Control System Entity"
ENT.Category = "Bulks Entities"
ENT.Author = "Bulkplayer94"
ENT.Spawnable = true

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "DoorCount")
end