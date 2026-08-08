function reset_ap_variables()
    AP_CONNECTED = false
    save.ap_init_done = false
    PENDING_AP_NOTIFICATIONS = {}
    if save.remote_str_to_id ~= nil then save.remote_str_to_id = {} end
    if save.remote_str_offset ~= nil then save.remote_str_offset = 0 end
    if save.stat_ups_received ~= nil then save.stat_ups_received = {} end
    if save.local_stage_unlock_count ~= nil then save.local_stage_unlock_count = 0 end
    if save.remote_stage_unlock_count ~= nil then save.remote_stage_unlock_count = 0 end
    if save.stage_unlock_locations ~= nil then save.stage_unlock_locations = {} end
end

function process_ap_message(msg)
    if not save.remote_str_to_id then save.remote_str_to_id = {} end
    if not save.remote_str_offset then save.remote_str_offset = 0 end
    if not save.stat_ups_received then save.stat_ups_received = {} end
    if not save.local_stage_unlock_count then save.local_stage_unlock_count = 0 end
    if not save.remote_stage_unlock_count then save.remote_stage_unlock_count = 0 end
    if not save.stage_unlock_locations then save.stage_unlock_locations = {} end
    
    if not msg['type'] then return
    elseif msg['type'] == 'resp_hello' then
        debug_write("Got response from hello. Hello, Archipelago!")
        AP_CONNECTED = true
        return
    elseif msg['type'] == 'LocationInfo' then
        debug_write("Got LocationInfo packet, updating rewards")
        for location, reward in pairs(msg['locations']) do
            if type(reward) == "number" then
                StageRankGet[tonumber(location)] = reward
                if reward == -21 or reward == -22 then
                    save.stage_unlock_locations[tonumber(location)] = 1
                end
            else
                if not save.remote_str_to_id[reward] then
                    local next_id = 400 + save.remote_str_offset
                    save.remote_str_to_id[reward] = next_id
                    ap_text[next_id] = {reward,}
                    G.In_Picture_Setup.set[next_id] = G.AP_Icon
                    G.In_Name.Set[next_id] = G.AP_Text
                    save.remote_str_offset = save.remote_str_offset + 1
                end
                StageRankGet[tonumber(location)] = save.remote_str_to_id[reward]
            end
        end
    elseif msg['type'] == 'CheckedLocations' then
        save.local_stage_unlock_count = 0
        for _, location in pairs(msg['locations']) do
            local location = tonumber(location)
            if location ~= GOAL_LOCATION then
                -- The goal location sends the game clear when checked,
                -- so even if it somehow gets cleared out ahead of time,
                -- don't mark it.
                save.StageRank[location] = 2
            end
            if save.stage_unlock_locations[location] then
                save.local_stage_unlock_count = save.local_stage_unlock_count + 1
            end
        end
        local Clearstage = 1
        for i = 1, 15 do
            local d_rank = (i * 10) + 5
            if save.StageRank[d_rank] == 2 and Clearstage == i then
                Clearstage = Clearstage + 1
            else
                break
            end
        end
        if Clearstage == 16 then
            if save.local_stage_unlock_count + save.remote_stage_unlock_count >= 1 then
                Clearstage = Clearstage + 1
            end
            if save.local_stage_unlock_count + save.remote_stage_unlock_count >= 2 then
                -- Clearstage = Clearstage + 1
                Clearstage = 25
            end
        end
        save.Clearstage = Clearstage
    elseif msg['type'] == 'ItemsReceived' then
        local previous_remote_unlocks = save.remote_stage_unlock_count
        save.remote_stage_unlock_count = 0
        for item,count in pairs(msg['items']) do
            local item = tonumber(item)
            if type(item) == "nil" then
                item = 0
            end
            
            if item > 0 then
                if not save.Getapplication[item] or save.Getapplication[item] == 0 then
                    table.insert(PENDING_AP_NOTIFICATIONS, item)
                end
                save.Getapplication[item] = 1
            elseif item < -20 then
                save.remote_stage_unlock_count = save.remote_stage_unlock_count + 1
                if save.remote_stage_unlock_count > previous_remote_unlocks then
                    table.insert(PENDING_AP_NOTIFICATIONS, item)
                end
            elseif item < 0 then
                if not save.stat_ups_received[item] then
                    save.stat_ups_received[item] = 0
                end
                local new_stat_ups = count - save.stat_ups_received[item]
                for _ = 1, new_stat_ups, 1 do
                    table.insert(PENDING_AP_NOTIFICATIONS, item)
                end
                if item == -1 then
                    save.MaxLife = save.MaxLife + (new_stat_ups * 50)
                elseif item == -2 then
                    save.MaxLife = save.MaxLife + (new_stat_ups * 100)
                elseif item == -3 then
                    save.MaxLife = save.MaxLife + (new_stat_ups * 200)
                elseif item == -11 then
                    save.MaxEnergy = save.MaxEnergy + (new_stat_ups * 50)
                elseif item == -12 then
                    save.MaxEnergy = save.MaxEnergy + (new_stat_ups * 100)
                elseif item == -13 then
                    save.MaxEnergy = save.MaxEnergy + (new_stat_ups * 200)
                end
                save.stat_ups_received[item] = count
            end
        end
    elseif msg['type'] == 'SlotData' and not save.ap_init_done then
        -- If we haven't done this init yet, drop all the starting equipment
        -- and use what the slot specifies instead. This might *be* the default
        -- equipment, but it's sent either way, and the overwrites are trivial.
        save.Getapplication[1] = 0
        save.Getapplication[41] = 0
        save.Getapplication[81] = 0
        save.Getapplication[121] = 0
        local starting_blade = tonumber(msg['slot_data']['starting_blade'])
        local starting_assault = tonumber(msg['slot_data']['starting_assault'])
        local starting_shot = tonumber(msg['slot_data']['starting_shot'])
        local starting_charge = tonumber(msg['slot_data']['starting_charge'])
        save.Getapplication[starting_blade] = 1
        save.Setting[1] = starting_blade
        save.Getapplication[starting_assault] = 1
        save.Setting[2] = starting_assault
        save.Getapplication[starting_shot] = 1
        save.Setting[3] = starting_shot
        save.Getapplication[starting_charge] = 1
        save.Setting[4] = starting_charge

        -- TODO: This should probably be an option
        -- Reveal all missions:
        for i = 1, 25 do
            for j = 1, 5 do
                save.StageRank[(i * 10) + j] = 1
            end
        end
        save.Check = 1
        save.ap_init_done = true
    end
end

LAST_RECEIPT = 0
MAX_EMPTY_TIME = 30

function do_ap_transmission(msg)
    if not AP_TCP then
        AP_TCP = TCP:new()
        AP_TCP:connect("localhost", 9292)
    end

    AP_TCP:setStream(JSON.encode(msg) .. "\n")
    AP_TCP:send()
    AP_TCP:recv()
    local recv_msg = AP_TCP:getCache()
    if string.len(recv_msg) == 0 then
        local time_since_last_receipt = (LAST_RECEIPT - getSceneUptime(AP_SCENE)) / 60
        if time_since_last_receipt >= MAX_EMPTY_TIME then
            AP_CONNECTED = false
        end
        return {}
    end
    LAST_RECEIPT = getSceneUptime(AP_SCENE)
    AP_CONNECTED = true

    -- The impossibly jank way I'm doing communication means that sometimes
    -- we end up with two messages glued together, which fails to parse.
    -- Luckily, this is offset by a *different* flavor of jank in this implementation:
    -- the client sends every item we should have received from the multiworld
    -- on every pulse, so missing one just means it potentially takes an extra second
    -- to get our items. All of that to say: it's safe to pcall this and drop
    -- it on the floor if it fails.
    local return_val = {}
    if not pcall(function() return_val = JSON.decode(recv_msg) end) then
        debug_write("Got bad JSON: "..recv_msg)
    end
    return return_val
end

function create_ap_item_text(item)
    local item_name = AP_NAMES[item]
    local width = getTextWidth(AP_STROKE_FONT, item_name)
    local text_g = createBlankGraphic(width + 10, 24)

    drawAATextToGraphic(text_g, AP_STROKE_FONT, 4, 0, item_name, 0, 0, 0, 255, false)
    drawAATextToGraphic(text_g, AP_FONT, 5, 1, item_name, 255, 255, 255, 255, false)

    return text_g, width
end