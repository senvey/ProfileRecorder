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

local OUTPUT_PROFILE = "Profile.xml";

function GetElement(nodeName, t)
	if (tonumber(nodeName)) then
		nodeName = "Content" .. nodeName;
	end

	local elementBegin = "\n<" .. nodeName .. ">";
	local elementEnd = "</" .. nodeName .. ">";

	local element =
		elementBegin .. Parse(t) .. elementEnd;
	return element;
end

function Parse(t)
	if (IsTable(t)) then
		local index, content;
		local innerXml = "";
		while (true) do
			index, content = next(t, index);
			if (index == nil) then break; end

			-- print("Got index: " .. index);
			innerXml = innerXml .. string.gsub(GetElement(index, content), "\n", "\n	");
		end
		return innerXml .. "\n";
	else
		-- print("Plan content: " .. tostring(t));
		return tostring(t);
	end
end

function IsTable(t)
	local index = string.find(tostring(t), "table:");
	return (index ~= nil) and (index == 1);
end


fil, error = io.open(OUTPUT_PROFILE, "w");
if (error ~= nil) then
	print(error);
	return;
else
	fil:write('<?xml version="1.0" encoding="utf-8"?>' .. '\n');
	fil:write('<?xml-stylesheet href="Profile.xsl" type="text/xsl"?>');
end

fil:write(GetElement("ProfileDetails", ProfileDetails));
fil:close();