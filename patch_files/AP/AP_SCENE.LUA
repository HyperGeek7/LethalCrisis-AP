INDICATOR_LAYER = 11

function ap_OnStart()
    debug_write("AP_OnStart called")
    AP_TCP = TCP:new()
    AP_TCP:connect("localhost", 9292)
    AP_CONNECTED = false
    debug_write("AP_OnStart end")
end

function ap_OnStep()
    if not A.ap_indicator or not isAlive(A.ap_indicator) then
        A.ap_indicator = createActor(G.AP_Disconnected, 640 - 16, 480 - 16, INDICATOR_LAYER, "apIndicator");
    end

    if not save or save.Lastmessage == nil then
        -- Wait for initial setup to go through
        return
    end

    if getSceneUptime() % 60 ~= 0 then
        return
    end

    local msgs = {}
    if not AP_CONNECTED then
        debug_write("AP not connected, sending hello")
        local hello_msg = {type = "hello"}
        msgs = do_ap_transmission(hello_msg)
    else
        local locations_checked = {}
        for location_code, clear_code in pairs(save.StageRank) do
            if clear_code == 2 then
                locations_checked[#locations_checked+1] = location_code
                if location_code == GOAL_LOCATION then
                    locations_checked[#locations_checked+1] = "Victory"
                end
            end
        end

        local check_message = {type = "LocationChecks", locations = locations_checked}
        msgs = do_ap_transmission(check_message)
    end

    for _, msg in pairs(msgs) do
        process_ap_message(msg)
    end
    
    -- Cleanup
    -- I think this was a red herring when I actually had data in my save files
    -- that was causing the game to be unable to load them.
    -- But whatever, if it's a noop, it's a noop.
    save.Check = 1
    -- The game normally locks you out of the first 9 stages after you beat stage 9
    -- until you beat stage 16. Then it does it again with stage 10B until you clear 17B.
    -- But this only happens the first time through the game. After that, you can replay
    -- those stages at will with no lockout. Since getting locked out would be a BAD_THING
    -- for a rando, we dynamically set the flag tracking which endings you've gotten so
    -- it always thinks you have free access to them.
    if save.Clearstage < 10 then
        save.Cleargame = 0
    elseif save.Clearstage <= 17 then
        save.Cleargame = 1
    else
        save.Cleargame = 2
    end
end

function ap_OnClose()
    debug_write("AP_OnClose called")
    AP_TCP:closeSocket()
end