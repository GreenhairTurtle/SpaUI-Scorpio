Scorpio "SpaUI.Features.Resizable" ""

ResizableFrames = {
    
}

ResizableFramesNeedWait = {
}

__Async__()
function OnEnable(self)
    for _,frame in ipairs(ResizableFrames) do
        SetResizable(frame)
    end

    for addon,frameName in pairs(ResizableFramesNeedWait) do
        if IsAddOnLoaded(addon) then
            SetResizable(frameName)
        end
    end

    while true do
        local frameName = ResizableFramesNeedWait[NextEvent("ADDON_LOADED")]
        if frameName then
            SetResizable(_G[frameName])
        end
    end
end

function SetResizable(frame)
    if not frame then return end
    Resizer("Resizer", frame)
    frame:SetResizable(true)
end