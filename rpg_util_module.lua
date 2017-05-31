
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

return util_module

