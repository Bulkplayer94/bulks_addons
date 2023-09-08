local meta = FindMetaTable( "Player" )
// 1. Argument, Ja oder nein?
function meta:SetMoonshineLicense( bool )
    self:SetNWBool("MoonshineLicense", bool)
    // Bei Entzug werden die Daten automatisch gelöscht.
    if !bool then
        self:SetMoonshineLicenseData(nil, nil)
    end
end

function meta:GetMoonshineLicense()
    return self:GetNWBool( "MoonshineLicense" ) or nil
end

// 1. Argument, Name des Ausstellers
// 2. Argument, Ausstellungszeitpunkt (Unix Time Epoch); kann weggelassen werden.
function meta:SetMoonshineLicenseData(name, time)
    local timestr
    if name != nil then
        if time == nil then
            time = os.time()
        end
        timestr = os.date( "%H:%M", time )
    else
        name = " "
        timestr = " "
    end
    self:SetNWString("MoonshineLicenseName", name)
    self:SetNWString("MoonshineLicenseTime", timestr)
end

function meta:GetMoonshineLicenseData( bool )
    local name = self:GetNWString("MoonshineLicenseName")
    local time = self:GetNWString("MoonshineLicenseTime")
    return name or nil, time or nil
end