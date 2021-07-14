defaultColor = {0.87, 0.87, 0.87}
backgroundColor = {0.06, 0.06, 0.06}
skillPointColor = {0,0.8,0}
boostColor = {0.29, 0.76, 0.84}
boostUiSecondaryColor = {0.29, 0.50, 0.60}
hpColor = {0.94, 0.4, 0.27}
hpUiSecondaryColor = {0.7, 0.1, 0.1}
ammoColor = {1, 0.77, 0.36}
ammoUiSecondaryColor = {0.8, 0.55, 0.1}

defaultcolors = {defaultColor, hpColor, ammoColor, boostColor, skillPointColor}
negativeColors = M.map(defaultcolors, function (color)
    return M.map(color, function (value)
        return 1-value
    end)
end)
allColors = M.append(defaultcolors, negativeColors)

skillPoints = 0
function changeSp(amount)
    skillPoints = math.max(skillPoints - amount, 0)
end

attacks = {
    ["Neutral"] = {cooldown = 0.24, ammoCost = 0, abbreviation = "N", color = defaultColor},
    ["Double"] = {cooldown = 0.32, ammoCost = 2, abbreviation = "2", color = ammoColor},
    ["Triple"] = {cooldown = 0.32, ammoCost = 3, abbreviation = "3", color = boostColor},
    ["Rapid"] = {cooldown = 0.12, ammoCost = 1, abbreviation = "R", color = defaultColor},
    ["Spread"] = {cooldown = 0.16, ammoCost = 1, abbreviation = "RS", color = allColors[random(#allColors)]},
    ["Back"] = {cooldown = 0.32, ammoCost = 2, abbreviation = "Ba", color = skillPointColor},
    ["Side"] = {cooldown = 0.32, ammoCost = 3, abbreviation = "Si", color = boostColor}
}