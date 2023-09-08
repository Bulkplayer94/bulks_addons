--k_menu = k_menu or {}

--[[
hook.Add("k_menu:loaded", "CloseButton", function()
    print("K Menu CloseButton")
    k_menu.RegisterPanel({
        title = "Close",
        func = function(MainFrame)
            MainFrame:Close()
        end,
    })
end)
]]