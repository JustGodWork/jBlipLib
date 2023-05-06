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
    ---@param blipType number
    AddEventHandler(eEvents.BlipLib.Add, function(blipId, position, sprite, display, color, scale, range, label, job, job_grade, job2, job2_grade, route, visible, blipType)

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
                blipType
            
            );
        end

    end);

    AddEventHandler(eEvents.BlipLib.Purge, function()

        local resource = GetInvokingResource();

        if (IS_LIB) then
            jBlipLib.Purge(resource);
        end

    end);

    AddEventHandler(eEvents.BlipLib.Update, function(blipId, position, sprite, display, color, scale, range, label, job, job_grade, job2, job2_grade, route, visible, handle, blipType)

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
                visible,
                handle,
                blipType

            );
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
---@param blipId string
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

---@param resourceName string
---@param blipId string
AddEventHandler(eEvents.BlipLib.Display, function(resourceName, blipId)

    local resource = GetInvokingResource();

    if (not ENV or resource ~= lib) then return; end -- PREVENT CHEATER CALLING THIS EVENT
    if (resourceName ~= ENV.name) then return; end

    ---@type Blip
    local blip = STORED_BLIPS[blipId];
    
    if (blip) then

        if (blip.visible) then

            blip:PreloadTextures();
            blip:AddTitle();

            for i = 1, #blip.data do

                local info = blip.data[i];

                if (info.type == 2) then

                    blip:ShowIcon(

                        info.value.left, 
                        info.value.right, 
                        info.value.iconId, 
                        info.value.iconColor, 
                        info.value.checked

                    );

                else
                    blip:ShowText(info.value.left, info.value.right, info.value.type);
                end

            end

            blip:ShowDisplay(true);
            blip:UpdateDisplay();

        end

    end

end);

---@param resourceName string
---@param blipId string
AddEventHandler(eEvents.BlipLib.Clear, function(resourceName, blipId)

    local resource = GetInvokingResource();

    if (not ENV or resource ~= lib) then return; end -- PREVENT CHEATER CALLING THIS EVENT
    if (resourceName ~= ENV.name) then return; end

    ---@type Blip
    local blip = STORED_BLIPS[blipId];
    
    if (blip) then

        if (blip.visible) then
            blip:ClearDisplay();
            blip:ShowDisplay(false);
        end

    end

end);

AddEventHandler("onResourceStop", function(resourceName)
    
    if (IS_LIB) then return; end
    if (resourceName ~= ENV.name) then return; end

    TriggerEvent(eEvents.BlipLib.Purge);

end);