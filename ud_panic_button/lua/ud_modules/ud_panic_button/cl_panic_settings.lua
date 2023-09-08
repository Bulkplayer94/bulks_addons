hook.Add("UD_Settings:CreatePanels", "PanicSettings", function(Scroller) 

    local MainCategory = Scroller:Add("DCollapsibleCategory")
    MainCategory:SetSize(20,100)
    MainCategory:Dock(TOP)

end)