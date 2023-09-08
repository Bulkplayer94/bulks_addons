k_menu = k_menu or {}

--function func, string title
k_menu.PanelTable = {}
local Counter = 0
function k_menu.RegisterPanel(Tbl)
    --if table.HasValue(k_menu.PanelTable, Tbl) then return end
    Counter = Counter + 1
    k_menu.PanelTable[Counter] = Tbl
end

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

function k_menu.OpenMenu()
    local OuterFrame = vgui.Create("DFrame")
    OuterFrame:SetSize(ScrW() * .2, ScrH() * 0.4)
    OuterFrame:SetTitle("Interaktions Menü")
    OuterFrame:Center()
    OuterFrame:MakePopup()
    function OuterFrame:Paint(w,h)
        surface.SetDrawColor(50,50,50,200)
        surface.DrawRect( 0,0,w,h)
        surface.SetDrawColor(255,255,255,50)
        surface.DrawOutlinedRect(0,0,w,h)
        DrawEdges(0,0,w,h,5)
    end

    local ScrollPanel = vgui.Create("DScrollPanel", OuterFrame)
    ScrollPanel:SetPos(OuterFrame:GetWide() * 0.1, OuterFrame:GetTall() * 0.1)
    ScrollPanel:SetSize(OuterFrame:GetWide() * 0.8, OuterFrame:GetTall() * 0.8)

    for k, Tbl in pairs(k_menu.PanelTable) do
        if Tbl.hideFunc ~= nil && !Tbl.hideFunc(LocalPlayer()) then continue end
        local ScrollBtn = ScrollPanel:Add("DButton")
        ScrollBtn:SetSize(OuterFrame:GetWide() * 0.1, OuterFrame:GetTall() * 0.1)
        ScrollBtn:Dock(TOP)
        ScrollBtn:DockMargin(0,0,0,5)
        ScrollBtn:SetText("")
        function ScrollBtn:DoClick()
            Tbl.func(OuterFrame)
        end
        function ScrollBtn:Paint(w,h)
            surface.SetDrawColor(75,75,75,200)
            surface.DrawRect( 0,0,w,h)
            surface.SetDrawColor(255,255,255,50)
            surface.DrawOutlinedRect(0,0,w,h)
            DrawEdges(0,0,w,h,5)
            draw.SimpleText(Tbl.title, "DermaDefault", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
end



hook.Add("PlayerButtonDown", "k_menu", function(ply, key) 
    if IsFirstTimePredicted() && key == KEY_K then
        k_menu.OpenMenu()
    end
end)
timer.Simple(5, function()
    print("k_menu Loaded")
    hook.Run("k_menu:loaded")
end)