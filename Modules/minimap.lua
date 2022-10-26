Mini = WUI:NewModule("Mini")

local isWoWClassic, isWoWBcc, isWoWWotlkc, isWoWRetail = false, false, false, false;

if (_G["WOW_PROJECT_ID"] == _G["WOW_PROJECT_CLASSIC"]) then
	isWoWClassic = true;
elseif (_G["WOW_PROJECT_ID"] == _G["WOW_PROJECT_BURNING_CRUSADE_CLASSIC"]) then
	isWoWBcc = true;
elseif (_G["WOW_PROJECT_ID"] == _G["WOW_PROJECT_WRATH_CLASSIC"]) then
	isWoWWotlkc = true;
else
	isWoWRetail = true;
end

function Mini:OnInitialize()
end

function Mini:OnEnable()
  self:Update()
end

function Mini:OnDisable()
end

function Mini:Update()
if isWoWWotlkc then
	self:HideMapIcon()
	self:HideNorth()
	  self:HideZoomIcons()
  end
  self:ScrollZoom()

  self:MinimapScale()
end

function Mini:HideMapIcon()
  if WUI.db.profile.hidemapicon then
    MiniMapWorldMapButton:Hide()
  else
    MiniMapWorldMapButton:Show()
  end
end

function Mini:HideNorth()
  if WUI.db.profile.hidenorth then
    MinimapNorthTag:SetAlpha(0)
  else
    MinimapNorthTag:SetAlpha(1)
  end
end

function Mini:HideZoomIcons()
  if WUI.db.profile.hidezoomicons then
    MinimapZoomIn:Hide()
    MinimapZoomOut:Hide()
  else
    MinimapZoomIn:Show()
    MinimapZoomOut:Show()
  end
end

function Mini:ScrollZoom()
  if WUI.db.profile.scrollzoom then
    Minimap:EnableMouseWheel()
    local function Zoom(self, direction)
      if(direction > 0) then 
        Minimap_ZoomIn()
      else
        Minimap_ZoomOut()
      end
    end
    Minimap:SetScript("OnMouseWheel", Zoom)
  else
    Minimap:SetScript("OnMouseWheel", nil)
  end
end

function Mini:MinimapScale()
  MinimapCluster:SetScale(WUI.db.profile.minimapscale)
end