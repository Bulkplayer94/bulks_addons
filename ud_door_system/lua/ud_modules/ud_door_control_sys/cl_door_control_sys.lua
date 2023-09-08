hook.Add("HUDPaint", "UDDoorsysPaintHook", function()
    if LocalPlayer():GetNWBool("DoorSysAdminMode", false) then
       for k, v in pairs(ents.FindByClass("remote_door_ent")) do
            local ClEnt = v:GetPos():ToScreen()
            draw.DrawText("RemoteDoorSys\nIndex: "..v:EntIndex().."\nVerbundene Türen: "..v:GetDoorCount(), "Default", ClEnt.x, ClEnt.y, color_white, TEXT_ALIGN_CENTER)
       end
    end
end)

hook.Add("k_menu:loaded", "DoorsButton", function()
    k_menu.RegisterPanel({
        title = "Öffne Garage",
        func = function(MainFrame)
            RunConsoleCommand("opendoors")
        end,
    })
end)