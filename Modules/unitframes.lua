--[[

Code in parts or totally from Arena Junkies

http://www.arenajunkies.com/topic/222642-default-ui-scripts/

]]--

UnitFrames = WUI:NewModule("UnitFrames", "AceEvent-3.0", "AceHook-3.0")

function UnitFrames:OnInitialize()
end

function UnitFrames:OnEnable()
  self:Update()

  self:RegisterEvent("PLAYER_LOGIN", "ClassColor")
  self:RegisterEvent("UNIT_HEALTH", "ClassColor")

  self:SecureHook("UnitFrameHealthBar_Update", "ClassColor")
  self:SecureHook("HealthBar_OnValueChanged", "ClassColor")

  self:SecureHook("UnitFramePortrait_Update", "ClassPortrait")
end

function UnitFrames:OnDisable()
end

function UnitFrames:Update()
  self:PlayerFrameClassColor()
  self:TargetFrameClassColor()
  self:FocusFrameClassColor()
  self:PlayerFrame()
  self:TargetFrame()
  self:FocusFrame()
  self:PlayerPortrait()
  self:TargetPortrait()
  self:FocusPortrait()
  self:RaidFrameScale()
end

function UnitFrames:PlayerFrameClassColor()
  if WUI.db.profile.playerframeclasscolor then
    self:ClassColor(PlayerFrameHealthBar)
  else
    PlayerFrameHealthBar:SetStatusBarColor(0, 0.99, 0)
  end
end

function UnitFrames:TargetFrameClassColor()
  if WUI.db.profile.targetframeclasscolor then
    self:ClassColor(TargetFrameHealthBar)
  else
    TargetFrameHealthBar:SetStatusBarColor(0, 0.99, 0)
  end
end

function UnitFrames:FocusFrameClassColor()
  if WUI.db.profile.focusframeclasscolor then
    self:ClassColor(FocusFrameHealthBar)
  else
    FocusFrameHealthBar:SetStatusBarColor(0, 0.99, 0)
  end
end

function UnitFrames:PlayerFrame()
  local _
  local a = _G.PlayerFrame
  a:SetMovable(true)
  a:SetUserPlaced(true)
  a:ClearAllPoints()
  a:SetPoint(WUI.db.profile.playerframepoint, WUI.db.profile.playerframerelativeTo, WUI.db.profile.playerframerelativePoint, WUI.db.profile.playerframex, WUI.db.profile.playerframey)
  a:SetScale(WUI.db.profile.playerframescale)
  a:SetMovable(false)
end

function UnitFrames:TargetFrame()
  local _
  local a = _G.TargetFrame
  a:SetMovable(true)
  a:SetUserPlaced(true)
  a:ClearAllPoints()
  a:SetPoint(WUI.db.profile.targetframepoint, WUI.db.profile.targetframerelativeTo, WUI.db.profile.targetframerelativePoint, WUI.db.profile.targetframex, WUI.db.profile.targetframey)
  a:SetScale(WUI.db.profile.targetframescale)
  a:SetMovable(false)
end

function UnitFrames:FocusFrame()
  local _
  local a = _G.FocusFrame
  a:SetMovable(true)
  a:SetUserPlaced(true)
  a:ClearAllPoints()
  a:SetPoint(WUI.db.profile.focusframepoint, WUI.db.profile.focusframerelativeTo, WUI.db.profile.focusframerelativePoint, WUI.db.profile.focusframex, WUI.db.profile.focusframey)
  a:SetScale(WUI.db.profile.focusframescale)
  a:SetMovable(false)
end

function UnitFrames:ClassColor(b)
  local statusbar = b
  local unit = b.unit

  if WUI.db.profile.playerframeclasscolor and unit == "player" then
      local _, class, color
      if UnitIsPlayer(unit) and UnitIsConnected(unit) and unit == statusbar.unit and UnitClass(unit) then
        _, class = UnitClass(unit)
        color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
        statusbar:SetStatusBarColor(color.r, color.g, color.b)
      end
  end

  if WUI.db.profile.targetframeclasscolor and unit == "target" then
      local _, class, color
      if UnitIsPlayer(unit) and UnitIsConnected(unit) and unit == statusbar.unit and UnitClass(unit) then
        _, class = UnitClass(unit)
        color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
        statusbar:SetStatusBarColor(color.r, color.g, color.b)
      end
  end
  
    if WUI.db.profile.focusframeclasscolor and unit == "focus" then
      local _, class, color
      if UnitIsPlayer(unit) and UnitIsConnected(unit) and unit == statusbar.unit and UnitClass(unit) then
        _, class = UnitClass(unit)
        color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
        statusbar:SetStatusBarColor(color.r, color.g, color.b)
      end
  end
end

function UnitFrames:PlayerPortrait()
  if WUI.db.profile.playerportrait then
    self:ClassPortrait(PlayerFrame)
  else
    self:ClassPortrait(PlayerFrame)
  end
end

function UnitFrames:TargetPortrait()
  if WUI.db.profile.targetportrait then
    self:ClassPortrait(TargetFrame)
  else
    self:ClassPortrait(TargetFrame)
  end
end

function UnitFrames:FocusPortrait()
  if WUI.db.profile.focusportrait then
    self:ClassPortrait(FocusFrame)
  else
    self:ClassPortrait(FocusFrame)
  end
end

function UnitFrames:RaidFrameScale()
  CompactRaidFrameContainer:SetScale(WUI.db.profile.raidframescale)
end

function UnitFrames:ClassPortrait(frame)
  if (frame.unit == "vehicle") then
    self:DefaultPortrait(frame)
  end

  if (frame.unit == "player" and frame.portrait) then
    if WUI.db.profile.playerportrait then
      self:Portrait(frame)
    else
      self:DefaultPortrait(frame)
    end
  end

  if (frame.portrait and (frame.unit == "target" or frame.unit == "targettarget")) then
    if WUI.db.profile.targetportrait then
      self:Portrait(frame)
    else
      self:DefaultPortrait(frame)
    end
  end
  
  if (frame.unit == "focus" and frame.portrait) then
    if WUI.db.profile.focusportrait then
      self:Portrait(frame)
    else
      self:DefaultPortrait(frame)
    end
  end
end

function UnitFrames:Portrait(frame)
  local _, unitClass = UnitClass(frame.unit)
  if (unitClass and UnitIsPlayer(frame.unit)) then
      frame.portrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
      frame.portrait:SetTexCoord(unpack(CLASS_ICON_TCOORDS[unitClass]))
  else
      frame.portrait:SetTexCoord(0, 1, 0, 1)
  end
end

function UnitFrames:DefaultPortrait(frame)
  SetPortraitTexture(frame.portrait, frame.unit)
  frame.portrait:SetTexCoord(0, 1, 0, 1)
end