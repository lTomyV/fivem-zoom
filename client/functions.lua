function isPlayerUnarmed()
    local ped = PlayerPedId()
    return IsPedArmed(ped, 4) == false and IsPedArmed(ped, 1) == false and IsPedArmed(ped, 2) == false
end

function createFocusCamera()
    local ped = PlayerPedId()
    focusCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamFov(focusCam, Config.fovWalking)

    -- Sin rotación (usamos 0, 0, 0) y con el offset correcto
    HardAttachCamToEntity(focusCam, ped, 0.0, 0.0, 0.0, Config.offsetWalking.x, Config.offsetWalking.y, Config.offsetWalking.z, true)

    SetCamActive(focusCam, true)
    RenderScriptCams(true, true, 300, true, true)
end

function createFocusCameraInCar()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    focusCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamFov(focusCam, Config.fovDriving)

    AttachCamToVehicleBone(focusCam, veh, GetEntityBoneIndexByName(veh, "windscreen"), 0.0, 0.0, 0.0, Config.offsetDriving.x, Config.offsetDriving.y, Config.offsetDriving.z, true, 0, false, 2, true)

    SetCamActive(focusCam, true)
    RenderScriptCams(true, true, 300, true, true)
end

function updateFocusRotation()
    local camRot = GetGameplayCamRot(2)
    local camDir = rotationToDirection(camRot)
    local ped = PlayerPedId()
    local pedPos = GetEntityCoords(ped)

    -- Apuntar la cámara en dirección de la del jugador
    local lookAt = pedPos + camDir * 100.0
    PointCamAtCoord(focusCam, lookAt.x, lookAt.y, lookAt.z)

    -- Rotar el ped
    local heading = GetHeadingFromVector_2d(camDir.x, camDir.y)
    --SetEntityHeading(ped, heading)
end

function destroyFocusCamera()
    if focusCam then
        RenderScriptCams(false, true, 300, true, true)
        DestroyCam(focusCam, false)
        focusCam = nil
    end
end

function rotationToDirection(rot)
    local z = math.rad(rot.z)
    local x = math.rad(rot.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end
