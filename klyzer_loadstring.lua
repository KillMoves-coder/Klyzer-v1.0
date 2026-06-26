--[[ KLYZER HUB - Loadstring Version ]]
-- Execute with: loadstring(game:HttpGet("YOUR_URL_HERE"))()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local COLORS = {
	PRIMARY_RED = Color3.fromRGB(220, 50, 50),
	DARK_RED = Color3.fromRGB(150, 30, 30),
	LIGHT_RED = Color3.fromRGB(255, 100, 100),
	BACKGROUND = Color3.fromRGB(40, 40, 40),
	DARK_BG = Color3.fromRGB(25, 25, 25),
	TEXT_WHITE = Color3.fromRGB(255, 255, 255),
	ACCENT_CYAN = Color3.fromRGB(100, 200, 255),
}

local RARITIES = {
	"Common",
	"Uncommon",
	"Rare",
	"Epic",
	"Legendary",
	"Mythic",
	"Exclusive",
	"BlackRare"
}

local RARITY_COLORS = {
	Common = Color3.fromRGB(200, 200, 200),
	Uncommon = Color3.fromRGB(100, 200, 100),
	Rare = Color3.fromRGB(100, 150, 255),
	Epic = Color3.fromRGB(200, 100, 255),
	Legendary = Color3.fromRGB(255, 200, 50),
	Mythic = Color3.fromRGB(255, 100, 150),
	Exclusive = Color3.fromRGB(255, 50, 50),
	BlackRare = Color3.fromRGB(50, 50, 50),
}

local function createMainUI(player)
	local playerGui = player:WaitForChild("PlayerGui")
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "KlyzerHubGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
	
	local leftPanel = Instance.new("Frame")
	leftPanel.Name = "LeftPanel"
	leftPanel.Size = UDim2.new(0, 200, 1, 0)
	leftPanel.BackgroundColor3 = COLORS.DARK_BG
	leftPanel.BorderSizePixel = 0
	leftPanel.Parent = screenGui
	
	local header = Instance.new("TextLabel")
	header.Name = "Header"
	header.Text = "KLYZER"
	header.Size = UDim2.new(1, 0, 0, 40)
	header.BackgroundColor3 = COLORS.PRIMARY_RED
	header.TextColor3 = COLORS.TEXT_WHITE
	header.TextScaled = true
	header.Font = Enum.Font.GothamBold
	header.BorderSizePixel = 0
	header.Parent = leftPanel
	
	local menuItems = {"Main", "Farm", "Settings", "Collections"}
	local menuContainer = Instance.new("Frame")
	menuContainer.Name = "MenuContainer"
	menuContainer.Size = UDim2.new(1, 0, 1, -40)
	menuContainer.Position = UDim2.new(0, 0, 0, 40)
	menuContainer.BackgroundTransparency = 1
	menuContainer.Parent = leftPanel
	
	local function createMenuItem(text, index)
		local button = Instance.new("TextButton")
		button.Name = text
		button.Text = text
		button.Size = UDim2.new(1, 0, 0, 40)
		button.Position = UDim2.new(0, 0, 0, (index - 1) * 40)
		button.BackgroundColor3 = COLORS.DARK_BG
		button.TextColor3 = COLORS.ACCENT_CYAN
		button.Font = Enum.Font.Gotham
		button.TextSize = 14
		button.BorderSizePixel = 0
		button.Parent = menuContainer
		
		button.MouseEnter:Connect(function()
			button.BackgroundColor3 = COLORS.DARK_RED
		end)
		
		button.MouseLeave:Connect(function()
			button.BackgroundColor3 = COLORS.DARK_BG
		end)
		
		button.MouseButton1Click:Connect(function()
			print("Menu item clicked: " .. text)
		end)
		
		return button
	end
	
	for i, item in ipairs(menuItems) do
		createMenuItem(item, i)
	end
	
	local contentPanel = Instance.new("Frame")
	contentPanel.Name = "ContentPanel"
	contentPanel.Size = UDim2.new(1, -200, 1, 0)
	contentPanel.Position = UDim2.new(0, 200, 0, 0)
	contentPanel.BackgroundColor3 = COLORS.BACKGROUND
	contentPanel.BorderSizePixel = 0
	contentPanel.Parent = screenGui
	
	local contentHeader = Instance.new("TextLabel")
	contentHeader.Name = "ContentHeader"
	contentHeader.Text = "COLLECTIONS"
	contentHeader.Size = UDim2.new(1, 0, 0, 50)
	contentHeader.BackgroundColor3 = COLORS.PRIMARY_RED
	contentHeader.TextColor3 = COLORS.TEXT_WHITE
	contentHeader.TextScaled = true
	contentHeader.Font = Enum.Font.GothamBold
	contentHeader.BorderSizePixel = 0
	contentHeader.Parent = contentPanel
	
	local filterFrame = Instance.new("Frame")
	filterFrame.Name = "FilterFrame"
	filterFrame.Size = UDim2.new(1, 0, 0, 60)
	filterFrame.Position = UDim2.new(0, 0, 0, 50)
	filterFrame.BackgroundColor3 = COLORS.DARK_BG
	filterFrame.BorderSizePixel = 0
	filterFrame.Parent = contentPanel
	
	local filterLabel = Instance.new("TextLabel")
	filterLabel.Name = "FilterLabel"
	filterLabel.Text = "Рарность:"
	filterLabel.Size = UDim2.new(0, 100, 0, 30)
	filterLabel.Position = UDim2.new(0, 10, 0, 5)
	filterLabel.BackgroundTransparency = 1
	filterLabel.TextColor3 = COLORS.TEXT_WHITE
	filterLabel.Font = Enum.Font.Gotham
	filterLabel.Parent = filterFrame
	
	local buttonStartPos = 120
	for i, rarity in ipairs(RARITIES) do
		local rarityButton = Instance.new("TextButton")
		rarityButton.Name = rarity
		rarityButton.Text = rarity
		rarityButton.Size = UDim2.new(0, 80, 0, 25)
		rarityButton.Position = UDim2.new(0, buttonStartPos + (i - 1) * 90, 0, 10)
		rarityButton.BackgroundColor3 = RARITY_COLORS[rarity]
		rarityButton.TextColor3 = COLORS.DARK_BG
		rarityButton.Font = Enum.Font.Gotham
		rarityButton.TextSize = 12
		rarityButton.BorderSizePixel = 0
		rarityButton.Parent = filterFrame
		
		rarityButton.MouseButton1Click:Connect(function()
			print("Filter: " .. rarity)
		end)
	end
	
	local gridFrame = Instance.new("ScrollingFrame")
	gridFrame.Name = "ItemsGrid"
	gridFrame.Size = UDim2.new(1, -20, 1, -130)
	gridFrame.Position = UDim2.new(0, 10, 0, 120)
	gridFrame.BackgroundColor3 = COLORS.BACKGROUND
	gridFrame.BorderSizePixel = 0
	gridFrame.ScrollBarThickness = 12
	gridFrame.Parent = contentPanel
	
	local uiGridLayout = Instance.new("UIGridLayout")
	uiGridLayout.CellSize = UDim2.new(0, 120, 0, 120)
	uiGridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
	uiGridLayout.Parent = gridFrame
	
	for i = 1, 12 do
		local itemButton = Instance.new("TextButton")
		itemButton.Name = "Item" .. i
		itemButton.Text = "Item #" .. i
		itemButton.Size = UDim2.new(0, 120, 0, 120)
		itemButton.BackgroundColor3 = RARITY_COLORS[RARITIES[math.random(1, #RARITIES)]]
		itemButton.TextColor3 = COLORS.TEXT_WHITE
		itemButton.Font = Enum.Font.GothamBold
		itemButton.TextSize = 12
		itemButton.BorderSizePixel = 2
		itemButton.BorderColor3 = COLORS.PRIMARY_RED
		itemButton.Parent = gridFrame
		
		itemButton.MouseEnter:Connect(function()
			itemButton.BorderColor3 = COLORS.LIGHT_RED
		end)
		
		itemButton.MouseLeave:Connect(function()
			itemButton.BorderColor3 = COLORS.PRIMARY_RED
		end)
	end
	
	local infoPanel = Instance.new("Frame")
	infoPanel.Name = "InfoPanel"
	infoPanel.Size = UDim2.new(0, 250, 1, 0)
	infoPanel.Position = UDim2.new(1, -250, 0, 0)
	infoPanel.BackgroundColor3 = COLORS.DARK_BG
	infoPanel.BorderSizePixel = 2
	infoPanel.BorderColor3 = COLORS.PRIMARY_RED
	infoPanel.Parent = screenGui
	
	local infoHeader = Instance.new("TextLabel")
	infoHeader.Name = "InfoHeader"
	infoHeader.Text = "DISPLAY"
	infoHeader.Size = UDim2.new(1, 0, 0, 40)
	infoHeader.BackgroundColor3 = COLORS.PRIMARY_RED
	infoHeader.TextColor3 = COLORS.TEXT_WHITE
	infoHeader.Font = Enum.Font.GothamBold
	infoHeader.BorderSizePixel = 0
	infoHeader.Parent = infoPanel
	
	local displayOptions = {
		"Show Rarity",
		"Show Price",
		"Show Name",
		"Show Description",
		"Show Value"
	}
	
	for i, option in ipairs(displayOptions) do
		local checkbox = Instance.new("TextButton")
		checkbox.Name = option
		checkbox.Text = "☑ " .. option
		checkbox.Size = UDim2.new(1, -10, 0, 30)
		checkbox.Position = UDim2.new(0, 5, 0, 40 + (i - 1) * 35)
		checkbox.BackgroundColor3 = COLORS.DARK_BG
		checkbox.TextColor3 = COLORS.ACCENT_CYAN
		checkbox.Font = Enum.Font.Gotham
		checkbox.TextSize = 11
		checkbox.BorderSizePixel = 1
		checkbox.BorderColor3 = COLORS.PRIMARY_RED
		checkbox.Parent = infoPanel
		
		checkbox.MouseButton1Click:Connect(function()
			print("Toggled: " .. option)
		end)
	end
	
	print("Klyzer Hub UI Created Successfully!")
end

local player = Players.LocalPlayer
if player then
	if player.Character then
		createMainUI(player)
	end
	player.CharacterAdded:Connect(function()
		createMainUI(player)
	end)
end

print("Klyzer Hub Loadstring Script Loaded!")
