local skinScript = {}

-- First, we define the different skins we want to use
skins = {
    -- Full example of a skin
    {
        -- Default properties
        selectable = true,      -- Does this item show up in the selector?
        restricted = false,     -- Can you use this item?
                                -- (if true, allowRestricted needs to be true globally or for this selector)
        prefix = "§4",          -- Prefix to use when this item is active
        selectedPrefix = "§c",  -- Prefix to use when this item is selected
        applyFunction =         -- Function that runs when this outfit specifically is applied
            function ()
                host:setActionbar("DEFAULT SKIN")
            end,
        removeFunction =        -- Function that runs when this outfit specifically is removed
            function ()
                host:setActionbar("DEFAULT SKIN REMOVED")
            end,

        name = "Default",       -- Only a default property with default display function

        -- Custom properties
        texture = "textures.skins.default" -- Only used by our own changeSkin function
    },
    
    -- Shorter version that you'd use 95% of the time
    { selectable = true, name = "Terrible Dev", texture = "textures.skins.terrible_dev" },

    -- Use case: This is a texture you don't want to apply by accident, but need to know it's here. Like, testing a new one !
    { selectable = true, restricted = true, name = "Testing Texture", texture = "textures.skins.testing_texture" },
    
    -- Use case: If something goes catastrophically wrong, you can always fall back to this one to be warned something happened
    { selectable = false, restricted = true, name = "MISSING TEXTURE", texture = "textures.missing" }
}

-- The function that will visually swap the skin around
function pings.changeSkin(skin) changeSkin(skin) end
function changeSkin(skin)
    models.model.root:setPrimaryTexture(
        "Custom",
        textures[ skinSelector.items[skin].texture ] -- Selector.items[index].property
    )
end

-- Finally, we have what's needed to create the selector
skinSelector = selector.new(
    "§bChange Skin",    -- Title of the selector
    skins,              -- The items we defined above
    changeSkin,   -- Function that will be used whenever an item is confirmed
    nil,                -- Function that will be run whenever an item is removed
    nil,                -- Function that will define the displaying of the list
    nil,                -- What item to start with
    nil,                -- TODO: Unused, What item to be selected when initialized
    "skin",             -- The name of the config to save to
    nil                 -- Action wheel action it should be linked to
)


return skinScript
