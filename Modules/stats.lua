Stats = WUI:NewModule("Stats", "AceTimer-3.0")

local addons = {}
local maxaddons = 50

function Stats:OnInitialize()
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

function Stats:OnEnable()
	self:UpdateStats()

	for i=1,GetNumAddOns(), 1 do
		local tester = GetAddOnEnableState(nil, i) and IsAddOnLoaded(i)
		if tester then
			local name = select(1, GetAddOnInfo(i))
			table.insert(addons, name)
		end
	end
end

function Stats:OnDisable()
end

function Stats:UpdateStats()
	if WUI.db.profile.stats then
		statsframe:Show()
	else
		statsframe:Hide()
    end
end

function Stats:Timer()
	local fps = GetFramerate()
	local r, g, b = self:ColorGradient(fps/75, 1,0,0, 1,1,0, 0,1,0)
	local _, _, lh, lw = GetNetStats()
	local rl, gl, bl = self:ColorGradient(((lh+lw)/2)/1000, 0,1,0, 1,1,0, 1,0,0)
	statsframe.text:SetText(format("|cff%02x%02x%02x%.0f|r |cffE8D200fps|r |cff%02x%02x%02x%.0f|r |cffE8D200ms|r", r*255, g*255, b*255, fps, rl*255, gl*255, bl*255, lw))
end

function Stats:StatsTooltip(frame)
	GameTooltip:SetOwner(frame, "ANCHOR_BOTTOMLEFT")
	
	local totaladdon = 0

	UpdateAddOnMemoryUsage()
	GameTooltip:AddLine("AddOns")
	GameTooltip:AddLine(" ")

	sort(addons, function(a,b) return GetAddOnMemoryUsage(a) > GetAddOnMemoryUsage(b) end)
	UpdateAddOnMemoryUsage()
	for i, v in ipairs(addons) do
		if i <= maxaddons then
			local name
			local mem = GetAddOnMemoryUsage(v)
			local r, g, b = self:ColorGradient((mem)/1000, 0,1,0, 1,1,0, 1,0,0)
			totaladdon = totaladdon + mem
			GameTooltip:AddDoubleLine(select(2,GetAddOnInfo(v)), self:formatMem(mem), 1, 1, 1, r, g, b)
		end
	end

	local mem = collectgarbage("count")
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine("Total",  self:formatMem(totaladdon), 1, 1, 1, self:ColorGradient(totaladdon , 0,1,0, 1,1,0, 1,0,0))
	GameTooltip:AddDoubleLine("Total + Blizzard", self:formatMem(mem), 1, 1, 1, self:ColorGradient(mem , 0,1,0, 1,1,0, 1,0,0))
	GameTooltip:AddLine(" ")

	local _, _, lh, lw = GetNetStats()
	local rw, gw, bw = self:ColorGradient((lw/1000), 0,1,0, 1,1,0, 1,0,0)
	local rl, gl, bl = self:ColorGradient((lh/1000), 0,1,0, 1,1,0, 1,0,0)
	GameTooltip:AddDoubleLine("Home", format("|cff%02x%02x%02x%.0f|r |cffE8D200ms|r", rl*255, gl*255, bl*255, lh), 1, 1, 1)
	GameTooltip:AddDoubleLine("World", format("|cff%02x%02x%02x%.0f|r |cffE8D200ms|r", rw*255, gw*255, bw*255, lw), 1, 1, 1)
	GameTooltip:Show()
end

function Stats:formatMem(number)
	if number > 1024 then
		return format("%.2f MB", number/1e3)
	else
		return format("%.1f kB", number)
	end
end

function Stats:ColorGradient(perc, ...)
	if perc >= 1 then
		local r, g, b = select(select('#', ...) - 2, ...)
		return r, g, b
	elseif perc <= 0 then
		local r, g, b = ...
		return r, g, b
	end
	
	local num = select('#', ...) / 3

	local segment, relperc = math.modf(perc*(num-1))
	local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

	return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end