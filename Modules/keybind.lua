--[[

Code in parts or totally from _ForgeUser329408

https://www.curseforge.com/wow/addons/keybound

]]--

local f = CreateFrame("frame")

local LibKeyBound = LibStub:GetLibrary("LibKeyBound-1.0")

f:RegisterEvent("PLAYER_LOGIN")

f:SetScript("OnEvent", function(self, event, ...)
  if self[event] then
    return self[event](self, event, ...)
  end
end)

f.BindMapping = {
  ActionButton1               = "ACTIONBUTTON1",
  ActionButton2               = "ACTIONBUTTON2",
  ActionButton3               = "ACTIONBUTTON3",
  ActionButton4               = "ACTIONBUTTON4",
  ActionButton5               = "ACTIONBUTTON5",
  ActionButton6               = "ACTIONBUTTON6",
  ActionButton7               = "ACTIONBUTTON7",
  ActionButton8               = "ACTIONBUTTON8",
  ActionButton9               = "ACTIONBUTTON9",
  ActionButton10              = "ACTIONBUTTON10",
  ActionButton11              = "ACTIONBUTTON11",
  ActionButton12              = "ACTIONBUTTON12",
  MultiBarBottomLeftButton1   = "MULTIACTIONBAR1BUTTON1",
  MultiBarBottomLeftButton2   = "MULTIACTIONBAR1BUTTON2",
  MultiBarBottomLeftButton3   = "MULTIACTIONBAR1BUTTON3",
  MultiBarBottomLeftButton4   = "MULTIACTIONBAR1BUTTON4",
  MultiBarBottomLeftButton5   = "MULTIACTIONBAR1BUTTON5",
  MultiBarBottomLeftButton6   = "MULTIACTIONBAR1BUTTON6",
  MultiBarBottomLeftButton7   = "MULTIACTIONBAR1BUTTON7",
  MultiBarBottomLeftButton8   = "MULTIACTIONBAR1BUTTON8",
  MultiBarBottomLeftButton9   = "MULTIACTIONBAR1BUTTON9",
  MultiBarBottomLeftButton10  = "MULTIACTIONBAR1BUTTON10",
  MultiBarBottomLeftButton11  = "MULTIACTIONBAR1BUTTON11",
  MultiBarBottomLeftButton12  = "MULTIACTIONBAR1BUTTON12",
  MultiBarBottomRightButton1  = "MULTIACTIONBAR2BUTTON1",
  MultiBarBottomRightButton2  = "MULTIACTIONBAR2BUTTON2",
  MultiBarBottomRightButton3  = "MULTIACTIONBAR2BUTTON3",
  MultiBarBottomRightButton4  = "MULTIACTIONBAR2BUTTON4",
  MultiBarBottomRightButton5  = "MULTIACTIONBAR2BUTTON5",
  MultiBarBottomRightButton6  = "MULTIACTIONBAR2BUTTON6",
  MultiBarBottomRightButton7  = "MULTIACTIONBAR2BUTTON7",
  MultiBarBottomRightButton8  = "MULTIACTIONBAR2BUTTON8",
  MultiBarBottomRightButton9  = "MULTIACTIONBAR2BUTTON9",
  MultiBarBottomRightButton10 = "MULTIACTIONBAR2BUTTON10",
  MultiBarBottomRightButton11 = "MULTIACTIONBAR2BUTTON11",
  MultiBarBottomRightButton12 = "MULTIACTIONBAR2BUTTON12",
  MultiBarLeftButton1         = "MULTIACTIONBAR4BUTTON1",
  MultiBarLeftButton2         = "MULTIACTIONBAR4BUTTON2",
  MultiBarLeftButton3         = "MULTIACTIONBAR4BUTTON3",
  MultiBarLeftButton4         = "MULTIACTIONBAR4BUTTON4",
  MultiBarLeftButton5         = "MULTIACTIONBAR4BUTTON5",
  MultiBarLeftButton6         = "MULTIACTIONBAR4BUTTON6",
  MultiBarLeftButton7         = "MULTIACTIONBAR4BUTTON7",
  MultiBarLeftButton8         = "MULTIACTIONBAR4BUTTON8",
  MultiBarLeftButton9         = "MULTIACTIONBAR4BUTTON9",
  MultiBarLeftButton10        = "MULTIACTIONBAR4BUTTON10",
  MultiBarLeftButton11        = "MULTIACTIONBAR4BUTTON11",
  MultiBarLeftButton12        = "MULTIACTIONBAR4BUTTON12",
  MultiBarRightButton1        = "MULTIACTIONBAR3BUTTON1",
  MultiBarRightButton2        = "MULTIACTIONBAR3BUTTON2",
  MultiBarRightButton3        = "MULTIACTIONBAR3BUTTON3",
  MultiBarRightButton4        = "MULTIACTIONBAR3BUTTON4",
  MultiBarRightButton5        = "MULTIACTIONBAR3BUTTON5",
  MultiBarRightButton6        = "MULTIACTIONBAR3BUTTON6",
  MultiBarRightButton7        = "MULTIACTIONBAR3BUTTON7",
  MultiBarRightButton8        = "MULTIACTIONBAR3BUTTON8",
  MultiBarRightButton9        = "MULTIACTIONBAR3BUTTON9",
  MultiBarRightButton10       = "MULTIACTIONBAR3BUTTON10",
  MultiBarRightButton11       = "MULTIACTIONBAR3BUTTON11",
  MultiBarRightButton12       = "MULTIACTIONBAR3BUTTON12",
}

function f:GetHotkey()
  return LibKeyBound:ToShortKey(GetBindingKey(self:GetBindAction()))
end

function f:GetBindAction()
  return f.BindMapping[self:GetName()]
end

function f:SetKey(key)
  SetBinding(key, f.BindMapping[self:GetName()])
end

function f:GetBindings()
  local keys
  local binding = self:GetBindAction()
  for i = 1, select("#", GetBindingKey(binding)) do
    local hotKey = select(i, GetBindingKey(binding))
    if keys then
      keys = keys .. ", " .. GetBindingText(hotKey, "KEY_")
    else
      keys = GetBindingText(hotKey, "KEY_")
    end
  end
  return keys
end

function f:ClearBindings()
  local binding = self:GetBindAction()
  while GetBindingKey(binding) do
    SetBinding(GetBindingKey(binding), nil)
  end
end

function f:PLAYER_LOGIN()
  for name, _ in pairs(f.BindMapping) do
    local button = getglobal(name)
    if button then
      button:HookScript("OnEnter", function(self)
        LibKeyBound:Set(self)
      end)
      button.GetHotkey = self.GetHotkey
      button.SetKey = self.SetKey
      button.GetBindings = self.GetBindings
      button.GetBindAction = self.GetBindAction
      button.ClearBindings = self.ClearBindings
    end
  end

  --print("Type /kb to activate KeyBound.")
  self:UnregisterEvent("PLAYER_LOGIN")
  self.PLAYER_LOGIN = nil
end
