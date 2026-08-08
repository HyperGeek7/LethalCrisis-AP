AP_DEBUG = true

GOAL_LOCATION = 255

-- Using a table as a queue sounds like a recipe for inefficiency.
-- I'm really just hoping the operations are infrequent enough
-- and the list is short enough that this won't matter.
PENDING_AP_NOTIFICATIONS = {}

function debug_write(log)
    if AP_DEBUG then
        io.write(log.."\n")
    end
end

if AP_DEBUG then
    io.output("lc_ap.log")
    debug_write("AP handler initializing")
end

G.AP_Icon = loadGraphic("ap/gfx/ap_icon.png")
G.AP_Text = loadGraphic("ap/gfx/ap_text.png")
G.AP_Connected = loadGraphic("ap/gfx/ap_icon_sm.png")
G.AP_Disconnected = loadGraphic("ap/gfx/ap_icon_sm_gray.png")

AP_STROKE_FONT = createTextFont("Arial", 25, false, false)
AP_FONT = createTextFont("Arial", 24, false, false)

JSON = require "json"
debug_write("json.lua loaded")
prequire("ap/ap_names.lua")
debug_write("AP names loaded")
prequire("ap/ap_functions.lua")
debug_write("AP functions loaded")
prequire("ap/ap_text.lua")
debug_write("AP text loaded")
prequire("ap/ap_indicator.lua")
debug_write("AP indicator loaded")
prequire("ap/ap_scene.lua")
debug_write("AP scene loaded")

-- Add our AP manager as a scene that sits on top of the game.
AP_SCENE = addScene("ap", true, 0)
debug_write("AP scene created")

-- Consider save fields:
-- Cleargame = 2, which _hopefully_ keeps you from getting locked out of stages.
-- Getapplication, which indicates whether or not you have a given item.
-- StageRank, which is an array (a table, you know what I mean):
    -- index is (stage_num * 10) + (1 for S, 2 for A, etc.)
    -- 0 is hidden, 1 is revealed, 2 is clear
