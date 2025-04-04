local actionWheelScript = {} 


local mainPage = action_wheel:newPage()
action_wheel:setPage(mainPage)

-- Colors for main page
local mainColor = vec(0, 0.4, 0.5)
local mainHover = vec(0.5, 0.9, 1)
local mainOn =  vec(0.4, 0.8, 0.9)



-- Preparing the action for the selector
actionSkin = skinSelector:newAction(mainPage)
    :color(mainColor):hoverColor(mainHover)
    :item("minecraft:player_head")


-- Skin restriction
actionRestrictedSlon = mainPage:newAction()
    :color(mainColor):hoverColor(mainHover):toggleColor(mainOn)
    :title("§c§lAllow Restricted Skins§7")
    :item("minecraft:barrier")
    :toggleItem("minecraft:structure_void")
    :setOnToggle(
        function (state)
            skinSelector.allowRestricted = state
            skinSelector:updateTitle()
        end
    )
    :toggled(allowRestricted)

-- Global allow restricted
actionRestricted = mainPage:newAction()
    :color(mainColor):hoverColor(mainHover):toggleColor(mainOn)
    :title("§c§lAllow Restricted All§7")
    :item("minecraft:barrier")
    :toggleItem("minecraft:structure_void")
    :setOnToggle(
        function (state)
            allowRestricted = state
            skinSelector:updateTitle()
        end
    )
    :toggled(allowRestricted)


return actionWheelScript
