
local util_module = {}

function util_module.GetClassName(class_id)
	local class_table = {
		"Scout",
		"Sniper",
		"Soldier",
		"Demoman",
		"Medic",
		"HWGuy",
		"Pyro",
		"Spy",
		"Engineer",
		"Civilian"
	}
	return class_table[class_id]
end

function util_module.NewUlt(name1, desc1, name2, desc2, name3, desc3, name4, desc4)
	local self = {}
	local ult_name = {name1, name2, name3, name4}
	local ult_desc = {desc1, desc2, desc3, desc4}

	function self.GetUltName(int)
		return ult_name[int]
	end

	function self.GetUltDesc(int)
		return ult_desc[int]
	end

	return self
end
return util_module
