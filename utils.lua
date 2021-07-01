function UUID()
    local fn = function(x)
        local r = love.math.random(16) - 1
        r = (x == "x") and (r + 1) or (r % 4) + 9
        return ("0123456789abcdef"):sub(r, r)
    end
    return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end

function distance(x1, y1, x2, y2)
    return math.sqrt((x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2))
end

function unitVector(vectorLengthX, vectorLengthY)
    local vectorLength = math.sqrt(vectorLengthX^2 + vectorLengthY^2)
    return {(vectorLengthX / vectorLength), (vectorLengthY / vectorLength)}
end

function random(min, max)
    if max then
        if max < min then
            return love.math.random(max, min)
        end
        return love.math.random(min, max)
    end
    return love.math.random(min)
end