-- 施法条显示进度
Scorpio "SpaUI.Features.Castbar" ""

local GetNetStats = GetNetStats

function OnEnable(self)
    CreateTimerAndLag()
end

local function CastingBarFrame_OnUpdate_Hook(self, elapsed)
    if not self.timer then return end
    if self.update and self.update < elapsed then
        if self.casting or self.channeling then
            if self.lag and self.casting then
                local _, _, world = GetNetStats()
                if world and world > 0 then
                    local min, max = self:GetMinMaxValues();
                    local rate = (world / 1000) / (max - min);
                    if (rate < 0) then
                        rate = 0;
                    elseif (rate > 1) then
                        rate = 1
                    end
                    self.lag:SetWidth(self:GetWidth() * rate)
                else
                    self.lag:SetWidth(0)
                end
            elseif self.lag then
                self.lag:SetWidth(0)
            end
            self.timer:SetText(format("%.1f/%.1f", max(self.value, 0),
                                      self.maxValue))
        else
            self.timer:SetText("")
            if self.lag then self.lag:SetWidth(0) end
        end
        self.update = .1
    else
        self.update = self.update - elapsed
    end
end

function CreateTimerAndLag()
    local CastBarTimer = FontString("SpaUICastBarTimer", CastingBarFrame)
    local CastBarLag = Texture("SpaUICastBarLag", CastingBarFrame)
    CastingBarFrame.update = .1
    CastingBarFrame.timer = CastBarTimer
    CastingBarFrame.lag = CastBarLag

    local TargetFrameSpellBarTimer = FontString("SpaUITargetSpellBarTimer", TargetFrameSpellBar)
    TargetFrameSpellBar.update = .1
    TargetFrameSpellBar.timer = TargetFrameSpellBarTimer

    local FocusFrameSpellBarTimer = FontString("SpaUIFocusSpellBarTimer", FocusFrameSpellBar)
    FocusFrameSpellBar.update = .1
    FocusFrameSpellBar.timer = FocusFrameSpellBarTimer

    Style[CastBarTimer] = {
        font                = {
            font            = "Fonts\\FRIZQT__.TTF",
            height          = 8,
            outline         = "NORMAL",
            monochrome      = false
        },
        textColor           = Color.WHITE,
        location            = PLAYER_FRAME_CASTBARS_SHOWN and {Anchor("LEFT", 1, 0, CastingBarFrame:GetName(), "RIGHT")} or {Anchor("TOPRIGHT", 0, -2, CastingBarFrame:GetName(), "BOTTOMRIGHT")}
    }

    Style[CastBarLag] = {
        drawLayer           = "BACKGROUND",
        height              = CastingBarFrame:GetHeight(),
        location            = {Anchor("RIGHT", -1, 0, CastingBarFrame:GetName(), "RIGHT")},
        color               = ColorType(1, 0, 0, 1)
    }

    Style[TargetFrameSpellBarTimer] = {
        font                = {
            font            = "Fonts\\FRIZQT__.TTF",
            height          = 8,
            outline         = "NORMAL",
            monochrome      = false
        },
        textColor           = Color.WHITE,
        location            = {Anchor("LEFT", 1, 0, TargetFrameSpellBar:GetName(), "RIGHT")}
    }

    Style[FocusFrameSpellBarTimer] = {
        font                = {
            font            = "Fonts\\FRIZQT__.TTF",
            height          = 8,
            outline         = "NORMAL",
            monochrome      = false
        },
        textColor           = Color.WHITE,
        location            = {Anchor("LEFT", 1, 0, FocusFrameSpellBar:GetName(), "RIGHT")}
    }


    CastingBarFrame:HookScript('OnUpdate', CastingBarFrame_OnUpdate_Hook)
    TargetFrameSpellBar:HookScript('OnUpdate', CastingBarFrame_OnUpdate_Hook)
    FocusFrameSpellBar:HookScript('OnUpdate', CastingBarFrame_OnUpdate_Hook)
end

-- 头像下方显示施法条可见性优化
__SecureHook__()
function PlayerFrame_AttachCastBar()
    if not CastingBarFrame.timer then return end
    Style[CastingBarFrame.timer] = {
        location = {Anchor("LEFT", 1, 0, CastingBarFrame:GetName(), "RIGHT")}
    }
end

__SecureHook__()
function PlayerFrame_DetachCastBar()
    if not CastingBarFrame.timer then return end
    Style[CastingBarFrame.timer] = {
        location = {Anchor("TOPRIGHT", 0, -2, CastingBarFrame:GetName(), "BOTTOMRIGHT")}
    }
end

-- 疲劳、呼吸、假死条等
local function CreateMirrorTimerFrameDuration(frame)
    if not frame then return end
    local statusbar = _G[frame:GetName() .. "StatusBar"]
    if statusbar then
        frame.duration = FontString("SpaUI"..frame:GetName().."Duration", frame)
        frame.duration:SetFont("Fonts\\ARIALN.ttf", 10, "NORMAL")
        frame.duration:SetTextColor(1,1,1)
        frame.duration:SetPoint("RIGHT", statusbar, "RIGHT", -1, 2)
    end
end

__SecureHook__()
function MirrorTimerFrame_OnUpdate(frame, elapsed)
    if frame.refreshTimer and frame.refreshTimer > 0.1 then
        frame.refreshTimer = 0
        if not frame.duration then CreateMirrorTimerFrameDuration(frame) end
        frame.duration:SetText(ceil(frame.value))
    else
        frame.refreshTimer = (frame.refreshTimer or 0) + elapsed
    end
end
