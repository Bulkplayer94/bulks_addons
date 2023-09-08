include("ud_modules/ud_panic_button/sh_config.lua")
local ud_panic_button = ud_panic_button or {}
local client = ud_panic_button.client or {}

hook.Add( "PlayerButtonDown", "KeyDown_Panic_Button", function( ply, button )
	if input.IsButtonDown(KEY_P) && input.IsButtonDown(KEY_LALT) && IsFirstTimePredicted() then -- Alt + P	
        if ply:IsValid() && ply:IsPlayer() && ply:Alive() then
            net.Start("ud_panic_button")
            net.WriteEntity(ply)
            net.SendToServer()
        end
	end
end)

function ud_panic_button.client.Register( ply )
    if ply != LocalPlayer() || ud_panic_button.debug == true then
        local ClEnt = ents.CreateClientside("panic_button_ent")
        ClEnt:SetModel("models/hunter/blocks/cube025x025x025.mdl")
        ClEnt:SetPos(ply:GetPos() + ply:OBBCenter())
        ClEnt:Spawn()
        ClEnt.PanicOwner = ply
        notification.AddLegacy(ply:Nick().." hat einen Panik-Knopf ausgelöst!", NOTIFY_HINT, 5)
        sound.PlayFile("sound/ud_panic_button/panic_button.mp3", "", function(SoundChannel, ID, ErrorName) 
            if ErrorName != nil then 
                print(ErrorName)
            else
                SoundChannel:SetVolume(0.2)
            end
        end)
    else        
        notification.AddLegacy("Du hast einen Panik-Knopf ausgelöst!", NOTIFY_HINT, 5)
        Msg("Du hast einen Panik-Button ausgelöst!")
    end
end

net.Receive("ud_panic_button", function()
    local ply = net.ReadEntity()
    ud_panic_button.client.Register( ply )
end)

function ud_panic_button.client.CreateFont()
    surface.CreateFont("PanicButton7", {font="Arial", size=ScreenScale(7)})
end
ud_panic_button.client.CreateFont()

hook.Add("Think", "ud_panic_button_CheckButton", function()
    if ud_panic_button.shoulddelete then 
        for k, v in pairs(ents.FindByClass("panic_button_ent")) do
            if LocalPlayer():GetPos():DistToSqr(v:GetPos()) < ud_panic_button.distance && ud_panic_button.debug == false then
                v:Remove()
            end
        end
    end
end)

local edgeWidth = 2
local function DrawEdges( x, y, width, height, edgeSize )

    surface.SetDrawColor(255,255,255,120)
	--Draw the upper left corner.
	surface.DrawRect(x,y,edgeSize,edgeWidth)
	surface.DrawRect(x,y + edgeWidth,edgeWidth,edgeSize - edgeWidth)

	local XRight = x + width

	--Draw the upper right corner.
	surface.DrawRect(XRight - edgeSize,y,edgeSize,edgeWidth)
	surface.DrawRect(XRight - edgeWidth,y + edgeWidth,edgeWidth,edgeSize - edgeWidth)

	local YBottom = y + height

	--Draw the lower right corner.
	surface.DrawRect(XRight - edgeSize,YBottom - edgeWidth,edgeSize,edgeWidth)
	surface.DrawRect(XRight - edgeWidth,YBottom - edgeSize,edgeWidth,edgeSize - edgeWidth)

	--Draw the lower left corner.
	surface.DrawRect(x,YBottom - edgeWidth,edgeSize,edgeWidth)
	surface.DrawRect(x,YBottom - edgeSize,edgeWidth,edgeSize - edgeWidth)

end

hook.Add("HUDPaintBackground","ud_panic_button_HUDPaint" ,function()
    local FracX = (ScrW() * 0.05)
    local FracY = (ScrH() * 0.05)
    local FracS = (ScrH() * 0.02)
    for k,v in pairs(ents.FindByClass("panic_button_ent")) do
        if !v:IsValid() then return end
        local ClEnt = v:GetPos():ToScreen()
        local RectX = 0.2 * ClEnt.x
        surface.SetDrawColor(50,50,50,200)
        surface.DrawRect( ClEnt.x - FracX, ClEnt.y - FracY, FracX * 2, FracY * 2 )
        surface.SetDrawColor(255,255,255,50)
        surface.DrawOutlinedRect( ClEnt.x - FracX, ClEnt.y - FracY, FracX * 2, FracY * 2, 2 )
        DrawEdges( ClEnt.x - FracX, ClEnt.y - FracY, FracX * 2, FracY * 2, 8)
        local PlyName = v.PanicOwner:Nick()
        local Dist = "Distanz: "..tostring(math.Round((LocalPlayer():GetPos():Distance(v:GetPos())) * 0.01908)).."m"
        local TimeLeft = math.Round( timer.TimeLeft("Panic_Button_Remove "..v.Index) or 0).." Sekunden übrig"

        local Text = "Code 99\n"..PlyName.."\n"..Dist.."\n"..TimeLeft.."\n"
        draw.DrawText(Text,"PanicButton7", ClEnt.x, ClEnt.y - 43, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end)

hook.Add("OnScreenSizeChanged", "ud_panic_button_Font", function() 
    ud_panic_button.client.CreateFont()
end)

hook.Add("UD_Settings:CreatePanels", "PanicSettings", function(Scroller) 

    local MainCategory = Scroller:Add("DCollapsibleCategory")
    MainCategory:SetSize(20,100)
    MainCategory:Dock(TOP)
    MainCategory:SetLabel("Panik-Knopf")

    local Binder = vgui.Create("DBinder", MainCategory)
    Binder:SetPos(10,50)
    MainCategory:SetContents(Binder)

end)