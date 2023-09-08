hook.Add("k_menu:loaded", "confis_menu", function()
    print("Confis Menu Loaded")
    k_menu.RegisterPanel({
        title = "Konfiszieren",
        func = function(MainFrame)
            net.Start("ud_confis_menu")
            net.SendToServer()
        end,
        hideFunc = function(ply)
            if table.HasValue(ud_confiscation.CP_Teams, ply:Team()) && IsValid(ply:GetEyeTrace().Entity) then
                return true 
            else
                return false
            end
        end,
    })
end)