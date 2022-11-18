local vF = CreateFrame("Frame")
vF:RegisterEvent("MERCHANT_SHOW")
vF:RegisterEvent("PLAYER_LOGIN")

vF:SetScript("OnEvent",function(self, event, ...)
	if event == "MERCHANT_SHOW" then
		-- Fix To Show ALL Items in the Merchant Window
		MerchantFrame_SetFilter(MerchantFrame,1)
		for bag = 0, 4 do
			for slot = 1, C_Container.GetContainerNumSlots(bag) do
				local name = C_Container.GetContainerItemLink(bag,slot)
				if name and string.find(name,"ff9d9d9d") then C_Container.UseContainerItem(bag,slot) end
			end
		end
	end
	if event == "PLAYER_LOGIN" then
		-- Fix All Chat Window(s) to Never Fade
		for i=1,7 do _G["ChatFrame"..i]:SetFading(false) end
		vF:UnregisterEvent("PLAYER_LOGIN")
	end
end)