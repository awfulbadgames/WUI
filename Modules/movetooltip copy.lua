--[[
	Author: darcey.lloyd@gmail.com
--]]


local MTTInCombat = false;
local MTTEventFrame;
local MTTDragFrame1;
--local MTTDragFrame1Alignment = "TOPLEFT";
--local MTTDragFrame2;
--local MTTDragFrame2Alignment = "TOPLEFT";
local MTTW = 20;
local MTTH = 20;


function MoveTooltip:OnInitialize()
	statsframe = CreateFrame('Frame', nil, UIParent)
    statsframe:SetFrameStrata('BACKGROUND')
    statsframe:SetWidth(100)
    statsframe:SetHeight(32)
	statsframe:SetPoint('TOPLEFT', 10, 0)

	statsframe.text = statsframe:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
	statsframe.text:SetPoint('CENTER', 0, 0)
    statsframe.text:SetFont(STANDARD_TEXT_FONT, 12, 'THINOUTLINE')
    statsframe:SetScript("OnEnter", function() self:StatsTooltip(statsframe) end)
    statsframe:SetScript("OnLeave", function() GameTooltip:Hide() end)
	self.statsTimer = self:ScheduleRepeatingTimer("Timer", 1)
end

-- Create processor frame
MTTEventFrame = CreateFrame("frame","MTTFrame");
MTTEventFrame:RegisterEvent("VARIABLES_LOADED");
MTTEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
MTTEventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
MTTEventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
MTTEventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
MTTEventFrame:RegisterEvent("ZONE_CHANGED_INDOORS");
MTTEventFrame:RegisterEvent("ZONE_CHANGED");
--MTTEventFrame:RegisterEvent("PLAYER_LOGOUT");
-- # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #



-- MTTFrame update handler
--MTTEventFrame:SetScript("OnUpdate", function(self) MTTUpdateHandler() end);
-- # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #



-- Setup MTTFrame events and handle those events
MTTEventFrame:SetScript("OnEvent", function(self,event,addonName)
    -- print("EVENT: " .. event);

	if (event == "ADDON_LOADED") then

	--elseif (event == "VARIABLES_LOADED") then
    --    print(" ");
    --    print("MoveToolTip (DTip) v" .. MTTVersion .. "");
    --    print("MoveToolTip: Type /mtt for usage information and options.")

	elseif (event == "ZONE_CHANGED") then

	elseif (event == "ZONE_CHANGED_NEW") then

	elseif (event == "ZONE_CHANGED_NEW_AREA") then

	elseif (event == "ZONE_CHANGED_INDOORS") then

	elseif (event == "PLAYER_ENTERING_WORLD") then
		initMTT();
	elseif (event == "PLAYER_REGEN_DISABLED") then
		MTTInCombat = true;
	elseif (event == "PLAYER_REGEN_ENABLED") then
		MTTInCombat = false;
	else
		-- print("MTT: WARNING: Unhandled event: [" .. event .. "]");
	end
end);
-- # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

-- # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
--function MTTUpdateHandler()

--end
-- # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #



-- # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
function initMTT()
    --initVarsPersistentVars();

    -- MTT Drag frame setup
    MTTDragFrame1 = CreateFrame("Frame", "MTTDragFrame1", UIParent)
    MTTDragFrame1:SetFrameStrata("tooltip"); -- background, low, medium, high, dialog, fullscreen, tooltip
    MTTDragFrame1:SetWidth(MTTW)
    MTTDragFrame1:SetHeight(MTTH)
    MTTDragFrame1:SetMovable(true);
    MTTDragFrame1.texture = MTTDragFrame1:CreateTexture(nil, "BACKGROUND")
    MTTDragFrame1.texture:SetAllPoints(true)
    MTTDragFrame1.texture:SetColorTexture(0.0, 1.0, 0.0, 0.75) --SetColorTexture(1.0, 0.0, 0.0, 0.75)
    MTTDragFrame1:ClearAllPoints(true);
    MTTDragFrame1:SetPoint("TOPLEFT", WUI.db.profile.x, WUI.db.profile.y);
    MTTDragFrame1:EnableMouse(true);
    MTTDragFrame1:SetClampedToScreen(true);
    MTTDragFrame1:SetMovable(true);
    MTTDragFrame1:SetResizable(true);
    MTTDragFrame1:Show();
    MTTDragFrame1:SetScript("OnMouseDown", MTT1StartDrag)
    MTTDragFrame1:SetScript("OnMouseUp", MTT1StopDrag)
    
--[[
    MTTDragFrame2 = CreateFrame("Frame", "MTTDragFrame2", UIParent)
    MTTDragFrame2:SetFrameStrata("tooltip"); -- background, low, medium, high, dialog, fullscreen, tooltip
    MTTDragFrame2:SetWidth(MTTW)
    MTTDragFrame2:SetHeight(MTTH)
    MTTDragFrame2:SetMovable(true);
    MTTDragFrame2.texture = MTTDragFrame2:CreateTexture(nil, "BACKGROUND")
    MTTDragFrame2.texture:SetAllPoints(true)
    MTTDragFrame2.texture:SetColorTexture(0.0, 1.0, 0.0, 0.75)
    MTTDragFrame2:ClearAllPoints(true);
    MTTDragFrame2:SetPoint(MTTDragFrame2Alignment,WUI.db.profile.t2x,WUI.db.profile.t2y);
    MTTDragFrame2:EnableMouse(true);
    MTTDragFrame2:SetClampedToScreen(true);
    MTTDragFrame2:SetMovable(true);
    MTTDragFrame2:SetResizable(true);
    MTTDragFrame2:Show();
    MTTDragFrame2:SetScript("OnMouseDown", MTT2StartDrag)
    MTTDragFrame2:SetScript("OnMouseUp", MTT2StopDrag)

]]--

    --local scrW = GetScreenWidth() * UIParent:GetEffectiveScale();
    --local scrH = GetScreenHeight() * UIParent:GetEffectiveScale();
    -- print(scrW .. " x " .. scrH);



    -- MTTDragFrame1:HookScript("OnClick", function(self, button)
    --     print(self:GetName() .. " clicked with " .. button)
    --    end)



    ItemRefTooltip:SetOwner(MTTDragFrame1, "TOPLEFT")
	ItemRefTooltip:ClearAllPoints()
    ItemRefTooltip:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)


    hooksecurefunc("GameTooltip_SetDefaultAnchor", MTTToolTipHandler);


    -- Setup slash commands (Note: SLASH_<SlashCommandName> is the pickup, add number for multiple slash commands)
    --SLASH_MTTCommand1 = "/mtt";
    --SLASH_MTTCommand1 = "/MTT";
	--SlashCmdList["MTTCommand"] = MTTSlashCommandHandler;

    -- State init
    MTTDragFrame1:Hide();
    --MTTDragFrame2:Hide();

end
-- # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #






function MTTToolTipHandler(self)
    -- print(self);
    -- local w = self:GetWidth();
    -- local h = self:GetHeight();
    -- print(w .. "," .. h);

    self:SetOwner(MTTDragFrame1,"ANCHOR_NONE");
    self:ClearAllPoints(true);
    self:SetPoint("BOTTOMLEFT", MTTDragFrame1)
--[[
    if (ItemRefTooltip) then
        -- ItemRefTooltip:SetOwner(MTTDragFrame1, "ANCHOR_NONE");
        ItemRefTooltip:SetPoint("TOPLEFT", MTTDragFrame2)
    end
]]--
end

function MTT1StartDrag(self, button)
    if button == "LeftButton" and not self.isMoving then
        self:StartMoving();
        self.isMoving = true;
    end
end

function MTT1StopDrag(self, button)
    if button == "LeftButton" and self.isMoving then
        self:StopMovingOrSizing();
        self.isMoving = false;
        point, relativeTo, relativePoint, x, y = self:GetPoint();
        x = self:GetLeft();
        y = self:GetBottom();
        local scrW = GetScreenWidth();
        local scrH = GetScreenHeight();
        WUI.db.profile.x = x;
        WUI.db.profile.y = y-scrH+MTTH;
    end
end

--[[
function MTT2StartDrag(self, button)
    if button == "LeftButton" and not self.isMoving then
        self:StartMoving();
        self.isMoving = true;
    end
end

function MTT2StopDrag(self, button)
    if button == "LeftButton" and self.isMoving then
        self:StopMovingOrSizing();
        self.isMoving = false;
        point, relativeTo, relativePoint, x, y = self:GetPoint();
        x = self:GetLeft();
        y = self:GetBottom();
        local scrW = GetScreenWidth();
        local scrH = GetScreenHeight();
        WUI.db.profile.t2x = x;
        WUI.db.profile.t2y = y-scrH+MTTH;
    end
end
]]--

--[[
function MTTSlashCommandHandler(cmd)
	if (cmd == "hide") then
		MTTDragFrame1:Hide();
        MTTDragFrame2:Hide();
		return;
	end


    if (cmd == "show") then
        MTTDragFrame1:Show();
        MTTDragFrame2:Show();
		return;
	end
end
]]--