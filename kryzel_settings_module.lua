--[[ KRYZEL SETTINGS MODULE ]]
-- Game Settings and Configuration System for Kryzel Hub

local Settings = {}

-- Default Settings Configuration
Settings.DefaultSettings = {
	-- Display Settings
	Display = {
		ShowRarity = true,
		ShowPrice = true,
		ShowName = true,
		ShowDescription = true,
		ShowValue = true,
		GridSize = "Medium",
		SortBy = "Rarity",
		FilterMode = "All"
	},
	
	-- Gameplay Settings
	Gameplay = {
		AutoCollect = true,
		SoundEnabled = true,
		VolumeLevel = 0.7,
		AnimationsEnabled = true,
		ParticlesEnabled = true
	},
	
	-- Performance Settings
	Performance = {
		MaxGridItems = 100,
		RenderDistance = 50,
		EnableShadows = true,
		TextureQuality = "High"
	},
	
	-- Privacy Settings
	Privacy = {
		ShowCollection = true,
		AllowTrades = true,
		PublicProfile = false
	},
	
	-- Accessibility
	Accessibility = {
		HighContrast = false,
		TextSize = "Normal",
		ColorblindMode = "None",
		CameraShake = true
	}
}

-- Player Settings Storage
Settings.PlayerSettings = {}

-- Initialize player settings
function Settings.initializePlayerSettings(player)
	if not Settings.PlayerSettings[player.UserId] then
		-- Create deep copy of default settings
		Settings.PlayerSettings[player.UserId] = {}
		for category, options in pairs(Settings.DefaultSettings) do
			Settings.PlayerSettings[player.UserId][category] = {}
			for key, value in pairs(options) do
				Settings.PlayerSettings[player.UserId][category][key] = value
			end
		end
	end
	return Settings.PlayerSettings[player.UserId]
end

-- Get a specific setting
function Settings.getSetting(player, category, key)
	local playerSettings = Settings.initializePlayerSettings(player)
	if playerSettings[category] then
		return playerSettings[category][key]
	end
	return nil
end

-- Set a specific setting
function Settings.setSetting(player, category, key, value)
	local playerSettings = Settings.initializePlayerSettings(player)
	if playerSettings[category] then
		playerSettings[category][key] = value
		return true
	end
	return false
end

-- Get all settings for a category
function Settings.getCategorySettings(player, category)
	local playerSettings = Settings.initializePlayerSettings(player)
	return playerSettings[category]
end

-- Set all settings for a category
function Settings.setCategorySettings(player, category, newSettings)
	local playerSettings = Settings.initializePlayerSettings(player)
	if playerSettings[category] then
		for key, value in pairs(newSettings) do
			if playerSettings[category][key] ~= nil then
				playerSettings[category][key] = value
			end
		end
		return true
	end
	return false
end

-- Reset settings to default
function Settings.resetToDefault(player, category)
	local playerSettings = Settings.initializePlayerSettings(player)
	if category then
		-- Reset specific category
		if playerSettings[category] then
			for key, value in pairs(Settings.DefaultSettings[category]) do
				playerSettings[category][key] = value
			end
			return true
		end
	else
		-- Reset all settings
		for cat, options in pairs(Settings.DefaultSettings) do
			playerSettings[cat] = {}
			for key, value in pairs(options) do
				playerSettings[cat][key] = value
			end
		end
		return true
	end
	return false
end

-- Save settings to DataStore
function Settings.savePlayerSettings(player)
	local playerSettings = Settings.PlayerSettings[player.UserId]
	if playerSettings then
		local dataStore = game:GetService("DataStoreService"):GetDataStore("KryzelSettings")
		local success, err = pcall(function()
			dataStore:SetAsync(tostring(player.UserId), playerSettings)
		end)
		
		if not success then
			warn("Failed to save settings for " .. player.Name .. ": " .. err)
		end
		return success
	end
	return false
end

-- Load settings from DataStore
function Settings.loadPlayerSettings(player)
	local dataStore = game:GetService("DataStoreService"):GetDataStore("KryzelSettings")
	local success, data = pcall(function()
		return dataStore:GetAsync(tostring(player.UserId))
	end)
	
	if success and data then
		Settings.PlayerSettings[player.UserId] = data
		return data
	else
		return Settings.initializePlayerSettings(player)
	end
end

-- Get effective grid size
function Settings.getGridDimensions(player)
	local gridSize = Settings.getSetting(player, "Display", "GridSize")
	local dimensions = {
		Small = { rows = 5, cols = 8 },
		Medium = { rows = 4, cols = 6 },
		Large = { rows = 3, cols = 4 }
	}
	return dimensions[gridSize] or dimensions.Medium
end

-- Get volume level
function Settings.getVolumeLevel(player)
	return Settings.getSetting(player, "Gameplay", "VolumeLevel")
end

-- Toggle sound
function Settings.toggleSound(player)
	local current = Settings.getSetting(player, "Gameplay", "SoundEnabled")
	Settings.setSetting(player, "Gameplay", "SoundEnabled", not current)
	return not current
end

-- Get colorblind mode
function Settings.getColorbindMode(player)
	return Settings.getSetting(player, "Accessibility", "ColorblindMode")
end

-- Get all settings as JSON-compatible table
function Settings.exportSettings(player)
	return Settings.PlayerSettings[player.UserId] or Settings.initializePlayerSettings(player)
end

-- Import settings from JSON-compatible table
function Settings.importSettings(player, settingsTable)
	Settings.PlayerSettings[player.UserId] = settingsTable
	return Settings.savePlayerSettings(player)
end

-- Validate setting value
function Settings.validateSetting(category, key, value)
	local validators = {
		Display = {
			GridSize = function(v) return v == "Small" or v == "Medium" or v == "Large" end,
			SortBy = function(v) return v == "Rarity" or v == "Date" or v == "Value" or v == "Name" end,
			FilterMode = function(v) return v == "All" or v == "Favorite" or v == "Recent" end
		},
		Gameplay = {
			VolumeLevel = function(v) return type(v) == "number" and v >= 0 and v <= 1 end,
			SoundEnabled = function(v) return type(v) == "boolean" end,
			AutoCollect = function(v) return type(v) == "boolean" end,
			AnimationsEnabled = function(v) return type(v) == "boolean" end,
			ParticlesEnabled = function(v) return type(v) == "boolean" end
		},
		Performance = {
			MaxGridItems = function(v) return type(v) == "number" and v > 0 and v <= 1000 end,
			RenderDistance = function(v) return type(v) == "number" and v > 0 and v <= 500 end,
			EnableShadows = function(v) return type(v) == "boolean" end
		},
		Privacy = {
			ShowCollection = function(v) return type(v) == "boolean" end,
			AllowTrades = function(v) return type(v) == "boolean" end,
			PublicProfile = function(v) return type(v) == "boolean" end
		},
		Accessibility = {
			HighContrast = function(v) return type(v) == "boolean" end,
			TextSize = function(v) return v == "Small" or v == "Normal" or v == "Large" end,
			ColorblindMode = function(v) return v == "None" or v == "Deuteranopia" or v == "Protanopia" or v == "Tritanopia" end,
			CameraShake = function(v) return type(v) == "boolean" end
		}
	}
	
	if validators[category] and validators[category][key] then
		return validators[category][key](value)
	end
	
	return false
end

-- Get setting constraints/options
function Settings.getSettingOptions(category, key)
	local options = {
		Display = {
			GridSize = { "Small", "Medium", "Large" },
			SortBy = { "Rarity", "Date", "Value", "Name" },
			FilterMode = { "All", "Favorite", "Recent" }
		},
		Accessibility = {
			TextSize = { "Small", "Normal", "Large" },
			ColorblindMode = { "None", "Deuteranopia", "Protanopia", "Tritanopia" }
		}
	}
	
	if options[category] and options[category][key] then
		return options[category][key]
	end
	return nil
end

return Settings
