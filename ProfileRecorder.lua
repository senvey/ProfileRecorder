--[[

	ProfileRecorder, record user's info so that it could be browsed offline.
	Copyright 2007 Senvey Lee
	Email me at senvey@gmail.com

	This file is part of ProfileRecorder.

	ProfileRecorder is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	ProfileRecorder is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with ProfileRecorder; if not, write to the Free Software
	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

--]]

-- ProfileRecorder, record user's info so that it could be browsed offline.
-- Author: Senvey Lee
-- Email: senvey@gmail.com

------------------------------------------

PROFILE_RECORDER_VERSION = GetAddOnMetadata("ProfileRecorder", "Version");

UNIT_PLAYER = "player";
TOOLTIP_NAME = "ProfileRecorderScanningTooltip";

local DefaultProfileRecorderOptions = {
	["Version"] = PROFILE_RECORDER_VERSION,

	["ButtonShown"] = true,
	["ButtonPosition"] = 30,
	["ButtonRadius"] = 78,

	["Individual"] = true,
};

------------------------------------------

--[[
-- Debug Methods
function message(text)
	if (text) then
		DEFAULT_CHAT_FRAME:AddMessage(text);
	else
		DEFAULT_CHAT_FRAME:AddMessage("NIL PARAMETER!");
	end
end
-- End
--]]

-- Code by Grayhoof (SCT)
function CloneTable(t)				-- return a copy of the table t
	local new = {};					-- create a new table
	local i, v = next(t, nil);		-- i is an index of t, v = t[i]
	while i do
		if type(v)=="table" then 
			v=CloneTable(v);
		end 
		new[i] = v;
		i, v = next(t, i);			-- get next index
	end
	return new;
end
-- Code End


function ProfileRecorder_Init()

	if (event == "ADDON_LOADED" and arg1 == "ProfileRecorder") then
		-- clear saved vars for a new version (or a new install!)
		if ( ProfileRecorderOptions == nil or ProfileRecorderOptions["Version"] ~= PROFILE_RECORDER_VERSION) then
			ProfileRecorder_FreshOptions();
		end

		if (ProfileRecorderOptions.ButtonShown) then
			ProfileRecorderFrame:Show();
		else
			ProfileRecorderFrame:Hide();
		end

		ProfileRecorder_UpdatePosition();
	end

end


function ProfileRecorder_FreshOptions()
	ProfileRecorderOptions = CloneTable(DefaultProfileRecorderOptions);
end

function ProfileRecorder_UpdatePosition()
	ProfileRecorderFrame:SetPoint(
		"TOPLEFT",
		"Minimap",
		"TOPLEFT",
		54 - (ProfileRecorderOptions.ButtonRadius * cos(ProfileRecorderOptions.ButtonPosition)),
		(ProfileRecorderOptions.ButtonRadius * sin(ProfileRecorderOptions.ButtonPosition)) - 55
	);
end

function ProfileRecorderButton_BeingDragged()
    local xpos,ypos = GetCursorPosition() 
    local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom() 

    xpos = xmin-xpos/UIParent:GetScale()+70 
    ypos = ypos/UIParent:GetScale()-ymin-70 

    ProfileRecorderButton_SetPosition(math.deg(math.atan2(ypos,xpos)));
end

function ProfileRecorderButton_SetPosition(v)
    if(v < 0) then
        v = v + 360;
    end

    ProfileRecorderOptions.ButtonPosition = v;
    ProfileRecorder_UpdatePosition();
end

function ProfileRecorderButton_OnEnter()
    GameTooltip:SetOwner(this, "ANCHOR_LEFT");
    GameTooltip:SetText(PR_BUTTON_TOOLTIP_TITLE);
    GameTooltipTextLeft1:SetTextColor(1, 1, 1);
    GameTooltip:AddLine(PR_BUTTON_TOOLTIP_HINT);
    GameTooltip:Show();
end


-- Main function of this add-on.
-- Collect user's info about Character, Bags, Bank and so on.
function ProfileRecorderButton_OnClick()
	ProfileDetails = {};

	ProfileDetails["Time"] = date("%m/%d/%Y %H:%M:%S");
	local hours, minutes = GetGameTime();					-- returns hours, minutes;
	ProfileDetails["GameTime"] = hours .. ":" .. minutes;
	ProfileDetails["Realm"] = GetRealmName();
	local englishFaction, localizedFaction = UnitFactionGroup(UNIT_PLAYER);	-- e.g., "Alliance"
	ProfileDetails["Faction"] = {
		["En"] = englishFaction,
		["Localized"] = localizedFaction,
	};

-- BasicInfo
	ProfileDetails["BasicInfo"] = {};
	ProfileDetails["BasicInfo"]["Name"] = UnitName(UNIT_PLAYER);	-- return name & realm (realm be nil when from own realm)
	ProfileDetails["BasicInfo"]["Level"] = UnitLevel(UNIT_PLAYER);

	local sex = UnitSex(UNIT_PLAYER);				-- 1 = Neutrum / Unknown; 2 = Male; 3 = Female
	if (sex == 2) then 
		sex = { ["En"] = "Male", ["Localized"] = PR_Details_Sex_Male};
	elseif (sex == 3) then
		sex = { ["En"] = "Female", ["Localized"] = PR_Details_Sex_Female};
	end
	ProfileDetails["BasicInfo"]["Sex"] = sex;

	local localizedRace, enlishRace = UnitRace(UNIT_PLAYER);	-- e.g., "Human" or "Troll"; race, raceEn [Note for undead: race returns "Undead" but raceEn returns "Scourge".]
	ProfileDetails["BasicInfo"]["Race"] = {
		["En"] = enlishRace,
		["Localized"] = localizedRace,
	};

	local localizedClass, englishClass = UnitClass(UNIT_PLAYER);	-- e.g., "Warrior" or "Shaman"
	ProfileDetails["BasicInfo"]["Class"] = {
		["En"] = englishClass,
		["Localized"] = localizedClass,
	};

	local guildName, guildRankName, guildRankIndex = GetGuildInfo(UNIT_PLAYER);
	ProfileDetails["BasicInfo"]["GuildInfo"] = {
		["GuildName"] = guildName,
		["GuildRankName"] = guildRankName,
		["GuildRandIndex"] = guildRankIndex,			-- Integer - unit's rank (index). - zero based index 
	}

-- Character
	-- 0 - (Physical) - Armor rating
	-- 1 - (Holy)
	-- 2 - (Fire)
	-- 3 - (Nature)
	-- 4 - (Frost)
	-- 5 - (Shadow)
	-- 6 - (Arcane)
	local RESISTANCE_TYPES = { [2] = "Fire", [3] = "Nature", [4] = "Frost", [5] = "Shadow", [6] = "Arcane" };
	local tblResistance, base, total, bonus, minus = { };
	for i = 2, 6 do
		base, total, bonus, minus = UnitResistance(UNIT_PLAYER, i);	-- base, total, bonus, minus
		tblResistance[RESISTANCE_TYPES[i]] = {
			["Base"] = base, ["Total"] = total, ["Bonus"] = bonus, ["Minus"] = minus,
		};
	end

	local INVENTORY_SLOT_NAMES = {
		"HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot", "TabardSlot", "WristSlot",
		"HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot",
		"MainHandSlot", "SecondaryHandSlot", "RangedSlot", "AmmoSlot"
	}
	local tblInventoryItems = { };
	for i = 1, #(INVENTORY_SLOT_NAMES) do
		local slotName = INVENTORY_SLOT_NAMES[i];
		tblInventoryItems[slotName] = PR_GetInventorySlot(slotName);
	end

	local POWER_TYPES = { [0] = "Mana", [1] = "Rage", [2] = "Focus", [3] = "Energy", [4] = "Happiness" };
	ProfileDetails["Character"] = {
		["HP"] = {
			["Max"] = UnitHealthMax(UNIT_PLAYER),
			["Percentage"] = ceil(UnitHealth(UNIT_PLAYER) / UnitHealthMax(UNIT_PLAYER) * 100),
		},
		["Power"] = {
			["Type"] = POWER_TYPES[UnitPowerType(UNIT_PLAYER)],
			["Value"] = {
				["Max"] = UnitManaMax(UNIT_PLAYER),
				["Percentage"] = ceil(UnitMana(UNIT_PLAYER) / UnitManaMax(UNIT_PLAYER) * 100),
			},
		},
		["Resistance"] = tblResistance,
		["InventoryItems"] = tblInventoryItems,
	};

-- Bags
	-- Mainly use GetContainerItemLink to retrieve ItemLink in bags.
	-- However, also use GetInventorySlotInfo & GetInventoryItemLink to get info of bag itself.

	-- BagId:
	-- 0 is your backpack
	-- 1 -- NUM_BAG_SLOTS are your bags
	-- KEYRING_CONTAINER is the keyring
	-- BANK_CONTAINER is the bank window 
	-- NUM_BAG_SLOTS+1 -- NUM_BAG_SLOTS+NUM_BANKBAGSLOTS are your bank bags 

	local BAG_NAMES = {
		[0] = "Backpack", [1] = "Bag1", [2] = "Bag2", [3] = "Bag3", [4] = "Bag4", [-2] = "KeyRing", [-1] = "Bank",
		[5] = "BankBag1", [6] = "BankBag2", [7] = "BankBag3", [8] = "BankBag4", [9] = "BankBag5", [10] = "BankBag6", [11] = "BankBag7"
	}

	ProfileDetails["Bags"] = { };

	-- Have no idea how to retrieve default textures for backpack and container items,
	-- so these two kinds of textures are hard-code here.
	ProfileDetails["Bags"]["DefaultTexture"] = { };
	local defaultTexture;
	_, defaultTexture = GetInventorySlotInfo("Bag0Slot");
	ProfileDetails["Bags"]["DefaultTexture"]["Backpack"] = "interface\\icons\\INV_Misc_Bag_08.blp";
	ProfileDetails["Bags"]["DefaultTexture"]["BagSlot"] = defaultTexture;
	ProfileDetails["Bags"]["DefaultTexture"]["ItemSlot"] = "interface\\paperdoll\\UI-Backpack-EmptySlot.blp";

	-- Portable bags and KeyRing
	for bagId = 0, NUM_BAG_SLOTS do
		local bagInfo;
		if (bagId == 0) then
			bagInfo = nil;
		else
			bagInfo = PR_GetItemInfo(
				GetInventoryItemLink(UNIT_PLAYER, ContainerIDToInventoryID(bagId)),
				ContainerIDToInventoryID(bagId));
		end
		ProfileDetails["Bags"][BAG_NAMES[bagId]] = {
			["BagId"] = bagId,
			["Bag"] = bagInfo,
			["Content"] = PR_GetBagContent(bagId),
		};
	end
	ProfileDetails["Bags"][BAG_NAMES[KEYRING_CONTAINER]] = PR_GetBagContent(KEYRING_CONTAINER);

	-- Bank and BankBags
	ProfileDetails["Bags"][BAG_NAMES[BANK_CONTAINER]] = PR_GetBagContent(BANK_CONTAINER);
	if (NUM_BANKBAGSLOTS > 0) then
		for bagId = NUM_BAG_SLOTS+1, NUM_BAG_SLOTS+NUM_BANKBAGSLOTS do
			ProfileDetails["Bags"][BAG_NAMES[bagId]] = {
				["BagId"] = bagId,
				["Bag"] = PR_GetItemInfo(
					GetInventoryItemLink(UNIT_PLAYER, ContainerIDToInventoryID(bagId)),
					ContainerIDToInventoryID(bagId)),
				["Content"] = PR_GetBagContent(bagId),
			}
		end
	end

--Factions

-- Talent

-- End
	DEFAULT_CHAT_FRAME:AddMessage("|cFF0099FF" .. PR_NAME .. ":|r " .. PR_ProfileSaved);
end


-- Helper Methods
function PR_GetInventorySlot(slotName)
	local slotId, soltTexturePath = GetInventorySlotInfo(slotName);
	local itemLink = GetInventoryItemLink(UNIT_PLAYER, slotId);

	local slot = {
		-- SlotId, ItemLink are not actually used for display so far.
		-- ["SlotId"] = slotId,
		-- ["ItemLink"] = itemLink,

		["DefaultTexture"] = soltTexturePath,
		["Item"] = PR_GetItemInfo(itemLink, slotId),
	};

	return slot;
end

function PR_GetBagContent(bagId)
	local bagContent = { };

	local slotsNum = GetContainerNumSlots(bagId);
	local blankSlotsNum = 4 - slotsNum % 4;

	-- Insert blank slot(s) for display.
	if (blankSlotsNum < 4) then
		local blankSlot = { ["SlotId"] = 0 };
		for counter = 1, blankSlotsNum do
			tinsert(bagContent, blankSlot);
		end
	end

	local texture, itemCount, locked, quality, readable;
	for slotId = 1, slotsNum do
		texture, itemCount, locked, quality, readable = GetContainerItemInfo(bagId, slotId);
		tinsert(bagContent, {
			["SlotId"] = slotId,
			["ItemCount"] = itemCount,
			["Item"] = PR_GetItemInfo(GetContainerItemLink(bagId, slotId)),
		});
	end

	return bagContent;
end

function PR_GetItemInfo(itemLink, slotId)
	-- MinLevel, Type, SubType, StackCount, EquipLoc are not actually used for display so far.
	local itemName,
		itemQuality,	-- Integer - The numeric ID of the quality from 0 (Poor) to 6 (Artifact). Quality names are ITEM_QUALITY<num>_DESC.
		itemLevel,
		itemMinLevel,	-- The minimum level required to use the item, 0 meaning no level requirement.
		itemType,	-- The type of the item: Armor, Weapon, Quest, Key, etc.
		itemSubType,	-- The sub-type of the item: Enchanting, Cloth, Sword, etc.
		itemStackCount,	-- How many of the item per stack: 20 for Runecloth, 1 for weapon, etc.
		itemEquipLoc,	-- Where the item may be equipped, if it can. If not equippable, this is an empty string. The string returned is also the name of a global string variable.
		itemTexture;

	if (itemLink ~= nil) then
		itemName, _, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(itemLink);
	end
	local item = {
		["Name"] = itemName,
		["Quality"] = itemQuality,
		["Level"] = itemLevel,
		-- ["MinLevel"] = itemMinLevel,
		-- ["Type"] = itemType,
		-- ["SubType"] = itemSubType,
		-- ["StackCount"] = itemStackCount,
		-- ["EquipLoc"] = {
		--	["En"] = itemEquipLoc,
		--	["Localized"] = getglobal(itemEquipLoc),
		-- },
		["Texture"] = itemTexture,
		["Tooltip"] = PR_GetTooltip(itemLink, slotId),
	}

	return item;
end

function PR_GetTooltip(itemLink, slotId)

	-- message(itemLink);
	if (itemLink == nil) then return; end

	-- use scanning tootip to get infomation of inventory items
	local UITooltip = getglobal(TOOLTIP_NAME);
	UITooltip:SetOwner(UIParent, "ANCHOR_NONE");
	if (ProfileRecorderOptions["Individual"] and slotId ~= nil) then
		UITooltip:SetInventoryItem(UNIT_PLAYER, slotId);
	else
		UITooltip:SetHyperlink(itemLink);
	end
	local tooltip = { };

	for i = 1, UITooltip:NumLines() do
		local leftText, rightText =
			getglobal(TOOLTIP_NAME .. "TextLeft" .. i),
			getglobal(TOOLTIP_NAME .. "TextRight" .. i);
		tooltip["Line"..i] = { };
		tooltip["Line"..i]["Line"] = i;
		tooltip["Line"..i]["Left"] = { };
		tooltip["Line"..i]["Right"] = { };
		tooltip["Line"..i]["Left"]["Text"], tooltip["Line"..i]["Left"]["Color"] =
			HandleTextWithColor(leftText:GetText(), leftText:GetTextColor());
		tooltip["Line"..i]["Right"]["Text"], tooltip["Line"..i]["Right"]["Color"] =
			HandleTextWithColor(rightText:GetText(), rightText:GetTextColor());
	end

	for i = 1, 10 do	-- 10 Texture elements defined in GameTooltipTemplate. Don't know how to analyze how many used so far.
		local texture = getglobal(TOOLTIP_NAME .. "Texture" .. i);
		if (texture ~= nil) then
			local texturePath = texture:GetTexture();
			if (texturePath ~= nil) then
				local point, relativeTo, relativePoint, xOfs, yOfs = texture:GetPoint();
				local relativeName, preLen = relativeTo:GetName(), strlen(TOOLTIP_NAME .. "Text");
				local lineNum = strsub(relativeName, strlen(relativeName) - 1);
				if (tonumber(lineNum) == nil) then
					lineNum = strsub(relativeName, strlen(relativeName));
				end
				local loc = strsub(relativeName, preLen + 1, strlen(relativeName) - strlen(lineNum));
				-- message("==========");
				-- message("RelativeTo: "..relativeName);
				-- message("Line: "..lineNum.." AND Loc: "..loc);
				-- message("  --Texture: "..texturePath);
				-- message("==========");

				tooltip["Line"..lineNum][loc]["Texture"] = { };
				tooltip["Line"..lineNum][loc]["Texture"]["Path"] = gsub(texturePath, "\\", "/");
				tooltip["Line"..lineNum][loc]["Texture"]["Point"] = point;
				tooltip["Line"..lineNum][loc]["Texture"]["RelativePoint"] = relativePoint;
				tooltip["Line"..lineNum][loc]["Texture"]["OffsetX"] = xOfs;
				tooltip["Line"..lineNum][loc]["Texture"]["OffsetY"] = yOfs;
				
				texture:SetTexture(nil);
			end
		end
	end

	return tooltip;
end

function HandleTextWithColor(text, r, g, b, alpha)
	if (text == nil) then return; end

	local color;
	if (strfind(text, "|c") ~= nil) then
		local beginIndex = strfind(text, "|c") + 2;
		local endIndex = beginIndex + 7;
		local innerColor = strsub(text, beginIndex, endIndex);
		color = {
			["R"] = string.sub(innerColor, 3, 4),
			["G"] = string.sub(innerColor, 5, 6),
			["B"] = string.sub(innerColor, 7, 8),
			["Alpha"] = tonumber(string.sub(innerColor, 1, 2), 16) / 255 * 100,
		};

		beginIndex = endIndex + 1;
		endIndex = strfind(text, "|r") - 1;
		text = strsub(text, beginIndex, endIndex);
	else
		color = PR_GetColorCodeByRGB(r, g, b, alpha);
	end

	return gsub(gsub(gsub(text or "", "<", "&amp;lt;"), ">", "&amp;gt;"), "\r\n", "<br/>"), color;
		
end

function PR_GetColorCodeByRGB(r, g, b, alpha)
	return {
		["R"] = string.format("%02x", 255 * (r <= 1 and r >= 0 and r or 0)),
		["G"] = string.format("%02x", 255 * (g <= 1 and g >= 0 and g or 0)),
		["B"] = string.format("%02x", 255 * (b <= 1 and b >= 0 and b or 0)),
		["Alpha"] = alpha * 100,
	};
end
-- End of Helper Methods