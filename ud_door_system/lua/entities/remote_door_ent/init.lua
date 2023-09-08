AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString("ud_door_sys_ent")

ENT.DoorsControlled = {}
ENT.DoorsControlledEntitys = {}
ENT.SendingTeams = {}

function ENT:Initialize()
    self:SetModel("models/hunter/blocks/cube05x05x05.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NOCLIP)
    self:SetCollisionGroup(COLLISION_GROUP_WORLD)
    self:SetTrigger(true)
    self:SetUseType(SIMPLE_USE)
end

function ENT:RegisterDoor( strDoor, ply )
    if IsEntity(strDoor) then
        strDoor = strDoor:GetName()
    end
    if !table.HasValue(self.DoorsControlled, strDoor) then
        table.insert(self.DoorsControlled, strDoor)
        for k,v in pairs(ents.FindByName(strDoor)) do
            table.insert(self.DoorsControlledEntitys, v)
        end
        if ply != nil then
            ply:ChatPrint("Door "..strDoor.." registered!")
        end
        self:SetDoorCount(#self.DoorsControlled)
    else
        if ply != nil then
            ply:ChatPrint("Door"..strDoor.." is already registered!")
        end
    end
end

function ENT:RegisterTeam( testteam, ply )
    if team.GetName(testteam) != "" && !table.HasValue(self.SendingTeams, testteam) then
        table.insert(self.SendingTeams, testteam)
    else
        if ply:IsPlayer() then ply:ChatPrint("Das ist kein verfügbares Team oder das Team ist bereits im Entity vorhanden!") end
    end
end

function ENT:RemoveAllDoors()
    self.DoorsControlled = {}
    self.DoorsControlledEntitys = {}
end

function ENT:OpenDoors(ply)
    local function DoorOpen()
        for k, v in pairs(self.DoorsControlledEntitys) do
            v:Fire("Unlock")
            v:Fire("Toggle")
            v:Fire("Lock")
        end        
    end
    if ply != nil && !table.IsEmpty(self.SendingTeams) then
        if table.HasValue(self.SendingTeams, ply:Team()) then
            DoorOpen()
        end
    elseif ply != nil && table.IsEmpty(self.SendingTeams) then
        DoorOpen()
    else
        DoorOpen()
    end
    
end

function ENT:GetDoorList()
    return self.DoorsControlled
end

function ENT:Use(ply)
    if ply:IsSuperAdmin() && ply:GetNWBool("DoorSysAdminMode", false) then
        net.Start("ud_door_sys_ent")
        net.WriteEntity(self)
        net.WriteInt(#self.SendingTeams, 10)
        for _, v in pairs(self.SendingTeams) do
            net.WriteInt(v, 10)
        end
        net.WriteInt(#self.DoorsControlledEntitys, 10)
        for _, v in pairs(self.DoorsControlledEntitys) do
            net.WriteEntity(v)
        end
        net.Send(ply)
    end
end

net.Receive("ud_door_sys_ent", function(len, ply) 
    if ply:IsSuperAdmin() && ply:GetNWBool("DoorSysAdminMode", false) then
        local doorcontroller = net.ReadEntity()
        local typo = net.ReadInt(10)
        if typo == 1 then
            doorcontroller:OpenDoors()
        else
            doorcontroller:RemoveAllDoors()
            local lenTeamList = net.ReadInt(10)
            local TeamList = {}
            for i=1, lenTeamList do
                table.insert(TeamList, net.ReadInt(10))
            end
            doorcontroller.SendingTeams = TeamList
            local lenDoorList = net.ReadInt(10)
            local DoorList = {}
            for i=1, lenDoorList do
                doorcontroller:RegisterDoor(net.ReadEntity())
            end
        end
    else
        ply:ChatPrint("Du hast keine Berechtigung dazu oder der Admin-Mode ist ausgeschaltet.")
    end
end)