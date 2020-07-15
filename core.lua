WUI = LibStub("AceAddon-3.0"):NewAddon("WUI")

function WUI:OnInitialize()
  -- Code that you want to run when the addon is first loaded goes here.
  self.db = LibStub("AceDB-3.0"):New("WUIDB", config.defaults, true)

  --self.db.RegisterCallback(self, "OnProfileChanged", "UpdateProfile")
  --self.db.RegisterCallback(self, "OnProfileCopied", "UpdateProfile")
  --self.db.RegisterCallback(self, "OnProfileReset", "UpdateProfile")

  LibStub("AceConfig-3.0"):RegisterOptionsTable("WUI", options)
  LibStub("AceConfigDialog-3.0"):AddToBlizOptions("WUI", "WUI")

  --self:RegisterChatCommand("wui", "Slash")

  SLASH_wui1 = "/wui"
  SlashCmdList["wui"] = function()
    if InCombatLockdown() then
      DEFAULT_CHAT_FRAME:AddMessage(" |cffff0000" .. "Cannot open config dialog while in combat.")
    else
      InterfaceOptionsFrame_OpenToCategory("WUI")
      InterfaceOptionsFrame_OpenToCategory("WUI")
    end
  end
end

function WUI:OnEnable()
  -- Called when the addon is enabled
end

function WUI:OnDisable()
  -- Called when the addon is disabled
end

function WUI:UpdateProfile()
  --Function to update profile
end

--[[ function Slash()
  if InCombatLockdown() then
    DEFAULT_CHAT_FRAME:AddMessage(" |cffff0000" .. "Cannot open config dialog while in combat.")
  else
    InterfaceOptionsFrame_OpenToCategory("WUI")
    InterfaceOptionsFrame_OpenToCategory("WUI")
  end
end ]]