--[[
----
----Created Date: 2:40 Saturday May 6th 2023
----Author: JustGod
----Made with ❤
----
----File: [index]
----
----Copyright (c) 2023 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

jBlipLib = {};
local blips = {};
local DEBUG = GetConvar('jClassLib_DEBUG', 'false') == 'true';
local currentBlip;
local pause_active = false;

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
function jBlipLib.AddBlip(resourceName, blipId, position, sprite, display, color, scale, range, label, job, job_grade, job2, job2_grade, route, visible, blipType)
    
    blips[resourceName] = blips[resourceName] or {};
    blips[resourceName][blipId] = {

        position = Vector3(position.x, position.y, position.z),
        sprite = sprite,
        display = display,
        color = color,
        scale = scale,
        range = range,
        label = label,
        job = job,
        job_grade = job_grade,
        job2 = job2,
        job2_grade = job2_grade,
        route = route,
        visible = visible,
        type = blipType

    };

    if (DEBUG) then
        console.debug("^7(^3jBlipLib^7) ^0=> Added blip: ^1" .. blipId .. "^0 from resource: ^1" .. resourceName .. "^0");
    end

end

---@param resourceName string
---@param blipId number
function jBlipLib.ShowBlip(resourceName, blipId)
    if (Value.IsValid(blips[resourceName], Value.Types.Table)) then
        if (Value.IsValid(blips[resourceName][blipId], Value.Types.Table)) then
            blips[resourceName][blipId].visible = true;

            if (DEBUG) then
                console.debug("^7(^3jBlipLib^7) ^0=> Showed blip: ^1" .. blipId .. "^0 from resource: ^1" .. resourceName .. "^0");
            end

        end
    end
end

---@param resourceName string
---@param blipId number
function jBlipLib.RemoveBlip(resourceName, blipId)
    if (Value.IsValid(blips[resourceName], Value.Types.Table)) then
        if (Value.IsValid(blips[resourceName][blipId], Value.Types.Table)) then
            blips[resourceName][blipId].visible = false;

            if (DEBUG) then
                console.debug("^7(^3jBlipLib^7) ^0=> Removed blip: ^1" .. blipId .. "^0 from resource: ^1" .. resourceName .. "^0");
            end

        end
    end
end

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
---@param handle number
---@param blipType number
function jBlipLib.UpdateBlip(resourceName, blipId, position, sprite, display, color, scale, range, label, job, job_grade, job2, job2_grade, route, visible, handle, blipType)
    if (Value.IsValid(blips[resourceName], Value.Types.Table)) then
        if (Value.IsValid(blips[resourceName][blipId], Value.Types.Table)) then

            blips[resourceName][blipId] = {

                position = Vector3(position.x, position.y, position.z),
                sprite = sprite,
                display = display,
                color = color,
                scale = scale,
                range = range,
                label = label,
                job = job,
                job_grade = job_grade,
                job2 = job2,
                job2_grade = job2_grade,
                route = route,
                visible = visible,
                handle = handle,
                type = blipType
        
            };

            if (DEBUG) then
                console.debug("^7(^3jBlipLib^7) ^0=> Updated blip: ^1" .. blipId .. "^0 from resource: ^1" .. resourceName .. "^0");
            end

        end
    end
end

---@param resourceName string
function jBlipLib.Purge(resourceName)
    blips[resourceName] = nil;

    if (DEBUG) then
        console.debug("^7(^3jBlipLib^7) ^0=> Purged zones from resource: ^1" .. resourceName .. "^0");
    end

end

---@return boolean
local function IsESXReady()
    return ENV.ESX and Value.IsValid(ESX.PlayerData, Value.Types.Table);
end

---@param job string
---@param grade number
local function IsJobValid(job, grade)
    return (type(job) == "string" and type(grade) == "number");
end

---@param jobType string
---@param job string
---@param grade number
---@return boolean
local function HasJob(jobType, job, grade)

    local player = ESX.PlayerData;

    if (not Value.IsValid(player[jobType], Value.Types.Table)) then return false; end
    if (grade == nil) then return player[jobType].name == job; end
    return (player[jobType].name == job) and (player[jobType].grade >= grade);

end

---@param job string
---@param jobGrade number
---@param job2 string
---@param job2Grade number
---@return boolean
local function PlayerAllowed(job, jobGrade, job2, job2Grade)
    if (not IsJobValid(job, jobGrade) and not IsJobValid(job2, job2Grade)) then return true; end
    return (HasJob("job", job, jobGrade) or HasJob("job2", job2, job2Grade));
end

---@return table, string
local function GetBlipInfoByHandle(handle)
    for resourceName, resourceBlips in pairs(blips) do
        for blipId, blip in pairs(resourceBlips) do
            if (blip.type == "info" and blip.handle == handle) then
                return blip, resourceName;
            end
        end
    end
end

---@return table, string
local function GetLastBlip()
    for resourceName, resourceBlips in pairs(blips) do
        for blipId, blip in pairs(resourceBlips) do
            if (blip.type == "info" and blip.handle == currentBlip) then
                return blip, resourceName;
            end
        end
    end
end

local function StartInfoThread()
    CreateThread(function()
        while pause_active do

            if (IsFrontendReadyForControl()) then

                local _blip = GetNewSelectedMissionCreatorBlip();

                if (IsHoveringOverMissionCreatorBlip()) then

                    if (DoesBlipExist(_blip)) then

                        if (currentBlip ~= _blip) then

                            local oldBlip, oldResource = GetLastBlip();

                            if (oldBlip) then
                                TriggerEvent(eEvents.BlipLib.Clear, oldResource, oldBlip.id);
                            end

                            currentBlip = _blip;
                            TakeControlOfFrontend();

                            local blip, blipResource = GetBlipInfoByHandle(_blip);

                            if (Value.IsValid(blip, Value.Types.Table)) then
                                
                                TriggerEvent(eEvents.BlipLib.Display, blipResource, blip.id);
                                ReleaseControlOfFrontend();

                            end

                        end
                        
                    end

                else

                    if (Value.IsValid(currentBlip, Value.Types.Number)) then

                        local blip, resource = GetLastBlip();

                        if (blip) then
                            TriggerEvent(eEvents.BlipLib.Clear, resource, blip.id);
                        end
                        currentBlip = nil;

                    end

                end

            end

            Wait(0);

        end
    end);
end

jLib.PauseMenu.StateChange(function(is_active)
    
    pause_active = is_active;

    if (pause_active) then
        StartInfoThread();
    end

end);
    
CreateThread(function()
    while true do

        local ESXReady = IsESXReady();

        for resourceName, resourceBlips in pairs(blips) do

            if (Value.IsValid(resourceBlips, Value.Types.Table)) then

                for blipId, blip in pairs(resourceBlips) do

                    if (ESXReady) then

                        local allowed = PlayerAllowed(blip.job, blip.job_grade, blip.job2, blip.job2_grade);

                        if (blip.visible and not allowed) then

                            blip.visible = false;
                            TriggerEvent(eEvents.BlipLib.Hide, resourceName, blipId);

                        elseif (not blip.visible and allowed) then

                            blip.visible = true;
                            TriggerEvent(eEvents.BlipLib.Show, resourceName, blipId);

                        end

                    end

                end

            end

        end

        Wait(750);
    end
end);