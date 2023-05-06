--[[
----
----Created Date: 4:17 Saturday May 6th 2023
----Author: JustGod
----Made with ❤
----
----File: [example]
----
----Copyright (c) 2023 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

local blip = Blip(Vector3(-231.639557, -988.707703, 29.313599))
    :SetLabel("Test blip")
    :SetSprite(eBlipSprite.GTAOPassive)
    :SetScale(1.0)
    :SetColor(eBlipColor.Color24);

RegisterCommand("blip", function()

    if (blip.visible) then
        blip:Hide();
    else
        blip:Show();
    end

end);

RegisterCommand("blip_job", function()
    
    if (blip.job == "police") then
        blip:SetJob(nil, nil);
    else
        blip:SetJob("police", 2);
    end

end);

RegisterCommand("blip_force_hide", function()
    blip:SetForceHide(not blip.force_hide);
end);