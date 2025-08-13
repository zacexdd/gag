if game.PlaceId == 126884695634066 then

    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local Window = Rayfield:CreateWindow({
        Name = "Dark Spawner by Zace",
        Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
        LoadingTitle = "Zace hub",
        LoadingSubtitle = "by Zace",
        ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
        Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

        ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

        DisableRayfieldPrompts = false,
        DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

        ConfigurationSaving = {
            Enabled = true,
            FolderName = nil, -- Create a custom folder for your hub/game
            FileName = "Zace Hub"
        },

        Discord = {
            Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
            Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
            RememberJoins = true -- Set this to false to make them join the discord every time they load it up
        },

        KeySystem = true, -- Set this to true to use our key system
        KeySettings = {
            Title = "Zace hub key system",
            Subtitle = "Enter valid key to acces the script",
            Note = "Get the key from here : www.gamelnk.site", -- Use this to tell the user how to get a key
            FileName = "Zace Hub", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
            SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
            GrabKeyFromSite = true, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
            Key = {"https://pastebin.com/raw/y6zvrV55"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
        }
    })

    local PetTab = Window:CreateTab("Pets Spawner", nil) -- Title, Image
    local PetSection = PetTab:CreateSection("Spawn selected pet")

    local Dropdown = PetTab:CreateDropdown({
        Name = "Select Pet",
        Options = {"Red Fox", "Raccon", "Drangonfly", "Disco Bee", "Kitsune", "T-Rex", "Corrupted Kitsune",
                   "French Fry Ferret", "Moon Cat", "Raiju", "Hotdog Daschund", "Spinosaurus", "Spaghetti Sloth"},
        CurrentOption = {"Red Fox"},
        MultipleOptions = false,
        Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Options)

        end
    })

    local Input = PetTab:CreateInput({
        Name = "Weight",
        CurrentValue = "1",
        PlaceholderText = "1",
        RemoveTextAfterFocusLost = false,
        Flag = "Input1",
        Callback = function(Text)

        end
    })

    local Input = PetTab:CreateInput({
        Name = "Age",
        CurrentValue = "1",
        PlaceholderText = "1",
        RemoveTextAfterFocusLost = false,
        Flag = "Input2",
        Callback = function(Text)

        end
    })

    local Button = PetTab:CreateButton({
        Name = "Spawn Pet",
        Callback = function()
            local petName = Rayfield.Flags.Dropdown1.CurrentOption[1]
            local weight = tonumber(Rayfield.Flags.Input1.CurrentValue) or 1
            local age = tonumber(Rayfield.Flags.Input2.CurrentValue) or 1

            -- 1. Generate valid UUID
            local function generateValidUUID()
                local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
                return "{" .. string.gsub(template, "[xy]", function(c)
                    local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
                    return string.format("%x", v)
                end) .. "}"
            end
            local petUUID = generateValidUUID()

            -- 2. Load pet assets
            game:GetService("ReplicatedStorage").GameEvents.ReplicationChannel:FireServer("PetAssets", petName)
            wait(0.5)

            -- 3. METHOD 1: Try adding through PetService instead
            local addToInventoryArgs = {
                [1] = "AddPet",
                [2] = petUUID,
                [3] = {
                    Name = petName,
                    Weight = weight,
                    Age = age,
                }
            }

            -- Try different services until we find the right one
            local servicesToTry = {"PetsService", "PetService", "PlayerDataService", "DataService", "InventoryManager"}

            local addedToInventory = false

            for _, serviceName in ipairs(servicesToTry) do
                local service = game:GetService("ReplicatedStorage").GameEvents:FindFirstChild(serviceName)
                if service then
                    pcall(function()
                        service:FireServer(unpack(addToInventoryArgs))
                        print("Attempted to add via", serviceName)
                        addedToInventory = true
                    end)
                    wait(0.2)
                end
            end

            if not addedToInventory then
                -- 4. METHOD 2: Try hatching a fake egg if inventory add fails
                local hatchArgs = {
                    [1] = "HatchPet",
                    [2] = petName,
                    [3] = petUUID
                }
                game:GetService("ReplicatedStorage").GameEvents.PetEggService:FireServer(unpack(hatchArgs))
                wait(0.5)
            end

            -- 5. Equip the pet
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            local spawnCFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -5)

            local equipArgs = {
                [1] = "EquipPet",
                [2] = petUUID,
                [3] = spawnCFrame
            }
            game:GetService("ReplicatedStorage").GameEvents.PetsService:FireServer(unpack(equipArgs))

            -- Debug
            local marker = Instance.new("Part")
            marker.Anchored = true
            marker.Size = Vector3.new(1, 1, 1)
            marker.Position = spawnCFrame.Position
            marker.Color = Color3.fromRGB(0, 255, 0)
            marker.Transparency = 0.7
            marker.Parent = workspace
            game:GetService("Debris"):AddItem(marker, 5)

            print("Spawned", petName, "with UUID:", petUUID)
        end
    })
end