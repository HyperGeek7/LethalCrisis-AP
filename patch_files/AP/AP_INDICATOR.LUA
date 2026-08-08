AP_TEXT_COOLDOWN = 1 * 60
AP_INDICATOR_VAR_TEXT_COOLDOWN = 1


function apIndicator_OnStart()
    VAR[AP_INDICATOR_VAR_TEXT_COOLDOWN] = 0
end

function apIndicator_OnStep()
    if AP_CONNECTED then
        addMover(iSelf(), -1, 1, MOVER_SETFACE, G.AP_Connected)
    else
        addMover(iSelf(), -1, 1, MOVER_SETFACE, G.AP_Disconnected)
    end

    if ON_TITLE then
        -- Wait for initial setup to go through
        PENDING_AP_NOTIFICATIONS = {}
        return
    end

    if VAR[AP_INDICATOR_VAR_TEXT_COOLDOWN] > 0 then
        VAR[AP_INDICATOR_VAR_TEXT_COOLDOWN] = VAR[AP_INDICATOR_VAR_TEXT_COOLDOWN] - 1
    elseif table.maxn(PENDING_AP_NOTIFICATIONS) > 0 then
        local new_notification_id = table.remove(PENDING_AP_NOTIFICATIONS,1)
        debug_write("Display item "..new_notification_id)
        playSound(S.Lvup)
        local text_image, width = create_ap_item_text(new_notification_id)
        debug_write("Item width is "..width)
        local text_actor = createActor(text_image, math.ceil(-width / 2) - 20, 0, INDICATOR_LAYER, "apText")
        setv(text_actor, 0, text_image)
        VAR[AP_INDICATOR_VAR_TEXT_COOLDOWN] = AP_TEXT_COOLDOWN
    end
end

function apIndicator_OnVanish()
end