-- file: <unknown>
-- dialect: lua5.1
-- encoding: auto
-- decompiled by unluac-rs

-- line 1-74
-- proto#1 params=0 locals=42 upvalues=0 vararg=false
function title_OnStart()
    ON_TITLE = true
    LAYER_BG = 0
    LAYER_BAR_BLUE = 1
    LAYER_BAR = 2
    LAYER_TEXT = 3
    LAYER_FEED = 4
    Scene = 0
    TitleChois = 1
    TitleChoisFormer = 1
    MoveBlue = 0
    MoveMemo1 = 0
    MoveMemo2 = 360
    MoveMemo3 = 360
    MoveMemo4 = 360
    TIME = 0
    AfterChois = 0
    Feedtime = 0
    A.Bg_Title = createActor(G.Bg_Title, 320, 240, LAYER_BG)
    A.Bar_Blue_M = createActor(G.In_Bar.Blue_M, 320, 290, LAYER_BAR_BLUE)
    A.Bar_1Left = createActor(G.In_Bar.L_Left[1], 220, 300, LAYER_BAR)
    A.Bar_1Center = createActor(G.In_Bar.L_Center[1], 250, 300, LAYER_BAR)
    A.Bar_1Right = createActor(G.In_Bar.L_Right[1], 280, 300, LAYER_BAR)
    addMover(A.Bar_1Left, -1, 1, MOVER_SETZOOM, 22, 1)
    addMover(A.Bar_1Right, -1, 1, MOVER_SETZOOM, 36, 1)
    A.Dataload = createActor(G.In_Text.Set[1], 140, 295, LAYER_TEXT)
    A.Bar_2Left = createActor(G.In_Bar.L_Left_Gray, 260, 340, LAYER_BAR)
    A.Bar_2Center = createActor(G.In_Bar.L_Center_Gray, 290, 340, LAYER_BAR)
    A.Bar_2Right = createActor(G.In_Bar.L_Right_Gray, 320, 340, LAYER_BAR)
    addMover(A.Bar_2Left, -1, 1, MOVER_SETZOOM, 26, 1)
    addMover(A.Bar_2Right, -1, 1, MOVER_SETZOOM, 32, 1)
    A.Newgame = createActor(G.In_Text.Set[2], 180, 335, LAYER_TEXT)
    A.Bar_3Left = createActor(G.In_Bar.L_Left_Gray, 300, 380, LAYER_BAR)
    A.Bar_3Center = createActor(G.In_Bar.L_Center_Gray, 330, 380, LAYER_BAR)
    A.Bar_3Right = createActor(G.In_Bar.L_Right_Gray, 360, 380, LAYER_BAR)
    addMover(A.Bar_3Left, -1, 1, MOVER_SETZOOM, 30, 1)
    addMover(A.Bar_3Right, -1, 1, MOVER_SETZOOM, 28, 1)
    A.Config = createActor(G.In_Text.Set[3], 220, 375, LAYER_TEXT)
    A.Bar_4Left = createActor(G.In_Bar.L_Left_Gray, 340, 420, LAYER_BAR)
    A.Bar_4Center = createActor(G.In_Bar.L_Center_Gray, 370, 420, LAYER_BAR)
    A.Bar_4Right = createActor(G.In_Bar.L_Right_Gray, 400, 420, LAYER_BAR)
    addMover(A.Bar_4Left, -1, 1, MOVER_SETZOOM, 34, 1)
    addMover(A.Bar_4Right, -1, 1, MOVER_SETZOOM, 24, 1)
    A.Exit = createActor(G.In_Text.Set[4], 260, 415, LAYER_TEXT)
    A.Load_Memo = createActor(G.In_Text.Set[29], 410, 290, LAYER_TEXT)
    A.New_Memo = createActor(G.In_Text.Set[30], 810, 330, LAYER_TEXT)
    A.Con_Memo = createActor(G.In_Text.Set[31], 850, 370, LAYER_TEXT)
    A.Exit_Memo = createActor(G.In_Text.Set[32], 890, 410, LAYER_TEXT)
    playMusicLoop("bgm/Lethal_Crises.ogg")
    loadsavesys = loadFile("save/savesys")
    savesys = deserialize(loadsavesys)
end

-- line 76-290
-- proto#2 params=0 locals=144 upvalues=0 vararg=false
function title_OnStep()
    TIME = TIME + 1
    local r2_0 = TIME
    if r2_0 >= 300 and save.Demo_Stage ~= 0 then
        Demoplay = 1
        GoStage = save.Demo_Stage
        cls()
        changeScene("gfx")
    end
    keyset()
    if AfterChois == 0 then
        if BUTTON_RIGHTtime == 1 or BUTTON_DOWNtime == 1 then
            playSound(S.Titleselect)
            if TitleChois == 4 then
                TitleChois = 1
                MoveBlue = MoveBlue - 120
            else
                TitleChois = TitleChois + 1
                MoveBlue = MoveBlue + 40
            end
        end
        if BUTTON_LEFTtime == 1 or BUTTON_UPtime == 1 then
            playSound(S.Titleselect)
            if TitleChois == 1 then
                TitleChois = 4
                MoveBlue = MoveBlue + 120
            else
                TitleChois = TitleChois - 1
                MoveBlue = MoveBlue - 40
            end
        end
        if TitleChois ~= TitleChoisFormer then
            if TitleChoisFormer == 1 then
                local r2_1 = MOVER_SETFACE
                addMover(A.Bar_1Left, -1, 1, r2_1, G.In_Bar.L_Left_Gray)
                local r2_2 = MOVER_SETFACE
                addMover(A.Bar_1Center, -1, 1, r2_2, G.In_Bar.L_Center_Gray)
                local r2_3 = MOVER_SETFACE
                addMover(A.Bar_1Right, -1, 1, r2_3, G.In_Bar.L_Right_Gray)
            elseif TitleChoisFormer == 2 then
                local r2_4 = MOVER_SETFACE
                addMover(A.Bar_2Left, -1, 1, r2_4, G.In_Bar.L_Left_Gray)
                local r2_5 = MOVER_SETFACE
                addMover(A.Bar_2Center, -1, 1, r2_5, G.In_Bar.L_Center_Gray)
                local r2_6 = MOVER_SETFACE
                addMover(A.Bar_2Right, -1, 1, r2_6, G.In_Bar.L_Right_Gray)
            elseif TitleChoisFormer == 3 then
                local r2_7 = MOVER_SETFACE
                addMover(A.Bar_3Left, -1, 1, r2_7, G.In_Bar.L_Left_Gray)
                local r2_8 = MOVER_SETFACE
                addMover(A.Bar_3Center, -1, 1, r2_8, G.In_Bar.L_Center_Gray)
                local r2_9 = MOVER_SETFACE
                addMover(A.Bar_3Right, -1, 1, r2_9, G.In_Bar.L_Right_Gray)
            elseif TitleChoisFormer == 4 then
                local r2_10 = MOVER_SETFACE
                addMover(A.Bar_4Left, -1, 1, r2_10, G.In_Bar.L_Left_Gray)
                local r2_11 = MOVER_SETFACE
                addMover(A.Bar_4Center, -1, 1, r2_11, G.In_Bar.L_Center_Gray)
                local r2_12 = MOVER_SETFACE
                addMover(A.Bar_4Right, -1, 1, r2_12, G.In_Bar.L_Right_Gray)
            end
            if TitleChois == 1 then
                local r2_13 = MOVER_SETFACE
                addMover(A.Bar_1Left, -1, 1, r2_13, G.In_Bar.L_Left[1])
                local r2_14 = MOVER_SETFACE
                addMover(A.Bar_1Center, -1, 1, r2_14, G.In_Bar.L_Center[1])
                local r2_15 = MOVER_SETFACE
                addMover(A.Bar_1Right, -1, 1, r2_15, G.In_Bar.L_Right[1])
            elseif TitleChois == 2 then
                local r2_16 = MOVER_SETFACE
                addMover(A.Bar_2Left, -1, 1, r2_16, G.In_Bar.L_Left[1])
                local r2_17 = MOVER_SETFACE
                addMover(A.Bar_2Center, -1, 1, r2_17, G.In_Bar.L_Center[1])
                local r2_18 = MOVER_SETFACE
                addMover(A.Bar_2Right, -1, 1, r2_18, G.In_Bar.L_Right[1])
            elseif TitleChois == 3 then
                local r2_19 = MOVER_SETFACE
                addMover(A.Bar_3Left, -1, 1, r2_19, G.In_Bar.L_Left[1])
                local r2_20 = MOVER_SETFACE
                addMover(A.Bar_3Center, -1, 1, r2_20, G.In_Bar.L_Center[1])
                local r2_21 = MOVER_SETFACE
                addMover(A.Bar_3Right, -1, 1, r2_21, G.In_Bar.L_Right[1])
            elseif TitleChois == 4 then
                local r2_22 = MOVER_SETFACE
                addMover(A.Bar_4Left, -1, 1, r2_22, G.In_Bar.L_Left[1])
                local r2_23 = MOVER_SETFACE
                addMover(A.Bar_4Center, -1, 1, r2_23, G.In_Bar.L_Center[1])
                local r2_24 = MOVER_SETFACE
                addMover(A.Bar_4Right, -1, 1, r2_24, G.In_Bar.L_Right[1])
            end
            TitleChoisFormer = TitleChois
        end
        local r2_25 = MoveBlue
        if r2_25 > 0 then
            y = getY(A.Bar_Blue_M)
            addMover(A.Bar_Blue_M, -1, 1, MOVER_SETPOSITION, 320, y + 5)
            MoveBlue = MoveBlue - 5
        end
        if MoveBlue < 0 then
            y = getY(A.Bar_Blue_M)
            addMover(A.Bar_Blue_M, -1, 1, MOVER_SETPOSITION, 320, y - 5)
            MoveBlue = MoveBlue + 5
        end
        if TitleChois == 1 then
            local r2_26 = MoveMemo1
            if r2_26 > 0 then
                x1 = getX(A.Load_Memo)
                addMover(A.Load_Memo, -1, 1, MOVER_SETPOSITION, x1 - 30, 290)
                MoveMemo1 = MoveMemo1 - 30
            end
            if MoveMemo2 < 360 then
                x2 = getX(A.New_Memo)
                addMover(A.New_Memo, -1, 1, MOVER_SETPOSITION, x2 + 30, 330)
                MoveMemo2 = MoveMemo2 + 30
            end
            if MoveMemo3 < 360 then
                x3 = getX(A.Con_Memo)
                addMover(A.Con_Memo, -1, 1, MOVER_SETPOSITION, x3 + 30, 370)
                MoveMemo3 = MoveMemo3 + 30
            end
            if MoveMemo4 < 360 then
                x4 = getX(A.Exit_Memo)
                addMover(A.Exit_Memo, -1, 1, MOVER_SETPOSITION, x4 + 30, 410)
                MoveMemo4 = MoveMemo4 + 30
            end
        end
        if TitleChois == 2 then
            if MoveMemo1 < 360 then
                x1 = getX(A.Load_Memo)
                addMover(A.Load_Memo, -1, 1, MOVER_SETPOSITION, x1 + 30, 290)
                MoveMemo1 = MoveMemo1 + 30
            end
            local r2_27 = MoveMemo2
            if r2_27 > 0 then
                x2 = getX(A.New_Memo)
                addMover(A.New_Memo, -1, 1, MOVER_SETPOSITION, x2 - 30, 330)
                MoveMemo2 = MoveMemo2 - 30
            end
            if MoveMemo3 < 360 then
                x3 = getX(A.Con_Memo)
                addMover(A.Con_Memo, -1, 1, MOVER_SETPOSITION, x3 + 30, 370)
                MoveMemo3 = MoveMemo3 + 30
            end
            if MoveMemo4 < 360 then
                x4 = getX(A.Exit_Memo)
                addMover(A.Exit_Memo, -1, 1, MOVER_SETPOSITION, x4 + 30, 410)
                MoveMemo4 = MoveMemo4 + 30
            end
        end
        if TitleChois == 3 then
            if MoveMemo1 < 360 then
                x1 = getX(A.Load_Memo)
                addMover(A.Load_Memo, -1, 1, MOVER_SETPOSITION, x1 + 30, 290)
                MoveMemo1 = MoveMemo1 + 30
            end
            if MoveMemo2 < 360 then
                x2 = getX(A.New_Memo)
                addMover(A.New_Memo, -1, 1, MOVER_SETPOSITION, x2 + 30, 330)
                MoveMemo2 = MoveMemo2 + 30
            end
            local r2_28 = MoveMemo3
            if r2_28 > 0 then
                x3 = getX(A.Con_Memo)
                addMover(A.Con_Memo, -1, 1, MOVER_SETPOSITION, x3 - 30, 370)
                MoveMemo3 = MoveMemo3 - 30
            end
            if MoveMemo4 < 360 then
                x4 = getX(A.Exit_Memo)
                addMover(A.Exit_Memo, -1, 1, MOVER_SETPOSITION, x4 + 30, 410)
                MoveMemo4 = MoveMemo4 + 30
            end
        end
        if TitleChois == 4 then
            if MoveMemo1 < 360 then
                x1 = getX(A.Load_Memo)
                addMover(A.Load_Memo, -1, 1, MOVER_SETPOSITION, x1 + 30, 290)
                MoveMemo1 = MoveMemo1 + 30
            end
            if MoveMemo2 < 360 then
                x2 = getX(A.New_Memo)
                addMover(A.New_Memo, -1, 1, MOVER_SETPOSITION, x2 + 30, 330)
                MoveMemo2 = MoveMemo2 + 30
            end
            if MoveMemo3 < 360 then
                x3 = getX(A.Con_Memo)
                addMover(A.Con_Memo, -1, 1, MOVER_SETPOSITION, x3 + 30, 370)
                MoveMemo3 = MoveMemo3 + 30
            end
            local r2_29 = MoveMemo4
            if r2_29 > 0 then
                x4 = getX(A.Exit_Memo)
                addMover(A.Exit_Memo, -1, 1, MOVER_SETPOSITION, x4 - 30, 410)
                MoveMemo4 = MoveMemo4 - 30
            end
        end
        if BUTTON_TRIGAtime == 1 then
            BUTTON_TRIGAtime = BUTTON_TRIGAtime + 1
            A.Feedblack = createActor(G.Ef_Black, 320, 240, LAYER_FEED)
            addMover(A.Feedblack, -1, 1, MOVER_SETALPHA, 0)
            addMover(A.Feedblack, -1, 1, MOVER_SETZOOM, 64, 48)
            playSound(S.Diside)
            AfterChois = 1
            Feedtime = 1
        end
    end
    if AfterChois == 1 then
        Feedtime = Feedtime + 1
        addMover(A.Feedblack, -1, 1, MOVER_SETALPHA, Feedtime * 5)
        local r2_30 = Feedtime
        if r2_30 >= 51 then
            cls()
            if TitleChois == 1 then
                changeScene("load")
            elseif TitleChois == 2 then
                GoStage = 1
                changeScene("stage1")
            elseif TitleChois == 3 then
                changeScene("keyconfig")
            elseif TitleChois == 4 then
                release()
                quit()
            end
        end
    end
end

-- line 292-294
-- proto#3 params=0 locals=0 upvalues=0 vararg=false
function title_OnClose()
    ON_TITLE = false
    reset_ap_variables()
end
