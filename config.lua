local isWoWCata, isWoWRetail = false, false;

if (_G["WOW_PROJECT_ID"] == _G["WOW_PROJECT_CATACLYSM_CLASSIC"]) then
	isWoWCata = true;
elseif (_G["WOW_PROJECT_ID"] == _G["WOW_PROJECT_MAINLINE"]) then
	isWoWRetail = true;
end

if isWoWCata then
	
	config = {}
	config.defaults = {
		profile = {
			--Buffs
			buffsL1			= "TOPRIGHT",
			buffsL2			= "Minimap",
			buffsL3	        = "TOPLEFT",
			buffsL4			= -40,
			buffsL5			= 10,
			buffsScale      = 1,
			buffsPadding    = 5,
			buffsWidth		= 40,
			buffsHeight		= 40,
			buffsMargin		= 5,
			buffsNumCols	= 10,
			buffsStartPoint = "TOPRIGHT",
			buffsRowMargin	= 20,
			--Debuffs
			deBuffsLocation     = { "TOPRIGHT", "WUIBuffFrame", "BOTTOMRIGHT", 0, -10 },
			deBuffsScale		= 1,
			deBuffsPadding	    = 5,
			deBuffsWidth		= 48,
			deBuffsHeight		= 48,
			deBuffsMargin		= 5,
			deBuffsNumCols	    = 8,
			deBuffsStartPoint   = "TOPRIGHT",
			deBuffsRowMargin    = 20,

			--Casting Bar
			castingbaricon          = true,
			castingbariconposition  = 1,
			castingbarpoint         = select(1,CastingBarFrame:GetPoint()),
			castingbarrelativeTo    = select(2,CastingBarFrame:GetPoint()),
			castingbarrelativePoint = select(3,CastingBarFrame:GetPoint()),
			castingbarx             = 0,
			castingbary             = 225,
			castingbarscale         = 1.2,

			--Minimap
			hidemapicon     = true,
			hidenorth       = true,
			hidezoomicons   = true,
			scrollzoom      = true,
			minimapscale    = 1,

			--Misc
			autoscreenshot  = true,
			chat            = true,
			easydelete      = true,
			stats           = true,
			talkinghead     = true,

			--Unitframes
			playerframeclasscolor   = true,
			targetframeclasscolor   = true,
			focusframeclasscolor	= true,
			playerportrait          = true,
			targetportrait          = true,
			focusportrait          	= true,
		
			playerframepoint            = select(1,PlayerFrame:GetPoint()),
			playerframerelativeTo       = select(2,PlayerFrame:GetPoint()),
			playerframerelativePoint    = select(3,PlayerFrame:GetPoint()),
			playerframex                = 435, --select(4,PlayerFrame:GetPoint()),
			playerframey                = -570, --select(5,PlayerFrame:GetPoint()),
			playerframescale            = 1, --PlayerFrame:GetScale(),
			targetframepoint            = select(1,TargetFrame:GetPoint()),
			targetframerelativeTo       = select(2,TargetFrame:GetPoint()),
			targetframerelativePoint    = select(3,TargetFrame:GetPoint()),
			targetframex                = 850, --select(4,TargetFrame:GetPoint()),
			targetframey                = -570, --select(5,TargetFrame:GetPoint()),
			targetframescale            = 1, --TargetFrame:GetScale(),
			focusframepoint            = select(1,FocusFrame:GetPoint()),
			focusframerelativeTo       = select(2,FocusFrame:GetPoint()),
			focusframerelativePoint    = select(3,FocusFrame:GetPoint()),
			focusframex                = 260, --select(4,TargetFrame:GetPoint()),
			focusframey                = -340, --select(5,TargetFrame:GetPoint()),
			focusframescale            = 1, --TargetFrame:GetScale(),
			
			raidframescale = 1,

		},
	}

	options = {
		type = "group",
		name = format("WUI - v%.2f", GetAddOnMetadata("WUI", "Version")),
		handler = WUI,
		args = {

			align = {
				name = "Align",
				desc = "Turn on/off a grid pattern in the UI",
				type = 'group',
				order = 1,
				args = {
					aligntext = {
						order = 1, type = "description",
						name = "You also can type /align to turn on/off the grid",
					},
					aligngrid = {
						order = 2, type = "group", inline = true,
						name = "",
						args = {
							bind = {
								order = 1, type = "execute", func = function() SlashCmdList["EA"]("align"); InterfaceOptionsFrame_Show(false) end,
								name = "Align...", desc = format("%s", "\nTurn on/off the grid"),
							},
						},
					},
				},
			},

			buffsframe = {
				name = "Buffs",
				desc = "Some changes to the BuffFrame",
				type = 'group',
				order = 1.1,
				args = {
					buffs = {
						order = 1, type = "group", inline = true,
						name = "Buffs settings",
						args = {
							buffsWidth = {
								order = 1, type = "range", min = 10, max = 80,
								name = "Buffs Width", desc = "Size of buffs icons width",
								get = function(info) return WUI.db.profile.buffsWidth end,
								set = function(info,val) WUI.db.profile.buffsWidth = val end,
							},
							buffsHeight = {
								order = 2, type = "range", min = 10, max = 80,
								name = "Buffs Height", desc = "Size of buffs icons height",
								get = function(info) return WUI.db.profile.buffsHeight end,
								set = function(info,val) WUI.db.profile.buffsHeight = val end,
							},
							buffsNumCols = {
								order = 3, type = "range", min = 1, max = 10, step = 1,
								name = "Buffs Num Columns", desc = "Number of columns of the BuffFrame",
								get = function(info) return WUI.db.profile.buffsNumCols end,
								set = function(info,val) WUI.db.profile.buffsNumCols = val end,
							},
						},
					},
					debuffs = {
						order = 2, type = "group", inline = true,
						name = "DeBuffs settings",
						args = {
							deBuffsWidth = {
								order = 1, type = "range", min = 10, max = 80,
								name = "DeBuffs Width", desc = "Size of debuffs icons width",
								get = function(info) return WUI.db.profile.deBuffsWidth end,
								set = function(info,val) WUI.db.profile.deBuffsWidth = val end,
							},
							deBuffsHeight = {
								order = 2, type = "range", min = 10, max = 80,
								name = "DeBuffs Height", desc = "Size of debuffs icons height",
								get = function(info) return WUI.db.profile.deBuffsHeight end,
								set = function(info,val) WUI.db.profile.deBuffsHeight = val end,
							},
							deBuffsNumCols = {
								order = 3, type = "range", min = 1, max = 10, step = 1,
								name = "DeBuffs Num Columns", desc = "Number of columns of the deBuffFrame",
								get = function(info) return WUI.db.profile.deBuffsNumCols end,
								set = function(info,val) WUI.db.profile.deBuffsNumCols = val end,
							},
						},
					},
					reloadbuffs = {
						order = 6, type = "group", inline = true,
						name = "",
						args = {
							reload = {
								order = 1, type = "execute", func = function() ReloadUI() end, confirm = true,
								name = "Reload UI", desc = format("%s", "\nTo these settings take effect, you need to reload user interface"),
							},
						},
					},
				},
			},
			
			castingbar = {
				name = "Casting Bar",
				desc = "Changes to the casting bar",
				type = 'group',
				order = 2,
				args = {
					castingbaricon = {
						order = 1, type = "toggle",
						name = "Casting Bar Icon", desc = "Show the casting bar icon",
						get = function(info) return WUI.db.profile.castingbaricon end,
						set = function(info,val) WUI.db.profile.castingbaricon = val end,
					},
					castingbariconposition = {
						order = 2, type = "select",
						name = "Casting Bar Icon Position",
						desc = "Position of the icon relative to the casting bar",
						get = function ()
							return WUI.db.profile.castingbariconposition
						end,
						set = function (info, newValue)
							WUI.db.profile.castingbariconposition = newValue; 
						end,
						style = "dropdown",
						values = {"Left", "Inside", "Right"},
						disabled = function () 
							return WUI.db.profile.castingbaricon == false;
						end,
					},
					castingbartweaks = {
						order = 3, type = "group", inline = true,
						name = "Casting Bar Tweaks",
						args = {
							castingbarx = {
								order = 1, type = "range", min =  -(floor(tonumber(GetScreenWidth())) / 4) , max = floor(tonumber(GetScreenWidth())) / 4, step = 1, bigStep = 10,
								name = "Casting Bar X", desc = "Casting bar X position",
								get = function(info) return WUI.db.profile.castingbarx end,
								set = function(info,val)
									WUI.db.profile.castingbarx = val
									CastingBar:CastingBarUpdate()
								end,
							},
							castingbary = {
								order = 2, type = "range", min = 0, max = (floor(tonumber(GetScreenHeight())) /2), step = 1, bigStep = 10,
								name = "Casting Bar Y", desc = "Casting bar Y position",
								get = function(info) return WUI.db.profile.castingbary end,
								set = function(info,val)
									WUI.db.profile.castingbary = val
									CastingBar:CastingBarUpdate()
								end,
							},
							castingbarscale = {
								order = 3, type = "range", min = 0.1, max = 2.0,
								name = "Casting Bar Scale", desc = "Casting bar scale",
								get = function(info) return WUI.db.profile.castingbarscale end,
								set = function(info,val)
									WUI.db.profile.castingbarscale = val
									CastingBar:CastingBarUpdate()
								end,
							},
							reloadcastingbar = {
								order = 4, type = "group", inline = true,
								name = "",
								args = {
									reload = {
										order = 1, type = "execute", func = function() ReloadUI() end, confirm = true,
										name = "Reload UI", desc = format("%s", "\nTo these settings take effect, you need to reload user interface"),
									},
								},
							},
						},
					},
				},
			},

			--local LibKeyBound = LibStub('LibKeyBound-1.0')
			--LibKeyBound:Toggle()
			keybind = {
				name = "Keybind",
				desc = "Change Actionbars Keybinds",
				type = 'group',
				order = 3,
				args = {
					bindtext = {
						order = 1, type = "description",
						name = "You also can type /kb to bind keys",
					},
					bindmode = {
						order = 2, type = "group", inline = true,
						name = "",
						args = {
							bind = {
								order = 1, type = "execute", func = function() local LibKeyBound = LibStub('LibKeyBound-1.0'); LibKeyBound:Toggle(); InterfaceOptionsFrame_Show(false) end,
								name = "Bind keys...", desc = format("%s", "\nEnter binding key mode"),
							},
						},
					},
				},
			},

			minimap = {
				name = "Minimap",
				desc = "Some changes to the Minimap",
				type = 'group',
				order = 4,
				args = {
					hidemapicon = {
						order = 1, type = "toggle",
						name = "Hide Map Icon", desc = "Hides the map icon",
						get = function(info) return WUI.db.profile.hidemapicon end,
						set = function(info,val)
							WUI.db.profile.hidemapicon = val
							Mini:HideMapIcon()
						end,
					},
					hidenorth = {
						order = 2, type = "toggle",
						name = "Hide North", desc = "Hides north indicator",
						get = function(info) return WUI.db.profile.hidenorth end,
						set = function(info,val)
							WUI.db.profile.hidenorth = val
							Mini:HideNorth()
						end,
					},
					hidezoomicons = {
						order = 3, type = "toggle",
						name = "Hide Zoom Icons", desc = "Hides the zoom + - icons",
						get = function(info) return WUI.db.profile.hidezoomicons end,
						set = function(info,val)
							WUI.db.profile.hidezoomicons = val
							Mini:HideZoomIcons()
						end,
					},
					scrollzoom = {
						order = 4, type = "toggle",
						name = "Enable Scrool Zoom", desc = "Enables scroll zoom in minimap",
						get = function(info) return WUI.db.profile.scrollzoom end,
						set = function(info,val)
							WUI.db.profile.scrollzoom = val
							Mini:ScrollZoom()
						end,
					},
					spacer = {
					order = 4.5, type = "description",
					name = "",
					},
					minimapscale = {
						order = 5, type = "range", min = 0.1, max = 2,
						name = "Minimap Scale", desc = "Change minimap scale",
						get = function(info) return WUI.db.profile.minimapscale end,
						set = function(info,val)
							WUI.db.profile.minimapscale = val
							Mini:MinimapScale()
						end,
					},
				},
			},

			misc = {
				name = "Miscellaneous",
				desc = "Some quality of life options",
				type = 'group',
				order = 5,
				args = {
					autoscreenshot = {
						order = 1, type = "toggle",
						name = "Auto Screenshot", desc = "Automatically triggers screenshot when receiving achievements",
						get = function(info) return WUI.db.profile.autoscreenshot end,
						set = function(info,val) WUI.db.profile.autoscreenshot = val end,
					},
					easydelete = {
						order = 3, type = "toggle",
						name = "Easy Delete", desc = "Supress [Type DELETE into the field to confirm] on deleting itens (disable will reload ui)",
						get = function(info) return WUI.db.profile.easydelete end,
						set = function(info,val) WUI.db.profile.easydelete = val end,
					},
					stats = {
						order = 4, type = "toggle",
						name = "Stats", desc = "Show a bar with fps/ms statistics",
						get = function(info) return WUI.db.profile.stats end,
						set = function(info,val)
							WUI.db.profile.stats = val
							Stats:UpdateStats()
						end,
					},
					reloadmisc = {
						order = 6, type = "group", inline = true,
						name = "",
						args = {
							reload = {
								order = 1, type = "execute", func = function() ReloadUI() end, confirm = true,
								name = "Reload UI", desc = format("%s", "\nTo some settings take effect, you need to reload user interface"),
							},
						},
					},
				},
			},

			unitframes = {
				name = "UnitFrames",
				desc = "Some changes to the UnitFrames",
				type = 'group',
				order = 7,
				args = {    
					playerframeclasscolor = {
						order = 1, type = "toggle",
						name = "Player Class Color", desc = "Change health bar color of player frame to class color",
						get = function(info) return WUI.db.profile.playerframeclasscolor end,
						set = function(info,val)
							WUI.db.profile.playerframeclasscolor = val
							UnitFrames:PlayerFrameClassColor()
						end,
					},
					playerportrait = {
						order = 2, type = "toggle",
						name = "Player Class Icon Portrait", desc = "Change the player frame portrait to class icon",
						get = function(info) return WUI.db.profile.playerportrait end,
						set = function(info,val)
							WUI.db.profile.playerportrait = val
							UnitFrames:PlayerPortrait()
						end,
					},
					unitframesHeader1 = {
						order = 3, type = "header",
						name = "", desc = "",
					},
					targetframeclasscolor = {
						order = 4, type = "toggle",
						name = "Target Class Color", desc = "Change health bar color of target frame to class color",
						get = function(info) return WUI.db.profile.targetframeclasscolor end,
						set = function(info,val)
							WUI.db.profile.targetframeclasscolor = val
							UnitFrames:TargetFrameClassColor()
						end,
					},
					targetportrait = {
						order = 5, type = "toggle",
						name = "Target Class Icon Portrait", desc = "Change the target frame portrait to class icon",
						get = function(info) return WUI.db.profile.targetportrait end,
						set = function(info,val)
							WUI.db.profile.targetportrait = val
							UnitFrames:TargetPortrait()
						end,
					},
					unitframesHeader2 = {
						order = 6, type = "header",
						name = "", desc = "",
					},
					focusframeclasscolor = {
						order = 7, type = "toggle",
						name = "Focus Class Color", desc = "Change health bar color of focus frame to class color",
						get = function(info) return WUI.db.profile.focusframeclasscolor end,
						set = function(info,val)
							WUI.db.profile.focusframeclasscolor = val
							UnitFrames:FocusFrameClassColor()
						end,
					},
					focusportrait = {
						order = 8, type = "toggle",
						name = "Focus Class Icon Portrait", desc = "Change the target frame portrait to class icon",
						get = function(info) return WUI.db.profile.focusportrait end,
						set = function(info,val)
							WUI.db.profile.focusportrait = val
							UnitFrames:FocusPortrait()
						end,
					},
					playerframestweaks = {
						order = 9, type = "group", inline = true,
						name = "Player Frames Tweaks",
						args = {
							playerframex = {
								order = 1, type = "range", min = 0, max = floor(tonumber(GetScreenWidth())), step = 1, bigStep = 10,
								name = "Player Frame X", desc = "Change player frame X position",
								get = function(info) return WUI.db.profile.playerframex end,
								set = function(info,val)
									WUI.db.profile.playerframex = val
									UnitFrames:PlayerFrame()
								end,
							},
							playerframey = {
								order = 2, type = "range", min = -(floor(tonumber(GetScreenHeight()))), max = 0, step = 1, bigStep = 10,
								name = "Player Frame Y", desc = "Change player frame Y position",
								get = function(info) return WUI.db.profile.playerframey end,
								set = function(info,val)
									WUI.db.profile.playerframey = val
									UnitFrames:PlayerFrame()
								end,
							},
							playerframescale = {
								order = 3, type = "range", min = 0.1, max = 2.0,
								name = "Player Frame Scale", desc = "Change player frame scale",
								get = function(info) return WUI.db.profile.playerframescale end,
								set = function(info,val)
									WUI.db.profile.playerframescale = val
									UnitFrames:PlayerFrame()
								end,
							},
						},
					},
					targetframestweaks = {
						order = 10, type = "group", inline = true,
						name = "Target Frames Tweaks",
						args = {
							targetframex = {
								order = 1, type = "range", min = 0, max = floor(tonumber(GetScreenWidth())), step = 1, bigStep = 10,
								name = "Target Frame X", desc = "Change target frame X position",
								get = function(info) return WUI.db.profile.targetframex end,
								set = function(info,val)
									WUI.db.profile.targetframex = val
									UnitFrames:TargetFrame()
								end,
							},
							targetframey = {
								order = 2, type = "range", min = -(floor(tonumber(GetScreenHeight()))), max = 500, step = 1, bigStep = 10,
								name = "Target Frame Y", desc = "Change target frame Y position",
								get = function(info) return WUI.db.profile.targetframey end,
								set = function(info,val)
									WUI.db.profile.targetframey = val
									UnitFrames:TargetFrame()
								end,
							},
							targetframescale = {
								order = 3, type = "range", min = 0.1, max = 2.0,
								name = "Target Frame Scale", desc = "Change target frame scale",
								get = function(info) return WUI.db.profile.targetframescale end,
								set = function(info,val)
									WUI.db.profile.targetframescale = val
									UnitFrames:TargetFrame()
								end,
							},
						},
					},
					focusframestweaks = {
						order = 11, type = "group", inline = true,
						name = "Focus Frames Tweaks",
						args = {
							focusframex = {
								order = 1, type = "range", min = 0, max = floor(tonumber(GetScreenWidth())), step = 1, bigStep = 10,
								name = "Focus Frame X", desc = "Change focus frame X position",
								get = function(info) return WUI.db.profile.focusframex end,
								set = function(info,val)
									WUI.db.profile.focusframex = val
									UnitFrames:FocusFrame()
								end,
							},
							focusframey = {
								order = 2, type = "range", min = -(floor(tonumber(GetScreenHeight()))), max = 500, step = 1, bigStep = 10,
								name = "Focus Frame Y", desc = "Change focus frame Y position",
								get = function(info) return WUI.db.profile.focusframey end,
								set = function(info,val)
									WUI.db.profile.focusframey = val
									UnitFrames:FocusFrame()
								end,
							},
							focusframescale = {
								order = 3, type = "range", min = 0.1, max = 2.0,
								name = "Focus Frame Scale", desc = "Change focus frame scale",
								get = function(info) return WUI.db.profile.focusframescale end,
								set = function(info,val)
									WUI.db.profile.focusframescale = val
									UnitFrames:FocusFrame()
								end,
							},
						},
					},
					raidframescale = {
						order = 12, type = "range", min = 0.1, max = 2,
						name = "Raid Frame Scale", desc = "Change raid frame scale",
						get = function(info) return WUI.db.profile.raidframescale end,
						set = function(info,val)
							WUI.db.profile.raidframescale = val
							UnitFrames:RaidFrameScale()
						end,
					},
				},
			},
		},
	}
	
elseif isWoWRetail then

	config = {}
	config.defaults = {
		profile = {
			
			--Casting Bar
			castingbaricon          = true,
			castingbariconposition  = 1,
			castingbarpoint         = select(1,PlayerCastingBarFrame:GetPoint()),
			castingbarrelativeTo    = select(2,PlayerCastingBarFrame:GetPoint()),
			castingbarrelativePoint = select(3,PlayerCastingBarFrame:GetPoint()),
			castingbarx             = 0,
			castingbary             = 210,
			castingbarscale         = 1.3,

			--Minimap
			hidemapicon     = true,
			hidenorth       = true,
			hidezoomicons   = true,
			scrollzoom      = true,
			minimapscale    = 1,

			--Misc
			autoscreenshot  = true,
			chat            = true,
			cinematic		= false,
			easydelete      = true,
			stats           = true,
			talkinghead     = true,

			--Unitframes
			playerframeclasscolor   = true,
			targetframeclasscolor   = true,
			focusframeclasscolor	= true,
			playerportrait          = true,
			targetportrait          = true,
			focusportrait          	= true,

			raidframescale = 1,

		},
	}

	options = {
		type = "group",
		name = format("WUI - v%.2f", GetAddOnMetadata("WUI", "Version")),
		handler = WUI,
		args = {

			align = {
				name = "Align",
				desc = "Turn on/off a grid pattern in the UI",
				type = 'group',
				order = 1,
				args = {
					aligntext = {
						order = 1, type = "description",
						name = "You also can type /align to turn on/off the grid",
					},
					aligngrid = {
						order = 2, type = "group", inline = true,
						name = "",
						args = {
							bind = {
								order = 1, type = "execute", func = function() SlashCmdList["EA"]("align"); CloseWindows() end,
								name = "Align...", desc = format("%s", "\nTurn on/off the grid"),
							},
						},
					},
				},
			},
			
			castingbar = {
				name = "Casting Bar",
				desc = "Changes to the casting bar",
				type = 'group',
				order = 2,
				args = {
					castingbaricon = {
						order = 1, type = "toggle",
						name = "Casting Bar Icon", desc = "Show the casting bar icon",
						get = function(info) return WUI.db.profile.castingbaricon end,
						set = function(info,val) WUI.db.profile.castingbaricon = val end,
					},
					castingbariconposition = {
						order = 2, type = "select",
						name = "Casting Bar Icon Position",
						desc = "Position of the icon relative to the casting bar",
						get = function ()
							return WUI.db.profile.castingbariconposition
						end,
						set = function (info, newValue)
							WUI.db.profile.castingbariconposition = newValue; 
						end,
						style = "dropdown",
						values = {"Left", "Inside", "Right"},
						disabled = function () 
							return WUI.db.profile.castingbaricon == false;
						end,
					},
				},
			},

			--local LibKeyBound = LibStub('LibKeyBound-1.0')
			--LibKeyBound:Toggle()
			keybind = {
				name = "Keybind",
				desc = "Change Actionbars Keybinds",
				type = 'group',
				order = 3,
				args = {
					bindtext = {
						order = 1, type = "description",
						name = "You also can type /kb to bind keys",
					},
					bindmode = {
						order = 2, type = "group", inline = true,
						name = "",
						args = {
							bind = {
								order = 1, type = "execute", func = function() local LibKeyBound = LibStub('LibKeyBound-1.0'); LibKeyBound:Toggle(); CloseWindows() end,
								name = "Bind keys...", desc = format("%s", "\nEnter binding key mode"),
							},
						},
					},
				},
			},

			minimap = {
				name = "Minimap",
				desc = "Some changes to the Minimap",
				type = 'group',
				order = 4,
				args = {
					scrollzoom = {
						order = 4, type = "toggle",
						name = "Enable Scrool Zoom", desc = "Enables scroll zoom in minimap",
						get = function(info) return WUI.db.profile.scrollzoom end,
						set = function(info,val)
							WUI.db.profile.scrollzoom = val
							Mini:ScrollZoom()
						end,
					},
					spacer = {
					order = 4.5, type = "description",
					name = "",
					},
					minimapscale = {
						order = 5, type = "range", min = 0.1, max = 2,
						name = "Minimap Scale", desc = "Change minimap scale",
						get = function(info) return WUI.db.profile.minimapscale end,
						set = function(info,val)
							WUI.db.profile.minimapscale = val
							Mini:MinimapScale()
						end,
					},
				},
			},

			misc = {
				name = "Miscellaneous",
				desc = "Some quality of life options",
				type = 'group',
				order = 5,
				args = {
					autoscreenshot = {
						order = 1, type = "toggle",
						name = "Auto Screenshot", desc = "Automatically triggers screenshot when receiving achievements",
						get = function(info) return WUI.db.profile.autoscreenshot end,
						set = function(info,val) WUI.db.profile.autoscreenshot = val end,
					},
					cinematic = {
						order = 2, type = "toggle",
						name = "Cinematic Skip", desc = "Auto skip Cinematics and Movie Trailers (Hold any of the modifier keys <alt> <ctrl> <shift> to watch the cinematics)",
						get = function(info) return WUI.db.profile.cinematic end,
						set = function(info,val) WUI.db.profile.cinematic = val end,
					},
					easydelete = {
						order = 3, type = "toggle",
						name = "Easy Delete", desc = "Supress [Type DELETE into the field to confirm] on deleting itens (disable will reload ui)",
						get = function(info) return WUI.db.profile.easydelete end,
						set = function(info,val) WUI.db.profile.easydelete = val end,
					},
					stats = {
						order = 4, type = "toggle",
						name = "Stats", desc = "Show a bar with fps/ms statistics",
						get = function(info) return WUI.db.profile.stats end,
						set = function(info,val)
							WUI.db.profile.stats = val
							Stats:UpdateStats()
						end,
					},
					talkinghead = {
						order = 5, type = "toggle",
						name = "Talking Head", desc = "Hides the talking head frame",
						get = function(info) return WUI.db.profile.talkinghead end,
						set = function(info,val) WUI.db.profile.talkinghead = val end,
					},
					reloadmisc = {
						order = 6, type = "group", inline = true,
						name = "",
						args = {
							reload = {
								order = 1, type = "execute", func = function() ReloadUI() end, confirm = true,
								name = "Reload UI", desc = format("%s", "\nTo some settings take effect, you need to reload user interface"),
							},
						},
					},
				},
			},
			
			unitframes = {
				name = "UnitFrames",
				desc = "Some changes to the UnitFrames",
				type = 'group',
				order = 7,
				args = {    
					playerframeclasscolor = {
						order = 1, type = "toggle",
						name = "Player Class Color", desc = "Change health bar color of player frame to class color",
						get = function(info) return WUI.db.profile.playerframeclasscolor end,
						set = function(info,val)
							WUI.db.profile.playerframeclasscolor = val
							UnitFrames:PlayerFrameClassColor()
						end,
					},
					playerportrait = {
						order = 2, type = "toggle",
						name = "Player Class Icon Portrait", desc = "Change the player frame portrait to class icon",
						get = function(info) return WUI.db.profile.playerportrait end,
						set = function(info,val)
							WUI.db.profile.playerportrait = val
							UnitFrames:PlayerPortrait()
						end,
					},
					unitframesHeader1 = {
						order = 3, type = "header",
						name = "", desc = "",
					},
					targetframeclasscolor = {
						order = 4, type = "toggle",
						name = "Target Class Color", desc = "Change health bar color of target frame to class color",
						get = function(info) return WUI.db.profile.targetframeclasscolor end,
						set = function(info,val)
							WUI.db.profile.targetframeclasscolor = val
							UnitFrames:TargetFrameClassColor()
						end,
					},
					targetportrait = {
						order = 5, type = "toggle",
						name = "Target Class Icon Portrait", desc = "Change the target frame portrait to class icon",
						get = function(info) return WUI.db.profile.targetportrait end,
						set = function(info,val)
							WUI.db.profile.targetportrait = val
							UnitFrames:TargetPortrait()
						end,
					},
					unitframesHeader2 = {
						order = 6, type = "header",
						name = "", desc = "",
					},
					focusframeclasscolor = {
						order = 7, type = "toggle",
						name = "Focus Class Color", desc = "Change health bar color of focus frame to class color",
						get = function(info) return WUI.db.profile.focusframeclasscolor end,
						set = function(info,val)
							WUI.db.profile.focusframeclasscolor = val
							UnitFrames:FocusFrameClassColor()
						end,
					},
					focusportrait = {
						order = 8, type = "toggle",
						name = "Focus Class Icon Portrait", desc = "Change the target frame portrait to class icon",
						get = function(info) return WUI.db.profile.focusportrait end,
						set = function(info,val)
							WUI.db.profile.focusportrait = val
							UnitFrames:FocusPortrait()
						end,
					},
					raidframescale = {
						order = 12, type = "range", min = 0.1, max = 2,
						name = "Raid Frame Scale", desc = "Change raid frame scale",
						get = function(info) return WUI.db.profile.raidframescale end,
						set = function(info,val)
							WUI.db.profile.raidframescale = val
							UnitFrames:RaidFrameScale()
						end,
					},
				},
			},
		},
	}
end