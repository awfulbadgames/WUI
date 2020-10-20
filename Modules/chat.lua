--[[

Code from zorker

https://github.com/zorker/rothui
https://github.com/zorker/rothui/tree/master/wow8.0/rChat

MIT license

]]--

Chat = WUI:NewModule("Chat", "AceHook-3.0")

local DefaultSetItemRef = SetItemRef

--font size
CHAT_FONT_HEIGHTS = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}

--tabs
CHAT_TAB_HIDE_DELAY = 1
CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 1

--channels
CHAT_WHISPER_GET              = "From %s "
CHAT_WHISPER_INFORM_GET       = "To %s "
CHAT_BN_WHISPER_GET           = "From %s "
CHAT_BN_WHISPER_INFORM_GET    = "To %s "
CHAT_YELL_GET                 = "%s "
CHAT_SAY_GET                  = "%s "
CHAT_BATTLEGROUND_GET         = "|Hchannel:Battleground|hBG.|h %s: "
CHAT_BATTLEGROUND_LEADER_GET  = "|Hchannel:Battleground|hBGL.|h %s: "
CHAT_GUILD_GET                = "|Hchannel:Guild|hG.|h %s: "
CHAT_OFFICER_GET              = "|Hchannel:Officer|hGO.|h %s: "
CHAT_PARTY_GET                = "|Hchannel:Party|hP.|h %s: "
CHAT_PARTY_LEADER_GET         = "|Hchannel:Party|hPL.|h %s: "
CHAT_PARTY_GUIDE_GET          = "|Hchannel:Party|hPG.|h %s: "
CHAT_RAID_GET                 = "|Hchannel:Raid|hR.|h %s: "
CHAT_RAID_LEADER_GET          = "|Hchannel:Raid|hRL.|h %s: "
CHAT_RAID_WARNING_GET         = "|Hchannel:RaidWarning|hRW.|h %s: "
CHAT_INSTANCE_CHAT_GET        = "|Hchannel:Battleground|hI.|h %s: "
CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:Battleground|hIL.|h %s: "
--CHAT_MONSTER_PARTY_GET       = CHAT_PARTY_GET
--CHAT_MONSTER_SAY_GET         = CHAT_SAY_GET
--CHAT_MONSTER_WHISPER_GET     = CHAT_WHISPER_GET
--CHAT_MONSTER_YELL_GET        = CHAT_YELL_GET
CHAT_FLAG_AFK = "<AFK> "
CHAT_FLAG_DND = "<DND> "
CHAT_FLAG_GM = "<[GM]> "

--remove the annoying guild loot messages by replacing them with the original ones
YOU_LOOT_MONEY_GUILD = YOU_LOOT_MONEY
LOOT_MONEY_SPLIT_GUILD = LOOT_MONEY_SPLIT

function Chat:OnInitialize()
end

function Chat:OnEnable()
    if WUI.db.profile.chat then
        --temporary chat windows
        self:SecureHook("FCF_OpenTemporaryWindow", "OpenTemporaryWindow")
        --background thingy
        self:SecureHook("FloatingChatFrame_UpdateBackgroundAnchors", "UpdateBackgroundAnchors")
        
        --don't cut the toastframe
        BNToastFrame:SetClampedToScreen(true)
        BNToastFrame:SetClampRectInsets(-15,15,15,-15)
        --ChatFrameMenuButton
        ChatFrameMenuButton:HookScript("OnShow", ChatFrameMenuButton.Hide)
        ChatFrameMenuButton:Hide()
        --ChatFrameChannelButton
        ChatFrameChannelButton:HookScript("OnShow", ChatFrameChannelButton.Hide)
        ChatFrameChannelButton:Hide()
        --ChatFrameToggleVoiceDeafenButton
        ChatFrameToggleVoiceDeafenButton:HookScript("OnShow", ChatFrameToggleVoiceDeafenButton.Hide)
        ChatFrameToggleVoiceDeafenButton:Hide()
        --ChatFrameToggleVoiceMuteButton
        ChatFrameToggleVoiceMuteButton:HookScript("OnShow", ChatFrameToggleVoiceMuteButton.Hide)
        ChatFrameToggleVoiceMuteButton:Hide()
        --hide the friend micro button
        local button = QuickJoinToastButton or FriendsMicroButton
        button:HookScript("OnShow", button.Hide)
        button:Hide()
        --scroll
        FloatingChatFrame_OnMouseScroll = OnMOuseScroll

        --skin chat
        for i = 1, NUM_CHAT_WINDOWS do
            local chatframe = _G["ChatFrame"..i]
            chatframe:SetClampRectInsets(0, 0, 0, 0)
            self:SkinChat(chatframe)
            --adjust channel display
            if (i ~= 2) then
                --chatframe.DefaultAddMessage = chatframe.AddMessage
                --chatframe.AddMessage = self:AddMessage()
                self:RawHook(chatframe, "AddMessage", true)
            end
        end

    end
end

function Chat:OnDisable()
end

--SkinChat
function Chat:SkinChat(self)
    if not self then return end
    local name = self:GetName()
    --chat frame resizing
    self:SetClampRectInsets(0, 0, 0, 0)
    --self:SetMaxResize(UIParent:GetWidth()/2, UIParent:GetHeight()/2)  --original
    self:SetMaxResize(floor(tonumber(GetScreenWidth()))/2, floor(tonumber(GetScreenHeight()))/2)
    self:SetMinResize(100, 50)

    if name ~= "ChatFrame2" then
        self:ClearAllPoints()
        self:SetPoint("BOTTOMLEFT", UIParent, 5, 9)
        self:SetWidth(440)
        self:SetHeight(190)
    end

    --chat fading
    self:SetFading(true)

    --hide button frame
    local bf = _G[name.."ButtonFrame"]
    bf:HookScript("OnShow", bf.Hide)
    bf:Hide()

    --editbox
    local eb = _G[name.."EditBox"]
    eb:SetAltArrowKeyMode(false)
    --reposition
    eb:ClearAllPoints()
    if name == "ChatFrame2" then
        eb:SetPoint("BOTTOM", self, "TOP", 0, 22+24) --CombatLogQuickButtonFrame_Custom:GetHeight()
    else
        eb:SetPoint("BOTTOM", self, "TOP", 0, 22)
    end
    eb:SetPoint("LEFT",self,-5,0)
    eb:SetPoint("RIGHT",self,10,0)
end

--OpenTemporaryWindow
function Chat:OpenTemporaryWindow()
    for _, name in next, CHAT_FRAMES do
        local frame = _G[name]
        if (frame.isTemporary) then
            self:SkinChat(frame)
        end
    end
end

function Chat:UpdateBackgroundAnchors(self)
    --fix wierd combat log
    self:SetClampRectInsets(0, 0, 0, 0)
end

--OnMOuseScroll
function Chat:OnMOuseScroll(self,dir)
    if(dir > 0) then
        if(IsShiftKeyDown()) then self:ScrollToTop() else self:ScrollUp() end
    else
        if(IsShiftKeyDown()) then self:ScrollToBottom() else self:ScrollDown() end
    end
end

--we replace the default setitemref and use it to parse links for alt invite and url copy
function Chat:SetItemRef(link, ...)
    local type, value = link:match("(%a+):(.+)")
    if IsAltKeyDown() and type == "player" then
        InviteUnit(value:match("([^:]+)"))
    elseif (type == "url") then
        local eb = LAST_ACTIVE_CHAT_EDIT_BOX or ChatFrame1EditBox
        if not eb then return end
        eb:SetText(value)
        eb:SetFocus()
        eb:HighlightText()
        if not eb:IsShown() then eb:Show() end
    else
        return DefaultSetItemRef(link, ...)
    end
end

--AddMessage
function Chat:AddMessage(frame, text, ...)
    --channel replace (Trade and such)
    text = text:gsub("|h%[(%d+)%. .-%]|h", "|h%1.|h")
    --url search
    text = text:gsub('([wWhH][wWtT][wWtT][%.pP]%S+[^%p%s])', '|cffffffff|Hurl:%1|h[%1]|h|r')
    --return self.DefaultAddMessage(self, text, ...)
    return self.hooks[frame].AddMessage(frame, text, ...)
end