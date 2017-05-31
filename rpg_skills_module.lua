local skills_module = {}


function skills_module.Regeneration()


end

function skills_module.Speed()


end

function skills_module.Resistance(player, damageinfo)
    local lvl = player.GetResistLevel()
    if lvl >= 1 then damageinfo:ScaleDamage(1 - 0.05 * lvl) end
end

function skills_module.IncreaseDamage(player, damageinfo)
    local lvl = player.GetDamageLevel()
    if lvl >= 1 then damageinfo:ScaleDamage(0.05 * lvl) end
end

return skills_module
