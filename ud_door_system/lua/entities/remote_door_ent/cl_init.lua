include("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
    if LocalPlayer():GetNWBool("DoorSysAdminMode", false) then
        self:DrawModel()
    end
end

local blacklistteams = {
    TEAM_CONNECTING,
    TEAM_SPECTATOR,
    TEAM_UNASSIGNED
}

net.Receive("ud_door_sys_ent", function() 
    local ent = net.ReadEntity()
    local sendingteamsvalues = net.ReadInt(10)
    local sendingteams = {}
    for i=1, sendingteamsvalues do
        table.insert(sendingteams, net.ReadInt(10))
    end
    local SendingDoorList = {}
    local SendingDoorListValues = net.ReadInt(10)
    for i=1, SendingDoorListValues do
        table.insert(SendingDoorList, net.ReadEntity())
    end
    
    // Main Window
    local dframe = vgui.Create("DFrame")
    dframe:SetTitle("")
    dframe:SetSize(300, 450)
    dframe:Center()
    dframe:MakePopup()
    dframe:ShowCloseButton()
    function dframe:Paint(w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(75,75,75))
        draw.DrawText([[Info:
        /registerdoor (Index des Controllers): 
        Die derzeitig angeguckte Tür registrieren.
        /savedoorremotes: Speichere alle Remotes
        /loaddoorremotes: Remotes Neuladen
        /removedoorremotes: Remotes entfernen
        /toggledooradmin: Den Admin mode umschalten.
        opendoors: Command zum Binden und für Spieler.]], "Default", 0, 350, Color(255,255,255), TEXT_ALIGN_TOP, TEXT_ALIGN_LEFT)
    end
    
    // Button for Opening all Doors (WIP)
    local OpenDoorsB = vgui.Create("DButton", dframe)
    OpenDoorsB:SetText("Toggle alle Türen")
    OpenDoorsB:SetSize(300, 50)
    OpenDoorsB:SetPos(0, 25)
    function OpenDoorsB:DoClick()
        SendtheInfo(1)
        dframe:Close()
    end

    // List of all Registered Teams
    local TeamList = vgui.Create("DListView", dframe)
    TeamList:SetSize(300, 100)
    TeamList:SetPos(0, 75)
    TeamList:AddColumn("Name", 1)
    TeamList:AddColumn("Index", 2)
    TeamList:AddColumn("Spieler", 3)
    TeamList:AddColumn("Key", 4)
    
    // List of all Registered Teams Refresh
    local function RefreshTeamList()
        for k,v in pairs(TeamList:GetLines()) do
            TeamList:RemoveLine(k)
        end
        for k, v in pairs(sendingteams) do
            local line = TeamList:AddLine(team.GetName(v), v, #team.GetPlayers(), k)
            line:SetSortValue(4, k)
        end
    end
    RefreshTeamList()

    // Menu to Add or Remove the Teams
    function TeamList:OnRowRightClick(ID, Line)
        local Menu = DermaMenu()
        local NewLine = TeamList:GetLine(ID)
        Menu:AddOption("Entfernen", function() 
        table.remove(sendingteams, NewLine:GetSortValue(4))
        RefreshTeamList()
        end)
        Menu:Open(gui.MouseX(), gui.MouseY(),true,Line)
    end
    
    // Button to open the Team Add Menu
    local AddTeamButton = vgui.Create("DButton", dframe)
    AddTeamButton:SetText("Team Hinzufügen")
    AddTeamButton:SetSize(300, 20)
    AddTeamButton:SetPos(0, 175)

    function AddTeamButton:DoClick()
        local Menu = DermaMenu()
        for k,v in pairs(team.GetAllTeams()) do
            if !table.HasValue(sendingteams, k) && !table.HasValue(blacklistteams, k) then

                Menu:AddOption(team.GetName(k), function() 
                    local newk = table.insert(sendingteams, k)
                    RefreshTeamList()
                end)
            
            end
        end
        Menu:Open(gui.MouseX(),gui.MouseY())
    end

    // Door List
    local DoorList = vgui.Create("DListView", dframe)
    DoorList:SetSize(300, 100)
    DoorList:SetPos(0, 195)
    DoorList:AddColumn("Index", 1)
    DoorList:AddColumn("Class", 2)
    DoorList:AddColumn("Key", 3)
    function RefreshDoorList()
        for k,v in pairs(DoorList:GetLines()) do
            DoorList:RemoveLine(k)
        end
        for k,v in pairs(SendingDoorList) do
            local Line = DoorList:AddLine(v:EntIndex(), v:GetClass(), k)
            Line:SetSortValue(3, k)
        end
    end
    RefreshDoorList()

    function DoorList:OnRowRightClick(ID, Line)
        local Menu = DermaMenu()
        Menu:AddOption("Entfernen", function()
            table.remove(SendingDoorList, Line:GetSortValue(3))
            RefreshDoorList()
        end)
        Menu:Open(gui.MouseX(), gui.MouseY())
    end

    local SaveButton = vgui.Create("DButton", dframe)
    SaveButton:SetSize(150,50)
    SaveButton:SetPos(0, 295)
    SaveButton:SetText("Speichern")
    function SaveButton:DoClick()
        SendtheInfo(2)
        dframe:Close()
    end

    local AbortButton = vgui.Create("DButton", dframe)
    AbortButton:SetSize(150,50)
    AbortButton:SetPos(150, 295)
    AbortButton:SetText("Abbrechen")
    function AbortButton:DoClick()
        dframe:Close()
    end
    
    function SendtheInfo(typo)
        net.Start("ud_door_sys_ent")
        net.WriteEntity(ent)
        net.WriteInt(typo, 10)
        if typo != 1 then
            net.WriteInt(#sendingteams, 10)
            for k,v in pairs(sendingteams) do
                net.WriteInt(v, 10)
            end
            net.WriteInt(#SendingDoorList, 10)
            for k,v in pairs(SendingDoorList) do
                net.WriteEntity(v)
            end
        end
        net.SendToServer()
    end

end)