local safe_errors = true
local original_services = {}
local wrapped_services  = {}

local function random_name()
	return "CATCH_ME_IF_YOU_CAN_" .. tostring(math.random(6769, 9999999))
	-- // you can change the name into anything you want
end

local function wrap_service(service: Instance)
	local proxy = newproxy(true)
	local meta  = getmetatable(proxy)
	meta.__index = function(_, key)
		local ok, result = pcall(function() return service[key] end)
		if ok then
			return result
		end
		if safe_errors then
			warn("[WRAP ERROR]", result)
		else
			error(result, 2)
		end
	end
	meta.__newindex = function(_, key, value)
		local ok, result = pcall(function() service[key] = value end)
		if not ok then
			if safe_errors then
				warn("[WRAP ERROR]", result)
			else
				error(result, 2)
			end
		end
	end
	meta.__tostring = function() return tostring(service) end
	meta.__metatable = "locked"
	return proxy
end

local service_names = { -- // add more if required
	"Teams",
	"MaterialService",
	"JointsService",
	"MaterialService",
	"JointsService",
	"PhysicsService",
	"Chat",
	"ChatService",
	"ChatServiceRunner",
	"ReplicatedStorage",
	"StarterGui",
	"StarterPack",
	"SoundService",
	"Workspace",
	"Players",
	"Lighting",
	"ReplicatedFirst",
	"ReplicatedStorage",
	"StarterGui",
	"StarterPack",
	"SoundService",
	"TweenService",
	"HttpService",
	"RunService",
	"TeleportService",
	"TextService",
	"LocalizationService",
	"Debris",
	"LogService",
	"CoreGui",
}

for _, name in ipairs(service_names) do
	local ok, svc = pcall(function() return game:FindService(name) end)
	if ok and svc then
		original_services[name] = svc
		wrapped_services[name]  = wrap_service(svc)
	end
end

task.spawn(function()
	while true do
		for name, svc in pairs(original_services) do
			if svc and svc.Parent then
				local newName = random_name()
				pcall(function() svc.Name = newName end)
			end
		end
		task.wait(1)
	end
end)
-- debugs :(
--task.delay(1, function()
--    print("[Check] Workspace is still accessible via GetService:", game:GetService("Workspace"))
--end)

return wrapped_services

-- // made by pulsaros and femboyis12 :)
