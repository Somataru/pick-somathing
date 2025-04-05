
local Selector = {}
Selector.__index = Selector

Selector.selectors = {}

function Selector.new(title, items, onConfirm, onRemove, displayFunction, currentItem, selectedItem, configName, action)
    local self = {}  -- Create a new table
    setmetatable(self, Selector)  -- Set the metatable explicitly
    table.insert(Selector.selectors, self)
    self.id = #Selector.selectors

    self.title = title
    self.items = items or { }
    self.currentItem = currentItem or 1
    self.selectedItem = self.currentItem
    self.onConfirm = onConfirm
    self.onRemove = onRemove
    self.configName = configName
    self.action = action
    self.displayFunction = displayFunction or function(item, isCurrent, isSelected)
        local prefix = "§7"

        -- We want to override the color...
        if isCurrent then prefix = item.prefix or "§a" end
        if isSelected then prefix = item.selectedPrefix or "§f" end
        -- ... But not override it with a strikethrough
        if item.restricted and not (allowRestricted or self.allowRestricted) then prefix = prefix.."§m§k" end

        local name = item.name
        if isCurrent then name = "§l[" .. name .. "]" end
        if isSelected then name = "> " .. name end

        return prefix .. name
    end

    --[[ items currently have:
    * selectable (boolean)      - Whether it's shown in the selector
    * restricted (boolean)      - If true, a global "allowRestricted" or this
    selector.allowRestricted must be true to allow it, otherwise, will obfuscate it
    * prefix (string)           - Prefix (mostly color) for the name to display
    * selectedPrefix (string)   - Same, but when selected
    * applyFunction (function)  - Function that runs with this outfit is applied
    * removeFunction (function) - Function that runs when this outfit is swppaed out

    ** name (string)            - (Default displayFunction) name to display
    ]]

    return self
end

function Selector:scroll(dir)
    if dir < 0 then dir = -1 else dir = 1 end
    
    local startIndex = self.selectedItem
    repeat
        self.selectedItem = ((self.selectedItem - 1 - dir) % #self.items) + 1
    until self.items[self.selectedItem].selectable or self.selectedItem == startIndex

    if host:isHost() and player:isLoaded() then
        sounds:playSound("minecraft:ui.button.click", player:getPos(), 1.0, 1.0, false)
    end

    if self.action then
        self.action:title(self:getDisplay())
    end
end


-- Item Selection --

function Selector:setItem(index, doForce, makeSelected, doConfirm, doApply, doRemove)
    if makeSelected or makeSelected == nil then
        self.selectedItem = index
    end

    if doConfirm or doConfirm == nil then
        self:confirm(doForce, doApply or doApply == nil, doRemove or doRemove == nil)
    else
        self.currentItem = index
    end
end

function pings.pickSomathingConfirm(selectorIndex, selectedItem, currentItem, doForce, doApply, doRemove)
    local thingSelector = Selector.selectors[selectorIndex]
    thingSelector.selectedItem = selectedItem
    thingSelector.currentItem = currentItem
    thingSelector:confirm(doForce, doApply, doRemove)
end

function Selector:confirm(doForce, doApply, doRemove)
    local item = self.items[self.selectedItem]
    local currentItem = self.items[self.currentItem]
    doRemove = doRemove or doRemove == nil

    if item and (doForce or item.selectable and (not item.restricted or allowRestricted or self.allowRestricted)) then
        if currentItem and currentItem.removeFunction and doRemove then currentItem.removeFunction() end
        if self.onRemove and doRemove then self.onRemove() end

        self.onConfirm(self.selectedItem)
        self.currentItem = self.selectedItem
        if item and item.applyFunction and (doApply or doApply == nil) then item.applyFunction() end

        if host:isHost() and player:isLoaded() then
            sounds:playSound("minecraft:item.armor.equip_leather", player:getPos(), 1.0, 1.0, false)
            if self.configName then config:save(self.configName, self.selectedItem) end
        end

        self:updateTitle()
    else
        if host:isHost() and player:isLoaded() then
            host:setActionbar("§cYou can't equip this !")
            sounds:playSound("minecraft:item.shield.block", player:getPos(), 1.0, 1.0, false)
        end
    end
end

function Selector:getDisplay()
    local output = self.title .. "\n"
    for index, item in ipairs(self.items) do
        if item.selectable then
            local isCurrent = (index == self.currentItem)
            local isSelected = (index == self.selectedItem)
            output = output .. "\n" .. self.displayFunction(item, isCurrent, isSelected)
        end
    end
    return output
end

function Selector:updateTitle()
    if self.action then
        self.action:title(self:getDisplay())
    end
end

-- Action stuff --
function Selector:newAction(page)
    return self:completeAction(page:newAction())
end

function Selector:completeAction(action)
    if action then self.action = action end

    self.action
        :title(self:getDisplay())
        :onScroll(function (dir) self:scroll(dir) end)
        :onLeftClick(function () pings.pickSomathingConfirm(self.id, self.selectedItem, self.currentItem) end)
        :onRightClick(function () self:scroll(-1) end)

    return self.action
end

return Selector
