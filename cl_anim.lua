
local prop


-- Attachment - fem - newspaper: 0.10 -0.05 -0.20 100.0 70.0 0.0


local AttachmentNewspaperFem = {
    -- 0.07 -0.01 -0.10 100.0 70.0 0.0
    ["BoneID"] = "SKEL_R_HAND",
    ["PX"] = 0.10,
    ["PY"] = -0.05,
    ["PZ"] = -0.20,
    ["PRX"] = 100.0,
    ["PRY"] = 70.0,
    ["PRZ"] = 0.0,
}

local AttachmentBookFem = {
    ["BoneID"] = "SKEL_R_HAND",
    ["PX"] = 0.07,
    ["PY"] = 0.01,
    ["PZ"] = -0.20,
    ["PRX"] = 120.0,
    ["PRY"] = 70.0,
    ["PRZ"] = 180.0,
}

local AttachmentCardFem = {
    ["BoneID"] = "SKEL_L_HAND",
    ["PX"] = 0.07,
    ["PY"] = 0.02,
    ["PZ"] = 0.04,
    ["PRX"] = 0.0,
    ["PRY"] = 0.0,
    ["PRZ"] = 60.0,
}

-- local Attachment = {}
local Attachment = AttachmentNewspaperFem


if Config.DebugCommands then
    RegisterCommand("playReadAnimation", function(source, args, rawCommand)
        Attachment = {
            ["BoneID"] = "SKEL_L_HAND",
            ["PX"] = tonumber(args[2]),
            ["PY"] = tonumber(args[3]),
            ["PZ"] = tonumber(args[4]),
            ["PRX"] = tonumber(args[5]),
            ["PRY"] = tonumber(args[6]),
            ["PRZ"] = tonumber(args[7]),
        }

        PlayReadingAnimation(args[1])
        
    end, false)
end


function PlayReadingAnimation(readableType)

    deleteProp()

	local playerPedId = PlayerPedId()
    local pos = GetEntityCoords(playerPedId)

    local propModel
	local dict
	local anim

	if readableType=='newspaper' then
        dict = "mech_inspection@newspaper@base"
		anim = "hold"
        propModel = `s_cs_sd_newspaper01x`
        Attachment = AttachmentNewspaperFem
    elseif readableType=='book' then
		dict = "mech_inspection@newspaper@base"
		anim = "hold"
        propModel = `mp006_s_mp_book_emote01x`
        Attachment = AttachmentBookFem
	elseif readableType=='card' then
		dict = "mech_inspection@cigarette_card"
		anim = "card_idle"
        propModel = `p_cs_smallnotecard01x`
        Attachment = AttachmentCardFem
	end

    -- Load the animation
	RequestAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		Citizen.Wait(100)
	end

    -- Load the prop
    RequestModel(propModel)
    while not HasModelLoaded(propModel) do
        Citizen.Wait(100)
    end


	local boneIndex = GetEntityBoneIndexByName(playerPedId, Attachment["BoneID"])

	-- Unarm the player so the weapon doesn't interfere
	Citizen.InvokeNative(0xFCCC886EDE3C63EC, playerPedId, 2, true) -- HidePedWeapons

	TaskPlayAnim(playerPedId, dict, anim, 1.0, 1.0, -1, 10, 0.0, false, false, false)

	Citizen.Wait(3000)

	prop = CreateObject(propModel, pos.x, pos.y, pos.z, true, true, false)
	AttachEntityToEntity(prop, playerPedId, boneIndex, Attachment.PX, Attachment.PY, Attachment.PZ, Attachment.PRX, Attachment.PRY, Attachment.PRZ, true, true, false, true, 1, true)

    Citizen.CreateThread(function()
        Citizen.Wait(100)
        while isOpen do
            Citizen.Wait(500)
        end
        deleteProp()
    end)
end


function deleteProp()
    if prop ~= nil then
        DeleteObject(prop)
        SetEntityAsNoLongerNeeded(prop)
        prop = nil
        ClearPedTasks(PlayerPedId())
    end
end

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
    deleteProp()
    ClearPedTasks(PlayerPedId())
end)