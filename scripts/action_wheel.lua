local actionWheelScript = {} 


local mainPage = action_wheel:newPage()
action_wheel:setPage(mainPage)

-- Colors for main page
local mainColor = vec(0, 0.4, 0.5)
local mainHover = vec(0.5, 0.9, 1)
local mainOn =  vec(0.4, 0.8, 0.9)



-- Preparing the action for the selector
actionSkin = mainPage:newAction()
    :color(mainColor):hoverColor(mainHover)
    :item("minecraft:player_head")

-- Letting our selector complete the action
skinSelector:completeAction(actionSkin)

return actionWheelScript
