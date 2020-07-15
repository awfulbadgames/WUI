local AutoScreeshot = WUI:NewModule("AutoScreeshot", "AceEvent-3.0")

function AutoScreeshot:OnInitialize()
end

function AutoScreeshot:OnEnable()
  self:RegisterEvent("ACHIEVEMENT_EARNED")
end

function AutoScreeshot:OnDisable()
end
  
function AutoScreeshot:ACHIEVEMENT_EARNED()
    if WUI.db.profile.autoscreenshot then
        C_Timer.After(1, Screenshot)
    end
end