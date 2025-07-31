local VORPutils = {}
TriggerEvent("getUtils", function(utils)
    VORPutils = utils
    print = VORPutils.Print:initialize(print) --Initial setup 
end)
local VORPcore = {}
TriggerEvent("getCore", function(core)
    VORPcore = core
end)
MenuData = {}
TriggerEvent("menuapi:getData",function(call)
    MenuData = call
end)

local RainbowCore = exports["rainbow-core"]:initiate()

isOpen = false
local playerCoords

local PromptGroup = VORPutils.Prompts:SetupPromptGroup() --Setup Prompt Group
local Prompt


-------- THREADS

-- Make sure only talk keys are passed thru
Citizen.CreateThread(function()
    while true do
        local sleep = 500

		-- Viewing only (not editing)
        if isOpen then
            sleep = 0
			
			if IsControlJustPressed(0, 0x156F7119) then -- INPUT_FRONTEND_CANCEL (Esc)
				CloseBook()
			end
			
            DisableAllControlActions(0)
			EnableControlAction(0, 0x4BC9DABB, true) -- Enable push-to-talk
			EnableControlAction(0, 0xF3830D8E, true) -- Enable J for jugular
			EnableControlAction(0, 0x156F7119, true) -- INPUT_FRONTEND_CANCEL (Esc)
        end

        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
	Prompt = PromptGroup:RegisterPrompt("Open", 0x760A9C6F, 1, 1, true, "hold", {timedeventhash = "SHORT_TIMED_EVENT_MP"})
end)

-- Only occassionally get the player's coords (for performance)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        playerCoords = GetEntityCoords(PlayerPedId())
    end
end)

-- Check if they're nearby a coords-based book
Citizen.CreateThread(function()
    while true do
		local sleep = 100
        if playerCoords then
            
			for k,book in pairs(Config.Books) do

				if book.type == "coords" then

					local bookCoords = vector3(book.coords.x, book.coords.y, book.coords.z)
					if not isOpen and #(playerCoords.xy - bookCoords.xy) < 1.5 then

						sleep = 4

						-- Check if job-locked
						local isJobLocked = book.job and book.job ~= nil and book.job ~= "" and book.job ~= 0
						local hasJobAndGrade = false
						if isJobLocked then
							hasJobAndGrade = RainbowCore.AbsolutelyHasJobAndGradeClient(book.job, book.jobGrade)
						end

						if not isJobLocked or (isJobLocked and hasJobAndGrade) then
	
							-- if Config.ShameyDebug then print("can harvest", k) end
							PromptGroup:ShowGroup(book.label)

							if Prompt:HasCompleted() then
								OpenBook(book)
							end
	
						end

					end

				end
			end
            
        end
		Citizen.Wait(sleep)
    end
end)



-------- EVENTS

RegisterNetEvent("rainbow_book:OpenBook")
AddEventHandler("rainbow_book:OpenBook", function(book)
	if Config.ShameyDebug then print("rainbow_book:OpenBook", book) end
	OpenBook(book)
   
end)

RegisterNetEvent("rainbow_book:OpenBookPublished")
AddEventHandler("rainbow_book:OpenBookPublished", function(book)
	if Config.ShameyDebug then print("rainbow_book:OpenBookPublished", book) end
	OpenBookPublished(book)
   
end)


-------- FUNCTIONS

function OpenBook(book)
	if Config.ShameyDebug then print("OpenBook - ", book) end

	SendNUIMessage({
        type = "view",
        book = book,
    })
	SetNuiFocus(true, true)
	SetNuiFocusKeepInput(true)
	isOpen = true

	PlayReadingAnimation("book")
end

function OpenBookPublished(printableDbRecord)
	if Config.ShameyDebug then print("OpenBookPublished - ", printableDbRecord) end

	SendNUIMessage({
        type = "viewPublished",
		title = printableDbRecord.title,
        book = json.decode(printableDbRecord.data),
    })
	SetNuiFocus(true, true)
	SetNuiFocusKeepInput(true)
	isOpen = true

	PlayReadingAnimation(printableDbRecord.type)
end

function CloseBook()
	SendNUIMessage({
        type = "close",
    })
    SetNuiFocus(false, false)
    isOpen = false
end

RegisterNUICallback('closeView', function(args, cb)
	if Config.Debug then print("closeView") end
	CloseBook()
	cb('ok')
end)





--------

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end


end)
