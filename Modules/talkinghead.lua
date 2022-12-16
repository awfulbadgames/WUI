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

function Close()
	if WUI.db.profile.talkinghead == true then
		TalkingHeadFrame:CloseImmediately()
	end
end

function f:OnEvent(event, ...)
	if event == "PLAYER_LOGIN" then
		hooksecurefunc(TalkingHeadFrame, "PlayCurrent", Close)
	end
end

f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", f.OnEvent)