if game.PlaceId == 126884695634066 then
   
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Pet and seed spawner script",
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
      Subtitle = "Copy the link from below",
      Note = "Get the key from here : www.gamelnk.site", -- Use this to tell the user how to get a key
      FileName = "Zace Hub", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = true, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"https://pastebin.com/raw/y6zvrV55"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("Pets", nil) -- Title, Image
local MainSection = MainTab:CreateSection("pets section")

local Dropdown = MainTab:CreateDropdown({
   Name = "Select Pet",
   Options = {"Red Fox","Raccon","Drangonfly","Disco Bee"},
   CurrentOption = {"nil"},
   MultipleOptions = false,
   Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Options)
   
   end,
})

local Input = MainTab:CreateInput({
   Name = "Weight",
   CurrentValue = "1",
   PlaceholderText = "1",
   RemoveTextAfterFocusLost = false,
   Flag = "Input1",
   Callback = function(Text)
   
   end,
})

local Input = MainTab:CreateInput({
   Name = "Age",
   CurrentValue = "1",
   PlaceholderText = "1",
   RemoveTextAfterFocusLost = false,
   Flag = "Input2",
   Callback = function(Text)
  
   end,
})

local Button = MainTab:CreateButton({
   Name = "Spawn Pet",
   Callback = function()
      print('Raccon')
   end,
})

local SecondTab = Window:CreateTab("Seeds", nil) -- Title, Image
local SecondSection = SecondTab:CreateSection("seeds section")

local Dropdown = SecondTab:CreateDropdown({
   Name = "Select Seed",
   Options = {"Candy Blossom","Tomato","Pineapple","Avocado"},
   CurrentOption = "nill",
   MultipleOptions = false,
   Flag = "Dropdown2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Options)
   
   end,
})

local Button = SecondTab:CreateButton({
   Name = "Spawn Seed",
   Callback = function()
   print('Candy Blossom')
   end,
})

end
