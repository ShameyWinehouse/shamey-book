local VORPutils = {}
TriggerEvent("getUtils", function(utils)
    VORPutils = utils
    print = VORPutils.Print:initialize(print) --Initial setup 
end)
local VORPcore = {}
TriggerEvent("getCore", function(core)
    VORPcore = core
end)

local VorpInv = exports.vorp_inventory:vorp_inventoryApi()


-------- THREADS

Citizen.CreateThread(function()

    Citizen.Wait(3 * 1000)

	for k,book in pairs(Config.Books) do

		if book.type == "item" then
			local itemName = book.itemName
			local _book = book
			if Config.ShameyDebug then print("itemName", itemName) end
            VorpInv.RegisterUsableItem(itemName, function(data)
                if Config.ShameyDebug then print("book used", itemName, data.item, _book) end
				VorpInv.CloseInv(data.source)
                TriggerClientEvent("rainbow_book:OpenBook", data.source, _book)
            end)
		end

	end


	for k,bookItemName in pairs(Config.PublishableBookItems) do

		if Config.ShameyDebug then print("bookItemName", bookItemName.name) end
		VorpInv.RegisterUsableItem(bookItemName.name, function(data)
			if Config.ShameyDebug then print("publishable used", bookItemName.name, data.item) end
			VorpInv.CloseInv(data.source)

			if not data.item.metadata.printableId then
				return
			end

			-- Get the printable's DB record, in order to retreieve the printable's "pages" data
			local printableDbRecord = fetchPrintableFromDbById(data.item.metadata.printableId)

			TriggerClientEvent("rainbow_book:OpenBookPublished", data.source, printableDbRecord)
		end)

	end

end)


function fetchPrintableFromDbById(printableId)
    local row = MySQL.single.await('SELECT * FROM `printables` WHERE `id` = ? LIMIT 1', {
        printableId
    })
    if not row then return false end
    return row
end


-------- EVENTS




-------- FUNCTIONS



--------

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end

end)