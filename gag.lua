if game.PlaceId == 126884695634066 then
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local Window = Rayfield:CreateWindow({
        Name = "Pet and Seed Viewer",
        Icon = 0,
        LoadingTitle = "Zace hub",
        LoadingSubtitle = "by Zace",
        Theme = "Default",
        ToggleUIKeybind = "K",

        ConfigurationSaving = {
            Enabled = true,
            FileName = "Zace Hub"
        },

        KeySystem = true,
        KeySettings = {
            Title = "Zace hub key system",
            Note = "Get the key from here : www.gamelnk.site",
            FileName = "Zace Hub",
            SaveKey = true,
            GrabKeyFromSite = true,
            Key = {"https://pastebin.com/raw/y6zvrV55"}
        }
    })

    -- Table to store fake pets
    local PetInventory = {}

    -- Create custom GUI for pets
    local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
    ScreenGui.Name = "PetInventoryGUI"

    local InventoryFrame = Instance.new("Frame", ScreenGui)
    InventoryFrame.Size = UDim2.new(0, 300, 0, 200)
    InventoryFrame.Position = UDim2.new(1, -310, 0.5, -100)
    InventoryFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    InventoryFrame.Visible = true

    local UIList = Instance.new("UIListLayout", InventoryFrame)
    UIList.Padding = UDim.new(0, 5)
    UIList.FillDirection = Enum.FillDirection.Vertical

    local MainTab = Window:CreateTab("Pets", nil)

    local PetDropdown = MainTab:CreateDropdown({
        Name = "Select Pet",
        Options = {
            "Kitsune", "Raccoon", "Disco Bee", "T-Rex",
            "Corrupted Kitsune", "Raiju", "Lobster Thermidor",
            "French Fry Ferret", "Spinosaurus", "Dragonfly",
            "Hotdog Daschund", "Butterfly", "Blood Hedgehog",
            "Moon Cat", "Spaghetti Sloth", "Kappa"
        },
        CurrentOption = {"nil"},
        MultipleOptions = false,
        Flag = "PetChoice",
        Callback = function() end,
    })

    local WeightInput = MainTab:CreateInput({
        Name = "Weight",
        CurrentValue = "1",
        PlaceholderText = "1",
        Flag = "PetWeight",
        Callback = function() end,
    })

    local AgeInput = MainTab:CreateInput({
        Name = "Age",
        CurrentValue = "1",
        PlaceholderText = "1",
        Flag = "PetAge",
        Callback = function() end,
    })

    MainTab:CreateButton({
        Name = "Add to Inventory",
        Callback = function()
            local petName = Rayfield.Flags.PetChoice.CurrentOption[1]
            local weight = Rayfield.Flags.PetWeight.CurrentValue
            local age = Rayfield.Flags.PetAge.CurrentValue

            -- Store pet data
            table.insert(PetInventory, {
                Name = petName,
                Weight = weight,
                Age = age
            })

            -- Create UI button in inventory
            local PetButton = Instance.new("TextButton", InventoryFrame)
            PetButton.Size = UDim2.new(1, 0, 0, 30)
            PetButton.Text = petName .. " (W:" .. weight .. ", A:" .. age .. ")"
            PetButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            PetButton.TextColor3 = Color3.new(1, 1, 1)

            -- When clicked, show in ViewportFrame
            PetButton.MouseButton1Click:Connect(function()
                local ViewGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
                local Viewport = Instance.new("ViewportFrame", ViewGui)
                Viewport.Size = UDim2.new(0, 300, 0, 300)
                Viewport.Position = UDim2.new(0.5, -150, 0.5, -150)
                Viewport.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

                local cam = Instance.new("Camera")
                Viewport.CurrentCamera = cam

                -- Try to get pet model from ReplicatedStorage (client visual)
                local rs = game:GetService("ReplicatedStorage")
                local petModel = rs:FindFirstChild(petName)

                if petModel and petModel:IsA("Model") then
                    local clone = petModel:Clone()
                    clone.Parent = Viewport

                    -- Camera position
                    local cframe, size = clone:GetBoundingBox()
                    cam.CFrame = CFrame.new(cframe.Position + Vector3.new(0, size.Y, size.Z + 3), cframe.Position)
                else
                    local label = Instance.new("TextLabel", Viewport)
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.Text = "Pet model not found!"
                    label.TextColor3 = Color3.new(1, 1, 1)
                    label.BackgroundTransparency = 1
                end

                -- Click anywhere to close
                ViewGui.ResetOnSpawn = false
                ViewGui.DisplayOrder = 999
                ViewGui.IgnoreGuiInset = true

                ViewGui.MouseButton1Click:Connect(function()
                    ViewGui:Destroy()
                end)
            end)
        end
    })
end
