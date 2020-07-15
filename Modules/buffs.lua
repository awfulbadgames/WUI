--[[

Code from zorker

https://github.com/zorker/rothui
https://github.com/zorker/rothui/tree/master/wow8.0/rBuffFrame

MIT license

Code from lithammer

https://github.com/lithammer/NeavUI
https://github.com/lithammer/NeavUI/tree/master/Interface/AddOns/nBuff

]]--

Buffs = WUI:NewModule("Buffs")

function Buffs:OnInitialize()
  self:CreateBuffFrame(WUI.name, WUI.db.profile.buffsL1, WUI.db.profile.buffsL2, WUI.db.profile.buffsL3, WUI.db.profile.buffsL4, WUI.db.profile.buffsL5, WUI.db.profile.buffsScale, WUI.db.profile.buffsPadding, WUI.db.profile.buffsWidth, WUI.db.profile.buffsHeight, WUI.db.profile.buffsMargin, WUI.db.profile.buffsNumCols, WUI.db.profile.buffsStartPoint, WUI.db.profile.buffsRowMargin)
  self:CreateDebuffFrame(WUI.name, WUI.db.profile.deBuffsLocation, WUI.db.profile.deBuffsScale, WUI.db.profile.deBuffsPadding, WUI.db.profile.deBuffsWidth, WUI.db.profile.deBuffsHeight, WUI.db.profile.deBuffsMargin, WUI.db.profile.deBuffsNumCols, WUI.db.profile.deBuffsStartPoint, WUI.db.profile.deBuffsRowMargin)
end

function Buffs:OnEnable()
  hooksecurefunc("AuraButton_Update", function(self, index)
    function AuraButton_SetBorderColor(self, ...)
      return self.border:SetVertexColor(...)
    end

    local button = _G[self..index]
    if button and not button.Shadow then
      local border = _G[self..index.."Border"]
      if border then
        border:SetPoint("TOPLEFT", button, -3, 2)
        border:SetPoint("BOTTOMRIGHT", button, 2, -2)
        border:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
        border:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
        border.SetBorderColor = AuraButton_SetBorderColor
      end
    end
  end)
end

function Buffs:OnDisable()
end

function Buffs:GetButtonList(buttonName,numButtons,buttonList)
  buttonList = buttonList or {}
  for i=1, numButtons do
    local button = _G[buttonName..i]
    if not button then break end
    if button:IsShown() then
      table.insert(buttonList, button)
    end
  end
  return buttonList
end

--points
--1. p1, f, fp1, fp2
--2. p2, rb-1, p3, bm1, bm2
--3. p4, b-1, p5, bm3, bm4
function Buffs:SetupButtonPoints(frame, buttonList, buttonWidth, buttonHeight, numCols, p1, fp1, fp2, p2, p3, bm1, bm2, p4, p5, bm3, bm4)
  for index, button in next, buttonList do
  button:SetSize(buttonWidth, buttonHeight)
  button:ClearAllPoints()
  if index == 1 then
    button:SetPoint(p1, frame, fp1, fp2)
  elseif numCols == 1 or mod(index, numCols) == 1 then
    button:SetPoint(p2, buttonList[index-numCols], p3, bm1, bm2)
  else
    button:SetPoint(p4, buttonList[index-1], p5, bm3, bm4)
  end
  end

end

function Buffs:SetupButtonFrame(frame, framePadding, buttonList, buttonWidth, buttonHeight, buttonMargin, numCols, startPoint, rowMargin)
  local numButtons = # buttonList
  numCols = max(min(numButtons, numCols),1)
  local numRows = max(ceil(numButtons/numCols),1)
  if not rowMargin then
  rowMargin = buttonMargin
  end
  local frameWidth = numCols*buttonWidth + (numCols-1)*buttonMargin + 2*framePadding
  local frameHeight = numRows*buttonHeight + (numRows-1)*rowMargin + 2*framePadding
  frame:SetSize(frameWidth,frameHeight)
  --TOPLEFT
  --1. TL, f, p, -p
  --2. T, rb-1, B, 0, -m
  --3. L, b-1, R, m, 0
  if startPoint == "TOPLEFT" then
  self:SetupButtonPoints(frame, buttonList, buttonWidth, buttonHeight, numCols, startPoint, framePadding, -framePadding, "TOP", "BOTTOM", 0, -rowMargin, "LEFT", "RIGHT", buttonMargin, 0)
  --end
  --TOPRIGHT
  --1. TR, f, -p, -p
  --2. T, rb-1, B, 0, -m
  --3. R, b-1, L, -m, 0
  elseif startPoint == "TOPRIGHT" then
  self:SetupButtonPoints(frame, buttonList, buttonWidth, buttonHeight, numCols, startPoint, -framePadding, -framePadding, "TOP", "BOTTOM", 0, -rowMargin, "RIGHT", "LEFT", -buttonMargin, 0)
  --end
  --BOTTOMRIGHT
  --1. BR, f, -p, p
  --2. B, rb-1, T, 0, m
  --3. R, b-1, L, -m, 0
  elseif startPoint == "BOTTOMRIGHT" then
    self:SetupButtonPoints(frame, buttonList, buttonWidth, buttonHeight, numCols, startPoint, -framePadding, framePadding, "BOTTOM", "TOP", 0, rowMargin, "RIGHT", "LEFT", -buttonMargin, 0)
  --end
  --BOTTOMLEFT
  --1. BL, f, p, p
  --2. B, rb-1, T, 0, m
  --3. L, b-1, R, m, 0
  --elseif startPoint == "BOTTOMLEFT" then
  else
  startPoint = "BOTTOMLEFT"
  self:SetupButtonPoints(frame, buttonList, buttonWidth, buttonHeight, numCols, startPoint, framePadding, framePadding, "BOTTOM", "TOP", 0, rowMargin, "LEFT", "RIGHT", buttonMargin, 0)
  end
end

function Buffs:CreateBuffFrame(addonName, buffsL1, buffsL2, buffsL3, buffsL4, buffsL5, buffsScale, buffsPadding, buffsWidth, buffsHeight, buffsMargin, buffsNumCols, buffsStartPoint, buffsRowMargin)
  frameName = addonName.."BuffFrame"
  frameParent = frameParent or UIParent
  frameTemplate = nil
  --create new parent frame for buttons
  local frame = CreateFrame("Frame", frameName, frameParent, frameTemplate)
  frame:SetPoint(buffsL1, buffsL2, buffsL3, buffsL4, buffsL5)
  frame:SetScale(buffsScale)
  local function UpdateAllBuffAnchors()
  --add temp enchant buttons
  local buttonList = self:GetButtonList("TempEnchant",BuffFrame.numEnchants)
  --add all other buff buttons
  buttonList = self:GetButtonList("BuffButton",BUFF_MAX_DISPLAY,buttonList)
  --adjust frame by button list
  self:SetupButtonFrame(frame, buffsPadding, buttonList, buffsWidth, buffsHeight, buffsMargin, buffsNumCols, buffsStartPoint, buffsRowMargin)
  end
  hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", UpdateAllBuffAnchors)
  return frame
end

function Buffs:CreateDebuffFrame(addonName, deBuffsLocation, deBuffsScale, deBuffsPadding, deBuffsWidth, deBuffsHeight, deBuffsMargin, deBuffsNumCols, deBuffsStartPoint, deBuffsRowMargin)
  frameName = addonName.."DebuffFrame"
  frameParent = frameParent or UIParent --deBuffsLocation.Parent or UIParent
  frameTemplate = nil
  --create new parent frame for buttons
  local frame = CreateFrame("Frame", frameName, frameParent, frameTemplate)
  frame:SetPoint(unpack(deBuffsLocation))
  frame:SetScale(deBuffsScale)
  local function UpdateAllDebuffAnchors(buttonName, index)
  --add all other debuff buttons
  local buttonList = self:GetButtonList("DebuffButton",DEBUFF_MAX_DISPLAY,buttonList)
  --adjust frame by button list
  self:SetupButtonFrame(frame, deBuffsPadding, buttonList, deBuffsWidth, deBuffsHeight, deBuffsMargin, deBuffsNumCols, deBuffsStartPoint, deBuffsRowMargin)
  end
  hooksecurefunc("DebuffButton_UpdateAnchors", UpdateAllDebuffAnchors)
  return frame
end

function Buffs:AuraButton_SetBorderColor(self, ...)
  return self.border:SetVertexColor(...)
end