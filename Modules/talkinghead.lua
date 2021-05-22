--[[

Code in parts or totally from Xorag

https://github.com/Xorag/BeQuiet

MIT license

]]--

local Talkinghead = WUI:NewModule("Talkinghead", "AceEvent-3.0", "AceHook-3.0")

function Talkinghead:OnInitialize()
end

function Talkinghead:OnEnable()
end

function Talkinghead:OnDisable()
end

local f = CreateFrame("Frame")

--Main function
function f:OnEvent(event, addon)
	--Check if the talkinghead addon is being loaded
	if addon == "Blizzard_TalkingHeadUI" then
		hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
			--Only run this logic if the functionality is turned on
			if WUI.db.profile.talkinghead == true then
				--Block the talking head unless we have a whitelisted condition
					--Close the talking head
					TalkingHeadFrame_CloseImmediately()
			end
		end)
	self:UnregisterEvent(event)
	end
end

f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", f.OnEvent)