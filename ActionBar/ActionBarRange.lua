Scorpio "SpaUI.ActionBar.ActionBarRange" ""

function OnLoad(self)
    _Enabled = _Config.ActionBar.OutOfRangeColor.Enable
end

__SecureHook__()
function ActionButton_UpdateRangeIndicator(self, checksRange, inRange)
    if self.action == nil then return end
    if (checksRange and not inRange) then
        _G[self:GetName() .. "Icon"]:SetVertexColor(0.5, 0.1, 0.1)
    else
        local isUsable, notEnoughMana = IsUsableAction(self.action)
        if isUsable ~= true or notEnoughMana == true then
            _G[self:GetName() .. "Icon"]:SetVertexColor(0.4, 0.4, 0.4)
        else
            _G[self:GetName() .. "Icon"]:SetVertexColor(1, 1, 1)
        end
    end
end