--[[
----
----Created Date: 4:11 Friday May 5th 2023
----Author: JustGod
----Made with ❤
----
----File: [imports]
----
----Copyright (c) 2023 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

ENV.name = GetCurrentResourceName();
local lib = "jBlipLib";

local state = GetResourceState(lib);

if (state == "missing") then
    return error(('\n^1Error: %s is missing^0'):format(lib), 0);
end

if (state ~= "started") then
    return error(('\n^1Error: %s must be started before ^5%s^0'):format(lib, ENV.name), 0);
end

if (not ENV.IS_SERVER) then

    ENV.require('lib/events.lua', lib);
    ENV.require('classes/Blip.lua', lib);

end