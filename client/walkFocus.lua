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
        
        if IsPedOnFoot(PlayerPedId()) and isPlayerUnarmed() and not isFocusing then
            if IsControlPressed(0, Config.key) then -- Si el botón derecho está presionado
                isFocusing = true
                createFocusCamera()
            end
        elseif isFocusing and not IsControlPressed(0, Config.key) then -- Si el botón derecho se ha soltado
            isFocusing = false
            destroyFocusCamera()
        elseif (not IsPedOnFoot(PlayerPedId()) or not isPlayerUnarmed()) and isFocusing then -- Si el jugador está en el suelo y la cámara de enfoque está activa
            isFocusing = false
            destroyFocusCamera()
        end

        if isFocusing and IsPedOnFoot(PlayerPedId()) then
            -- Actualizar la rotación de la cámara
            updateFocusRotation()
        end
    end
end)