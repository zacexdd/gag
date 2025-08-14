if game.PlaceId ~= 126884695634066 then
    return warn("You must be in the correct game!")
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Dark Spawner by Zace",
    Icon = 0,
    LoadingTitle = "Zace hub",
    LoadingSubtitle = "by Zace",
    ShowText = "Rayfield",
    Theme = "Default",
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {Enabled = true, FolderName = nil, FileName = "Zace Hub"},
    Discord = {Enabled = false, Invite = "noinvitelink", RememberJoins = true},
    KeySystem = true,
    KeySettings = {
        Title = "Zace hub key system",
        Subtitle = "Enter valid key to access the script",
        Note = "Get the key from here : www.gamelnk.site",
        FileName = "Zace Hub",
        SaveKey = true,
        GrabKeyFromSite = true,
        Key = {"https://pastebin.com/raw/y6zvrV55"}
    }
})

-- Create Pets tab
local PetTab = Window:CreateTab("Pets Spawner", nil)
local PetSection = PetTab:CreateSection("Spawn selected pet")

-- Dropdown for pet selection
local Dropdown = PetTab:CreateDropdown({
    Name = "Select Pet",
    Options = {"Red Fox", "Raccon", "Dragonfly", "Disco Bee", "Kitsune", "T-Rex", "Corrupted Kitsune",
               "French Fry Ferret", "Moon Cat", "Raiju", "Hotdog Daschund", "Spinosaurus", "Spaghetti Sloth"},
    CurrentOption = {"Red Fox"},
    MultipleOptions = false,
    Flag = "Dropdown1"
})

-- Input for Weight
local WeightInput = PetTab:CreateInput({
    Name = "Weight",
    CurrentValue = "1",
    PlaceholderText = "1",
    RemoveTextAfterFocusLost = false,
    Flag = "Input1"
})

-- Input for Age
local AgeInput = PetTab:CreateInput({
    Name = "Age",
    CurrentValue = "1",
    PlaceholderText = "1",
    RemoveTextAfterFocusLost = false,
    Flag = "Input2"
})

-- Spawn Pet button
local Button = PetTab:CreateButton({
    Name = "Spawn Pet",
    Callback = function()
        local petName = Rayfield.Flags.Dropdown1.CurrentOption[1]
        local weight = tonumber(Rayfield.Flags.Input1.CurrentValue) or 1
        local age = tonumber(Rayfield.Flags.Input2.CurrentValue) or 1

        -- Generate unique UUID
        local function generateUUID()
            local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
            return "{"..string.gsub(template, "[xy]", function(c)
                local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
                return string.format("%x", v)
            end).."}"
        end
        local petUUID = generateUUID()

        local RepStorage = game:GetService("ReplicatedStorage")
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        local spawnCFrame = hrp.CFrame * CFrame.new(0,0,-5)

        -- 1. Load pet assets
        RepStorage.GameEvents.ReplicationChannel:FireServer("PetAssets", petName)
        wait(0.5)

        -- 2. Add pet to inventory using PetService or fallback services
        local addArgs = {
            [1] = "AddPet",
            [2] = petUUID,
            [3] = {Name = petName, Weight = weight, Age = age, Rarity = "Common"}
        }

        local servicesToTry = {"PetsService", "PetService", "PlayerDataService", "DataService", "InventoryManager"}
        local added = false

        for _, svcName in ipairs(servicesToTry) do
            local svc = RepStorage.GameEvents:FindFirstChild(svcName)
            if svc then
                pcall(function()
                    svc:FireServer(unpack(addArgs))
                    added = true
                    print("Tried adding via", svcName)
                end)
                wait(0.2)
            end
        end

        -- 3. Hatch fake egg if inventory add fails
        if not added then
            local hatchArgs = {"HatchPet", petName, petUUID}
            RepStorage.GameEvents.PetEggService:FireServer(unpack(hatchArgs))
            wait(0.5)
        end

        -- 4. Equip the pet visually
        local equipArgs = {"EquipPet", petUUID, spawnCFrame}
        RepStorage.GameEvents.PetsService:FireServer(unpack(equipArgs))

        -- Optional visual marker for debug
        local marker = Instance.new("Part")
        marker.Size = Vector3.new(1,1,1)
        marker.Anchored = true
        marker.Position = spawnCFrame.Position
        marker.Color = Color3.fromRGB(0,255,0)
        marker.Transparency = 0.7
        marker.Parent = workspace
        game:GetService("Debris"):AddItem(marker, 5)

        print("Spawned", petName, "with UUID:", petUUID)
    end
})
