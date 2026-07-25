AP_DEBUG = false

GOAL_LOCATION = 255

function debug_write(log)
    if AP_DEBUG then
        io.write(log.."\n")
    end
end

if AP_DEBUG then
    io.output("lc_ap.log")
    debug_write("AP handler initializing")
end

JSON = require "json"
debug_write("json.lua loaded\n")
prequire("ap/ap_scene.lua")
debug_write("AP scene loaded\n")

-- Add our AP manager as a scene that sits on top of the game.
addScene("ap", true, 0)
debug_write("AP scene created\n")

G.AP_Icon = loadGraphic("ap/gfx/ap_icon.png")
G.AP_Text = loadGraphic("ap/gfx/ap_text.png")

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
        save.remote_stage_unlock_count = 0
        for item,count in pairs(msg['items']) do
            local item = tonumber(item)
            if type(item) == "nil" then
                item = 0
            end
            if item > 0 then
                save.Getapplication[item] = 1
            elseif item < -20 then
                save.remote_stage_unlock_count = save.remote_stage_unlock_count + 1
            elseif item < 0 then
                if not save.stat_ups_received[item] then
                    save.stat_ups_received[item] = 0
                end
                local new_stat_ups = count - save.stat_ups_received[item]
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
        return {}
    end

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

-- Consider save fields:
-- Cleargame = 2, which _hopefully_ keeps you from getting locked out of stages.
-- Getapplication, which indicates whether or not you have a given item.
-- StageRank, which is an array (a table, you know what I mean):
    -- index is (stage_num * 10) + (1 for S, 2 for A, etc.)
    -- 0 is hidden, 1 is revealed, 2 is clear
