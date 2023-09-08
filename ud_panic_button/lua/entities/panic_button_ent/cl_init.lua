include("shared.lua")

panic_button_counter = 0
function ENT:Initialize()
    panic_button_counter = panic_button_counter + 1
    self.Index = panic_button_counter
    timer.Create("Panic_Button_Remove "..self.Index, ud_panic_button.RemoveAfterTimer, 1, function() 
        self:Remove()
    end)
end

function ENT:Draw()
    //self:DrawModel()
end

function ENT:OnRemove()
    if timer.Exists("Panic_Button_Remove "..self.Index) then
        timer.Remove("Panic_Button_Remove "..self.Index)
    end
end