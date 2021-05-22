--[[

Code in parts or totally from WowWiki

https://wowwiki-archive.fandom.com/wiki/Making_Draggable_Frames

]]--

local MoveTooltip = WUI:NewModule("MoveTooltip")

function MoveTooltip:OnInitialize()
    frame = CreateFrame("Frame", "DragFrame2", UIParent)
    frame:SetMovable(true)
    frame:SetPoint(WUI.db.profile.point, WUI.db.profile.offsetX, WUI.db.profile.offsetY)
    frame:EnableMouse(true)
    frame:SetClampedToScreen(true)
    frame:SetSize(150,24);

    local tex = frame:CreateTexture("ARTWORK")
    tex:SetAllPoints()
    tex:SetTexture(1.0, 0.5, 0); tex:SetAlpha(0.5)

    ItemRefTooltip:SetOwner(DragFrame2, "TOPLEFT")
	ItemRefTooltip:ClearAllPoints()
    ItemRefTooltip:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)

    frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.text:SetText("ANCHOR_TOOLTIP")
    frame.text:SetPoint("LEFT", 5, 0)
    
    frame.close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    frame.close:SetSize(24, 24)
    frame.close:SetPoint("RIGHT")

    frame:Hide()
end

function MoveTooltip:OnEnable()
    frame:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" and not self.isMoving then
            self:StartMoving()
            self.isMoving = true
        end
    end)

    frame:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" and self.isMoving then
            self:StopMovingOrSizing()
            self.isMoving = false
        end
    end)

    frame:SetScript("OnHide", function(self)
        if ( self.isMoving ) then
            self:StopMovingOrSizing()
            self.isMoving = false
        end
    end)
end

function MoveTooltip:OnDisable()
end