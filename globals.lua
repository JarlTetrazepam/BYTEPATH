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

skillPoints = 0
function changeSp(amount)
    skillPoints = math.max(skillPoints - amount, 0)
end