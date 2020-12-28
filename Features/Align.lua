Scorpio "SpaUI.Features.Align" ""

__SlashCmd__ "spa" "align"
__SlashCmd__ "spaui" "align"
__Async__()
function ToggleAlign()
	if AlignFrame then
		if AlignFrame:IsShown() then
			AlignFrame:Hide()
		else
			AlignFrame:Show()
		end
	else
		AlignFrame = Frame('SpaUIAlignLine')
		Style[AlignFrame].SetAllPoints = true
		local w = GetScreenWidth() / 64
		local h = GetScreenHeight() / 36
		for i = 0, 64 do
			local line = Texture("VerticalLine"..i,AlignFrame)
			Style[line] = {
				color 		= i == 32 and ColorType(1,1,0,0.5) or ColorType(1,1,1,0.15),
				location 	= {
					Anchor("TOPLEFT",i*w-1,0,AlignFrame:GetName(true),"TOPLEFT"),
					Anchor("BOTTOMRIGHT",i*w+1,0,AlignFrame:GetName(true),"BOTTOMLEFT")
				}
			}
		end
		for i = 0, 36 do
			local line = Texture("HorizontalLine"..i, AlignFrame, 'BACKGROUND')
			Style[line] = {
				color 		= i == 18 and ColorType(1,1,	0,0.5) or ColorType(1,1,1,0.15),
				location 	= {
					Anchor("TOPLEFT",0,-i*h+1,AlignFrame:GetName(true),"TOPLEFT"),
					Anchor("BOTTOMRIGHT",0,-i*h-1,AlignFrame:GetName(true),"TOPRIGHT")
				}
			}
		end
	end
end