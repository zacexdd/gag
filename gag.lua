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

            -- 1. Generate simple UUID without curly braces
            local petUUID = string.format("%x%x%x%x%x%x%x%x-%x%x%x%x-%x%x%x%x-%x%x%x%x-%x%x%x%x%x%x%x%x",
                math.random(0, 15), math.random(0, 15), math.random(0, 15), math.random(0, 15),
                math.random(0, 15), math.random(0, 15), math.random(0, 15), math.random(0, 15),
                math.random(0, 15), math.random(0, 15), math.random(0, 15), math.random(0, 15),
                math.random(0, 15), math.random(0, 15), math.random(0, 15), math.random(0, 15),
                math.random(0, 15), math.random(0, 15), math.random(0, 15), math.random(0, 15),
                math.random(0, 15), math.random(0, 15), math.random(0, 15), math.random(0, 15),
                math.random(0, 15), math.random(0, 15), math.random(0, 15), math.random(0, 15),
                math.random(0, 15), math.random(0, 15), math.random(0, 15), math.random(0, 15)
            )

            -- 2. Load pet assets FIRST (critical for visual appearance)
            game:GetService("ReplicatedStorage").GameEvents.ReplicationChannel:FireServer("PetAssets", petName)
            
            -- Wait for assets with timeout
            local startTime = tick()
            while tick() - startTime < 3 do -- 3 second timeout
                if pcall(function()
                    game:GetService("ContentProvider"):PreloadAsync({petName})
                end) then
                    break
                end
                wait(0.1)
            end
            wait(0.5) -- Additional safety delay

            -- 3. Add pet through direct PetsService call
            local success, err = pcall(function()
                game:GetService("ReplicatedStorage").GameEvents.PetsService:FireServer(
                    "AddPet",
                    petUUID,
                    {
                        Name = petName,
                        Age = age,
                        Weight = weight
                    }
                )
            end)
            
            if not success then
                warn("Inventory add failed:", err)
            end

            -- 4. Spawn pet in world
            local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            local spawnCFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -5)
            
            -- Final spawn call with proper arguments
            game:GetService("ReplicatedStorage").GameEvents.PetsService:FireServer(
                "EquipPet",
                petUUID,
                spawnCFrame
            )

            -- Debug output
            print(string.format("Spawned %s (Age: %d, Weight: %d)", petName, age, weight))
        end
    })
end