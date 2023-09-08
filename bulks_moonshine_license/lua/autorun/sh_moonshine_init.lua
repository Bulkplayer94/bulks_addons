hook.Add("PostGamemodeLoaded", "Moonshine_Setup", function()
    MsgC(Color(0,0,255), "Bulks Bierlizenzsystem geladen!\n")
    if SERVER then
        include("moonshine_license/sv_hooks.lua")
        include("moonshine_license/sv_meta.lua")
    end
end)