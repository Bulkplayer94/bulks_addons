UD_Settings = {}
UD_Settings.RegisteredPanels = {}

function UD_Settings_Open_Menu()
    local MainFrame = vgui.Create("DFrame")
    MainFrame:SetSize(300, 500)
    MainFrame:Center()
    MainFrame:MakePopup()

    local MainScroller = vgui.Create("DScrollPanel", MainFrame)
    MainScroller:SetPos(25,50)
    MainScroller:SetSize(250,400)

    hook.Run("UD_Settings:CreatePanels", MainScroller)

end

hook.Add("OnPlayerChat", "UD_Settings_Open", function(ply, msg) 
    if ply:IsValid() && ply == LocalPlayer() then
        if msg == "!settings" then
            UD_Settings_Open_Menu()
        end
    end
end)