ITEM.base = "base_bags"
ITEM.name = "Clothing Bag"
ITEM.description = "A big suitcase of clothes with pockets."
ITEM.model = Model("models/weapons/w_suitcase_passenger.mdl")
ITEM.bodygroup = 1
ITEM.bodygroupValue = 7
ITEM.width = 2
ITEM.height = 2
ITEM.invWidth = 2
ITEM.invHeight = 2
ITEM.civilProtectionItem = false

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("wearing", false)) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w-28, h-28, 16, 16)
		end
	end
end

ITEM.functions.Wear = {
	OnRun = function(itemTable)
		local client = itemTable.player
		local groups = client:GetCharacter():GetData("groups", {  })
		if(groups[itemTable.bodygroup] != 0 and groups[itemTable.bodygroup] != nil) then client:Notify("You are already wearing something in that slot!") return false end
		groups[itemTable.bodygroup] = itemTable.bodygroupValue
		client:SetBodygroup(itemTable.bodygroup, itemTable.bodygroupValue)
		client:GetCharacter():SetData("groups", groups)
		itemTable:SetData("wearing", true)

		return false
	end,
	OnCanRun = function(itemTable)
		if (!isfunction(itemTable:GetOwner().IsCombine)) then
			-- if the isCombine function does not exist, then bypass check
			CanFactionWear = true
		else
			local CanFactionWear = itemTable:GetOwner():IsCombine() == itemTable.civilProtectionItem
		end

		return !itemTable.entity and !itemTable:GetData("wearing", false) and (CanFactionWear)
	end
}


ITEM.functions.Remove = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetBodygroup(itemTable.bodygroup, 0)
		local groups = client:GetCharacter():GetData("groups", nil)
		groups[itemTable.bodygroup] = 0
		client:GetCharacter():SetData("groups", groups)
		itemTable:SetData("wearing", false)

		return false
	end,
	OnCanRun = function(itemTable)
		return !itemTable.entity and itemTable:GetData("wearing", false)
	end
}


ITEM:Hook("drop", function(itemTable)
	local client = itemTable.player

	client:SetBodygroup(itemTable.bodygroup, 0)
	local groups = client:GetCharacter():GetData("groups", nil)
	groups[itemTable.bodygroup] = 0
	client:GetCharacter():SetData("groups", groups)
	itemTable:SetData("wearing", false)
end)