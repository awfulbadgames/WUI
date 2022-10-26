
--[[

    Code in parts or totally from blizzsorc

    https://www.curseforge.com/wow/addons/tooltip-enhanced

    MIT license

]]--

--[[
    https://us.forums.blizzard.com/en/wow/t/wow-classic-ui-api-change-for-unithealth/446596
    https://www.townlong-yak.com/framexml/37176/GlobalStrings.lua/RU
    https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/SharedXML/SharedColorConstants.lua#L72-L81

    Multiplication factors prefix symbol:
    1e+24 1,000,000,000,000,000,000,000,000 yotta Y
    1e+21 1,000,000,000,000,000,000,000 zetta Z
    1e+18 1,000,000,000,000,000,000 exa E
    1e+15 1,000,000,000,000,000 peta P
    1e+12 1,000,000,000,000 tera T
    1e+09 1,000,000,000 giga G
    1e+06 1,000,000 mega M
    1e+03 1,000 kilo k
    1e+02 100 hecto h
    1e+01 10 deka da
    1e+00 1
    1e-01 0.1 deci d
    1e-02 0.01 centi c
    1e-03 0.001 milli m
    1e-06 0.000 001 micro
    1e-09 0.000 000 001 nano n
    1e-12 0.000 000 000 001 pico p
    1e-15 0.000 000 000 000 001 femto f
    1e-18 0.000 000 000 000 000 001 atto a
    1e-21 0.000 000 000 000 000 000 001 zepto z
    1e-24 0.000 000 000 000 000 000 000 001 yocto y

    Convert RGB(%) to Hex:
    string.format('|cff%02x%02x%02x%s|r', r * 255, g * 255, b * 255, text)

    Issue #1 (fixed):
    Hold LMB or RMB but do not rotate the camera, just move your character
    The cursor should not disappear from the screen at this time, it will follow the movement of your character
    Thus, while it follows, when hovering over a unit there is a color issue
    Because unit returns nil under the given conditions

    Issue #2 (fixed):
    Hover over a unit (during combat) and then move the cursor away
    The tooltip should not disappear from the screen at this time (FadeOut animation)
    Then quickly let the unit take some damage to see the changes
    The status bar color will turn to default green, not class color
    Because unit returns nil under the given conditions

    Issue #3 (fixed):
    An issue similar to issue #2 also occurs when using UnitPlayerControlled()
    Turn off nameplates to see it
]]

TTip = WUI:NewModule("TTip", "AceEvent-3.0")

u = {}

local TARGET_PREFIX = TARGET..":|cffffffff "
local TALENTS_PREFIX = TALENTS..":|cffffffff "
local TALENTS_NA = NOT_APPLICABLE:lower();
local TALENTS_NONE = NO.." "..TALENTS;
local TALENTS_LOADING = SEARCH_LOADING_TEXT;

local defaultColor = '|cffffd100'
local whiteColor = '|cffffffff'

function TTip:OnInitialize()
end

function TTip:OnEnable()
    if not WUI.db.profile.enableTooltipChanges then
        return
    end
    -- Create a string object for status bar text
    GameTooltipStatusBar.healthText = GameTooltipStatusBar:CreateFontString(nil, 'OVERLAY')
    GameTooltipStatusBar.healthText:SetFont(WUI.db.profile.healthFont, WUI.db.profile.healthFontSize, WUI.db.profile.healthFontFlags)
    GameTooltipStatusBar.healthText:SetPoint('CENTER', 0, WUI.db.profile.healthOffsetY)

    GameTooltip:HookScript('OnTooltipSetUnit', onTooltipSetUnit)
    GameTooltipStatusBar:HookScript('OnValueChanged', onValueChanged)

    GameTooltip:HookScript('OnShow', OnTooltipShow)
	GameTooltip:HookScript('OnUpdate', OnTooltipShow)
    GameTooltip:HookScript('OnTooltipSetSpell', onTooltipSetSpell) -- SpellBookFrame, PlayerTalentFrame, ...

    hooksecurefunc('GameTooltip_ShowCompareItem', ShowCompareItem)
    hooksecurefunc('GameTooltip_SetDefaultAnchor', setDefaultAnchor)
    hooksecurefunc(GameTooltip, 'SetUnitAura', setUnitAura) -- BuffFrame
    hooksecurefunc(GameTooltip, 'SetUnitBuff', setUnitAura) -- UnitFrame
    hooksecurefunc(GameTooltip, 'SetUnitDebuff', setUnitAura) -- UnitFrame

    self:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "GetSpec")
    self:RegisterEvent("INSPECT_READY", "SpecText")
end

function TTip:OnDisable()
end

local function abbreviateLargeNumbers(value)
    if value >= 1e11 then return string.format('%dG', value / 1e9) -- 128G
    elseif value >= 1e9 then return string.format('%.1fG', value / 1e9) -- 1.6G, 61.8G
    elseif value >= 1e8 then return string.format('%dM', value / 1e6) -- 128M
    elseif value >= 1e6 then return string.format('%.1fM', value / 1e6) -- 1.6M, 61.8M
    elseif value >= 1e5 then return string.format('%dk', value / 1e3) -- 128k
    elseif value >= 1e3 then return string.format('%.1fk', value / 1e3) -- 1.6k, 61.8k
    else return value
    end
end

local function updateStatusBar(statusBar, unit)
    local isDead = unit and UnitIsDeadOrGhost(unit)
    local color = WUI.db.profile.enableClassColor and TTip:GetClassColor(unit) or CreateColor(0, 1, 0)

    local currHealth = statusBar:GetValue()
    local maxHealth = select(2, statusBar:GetMinMaxValues())
    local healthText = ''

    if not WUI.db.profile.showUnitHealth then
        healthText = ''
    elseif currHealth <= 0 or isDead then
        healthText = DEAD
    else
        healthText = abbreviateLargeNumbers(currHealth) .. ' / ' .. abbreviateLargeNumbers(maxHealth)
    end
    statusBar.healthText:SetText(healthText)
    statusBar:SetStatusBarColor(color.r, color.g, color.b)

    if WUI.db.profile.insideBar then
        statusBar:ClearAllPoints()
		statusBar:SetPoint("BOTTOMLEFT", 7, 7)
		statusBar:SetPoint("BOTTOMRIGHT", -7, 7)
    end
end

function onTooltipSetUnit(self)
    -- Hold LMB or RMB but do not rotate the camera, just move your character
    -- The cursor should not disappear from the screen at this moment, it will follow the movement of your character
    -- Thus, as long as the cursor is following your character's movement, GetUnit() will always return nil
    if IsMouseButtonDown('LeftButton') or IsMouseButtonDown('RightButton') then
        return self:Hide() -- fix the issue
    end

    local unit = TTip:fixGetUnit(self)

    if WUI.db.profile.hideInCombat then
        if InCombatLockdown() and GetMouseFocus() == WorldFrame then
            return self:Hide()
        end
    end

    local pattern = "^"..LEVEL -- LEVEL is a global variable and used in all localisations
    --local unit = select(2, self:GetUnit())
    local unitDetail
    local targetUnit 
    local unitLevel
    if UnitExists(unit) then
        targetUnit = unit .. 'target'
        unitLevel = UnitLevel(unit)
    else
        targetUnit = ''
        unitLevel = ''
    end
    local statusBar = self:GetChildren()

    if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
        unitLevel = UnitBattlePetLevel(unit)
    end
    if (unitLevel == -1) then unitLevel = '??' end
    unitLevel = 'Level ' .. unitLevel

    if UnitIsPlayer(unit) then
        local unitName = GetUnitName(unit, WUI.db.profile.showServerName) -- also hides a title
        local guildName = GetGuildInfo(unit) --, _, _, guildRealm = GetGuildInfo(unit) -- isClassic
        local classColor = TTip:GetClassColor(unit)
        local playerFaction = select(2, UnitFactionGroup('player'))
        local unitFaction = select(2, UnitFactionGroup(unit))
		local _, unitRealmName = UnitName(unit)
		local unitRelation = UnitRealmRelationship(unit)
		local unitStatus = ''

        classColor = string.format('|cff%.2x%.2x%.2x', classColor.r * 255, classColor.g * 255, classColor.b * 255)

		if (unitRealmName == nil) then unitRealmName = "" end

        for i = 1, self:NumLines() do
            local line = _G[self:GetName() .. 'TextLeft' .. i]
            local lineText = line:GetText()

            if i == 1 then
				if WUI.db.profile.UnitStatus then
					if UnitIsAFK(unit) then
						unitStatus = whiteColor .. '<' .. AFK .. '> |r'
					elseif UnitIsDND(unit) then
						unitStatus = whiteColor .. '<' .. DND .. '> |r'
					end
                    unitName = unitStatus .. unitName
				end
				
				if WUI.db.profile.UnitTitle and UnitPVPName(unit) then
					unitName = unitStatus .. UnitPVPName(unit)
				end
				
                --if WUI.db.profile.UnitRealm and unitRealmName and (unitRealmName ~= '') then
				if WUI.db.profile.UnitRealm and (unitRealmName ~= '') then
					if WUI.db.profile.RealmLabel then
						if (unitRelation == LE_REALM_RELATION_VIRTUAL) then
							unitName = unitName .. INTERACTIVE_SERVER_LABEL
						else
							unitName = unitName .. FOREIGN_SERVER_LABEL
						end
					else
						unitName = unitName .. ' - ' .. unitRealmName
					end
				end
				
                line:SetText(WUI.db.profile.enableClassColor and (classColor .. unitName) or unitName)
            
            elseif i == 2 and guildName then
				local guildString
				local guildUnitRank = ''
				local unitName, unitRealmName = UnitName(unit)

				if UnitIsPlayer(unit) then
					u.reactionIndex = TTip:GetUnitReactionIndex(unit) --(u.token)
					u.reactionColor = WUI.db.profile["colReactText"..u.reactionIndex]

					local pGuild = GetGuildInfo("player")
                    local guildName, guildRank, guildRankIndex, realmName = GetGuildInfo(unit)
					local guildColor = (guildName == pGuild and WUI.db.profile.colSameGuild or WUI.db.profile.colorGuildByReaction and u.reactionColor or WUI.db.profile.colGuild)

					if guildName then
						if WUI.db.profile.GuildRank and guildRank then
							guildUnitRank = '|cff0080cc[' .. guildRank .. ']' .. whiteColor .. ' in '
						end
						if WUI.db.profile.UnitRealm then
							if (realmName == unitRealmName) then
                                guildString = guildUnitRank .. (WUI.db.profile.colorGuildByReaction and (guildColor .. '<' .. guildName .. '>') or guildName)
							else
                                --print(realmName)
                                if realmName == nil then
                                    guildString = guildUnitRank .. (WUI.db.profile.colorGuildByReaction and (guildColor .. '<' .. guildName .. '>') or guildName)
                                else
                                    guildString = guildUnitRank .. (WUI.db.profile.colorGuildByReaction and (guildColor .. '<' .. guildName .. '> - ') or guildName) .. realmName
                                end
							end
						else
                            guildString = guildUnitRank .. (WUI.db.profile.colorGuildByReaction and (guildColor .. '<' .. guildName .. '>') or guildName)
						end
					else
						guildString = '<' .. gsub(guildLine:GetText(), '-.+', '') .. '>'
					end
				else
					guildString = '<' .. gsub(guildLine:GetText(), '-.+\'s', '\'s') .. '>'
				end

                line:SetText(WUI.db.profile.showServerName and guildString or guildName)

            elseif i==2 and guildName~='' or i==3 and guildName then
                local unitRace = UnitRace(unit)
                local className, str = UnitClass(unit)

                if WUI.db.profile.ClassColor then
                    className = ''
                end

                if WUI.db.profile.UnitGender then
                    local unitGender = {'', MALE, FEMALE}
                    unitDetail = unitGender[UnitSex(unit)] .. ' ' .. unitRace .. ' ' .. (WUI.db.profile.enableClassColor and (classColor .. className) or className)
                else
                    unitDetail = unitRace .. ' ' .. (WUI.db.profile.enableClassColor and (classColor .. className) or className)
                end

                line:SetText(unitLevel .. ' ' .. unitDetail)

            -- Set faction line color, if the unit (player) is from the opposite faction
            elseif not WUI.db.profile.enableClassColor then
                break
            elseif (lineText == FACTION_ALLIANCE or lineText == FACTION_HORDE) and playerFaction ~= unitFaction then
                line:SetTextColor(FACTION_BAR_COLORS[1].r, FACTION_BAR_COLORS[1].g, FACTION_BAR_COLORS[1].b)
                break
            end
        end

        --Target of Target
        if WUI.db.profile.TargetOfTarget and UnitExists(targetUnit) then
            GameTooltip:AddLine(defaultColor .. 'Targeting: ' .. TTip:TargetOfTarget(unit))
        end

    else -- If Unit is not player
        if WUI.db.profile.enableClassColor then
            for i = 1, self:NumLines() do
                local line = _G[self:GetName() .. 'TextLeft' .. i]
                local lineText = line:GetText()

                if i == 2 and string.find(lineText, pattern) then
                    local creatureClass, creatureType
                    if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
                        creatureType = UnitBattlePetType(unit)
                        creatureType = PET_TYPE_SUFFIX[creatureType]
                        creatureClass = ' (' .. PET .. ')'
                    else
                        creatureType = UnitCreatureType(unit)
                        if (not creatureType) or (creatureType == 'Not specified') then
                            creatureType = ''
                        end
                        creatureClass = UnitClassification(unit)
                        if creatureClass then
                            if (creatureClass == 'elite') or (creatureClass == 'rareelite') then
                                unitLevel = unitLevel .. '+'
                            end
                            if (creatureClass == 'rare') or (creatureClass == 'rareelite') then
                                creatureClass = ' |cffff66ff(' .. ITEM_QUALITY3_DESC ..')'
                            elseif (creatureClass == 'worldboss') then
                                creatureClass = ' |cffff0000(' .. BOSS ..')'
                            else
                                creatureClass = ''
                            end
                        end
                    end
                    unitDetail = defaultColor .. creatureType .. creatureClass
                    line:SetText(unitLevel .. ' ' .. unitDetail)
                elseif i == 3 and string.find(lineText, pattern) then
                    local creatureClass, creatureType
                    if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
                        creatureType = UnitBattlePetType(unit)
                        creatureType = PET_TYPE_SUFFIX[creatureType]
                        creatureClass = ' (' .. PET .. ')'
                    else
                        creatureType = UnitCreatureType(unit)
                        if (not creatureType) or (creatureType == 'Not specified') then
                            creatureType = ''
                        end
                        creatureClass = UnitClassification(unit)
                        if creatureClass then
                            if (creatureClass == 'elite') or (creatureClass == 'rareelite') then
                                unitLevel = unitLevel .. '+'
                            end
                            if (creatureClass == 'rare') or (creatureClass == 'rareelite') then
                                creatureClass = ' |cffff66ff(' .. ITEM_QUALITY3_DESC ..')'
                            elseif (creatureClass == 'worldboss') then
                                creatureClass = ' |cffff0000(' .. BOSS ..')'
                            else
                                creatureClass = ''
                            end
                        end
                    end
                    unitDetail = defaultColor .. creatureType .. creatureClass
                    line:SetText(unitLevel .. ' ' .. unitDetail)           
                end
            end
        end

        --Target of Target
        if WUI.db.profile.TargetOfTarget and UnitExists(targetUnit) then
            GameTooltip:AddLine(defaultColor .. 'Targeting: ' .. TTip:TargetOfTarget(unit))
        end
    end
    --updateStatusBar(statusBar, unit)
end

function onValueChanged(self)
    local unit = select(2, self:GetParent():GetUnit())
    updateStatusBar(self, unit)
end

function setDefaultAnchor(self, parent)
    --self:SetOwner(parent, 'ANCHOR_NONE')
    --self:ClearAllPoints()

	--[[
    -- Set a custom position
    if WUI.db.profile.useCustomPosition then
        --self:SetPoint(WUI.db.profile.point, WUI.db.profile.relativeFrame, WUI.db.profile.relativePoint, WUI.db.profile.offsetX, WUI.db.profile.offsetY)
        self:SetOwner(DragFrame2,"ANCHOR_NONE")
        self:ClearAllPoints(true)
        self:SetPoint("BOTTOMLEFT", DragFrame2)
    else
        self:SetPoint('BOTTOMLEFT', GameTooltipDefaultContainer, 'BOTTOMLEFT') --, -CONTAINER_OFFSET_X - 13, CONTAINER_OFFSET_Y)
    end
	]]--
	--self:SetPoint('BOTTOMLEFT', GameTooltipDefaultContainer, 'BOTTOMLEFT') --, -CONTAINER_OFFSET_X - 13, CONTAINER_OFFSET_Y)
	
    -- Anchor to the mouse cursor
    if WUI.db.profile.anchorToCursor and not InCombatLockdown() and
        ( (WUI.db.profile.anchorToCursorAlt and GetMouseFocus() == WorldFrame) or not WUI.db.profile.anchorToCursorAlt ) then
        -- When anchorToCursorAlt is enabled, anchorToCursor will be ignored if it is not a WorldFrame
        self:SetOwner(parent, WUI.db.profile.cursorAnchorPoint, WUI.db.profile.cursorOffsetX, WUI.db.profile.cursorOffsetY)
    end

    -- This will flag the tooltip as having been anchored using the default anchor
    self.default = 1 -- probably does not work anymore
end

function addLine(tooltip, id)
    if not id then return end
    if not WUI.db.profile.showSpellID then return end
    local hexColor = WUI.db.profile.spellIDTextColor:GenerateHexColor()
    tooltip:AddLine('|c' .. hexColor .. WUI.db.profile.spellIDText .. '|r ' .. id, 1, 1, 1)
    tooltip:Show() -- update borders correctly
end

function onTooltipSetSpell(self)
    local id = select(2, self:GetSpell())
    if not WUI.db.profile.showSpellID then return end
    -- Fix duplicate line issue in PlayerTalentFrame (isRetail)
    for i = self:NumLines(), 3, -1 do
        local lineText = _G[self:GetName() .. 'TextLeft' .. i]:GetText()
        -- If the "Spell ID" line is found
        if string.match(lineText, WUI.db.profile.spellIDText) then
            return -- stop the loop and exit the function
        end
    end
    addLine(self, id)
end

function setUnitAura(self, unit, index, filter)
    if not WUI.db.profile.showSpellID then return end
    local id = select(10, UnitAura(unit, index, filter))
    addLine(self, id)
end

function OnTooltipShow(self)
    if WUI.db.profile.hideInCombat then
        if InCombatLockdown() and GetMouseFocus() == WorldFrame then
            return self:Hide()
        end
    end

    local color
    local name, unit = self:GetUnit()
    if (not name) and (not unit) then
        local _, link = self:GetItem()
        local quality = link and select(3, GetItemInfo(link)) or nil
        if (quality) then
            local r, g, b = GetItemQualityColor(quality)
            color = { r = r, g = g, b = b}
		else
			color = CreateColor(1, 1, 1)
        end
    else
        if UnitIsPlayer(unit) then -- or UnitPlayerControlled(unit)) then
            color = TTip:GetClassColor(unit)
		else
		    color = CreateColor(1, 1, 1)
        end
    end
	TTip:ColorTooltip(self, color)
end

function ShowCompareItem(self)
    if self and self.shoppingTooltips then
        for _, tooltip in pairs(self.shoppingTooltips) do
            local name, item = tooltip:GetItem()
            if (item) then
                local quality = select(3, GetItemInfo(item))
                local color
                if (quality) then
                    local r, g, b = GetItemQualityColor(quality)
                    color = { r = r, g = g, b = b}
                    TTip:ColorTooltip(tooltip, color)
                end
            end
        end
    end
end

function TTip:ColorTooltip(tooltip, color)
    if WUI.db.profile.enableClassColor then
		if not tooltip.SetBackdrop then
			Mixin(tooltip, BackdropTemplateMixin)
		end
		backdrop = {
			bgFile = "Interface\\TutorialFrame\\TutorialFrameBackground",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			--tile = true,
			--tileEdge = true,
			tileSize = 16,
			edgeSize = 16,
			insets = { left = 4, right = 4, top = 4, bottom = 4 }
			--insets = { left = 3, right = 5, top = 3, bottom = 5 }
		}
		tooltip:SetBackdrop(backdrop)
		tooltip:SetBackdropBorderColor(color.r, color.g, color.b)
    end
end

function TTip:GetClassColor(unit)
    --local color
    local unitType = unit and UnitGUID(unit):match('^(.-)%-'):lower()
    local unitIsPlayer = unitType == 'player'
    local unitClassColor = unitIsPlayer and RAID_CLASS_COLORS[ select(2, UnitClass(unit)) ]
    --[[
    if UnitIsPlayer(unit) then
        color = unitClassColor --RAID_CLASS_COLORS[str]
    else
        color = CreateColor(0, 1, 0) -- if not a player or nil
    end
    if unit == nil then
        color = CreateColor(0, 1, 0) -- if not a player or nil
    end]]--
    return unitClassColor --color
end

function TTip:GetUnitReactionIndex(unit)
	if (UnitIsDead(unit)) then
		return 7;
	elseif (UnitIsPlayer(unit) or UnitPlayerControlled(unit)) then
		if (UnitCanAttack(unit,"player")) then
			return (UnitCanAttack("player",unit) and 2 or 3);
		elseif (UnitCanAttack("player",unit)) then
			return 4;
		elseif (UnitIsPVP(unit) and not UnitIsPVPSanctuary(unit) and not UnitIsPVPSanctuary("player")) then
			return 5;
		else
			return 6;
		end
	elseif (UnitIsTapDenied(unit)) and not (UnitPlayerControlled(unit)) then
		return 1;
	else
		local reaction = (UnitReaction(unit,"player") or 3);
		return (reaction > 5 and 5) or (reaction < 2 and 2) or (reaction);
	end
end

function TTip:TargetOfTarget(unit)
    local targetUnit = unit .. 'target'
    local targetName, targetColor
    if UnitIsUnit(targetUnit, 'player') then
        if UnitCanAttack(unit, 'player') then
            targetColor = '|cffcc4c38'
        else
            targetColor = '|cff009919'
        end
        targetName = '<<' .. string.upper(YOU) .. '>>'
    else
        if UnitIsPlayer(targetUnit) then
            targetColor = TTip:GetClassColor(targetUnit)
            targetColor = string.format('|cff%.2x%.2x%.2x', targetColor.r * 255, targetColor.g * 255, targetColor.b * 255)
        else
            local r, g, b = GameTooltip_UnitColor(targetUnit)
            targetColor = string.format('|cff%.2x%.2x%.2x', r * 255, g * 255, b * 255)
        end
        targetName = UnitName(targetUnit)
    end
    return WUI.db.profile.enableClassColor and (targetColor .. targetName) or (whiteColor .. targetName)
end

function TTip:GetSpec()
    local talentsGUID
	if CanInspect("mouseover") and WUI.db.profile.enableSpecText then
        local level = UnitLevel(UnitGUID("mouseover"))
		if UnitLevel("mouseover") >= 10 then
            if InspectFrame and InspectFrame:IsShown() then
                GameTooltip:AddLine(TALENTS_PREFIX .. '|cffff0000' .. "Inspect Frame is open")
            elseif Examiner and Examiner:IsShown() then
                GameTooltip:AddLine(TALENTS_PREFIX .. '|cffff0000' .. "Inspect Frame is open")
            else
                talentsGUID = UnitGUID("mouseover")
                NotifyInspect("mouseover")
                GameTooltip:AddLine(TALENTS_PREFIX .. TALENTS_LOADING)
            end
		end
	end
    if WUI.db.profile.insideBar then --and WUI.db.profile.TargetOfTarget or WUI.db.profile.enableSpecText then
        GameTooltip:AddLine(" ")
    end
    GameTooltip:Show()
end

function TTip:SpecText()
	local specName, specNumber, left, leftText
	if UnitExists("mouseover") then
		specNumber = GetInspectSpecialization("mouseover")
        for i=1, GameTooltip:NumLines() do
            if _G[GameTooltip:GetName().."TextLeft"..i]:GetText() == TALENTS_PREFIX .. TALENTS_LOADING then
                if not specNumber or specNumber == 0 or specNumber >= 1440 then
                    specName = TALENTS_NONE
                else
                    specName = select(2, GetSpecializationInfoByID(specNumber))
                end
                _G[GameTooltip:GetName().."TextLeft"..i]:SetText(TALENTS_PREFIX .. specName)
            end
        end
	end
end

function TTip:fixGetUnit(tooltip)
    local unit = select(2, tooltip:GetUnit())

    -- When the mouse is over a UnitFrame
    if not unit then
        local frame = GetMouseFocus()
        unit = frame and frame.GetAttribute and frame:GetAttribute('unit') -- fix the issue
    end

    -- When the mouse is over a WorldFrame and nameplates are not displayed
    if not unit and UnitExists('mouseover') then
        unit = 'mouseover' -- fix the issue
    end
    return unit
end