Area = Object:extend()

function Area:new(room)
    self.room = room
    self.gameObjects = {}
end

function Area:update(dt)
    for i = #self.gameObjects, 1, -1 do
        local gameObject = self.gameObjects[i]
        gameObject:update(dt)
        if gameObject.dead then
            table.remove(self.gameObjects, i)
        end
    end
end

function Area:draw()
    for _, gameObject in ipairs(self.gameObjects) do
        gameObject:draw()
    end
end

function Area:addGameObject(objectType, x, y, options)
    local options = options or {}
    local gameObject = _G[objectType](self, x or 0, y or 0, options)
    gameObject.class = objectType
    table.insert(self.gameObjects, gameObject)
    return gameObject
end

function Area:queryCircleArea(x, y, r, classes)
    local queried = {}
    for _, gameObject in ipairs(self.gameObjects) do
        if M.include(classes, gameObject.class) then
            local distance = distance(x, y, gameObject.x, gameObject.y)
            if distance <= r then
                table.insert(queried, gameObject)
            end
        end
    end
    return queried
end

function Area:getClosestGameObject(x, y, classes)
    local closestGameObject = nil
    for _, gameObject in ipairs(self.gameObjects) do
        if M.include(classes, gameObject.class) then
            if distance(x, y, gameObject.x, gameObject.y) < distance(x, y, closestGameObject.x, closestGameObject.y) or not closestGameObject then
                closestGameObject = gameObject
            end
        end
    end
    return closestGameObject
end

function Area:getClosestGameObjectInArea(x, y, r, classes)
    local objectsInArea = self.queryCircleArea(x, y, r, classes)
    table.sort(objectsInArea, function (a, b)
        return distance(x, y, a.x, a.y) < distance(x, y, b.x, b.y)
    end)
    return objectsInArea[1]
end