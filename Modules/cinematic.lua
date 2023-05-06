--[[

Code in parts or totally from CinematicCanceler

https://www.curseforge.com/wow/addons/cinematiccanceler

BSD License

]]--

local Cinematic = WUI:NewModule("Cinematic", "AceEvent-3.0")

function Cinematic:OnInitialize()
end

function Cinematic:OnEnable()
    CinematicFrame:HookScript('OnShow', CinematicShow)
end

function Cinematic:OnDisable()
end

function Cinematic:OnDisable()
end

function Cinematic:Update()
end

function CinematicShow()
    if WUI.db.profile.cinematic then
		--CinematicFrame:HookScript("OnShow", function(self, ...)
			if IsModifierKeyDown() then return end
			CinematicFrame_CancelCinematic()
		--end)
		local omfpf = _G["MovieFrame_PlayMovie"]
		_G["MovieFrame_PlayMovie"] = function(...)
		if IsModifierKeyDown() then return omfpf(...) end
			--MovieFrame_OnMovieFinished()
			--MovieFrame:Hide()
			GameMovieFinished()
			return true
		end
	end
end