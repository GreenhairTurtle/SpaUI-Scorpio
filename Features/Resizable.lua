Scorpio "SpaUI.Features.Resizable" ""

ResizableFrames = {
    
}

ResizableFramesNeedWait = {
    
}

__Async__()
function OnEnable(self)
    for frame,info in pairs(ResizableFrames) do
        Style[_G[frame]] = info
        ResizableFrames[frame] = nil
    end

    for addon,info in pairs(ResizableFramesNeedWait) do
        if IsAddOnLoaded(addon) then
            for k,v in pairs(info) do
                Style[_G[k]] = v
            end
            ResizableFramesNeedWait[addon] = nil
        end
    end

    while next(ResizableFramesNeedWait) do
        local addon = NextEvent("ADDON_LOADED")
        local info = ResizableFramesNeedWait[addon]
        if info then
            for k,v in pairs(info) do
                Style[_G[k]] = v
            end
            ResizableFramesNeedWait[addon] = nil
        end
    end
end