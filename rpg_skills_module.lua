local skills_module = {}


function skills_module.Regeneration()


end

function skills_module.Speed()


end

function skills_module.Resistance(player, damageinfo)
    local resistance = player.GetResistLevel()
    if resistance >= 1 then
        damageinfo:ScaleDamage(1 - 0.05 * resistance)
    end
end
return skills_module
