local EasyDelete = WUI:NewModule("EasyDelete")

function EasyDelete:OnInitialize()
end

function EasyDelete:OnEnable()
    if WUI.db.profile.easydelete then
        StaticPopupDialogs.DELETE_GOOD_ITEM=StaticPopupDialogs.DELETE_ITEM
    end
end

function EasyDelete:OnDisable()
end