focusCam = nil
local isFocusing = false

local sleep = 0

CreateThread(function()
    while true do
        Wait(sleep)

        if isFocusing then
            sleep = 0
        else
            sleep = 500
        end

        if IsPedInAnyVehicle(PlayerPedId(), false) and not isFocusing then
            if IsControlPressed(0, Config.key) then -- If the configured key is pressed
                isFocusing = true
                createFocusCameraInCar()
            end
        elseif isFocusing and not IsControlPressed(0, Config.key) then -- If the configured key is released
            isFocusing = false
            destroyFocusCamera()
        elseif (not IsPedInAnyVehicle(PlayerPedId(), false)) and isFocusing then -- If the player exits the vehicle while focusing
            isFocusing = false
            destroyFocusCamera()
        end

        if isFocusing and IsPedInAnyVehicle(PlayerPedId(), false) then
            -- Update the camera rotation
            updateFocusRotation()
        end
    end
end)