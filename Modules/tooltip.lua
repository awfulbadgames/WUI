--[[

Code from Cloudy Tooltip Mod

https://www.curseforge.com/wow/addons/cloudy-tooltip-mod

]]--

TooltipFR = WUI:NewModule("TooltipFR", "AceHook-3.0")

function TooltipFR:OnInitialize()
end

function TooltipFR:OnEnable()

	-- Tooltip Anchor --
	hooksecurefunc('GameTooltip_SetDefaultAnchor', function(self, parent)
		if WUI.db.profile.HidePVP and UnitAffectingCombat('player') then
			return self:Hide()
		end
	end)

	-- Tooltip Color --
	local function OnTooltipShow(self)
		local color = nil
		local name, unit = self:GetUnit()
		if (not name) and (not unit) then
			if self:GetSpell() then
				color = '|cff71d5ff'
			else
				local _, link = self:GetItem()
				color = link and strmatch(link, '(|c%x+)')
			end
			TooltipFR:ColorTooltip(self, color)
		else
			color = unit and TooltipFR:GetUnitColor(unit)
			if color then
				TooltipFR:ColorTooltip(self, color)
			end
		end
	end
	
	GameTooltip:HookScript('OnShow', OnTooltipShow)
	GameTooltip:HookScript('OnUpdate', OnTooltipShow)

	-- Comparison Tooltip Color --
	hooksecurefunc('GameTooltip_ShowCompareItem', function(self)
		if self and self.shoppingTooltips then
			for _, tooltip in pairs(self.shoppingTooltips) do
				local _, link = tooltip:GetItem()
				local color = link and strmatch(link, '(|c%x+)')
				TooltipFR:ColorTooltip(tooltip, color)
				--tooltip:SetScale(WUI.db.profile.TipScale)
			end
		end
	end)

	-- Modify Item Tooltip --
	local TradeGoods = select(2, GetItemInfoInstant(2589))
	local function OnTooltipSetItem(self)
		if (not WUI.db.profile.TradeGoods) then return end

		local _, link = self:GetItem()
		if (not link) then return end

		local id = strmatch(link, 'item:(%d+)')
		if (not id) then return end

		local itemType, subType = select(2, GetItemInfoInstant(id))
		if (itemType == TradeGoods) then
			self:AddLine(BAG_FILTER_TRADE_GOODS .. ': |cffaaff77' .. (subType or UNKNOWN))
		end
	end
	GameTooltip:HookScript('OnTooltipSetItem', OnTooltipSetItem)
	ItemRefTooltip:HookScript('OnTooltipSetItem', OnTooltipSetItem)

	-- Modify Unit Tooltip --
	local function OnTooltipSetUnit(self)
		local _, unit = self:GetUnit()
		if (not unit) then return end

		-- Analyzing --
		local nameLine, guildLine, detailLine, lootLine

		for i = 1, self:NumLines() do
			local line = _G[self:GetName() .. 'TextLeft' .. i]
			local text = line:GetText()

			if text then
				if (i == 1) then
					nameLine = line
				elseif strfind(text, UNIT_LEVEL_TEMPLATE) or strfind(text, UNIT_LETHAL_LEVEL_TEMPLATE) then
					if (i > 2) then
						guildLine = _G[self:GetName() .. 'TextLeft' .. (i - 1)]
					end
					detailLine = line
				elseif strfind(text, LOOT .. ':') then
					lootLine = line
				elseif strfind(text, TARGET .. ':') then
					line:Hide()
				elseif (text == PVP) then
					line:Hide()
				elseif (text == FACTION_ALLIANCE) or (text == FACTION_HORDE) then
					if WUI.db.profile.FactionIcon then
						line:Hide()
					end
				end
			end
		end

		-- Get Color --
		local defaultColor = '|cffffd100'
		local unitColor = TooltipFR:GetUnitColor(unit)

		-- Name Mod --
		if nameLine then
			local unitName, unitRealmName = UnitName(unit)
			local unitRelation = UnitRealmRelationship(unit)

			if WUI.db.profile.UnitTitle and UnitPVPName(unit) then
				unitName = UnitPVPName(unit)
			end

			if WUI.db.profile.UnitStatus then
				if UnitIsAFK(unit) then
					unitName = '<' .. AFK .. '>' .. unitName
				elseif UnitIsDND(unit) then
					unitName = '<' .. DND .. '>' .. unitName
				end
			end

			if WUI.db.profile.UnitRealm and unitRealmName and (unitRealmName ~= '') then
				if WUI.db.profile.RealmLabel then
					if (unitRelation == LE_REALM_RELATION_VIRTUAL) then
						nameLine:SetText(unitColor .. unitName .. INTERACTIVE_SERVER_LABEL)
					else
						nameLine:SetText(unitColor .. unitName .. FOREIGN_SERVER_LABEL)
					end
				else
					nameLine:SetText(unitColor .. unitName .. ' - ' .. unitRealmName)
				end
			else
				nameLine:SetText(unitColor .. unitName)
			end
		end

		-- Guild Mod --
		if guildLine then
			local guildString
			if UnitIsPlayer(unit) then
				local guildName, guildRank = GetGuildInfo(unit)
				if guildName then
					if WUI.db.profile.GuildRank and guildRank then
						guildString = '<' .. guildName .. '> |cff0080cc' .. guildRank
					else
						guildString = '<' .. guildName .. '>'
					end
				else
					guildString = '<' .. gsub(guildLine:GetText(), '-.+', '') .. '>'
				end
			else
				guildString = '<' .. gsub(guildLine:GetText(), '-.+\'s', '\'s') .. '>'
			end
			--guildLine:SetText(unitColor .. guildString)
			guildLine:SetText(guildString)
		end

		-- Detail Mod --
		if detailLine then
			-- Unit Level --
			local unitLevel, levelColor = UnitLevel(unit), defaultColor

			if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
				unitLevel = UnitBattlePetLevel(unit)
			end
			if (unitLevel == -1) then unitLevel = '??' end
			if UnitCanAttack(unit, 'player') then
				levelColor = TooltipFR:GetLevelColor(unitLevel)
			end

			unitLevel = 'Level ' .. unitLevel

			-- Unit Detail --
			local unitDetail

			if UnitIsPlayer(unit) then
				local unitRace = UnitRace(unit)
				local classColor, className = TooltipFR:GetClassColor(unit)

				if WUI.db.profile.ClassColor then
					className = ''
				end

				if WUI.db.profile.UnitGender then
					local unitGender = {'', MALE, FEMALE}
					unitDetail = unitGender[UnitSex(unit)] .. ' ' .. unitRace .. ' ' .. classColor .. className
				else
					unitDetail = unitRace .. ' ' .. classColor .. className
				end
			else
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
			end

			detailLine:SetText(unitLevel .. ' ' .. unitDetail)
		end

		-- Loot Mod --
		if lootLine then
			local ownerName = strmatch(lootLine:GetText(), '%s([^%-]+)')
			if ownerName and (ownerName ~= '') then
				local ownerColor = '|cffffffff'
				if (UnitName('player') == ownerName) then
					ownerColor = TooltipFR:GetClassColor('player')
				else
					local groupType = 'party'
					if UnitInRaid('player') then
						groupType = 'raid'
					end

					for i = 1, GetNumGroupMembers() - 1 do
						local owner = groupType .. i
						if (UnitName(owner) == ownerName) then
							ownerColor = TooltipFR:GetClassColor(owner)
							break
						end
					end
				end

				lootLine:SetText(defaultColor .. LOOT .. ': ' .. ownerColor .. ownerName)
			end
		end

		-- Target of Target --
		local targetUnit = unit .. 'target'
		if WUI.db.profile.TargetOfTarget and UnitExists(targetUnit) then
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
					targetColor = TooltipFR:GetClassColor(targetUnit)
				else
					local r, g, b = GameTooltip_UnitColor(targetUnit)
					targetColor = string.format('|cff%.2x%.2x%.2x', r * 255, g * 255, b * 255)
				end

				targetName = UnitName(targetUnit)
			end

			self:AddLine(defaultColor .. 'Targenting: ' .. targetColor .. targetName)
		end

		-- Faction Icon --
		local faction = UnitFactionGroup(unit)
		if WUI.db.profile.FactionIcon and faction then
			if not self.icon then
				self.icon = self:CreateTexture(nil, 'ARTWORK')
				self.icon:SetSize(32, 32)
			end
			if (faction == FACTION_ALLIANCE) then
				self.icon:SetTexture('Interface\\Timer\\Alliance-Logo')
			elseif (faction == FACTION_HORDE) then
				self.icon:SetTexture('Interface\\Timer\\Horde-Logo')
			end

			if WUI.db.profile.HideBorder then
				nameLine:SetWidth(nameLine:GetWidth() + 15)
				self.icon:SetPoint('TOPRIGHT', 3, -1)
				self.icon:SetAlpha(0.55)
			else
				nameLine:SetWidth(nameLine:GetWidth() + 7)
				self.icon:SetPoint('TOPRIGHT', 10, 7)
				self.icon:SetAlpha(0.75)
			end
			self.icon:Show()
		end
		
		-- Cleanup Tooltip --
		for i = 1, self:NumLines() do
			local line = _G['GameTooltipTextLeft' .. i]
			local text = _G['GameTooltipTextRight' .. i]
			if line and not line:IsShown() then
				line:SetText(nil)
				text:SetText(nil)
				for j = i + 1, self:NumLines() do
					local nline = _G['GameTooltipTextLeft' .. j]
					local ntext = _G['GameTooltipTextRight' .. j]
					if nline and nline:IsShown() then
						local textL = nline:GetText()
						local textR = ntext:GetText()
						if textL then
							line:SetText(textL)
							line:Show()
							nline:SetText(nil)
							nline:Hide()
							if textR then
								text:SetText(textR)
								text:Show()
								ntext:SetText(nil)
								ntext:Hide()
							end
							break
						end
					end
				end
			end
		end
	end
	GameTooltip:HookScript('OnTooltipSetUnit', OnTooltipSetUnit)

	-- Clear Texture --
	GameTooltip:HookScript('OnTooltipCleared', function(self)
		if self.icon then
			self.icon:SetTexture(nil)
			self.icon:Hide()
		end
	end)

end

function TooltipFR:OnDisable()
end

--- Local Functions ---------------------------------------------------------------------------

-- Get Class Color --
function TooltipFR:GetClassColor(unit)
	local name, str = UnitClass(unit)

	local color = RAID_CLASS_COLORS[str]
	color = string.format('|cff%.2x%.2x%.2x', color.r * 255, color.g * 255, color.b * 255)

	return color, name
end

-- Get Unit Color --
function TooltipFR:GetUnitColor(unit)
	local r, g, b = GameTooltip_UnitColor(unit)
	local color = string.format('|cff%.2x%.2x%.2x', r * 255, g * 255, b * 255)

	if UnitIsDeadOrGhost(unit) or (not UnitIsConnected(unit)) then
		color = '|cff888888'
	elseif UnitIsPlayer(unit) or UnitPlayerControlled(unit) then
		if WUI.db.profile.TipClassColor then
			if UnitIsPlayer(unit) then
				color = TooltipFR:GetClassColor(unit)
			elseif not UnitIsPVP(unit) then
				color = '|cff0099ff'
			end
		elseif (not UnitIsPVP(unit)) or (UnitInParty(unit) and not UnitIsVisible(unit)) then
			color = '|cff0099ff'
		end
	elseif UnitIsTapDenied(unit) then
		color = '|cff77aaaa'
	end

	if C_PetBattles.IsInBattle() then
		if UnitIsBattlePetCompanion(unit) then
			color = '|cff0099ff'
		elseif UnitIsWildBattlePet(unit) then
			color = '|cffe5b200'
		end
	end

	return color
end

-- Get Level Color --
function TooltipFR:GetLevelColor(level)
	local color = '|cffff3333'

	if (level ~= '??') then
		color = GetQuestDifficultyColor(level)
		color = string.format('|cff%.2x%.2x%.2x', color.r * 255, color.g * 255, color.b * 255)
	end

	return color
end

-- Color Tooltip --
function TooltipFR:ColorTooltip(tooltip, color)
	local r, g, b = 0.65, 0.65, 0.65
	if WUI.db.profile.TipColor then
		if color and (strlen(color) == 10) then
			r = tonumber(strsub(color, 5, 6), 16) / 255
			g = tonumber(strsub(color, 7, 8), 16) / 255
			b = tonumber(strsub(color, 9), 16) / 255
		end
	end

--	tooltip:SetBackdrop(CTipBackdrop)
--	tooltip:SetBackdropColor(r * 0.2, g * 0.2, b * 0.2)
	tooltip:SetBackdropBorderColor(r  * 1.2, g * 1.2, b * 1.2)
end