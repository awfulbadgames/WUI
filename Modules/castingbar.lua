--[[

Code from Arena Junkies

http://www.arenajunkies.com/topic/222642-default-ui-scripts/

]]--

local _, wUI = ...
local cfg = wUI.Config

if not cfg.castingBar then
    return
end

CastingBarFrame:SetScale(cfg.castingBarScale)		
CastingBarFrame:ClearAllPoints()
CastingBarFrame:SetPoint('BOTTOM', UIParent, 'BOTTOM', cfg.castingBarX, cfg.castingBarY)
CastingBarFrame.SetPoint = function() end

CastingBarFrame.timer = CastingBarFrame:CreateFontString(nil);
CastingBarFrame.timer:SetFont(STANDARD_TEXT_FONT,11,"OUTLINE");
CastingBarFrame.timer:SetPoint('BOTTOM', CastingBarFrame, 'TOP', 0, 10);
CastingBarFrame.update = .1;

CastingBarFrame:HookScript("OnUpdate", function(self, elapsed)
       if not self.timer then return end
        if self.update and self.update < elapsed then
               if self.casting then
                        self.timer:SetText(format("%2.1f/%1.1f", max(self.maxValue - self.value, 0), self.maxValue))
                elseif self.channeling then
                        self.timer:SetText(format("%.1f", max(self.value, 0)))
                else
                        self.timer:SetText("")
                end
                self.update = .1
		else
                self.update = self.update - elapsed
        end
end)