--[[
----
----Created Date: 12:07 Sunday February 19th 2023
----Author: JustGod
----Made with ❤
----
----File: [Blip]
----
----Copyright (c) 2023 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

local _RemoveBlip = RemoveBlip;
local _AddTextEntry = AddTextEntry;
local _SetBlipSprite = SetBlipSprite;
local _SetBlipCoords = SetBlipCoords;
local _SetBlipScale = SetBlipScale;
local _SetBlipRoute = SetBlipRoute;
local _SetBlipColour = SetBlipColour;
local _SetBlipDisplay = SetBlipDisplay;
local _AddBlipForCoord = AddBlipForCoord;
local _SetBlipAsShortRange = SetBlipAsShortRange;
local _BeginTextCommandSetBlipName = BeginTextCommandSetBlipName;
local _AddTextComponentSubstringPlayerName = AddTextComponentSubstringPlayerName;
local _EndTextCommandSetBlipName = EndTextCommandSetBlipName;

--AddTextEntryByHash(`BLIP_OTHPLYR`, "Farming")
--AddTextEntryByHash(`BLIP_PROPCAT`, "Entreprise")
--AddTextEntryByHash(`BLIP_APARTCAT`, "Service")

---doc: https://docs.fivem.net/natives/?_0x9029B2F3DA924928
---@class Blip: BaseObject
---@field public id string
---@field public position Vector3
---@field public sprite eBlipSprite
---@field public display number
---@field public color eBlipColor
---@field public scale number
---@field public range boolean
---@field public label string
---@field public job string
---@field public job_grade number
---@field public job2 string
---@field public job2_grade number
---@field public route boolean
---@field public visible boolean
---@field public type string
---@overload fun(position: Vector3): Blip
Blip = Class.new 'Blip';

function Blip:Constructor(position, info)

    self.id = uuid();
    self.position = position or Vector3(0, 0, 0);
    self.sprite = 1;
    self.display = 2;
    self.color = 49;
    self.scale = 0.6;
    self.range = true;
    self.label = "No Label set";
    self.job = nil;
    self.job_grade = nil;
    self.job2 = nil;
    self.job2_grade = nil;
    self.route = false;
    self.visible = false;
    self.type = info or "blip";

    STORED_BLIPS[self.id] = self;
    TriggerEvent(eEvents.BlipLib.Add, 

        self.id, 
        self.position, 
        self.sprite, 
        self.display, 
        self.color, 
        self.scale, 
        self.range, 
        self.label, 
        self.job, 
        self.job_grade, 
        self.job2, 
        self.job2_grade, 
        self.route, 
        self.visible,
        self.type

    );

end

---@private
function Blip:SendUpdate()
    TriggerEvent(eEvents.BlipLib.Update, 

        self.id, 
        self.position, 
        self.sprite, 
        self.display, 
        self.color, 
        self.scale, 
        self.range, 
        self.label, 
        self.job, 
        self.job_grade, 
        self.job2, 
        self.job2_grade, 
        self.route, 
        self.visible,
        self.handle,
        self.type

    );
end

---Show the blip in game
---@private
function Blip:Show()
    if (not self.visible) then
        self.handle = _AddBlipForCoord(self.position.x, self.position.y, self.position.z);
        _SetBlipSprite(self.handle, self.sprite);
        _SetBlipDisplay(self.handle, self.display);
        _SetBlipScale(self.handle, self.scale);
        _SetBlipColour(self.handle, self.color);
        _SetBlipAsShortRange(self.handle, self.range);
        _AddTextEntry('BLIP'..self.id, '~a~');
        _BeginTextCommandSetBlipName('BLIP'..self.id);
        _AddTextComponentSubstringPlayerName(self.label);
        _EndTextCommandSetBlipName(self.handle);
        _SetBlipRoute(self.handle, self.route);
        self:SetVisible(true);
        self:SendUpdate();
    end
    return self;
end

---@param job string
---@param grade number
function Blip:SetJob(job, grade)
    self.job = job;
    self.job_grade = grade;
    self:SendUpdate();
    return self;
end

---@param job2 string
---@param grade number
function Blip:SetJob2(job2, grade)
    self.job2 = job2;
    self.job2_grade = grade;
    self:SendUpdate();
    return self;
end

---@private
function Blip:Update()
    if (self:IsVisible()) then
        self:Hide();
        self:Show();
    end
    return self;
end

---Hide blip but dont delete his data to show him later
---@private
function Blip:Hide()
    if (self.visible) then
        if (DoesBlipExist(self.handle)) then
            _RemoveBlip(self.handle);
        end
        self.handle = nil;
        self:SetVisible(false);
    end
    return self;
end

---@return boolean 
function Blip:IsVisible()
    return self.visible;
end

---@private
---@param bool boolean
function Blip:SetVisible(bool)
    self.visible = bool;
    return self;
end

---@param position Vector3
function Blip:SetPosition(position)
    self.position = position;
    if (self.handle) then
        _SetBlipCoords(self.handle, position.x, position.y, position.z);
        self:Update();
    end
    return self;
end

---@param toggle boolean
function Blip:SetRoute(toggle)
    self.route = toggle;
    if (self.handle) then
        _SetBlipRoute(self.handle, toggle);
        self:Update();
    end
    return self;
end

---0 = Doesn't show up, ever, anywhere. 
---1 = Doesn't show up, ever, anywhere. 
---2 = Shows on both main map and minimap. (Selectable on map)
---3 = Shows on main map only. (Selectable on map) 
---4 = Shows on main map only. (Selectable on map) 
---5 = Shows on minimap only. 
---6 = Shows on both main map and minimap. (Selectable on map) 
---7 = Doesn't show up, ever, anywhere. 
---8 = Shows on both main map and minimap. (Not selectable on map) 
---9 = Shows on minimap only. 
---10 = Shows on both main map and minimap. (Not selectable on map) 
---Anything higher than 10 seems to be exactly the same as 10. 
---Rockstar seem to only use 0, 2, 3, 4, 5 and 8 in the decompiled scripts.
---@param display number 
function Blip:SetDisplay(display)
    self.display = display;
    if (self.handle) then
        _SetBlipDisplay(self.handle, display);
        self:Update();
    end
    return self;
end

---@param color eBlipColor https://docs.fivem.net/docs/game-references/blips/#classColors
function Blip:SetColor(color)
    self.color = color;
    if (self.handle) then
        _SetBlipColour(self.handle, color);
        self:Update();
    end
    return self;
end

---@param sprite eBlipSprite https://docs.fivem.net/docs/game-references/blips/
function Blip:SetSprite(sprite)
    self.sprite = sprite;
    if (self.handle) then
        _SetBlipSprite(self.handle, sprite);
        self:Update();
    end
    return self;
end

---@param scale number @/!\ Scale is between 0.6 and 2.0 /!\
function Blip:SetScale(scale)
    self.scale = scale;
    if (self.handle) then
        _SetBlipScale(self.handle, scale);
        self:Update();
    end
    return self;
end

---@param range boolean Sets whether or not the specified blip 
---should only be displayed when nearby, or on the minimap.
function Blip:SetHasShortRange(range)
    self.range = range;
    if (self.handle) then
        _SetBlipAsShortRange(self.handle, range);
        self:Update();
    end
    return self;
end

---@param label string
function Blip:SetLabel(label)
    self.label = label;
    if (self.handle) then
        _AddTextEntry('BLIP'..self.id, '~a~');
        _BeginTextCommandSetBlipName('BLIP'..self.id);
        _AddTextComponentSubstringPlayerName(self.label);
        _EndTextCommandSetBlipName(self.handle);
        self:Update();
    end
    return self;
end