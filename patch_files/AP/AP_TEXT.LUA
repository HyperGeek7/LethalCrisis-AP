AP_TEXT_VAR_TIME_REMAINING = 1

AP_TEXT_LIFETIME = 3 * 60
AP_TEXT_MAX_SPEED = 10

function apText_OnStart()
    VAR[AP_TEXT_VAR_TIME_REMAINING] = AP_TEXT_LIFETIME
end

function apText_OnStep()
    VAR[AP_TEXT_VAR_TIME_REMAINING] = VAR[AP_TEXT_VAR_TIME_REMAINING] - 1

    if VAR[AP_TEXT_VAR_TIME_REMAINING] <= 0 then
        vanish()
    end

    local life_proportion = VAR[AP_TEXT_VAR_TIME_REMAINING] / AP_TEXT_LIFETIME

    local new_alpha = math.floor((life_proportion ^ (1/3)) * 255)
    addMover(iSelf(), -1, 1, MOVER_SETALPHA, new_alpha)

    local new_speed = -(1 - (life_proportion ^ 2))
    setVector(0, new_speed)
end

function apText_OnVanish()
    if VAR[0] then
        deleteGraphic(VAR[0])
    end
end
