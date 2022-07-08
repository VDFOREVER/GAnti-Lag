local lagrange = 0.07
local lagcount = 5
local lagquiet = 15
---------------------
local lastSysCurrDiff = 9999
local deltaSysCurrDiff = 0

local currcount = 0
local clearTime = 0
local framecount = 0

hook.Add( "Think", "LagDetThink", function()  framecount = framecount + 1  end)


local function GetCurrentDelta()
	local SysCurrDiff = SysTime() - CurTime()
	deltaSysCurrDiff = math.Round(SysCurrDiff - lastSysCurrDiff, 6)
	lastSysCurrDiff = SysCurrDiff
	return deltaSysCurrDiff
end
	 


local function LagMonThreshold()

	if currcount > 0 then
		if RealTime() > clearTime then
			currcount = 0 
			ServerLog("[AL] Lag has subsided\n")
		end
	end

	local delt = GetCurrentDelta()
	
	if delt >= lagrange then
		RunConsoleCommand("stats")
		ServerLog("[AL] FrameDelta= "..deltaSysCurrDiff.."  LagCount= "..currcount.."  Frames= "..framecount.."  \n")
	end
	
	
	if delt < lagrange then
		return false
	end
	
	currcount = currcount + 1
	clearTime = RealTime() + lagquiet
	
	if (currcount == lagcount) then
		return true 
	end
	
	return false
end

timer.Create("LagDetCheckPerf",1, 0, function()
	if LagMonThreshold() then
		ServerLog("[AL] Lag detected!\n")
	end
	framecount = 0
end)

hook.Add( "OnCrazyPhysics", "FixCrazyPhisics", function(ent, physobj)
	if !IsValid(ent) or !IsValid(physObj) then return end
		physObj:EnableMotion(false)
		physObj:Sleep()
		ServerLog("[AL] Corrected Crazy Physics!\n")
end)

function RemoveE2andSFchip()
	for k, v in ipairs(ents.FindByClass('gmod_wire_expression2')) do v:Remove() end
	for k, v in ipairs(ents.FindByClass('starfall_processor')) do v:Remove() end
end

function CleanMap()	
	game.CleanUpMap()
end

function FrezzeAllProps()
	for k, v in ipairs(ents.FindByClass('prop_physics')) do
		local physObj = v:GetPhysicsObject()
		physObj:EnableMotion(false)
		physObj:Sleep()
	end
end

function FrezzeAllEntities()
	for k, v in ipairs(ents.GetAll()) do
		local physObj = v:GetPhysicsObject()
		physObj:EnableMotion(false)
		physObj:Sleep()
	end
end