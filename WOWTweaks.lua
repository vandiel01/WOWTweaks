local vF = CreateFrame("Frame")
	vF:RegisterEvent("PLAYER_LOGIN")
	vF:RegisterEvent("PLAYER_MONEY")

	vF:RegisterEvent("MERCHANT_SHOW")
	
	vF:RegisterEvent("GUILDBANK_UPDATE_MONEY")
	vF:RegisterEvent("GUILDBANK_UPDATE_WITHDRAWMONEY")
	
	vF:RegisterEvent("AUCTION_HOUSE_SHOW")
	vF:RegisterEvent("OWNED_AUCTIONS_UPDATED")

vF:SetScript("OnEvent",function(self, event, ...)

	if event == "PLAYER_LOGIN" then
		-- Fix All Chat Window(s) to Never Fade
		for i=1,7 do _G["ChatFrame"..i]:SetFading(false) end
		vF:UnregisterEvent("PLAYER_LOGIN")
	end
	if ( event == "MERCHANT_SHOW" ) then
		-- Auto Repair Using Guild Bank Fund
		if ( CanWithdrawGuildBankMoney() and CanGuildBankRepair() ) then
			local repairCost, canRepair = GetRepairAllCost()
			if ( canRepair and ( repairCost > 0 ) ) then
				RepairAllItems(true) -- Use GBank Fund
				local RemainingFund = GetGuildBankWithdrawMoney() - repairCost
				local GFund = ""
				if ( IsGuildLeader() == false ) then GFund = ", GFund Left: "..GetCoinTextureString(tonumber(RemainingFund),10) end
				print("Repair: ",GetCoinTextureString(repairCost,10),GFund)
			end
		end
	end
	if event == "AUCTION_HOUSE_SHOW" then
			vAH_BOTtl = AuctionHouseFrame:CreateFontString()
			vAH_BOTtl:SetFontObject(GameFontNormal)
			vAH_BOTtl:SetPoint("BOTTOMLEFT", AuctionHouseFrame, 185, 7)
			
			vAH_BOInc = AuctionHouseFrame:CreateFontString()
			vAH_BOInc:SetFontObject(GameFontNormal)
			vAH_BOInc:SetPoint("BOTTOMRIGHT", AuctionHouseFrame, -195, 7)
	end
	if event == "OWNED_AUCTIONS_UPDATED" then
		local total = 0
		local incoming = 0
		for i = 1, C_AuctionHouse.GetNumOwnedAuctions() do
			buyout = C_AuctionHouse.GetOwnedAuctionInfo(i).buyoutAmount
			sold = C_AuctionHouse.GetOwnedAuctionInfo(i).status
			total = total + buyout
			if sold == 1 then
				incoming = incoming + buyout
			end
		end		
		AuctionValueTotal = total
		vAH_BOTtl:SetText(format("Buyout Total: |cffffffff%s|r", GetCoinTextureString(total)))
		vAH_BOInc:SetText(incoming > 0 and format("Incoming Sales: |cffffffff%s|r", GetCoinTextureString(incoming)) or "")
	end
--	if ( event == "MERCHANT_UPDATE" ) or event == "MERCHANT_FILTER_ITEM_UPDATE" ) then 
		-- Fix To Show ALL Items in the Merchant Window
--		MerchantFrame_SetFilter(MerchantFrame,1)
--	end
	
end)