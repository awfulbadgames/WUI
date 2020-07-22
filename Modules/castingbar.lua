--[[

Code from Arena Junkies

http://www.arenajunkies.com/topic/222642-default-ui-scripts/

]]--

CastingBar = WUI:NewModule("CastingBar")

function CastingBar:OnInitialize()
end

function CastingBar:OnEnable()
        self:Update()

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
end

function CastingBar:OnDisable()
end

function CastingBar:Update()
        self:CastingBarUpdate()
end

function CastingBar:CastingBarUpdate()
        CastingBarFrame:SetScale(WUI.db.profile.castingbarscale)	
        CastingBarFrame:ClearAllPoints()

        CastingBarFrame:SetPoint(WUI.db.profile.castingbarpoint, WUI.db.profile.castingbarrelativeTo, WUI.db.profile.castingbarrelativePoint, WUI.db.profile.castingbarx, WUI.db.profile.castingbary)
        CastingBarFrame.SetPoint = function() end

        CastingBarFrame.timer = CastingBarFrame:CreateFontString(nil)
        CastingBarFrame.timer:SetFont(STANDARD_TEXT_FONT,11,"OUTLINE")
        CastingBarFrame.timer:SetPoint('BOTTOM', CastingBarFrame, 'TOP', 0, 10)
        CastingBarFrame.update = .1

        if WUI.db.profile.castingbaricon then
                CastingBarFrame.Icon:Show()
                CastingBarFrame.Icon:ClearAllPoints()
                if WUI.db.profile.castingbariconposition == 1 then
                        CastingBarFrame.Icon:SetPoint("LEFT", CastingBarFrame, "LEFT", -25, 2)
                elseif WUI.db.profile.castingbariconposition == 2 then
                        CastingBarFrame.Icon:SetPoint("LEFT", CastingBarFrame, "LEFT", 2, 2)
                elseif WUI.db.profile.castingbariconposition == 3 then
                        CastingBarFrame.Icon:SetPoint("LEFT", CastingBarFrame, "RIGHT", 10, 2)
                end
                CastingBarFrame.Icon.SetPoint = function() end
        end
end