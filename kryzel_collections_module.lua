--[[ KRYZEL COLLECTIONS MODULE ]]
-- Item Collection and Inventory System for Kryzel Hub

local Collections = {}

-- Rarity Tier System
Collections.RarityTiers = {
	Common = {
		Weight = 50,
		DisplayColor = Color3.fromRGB(200, 200, 200),
		Value = 10
	},
	Uncommon = {
		Weight = 30,
		DisplayColor = Color3.fromRGB(100, 200, 100),
		Value = 25
	},
	Rare = {
		Weight = 12,
		DisplayColor = Color3.fromRGB(100, 150, 255),
		Value = 50
	},
	Epic = {
		Weight = 5,
		DisplayColor = Color3.fromRGB(200, 100, 255),
		Value = 100
	},
	Legendary = {
		Weight = 2,
		DisplayColor = Color3.fromRGB(255, 200, 50),
		Value = 250
	},
	Mythic = {
		Weight = 0.8,
		DisplayColor = Color3.fromRGB(255, 100, 150),
		Value = 500
	},
	Exclusive = {
		Weight = 0.15,
		DisplayColor = Color3.fromRGB(255, 50, 50),
		Value = 1000
	},
	BlackRare = {
		Weight = 0.05,
		DisplayColor = Color3.fromRGB(50, 50, 50),
		Value = 5000
	}
}

-- Item Template
function Collections.createItem(name, rarity, properties)
	local item = {
		id = game:GetService("HttpService"):GenerateGUID(false),
		name = name or "Unknown Item",
		rarity = rarity or "Common",
		acquired = tick(),
		properties = properties or {}
	}
	
	return item
end

-- Get random rarity based on weights
function Collections.getRandomRarity()
	local rarities = {}
	local weights = {}
	local totalWeight = 0
	
	for rarity, data in pairs(Collections.RarityTiers) do
		table.insert(rarities, rarity)
		table.insert(weights, data.Weight)
		totalWeight = totalWeight + data.Weight
	end
	
	local random = math.random() * totalWeight
	local current = 0
	
	for i, weight in ipairs(weights) do
		current = current + weight
		if random <= current then
			return rarities[i]
		end
	end
	
	return rarities[1]
end

-- Collection Manager for Players
Collections.PlayerCollections = {}

function Collections.initializePlayerCollection(player)
	if not Collections.PlayerCollections[player.UserId] then
		Collections.PlayerCollections[player.UserId] = {
			items = {},
			totalValue = 0,
			itemCount = 0,
			rarityCount = {
				Common = 0,
				Uncommon = 0,
				Rare = 0,
				Epic = 0,
				Legendary = 0,
				Mythic = 0,
				Exclusive = 0,
				BlackRare = 0
			}
		}
	end
	return Collections.PlayerCollections[player.UserId]
end

function Collections.addItemToCollection(player, item)
	local collection = Collections.initializePlayerCollection(player)
	
	table.insert(collection.items, item)
	collection.itemCount = collection.itemCount + 1
	collection.totalValue = collection.totalValue + Collections.RarityTiers[item.rarity].Value
	collection.rarityCount[item.rarity] = collection.rarityCount[item.rarity] + 1
	
	return item
end

function Collections.removeItemFromCollection(player, itemId)
	local collection = Collections.initializePlayerCollection(player)
	
	for i, item in ipairs(collection.items) do
		if item.id == itemId then
			collection.itemCount = collection.itemCount - 1
			collection.totalValue = collection.totalValue - Collections.RarityTiers[item.rarity].Value
			collection.rarityCount[item.rarity] = collection.rarityCount[item.rarity] - 1
			table.remove(collection.items, i)
			return true
		end
	end
	
	return false
end

function Collections.getPlayerCollection(player)
	return Collections.initializePlayerCollection(player)
end

function Collections.getItemsByRarity(player, rarity)
	local collection = Collections.initializePlayerCollection(player)
	local filtered = {}
	
	for _, item in ipairs(collection.items) do
		if item.rarity == rarity then
			table.insert(filtered, item)
		end
	end
	
	return filtered
end

function Collections.sortCollectionByRarity(player)
	local collection = Collections.initializePlayerCollection(player)
	local rarityOrder = {
		"BlackRare", "Exclusive", "Mythic", "Legendary",
		"Epic", "Rare", "Uncommon", "Common"
	}
	
	table.sort(collection.items, function(a, b)
		for i, rarity in ipairs(rarityOrder) do
			if a.rarity == rarity and b.rarity ~= rarity then
				return true
			elseif a.rarity ~= rarity and b.rarity == rarity then
				return false
			end
		end
		return a.acquired > b.acquired
	end)
	
	return collection.items
end

-- Auto-Save System
function Collections.savePlayerData(player)
	local collection = Collections.PlayerCollections[player.UserId]
	if collection then
		local dataStore = game:GetService("DataStoreService"):GetDataStore("KryzelCollections")
		local success, err = pcall(function()
			dataStore:SetAsync(tostring(player.UserId), collection)
		end)
		
		if not success then
			warn("Failed to save collection for " .. player.Name .. ": " .. err)
		end
	end
end

function Collections.loadPlayerData(player)
	local dataStore = game:GetService("DataStoreService"):GetDataStore("KryzelCollections")
	local success, data = pcall(function()
		return dataStore:GetAsync(tostring(player.UserId))
	end)
	
	if success and data then
		Collections.PlayerCollections[player.UserId] = data
		return data
	else
		return Collections.initializePlayerCollection(player)
	end
end

-- Batch Item Generator (for testing)
function Collections.generateRandomItems(player, count)
	local collection = Collections.initializePlayerCollection(player)
	
	for i = 1, count do
		local itemNames = {
			"Prismatic Orb", "Crimson Shard", "Void Echo", "Temporal Key",
			"Soul Fragment", "Eclipse Stone", "Nebula Dust", "Infernal Seal",
			"Mystic Rune", "Ancient Tablet", "Dragon Fang", "Phoenix Feather",
			"Shadow Essence", "Light Resonance", "Chaos Crystal", "Order Medallion"
		}
		
		local randomName = itemNames[math.random(1, #itemNames)] .. " #" .. i
		local randomRarity = Collections.getRandomRarity()
		
		local item = Collections.createItem(randomName, randomRarity)
		Collections.addItemToCollection(player, item)
	end
end

-- Get Collection Statistics
function Collections.getStatistics(player)
	local collection = Collections.initializePlayerCollection(player)
	
	local stats = {
		totalItems = collection.itemCount,
		totalValue = collection.totalValue,
		rarityBreakdown = collection.rarityCount,
		mostCommon = nil,
		rarest = nil
	}
	
	-- Find most common rarity
	local highestCommon = 0
	for rarity, count in pairs(collection.rarityCount) do
		if count > highestCommon then
			highestCommon = count
			stats.mostCommon = rarity
		end
	end
	
	-- Find rarest item
	local rarityOrder = {
		"BlackRare", "Exclusive", "Mythic", "Legendary"
	}
	for _, rarity in ipairs(rarityOrder) do
		if collection.rarityCount[rarity] > 0 then
			stats.rarest = rarity
			break
		end
	end
	
	return stats
end

return Collections
