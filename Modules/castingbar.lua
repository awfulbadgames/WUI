--[[

Code in parts or totally from Arena Junkies

http://www.arenajunkies.com/topic/222642-default-ui-scripts/

]]--

CastingBar = WUI:NewModule("CastingBar")

local isWoWCata, isWoWRetail = false, false;

if (_G["WOW_PROJECT_ID"] == _G["WOW_PROJECT_CATACLYSM_CLASSIC"]) then
	isWoWCata = true;
elseif (_G["WOW_PROJECT_ID"] == _G["WOW_PROJECT_MAINLINE"]) then
	isWoWRetail = true;
end

function CastingBar:OnInitialize()
end

function CastingBar:OnEnable()
	self:Update()

	if isWoWRetail then 
        PlayerCastingBarFrame:HookScript("OnUpdate", function(self, elapsed)
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
	else
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
end

function CastingBar:OnDisable()
end

function CastingBar:Update()
        self:CastingBarUpdate()
end

function CastingBar:CastingBarUpdate()
	if isWoWRetail then 
        PlayerCastingBarFrame.timer = PlayerCastingBarFrame:CreateFontString(nil)
        PlayerCastingBarFrame.timer:SetFont(STANDARD_TEXT_FONT,11,"OUTLINE")
        PlayerCastingBarFrame.timer:SetPoint('BOTTOM', PlayerCastingBarFrame, 'TOP', 0, 10)
        PlayerCastingBarFrame.update = .1
        if WUI.db.profile.castingbaricon then
                PlayerCastingBarFrame.Icon:Show()
                PlayerCastingBarFrame.Icon:ClearAllPoints()
                if WUI.db.profile.castingbariconposition == 1 then
                        PlayerCastingBarFrame.Icon:SetPoint("LEFT", PlayerCastingBarFrame, "LEFT", -25, 2)
                elseif WUI.db.profile.castingbariconposition == 2 then
                        PlayerCastingBarFrame.Icon:SetPoint("LEFT", PlayerCastingBarFrame, "LEFT", 2, 2)
                elseif WUI.db.profile.castingbariconposition == 3 then
                        PlayerCastingBarFrame.Icon:SetPoint("LEFT", PlayerCastingBarFrame, "RIGHT", 10, 2)
                end
                PlayerCastingBarFrame.Icon.SetPoint = function() end
        end
	else
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
end