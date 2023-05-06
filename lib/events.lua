--[[
----
----Created Date: 2:41 Saturday May 6th 2023
----Author: JustGod
----Made with ❤
----
----File: [events]
----
----Copyright (c) 2023 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

local lib = "jBlipLib";
STORED_BLIPS = {};
local IS_LIB = jBlipLib ~= nil;
local GetInvokingResource = GetInvokingResource;

if (IS_LIB) then

    ---@param resourceName string
    ---@param blipId number
    ---@param position Vector3
    ---@param sprite number
    ---@param display number
    ---@param color number
    ---@param scale number
    ---@param range number
    ---@param label string
    ---@param job string
    ---@param job_grade number
    ---@param job2 string
    ---@param job2_grade number
    ---@param route boolean
    ---@param visible boolean
    ---@param force_hide boolean
    AddEventHandler(eEvents.BlipLib.Add, function(blipId, position, sprite, display, color, scale, range, label, job, job_grade, job2, job2_grade, route, visible, force_hide)

        local resource = GetInvokingResource();
        
        if (IS_LIB) then
            jBlipLib.AddBlip(
                
                resource, 
                blipId, 
                position, 
                sprite, 
                display, 
                color, 
                scale, 
                range, 
                label, 
                job, 
                job_grade, 
                job2, 
                job2_grade, 
                route, 
                visible,
                force_hide
            
            );
        end

    end);

    AddEventHandler(eEvents.BlipLib.Purge, function()

        local resource = GetInvokingResource();

        if (IS_LIB) then
            jBlipLib.Purge(resource);
        end

    end);

    AddEventHandler(eEvents.BlipLib.Update, function(blipId, position, sprite, display, color, scale, range, label, job, job_grade, job2, job2_grade, route, visible)

        local resource = GetInvokingResource();

        if (IS_LIB) then
            jBlipLib.UpdateBlip(

                resource, 
                blipId, 
                position, 
                sprite, 
                display, 
                color, 
                scale, 
                range, 
                label, 
                job, 
                job_grade, 
                job2, 
                job2_grade, 
                route, 
                visible

            );
        end

    end);

    AddEventHandler(eEvents.BlipLib.UpdateSingle, function(blipId, key, value)

        local resource = GetInvokingResource();

        if (IS_LIB) then
            jBlipLib.SetValue(resource, blipId, key, value);
        end

    end);

end


---@param resourceName string
---@param blipId string
AddEventHandler(eEvents.BlipLib.Show, function(resourceName, blipId)

    local resource = GetInvokingResource();

    if (IS_LIB) then
        jBlipLib.ShowBlip(resourceName, blipId);
    else

        if (not ENV or resource ~= lib) then return; end -- PREVENT CHEATER CALLING THIS EVENT
        if (resourceName ~= ENV.name) then return; end

        ---@type Blip
        local blip = STORED_BLIPS[blipId];

        if (blip) then

            if (not blip.visible) then
                blip:Show();
            end

        end
        
    end

end);

---@param resourceName string
---@param zoneId string
AddEventHandler(eEvents.BlipLib.Hide, function(resourceName, blipId)

    local resource = GetInvokingResource();

    if (IS_LIB) then
        jBlipLib.RemoveBlip(resourceName, blipId);
    else

        if (not ENV or resource ~= lib) then return; end -- PREVENT CHEATER CALLING THIS EVENT
        if (resourceName ~= ENV.name) then return; end

        ---@type Blip
        local blip = STORED_BLIPS[blipId];
        
        if (blip) then

            if (blip.visible) then
                blip:Hide();
            end

        end
        
    end

end);

AddEventHandler("onResourceStop", function(resourceName)
    
    if (IS_LIB) then return; end
    if (resourceName ~= ENV.name) then return; end

    TriggerEvent(eEvents.BlipLib.Purge);

end);