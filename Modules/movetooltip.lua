--[[

Code from TheWebDeveloper

https://www.curseforge.com/wow/addons/movetooltip-dtip

]]--

MoveToolTip = WUI:NewModule("MoveToolTip")

local MTTInCombat = false
local MTTEventFrame
local MTTDragFrame1
local MTTW = 20
local MTTH = 20


function MoveToolTip:OnInitialize()
    -- MTT Drag frame setup
    MTTDragFrame1 = CreateFrame("Frame", "MTTDragFrame1", UIParent)
    MTTDragFrame1:SetFrameStrata("tooltip") -- background, low, medium, high, dialog, fullscreen, tooltip
    MTTDragFrame1:SetWidth(MTTW)
    MTTDragFrame1:SetHeight(MTTH)
    MTTDragFrame1:SetMovable(true)
    MTTDragFrame1.texture = MTTDragFrame1:CreateTexture(nil, "BACKGROUND")
    MTTDragFrame1.texture:SetAllPoints(true)
    MTTDragFrame1.texture:SetColorTexture(0.0, 1.0, 0.0, 0.75) --SetColorTexture(1.0, 0.0, 0.0, 0.75)
    MTTDragFrame1:ClearAllPoints(true)
    MTTDragFrame1:SetPoint("TOPLEFT", WUI.db.profile.mttx, WUI.db.profile.mtty)
    MTTDragFrame1:EnableMouse(true)
    MTTDragFrame1:SetClampedToScreen(true)
    MTTDragFrame1:SetMovable(true)
    MTTDragFrame1:SetResizable(true)
    MTTDragFrame1:Show()
    MTTDragFrame1:SetScript("OnMouseDown", MTT1StartDrag)
    MTTDragFrame1:SetScript("OnMouseUp", MTT1StopDrag)

    ItemRefTooltip:SetOwner(MTTDragFrame1, "TOPLEFT")
	ItemRefTooltip:ClearAllPoints()
    ItemRefTooltip:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)

    hooksecurefunc("GameTooltip_SetDefaultAnchor", MTTToolTipHandler)

    MTTDragFrame1:Hide();
end

function MoveToolTip:OnEnable()
       -- Create processor frame
       MTTEventFrame = CreateFrame("frame","MTTFrame")
       MTTEventFrame:RegisterEvent("VARIABLES_LOADED")
       MTTEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
       MTTEventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
       MTTEventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
       MTTEventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
       MTTEventFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
       MTTEventFrame:RegisterEvent("ZONE_CHANGED")
   
       -- Setup MTTFrame events and handle those events
       MTTEventFrame:SetScript("OnEvent", function(self,event,addonName)
           -- print("EVENT: " .. event)
           if (event == "ADDON_LOADED") then
   
           elseif (event == "ZONE_CHANGED") then
   
           elseif (event == "ZONE_CHANGED_NEW") then
   
           elseif (event == "ZONE_CHANGED_NEW_AREA") then
   
           elseif (event == "ZONE_CHANGED_INDOORS") then
   
           elseif (event == "PLAYER_ENTERING_WORLD") then

           elseif (event == "PLAYER_REGEN_DISABLED") then
               MTTInCombat = true
           elseif (event == "PLAYER_REGEN_ENABLED") then
               MTTInCombat = false
           else
               -- print("MTT: WARNING: Unhandled event: [" .. event .. "]")
           end
       end)
end

function MoveToolTip:OnDisable()
end

function MTTToolTipHandler(self)
    self:SetOwner(MTTDragFrame1,"ANCHOR_NONE")
    self:ClearAllPoints(true)
    self:SetPoint("BOTTOMLEFT", MTTDragFrame1)
end

function MTT1StartDrag(self, button)
    if button == "LeftButton" and not self.isMoving then
        self:StartMoving()
        self.isMoving = true
    end
end

function MTT1StopDrag(self, button)
    if button == "LeftButton" and self.isMoving then
        self:StopMovingOrSizing()
        self.isMoving = false
        point, relativeTo, relativePoint, x, y = self:GetPoint()
        x = self:GetLeft()
        y = self:GetBottom()
        local scrW = GetScreenWidth()
        local scrH = GetScreenHeight()
        WUI.db.profile.mttx = x
        WUI.db.profile.mtty = y-scrH+MTTH
    end
end