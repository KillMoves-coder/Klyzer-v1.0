# KLYZER v1.0 - New Script for TSUM

A complete Roblox game system for "Klyzer," a collection-based hub with a red color scheme. This is a new script built for TSUM with enhanced features and modular architecture.

---

## 📦 Included Files

1. **klyzer_hub.lua** - Main UI and game script
2. **klyzer_collections_module.lua** - Item collection and inventory system
3. **klyzer_settings_module.lua** - Player settings and configuration system

---

## 🎨 Color Scheme

The entire system uses a **red theme** instead of the default cyan/blue:

- **Primary Red**: RGB(220, 50, 50) - Main accent color
- **Dark Red**: RGB(150, 30, 30) - Secondary accents
- **Light Red**: RGB(255, 100, 100) - Hover states
- **Dark Background**: RGB(40, 40, 40) - Panel backgrounds
- **Text White**: RGB(255, 255, 255) - Primary text

---

## 📋 Feature Overview

### Main Hub UI
- **Left Menu Panel**: Navigation between Main, Farm, Settings, and Collections
- **Content Panel**: Main display area with rarity filters and item grid
- **Info Panel**: Display settings and toggles
- **Grid System**: Scrollable item display with 3x4 cell layout (adjustable)

### Collections Module
- **Add/Remove Items**: Full inventory management
- **Filter by Rarity**: Organize items by tier
- **Sort Collection**: Multiple sorting options
- **Get Statistics**: View collection data
- **Save/Load Data**: Persistent DataStore integration

### Settings Module
- **Display Settings**: Grid size, sorting, filtering
- **Gameplay Settings**: Auto-collect, sound, animations
- **Performance Settings**: Graphics quality, render distance
- **Privacy Settings**: Profile visibility, trading permissions
- **Accessibility**: Text size, colorblind modes, contrast options

---

## 🔄 Update History

**Klyzer v1.0 - Initial Release (TSUM)**
- Main UI system with red theme
- Collection and inventory system
- Settings and configuration module
- Full DataStore integration
- 8-tier rarity system
- Display filtering and sorting options

---

## 📄 License

This is a complete, ready-to-use system for Roblox game development.

**Happy collecting!** 🎉print("Total Value:", stats.totalValue)
```

### Create Custom Item
```lua
local Collections = require(game.StarterPlayer:WaitForChild("CollectionsModule"))
local player = game.Players:WaitForChild("YourUsername")

-- Create a custom item
local customItem = Collections.createItem("Legendary Artifact", "Legendary", {
    description = "A rare and powerful artifact",
    rarity_chance = 0.02
})

-- Add to player's collection
Collections.addItemToCollection(player, customItem)
```

### Manage Player Settings
```lua
local Settings = require(game.StarterPlayer:WaitForChild("SettingsModule"))
local player = game.Players:WaitForChild("YourUsername")

-- Initialize settings
Settings.initializePlayerSettings(player)

-- Set a specific setting
Settings.setSetting(player, "Display", "GridSize", "Large")
Settings.setSetting(player, "Gameplay", "VolumeLevel", 0.5)

-- Get a setting
local gridSize = Settings.getSetting(player, "Display", "GridSize")
print("Grid Size:", gridSize)

-- Get all display settings
local displaySettings = Settings.getCategorySettings(player, "Display")

-- Save settings to DataStore
Settings.savePlayerSettings(player)
```

---

## 🎯 Key Functions Reference

### Collections Module

| Function | Parameters | Returns | Purpose |
|----------|-----------|---------|---------|
| `createItem()` | name, rarity, properties | table | Create a new item |
| `getRandomRarity()` | none | string | Generate weighted random rarity |
| `initializePlayerCollection()` | player | table | Initialize player's collection |
| `addItemToCollection()` | player, item | table | Add item to collection |
| `removeItemFromCollection()` | player, itemId | bool | Remove item from collection |
| `getPlayerCollection()` | player | table | Get player's full collection |
| `getItemsByRarity()` | player, rarity | table | Get filtered items |
| `sortCollectionByRarity()` | player | table | Sort items by rarity tier |
| `savePlayerData()` | player | void | Save collection to DataStore |
| `loadPlayerData()` | player | table | Load collection from DataStore |
| `generateRandomItems()` | player, count | void | Generate test items |
| `getStatistics()` | player | table | Get collection stats |

### Settings Module

| Function | Parameters | Returns | Purpose |
|----------|-----------|---------|---------|
| `initializePlayerSettings()` | player | table | Initialize player settings |
| `getSetting()` | player, category, key | any | Get single setting |
| `setSetting()` | player, category, key, value | bool | Set single setting |
| `getCategorySettings()` | player, category | table | Get all settings in category |
| `setCategorySettings()` | player, category, newSettings | bool | Set entire category |
| `resetToDefault()` | player, [category] | bool | Reset to defaults |
| `savePlayerSettings()` | player | bool | Save to DataStore |
| `loadPlayerSettings()` | player | table | Load from DataStore |
| `getGridDimensions()` | player | table | Get grid layout dimensions |
| `getVolumeLevel()` | player | number | Get sound volume (0-1) |
| `toggleSound()` | player | bool | Toggle sound on/off |
| `exportSettings()` | player | table | Export all settings |
| `importSettings()` | player, table | bool | Import settings from table |
| `validateSetting()` | category, key, value | bool | Validate setting value |

---

## 🎮 Customization Guide

### Change Button Colors
In `kryzel_hub.lua`, modify the `COLORS` table:
```lua
local COLORS = {
    PRIMARY_RED = Color3.fromRGB(220, 50, 50),  -- Change this
    -- ... other colors
}
```

### Add New Menu Items
In the `createMainUI` function, add to `menuItems`:
```lua
local menuItems = {"Main", "Farm", "Settings", "Collections", "Marketplace"}
```

### Modify Rarity Values
In `kryzel_collections_module.lua`, edit `RarityTiers`:
```lua
Common = {
    Weight = 50,
    DisplayColor = Color3.fromRGB(200, 200, 200),
    Value = 10  -- Change value here
}
```

### Add New Settings Categories
In `kryzel_settings_module.lua`, add to `DefaultSettings`:
```lua
NewCategory = {
    OptionName = defaultValue,
    AnotherOption = true
}
```

---

## 🐛 Troubleshooting

### Items Not Appearing
- Ensure DataStore is enabled in Game Settings
- Check that ModuleScripts are in correct location
- Verify `require()` paths match your folder structure

### UI Not Loading
- Check that MainScript is in StarterPlayerScripts
- Ensure there are no script errors in Output panel
- Verify player is actually in game (UI is player-specific)

### Settings Not Saving
- Enable DataStore API in Game Settings
- Check console for DataStore errors
- Verify `savePlayerSettings()` is being called

### Performance Issues
- Reduce `MaxGridItems` in performance settings
- Disable particles/shadows if needed
- Lower `RenderDistance` setting

---

## 📝 Notes

- All color values use RGB format for Roblox compatibility
- The system uses UserIds for player identification (works with Roblox API)
- DataStore keys are formatted as "KryzelCollections" and "KryzelSettings"
- The UI is responsive and scales to different screen sizes
- All scripts are LocalScripts for client-side functionality

---

## 🔄 Update History

**Version 1.0 - Initial Release**
- Main UI system with red theme
- Collection and inventory system
- Settings and configuration module
- Full DataStore integration
- 8-tier rarity system
- Display filtering and sorting options

---

## 📄 License

This is a complete, ready-to-use system for Roblox game development.

**Happy collecting!** 🎉
