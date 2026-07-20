-- Decompiled using luadec 2.2 rev: 895d923 for Lua 5.1 from https://github.com/viruscamp/luadec
-- Command line: /home/hypergeek/miscProjects/LethalCrisis-AP/BOOT.LUA 

-- params : ...
-- function num : 0
prequire("common.lua")
G = {}
S = {}
A = {}
M = {}
map = {}
save = {}
savesys = {}
replay = {}
BUTTON_TRIGAtime = 0
BUTTON_TRIGBtime = 0
BUTTON_TRIGCtime = 0
BUTTON_TRIGDtime = 0
prequire("s/function/text_apmessage.lua")
prequire("s/function/text_mission.lua")
prequire("s/function/text_event.lua")
prequire("s/function/num_separate.lua")
prequire("s/function/stage_separate.lua")
prequire("s/function/save_replay.lua")
prequire("s/function/boss_para_appear.lua")
prequire("s/function/initialize.lua")
prequire("s/function/event.lua")
prequire("s/function/Attackset.lua")
prequire("s/function/Eb_knockback.lua")
prequire("s/function/deadblast.lua")
prequire("s/function/pre_stagestart.lua")
prequire("s/key/keyset.lua")
prequire("s/key/keyclarino.lua")
prequire("s/key/keylateA.lua")
prequire("s/key/keylateB.lua")
prequire("s/key/Demokeyset.lua")
prequire("s/key/Demokeyclarino.lua")
prequire("s/scene/movie.lua")
prequire("s/scene/title.lua")
prequire("s/scene/keyconfig.lua")
prequire("s/scene/load.lua")
prequire("s/scene/intermission.lua")
prequire("s/scene/result.lua")
prequire("s/event/gfx_St.lua")
prequire("s/event/event1.lua")
prequire("s/event/event2.lua")
prequire("s/event/event3.lua")
prequire("s/event/event4.lua")
prequire("s/event/event5.lua")
prequire("s/event/event6.lua")
prequire("s/event/event7.lua")
prequire("s/event/event8.lua")
prequire("s/event/event9.lua")
prequire("s/event/event10.lua")
prequire("s/event/event11.lua")
prequire("s/event/event12.lua")
prequire("s/event/event13.lua")
prequire("s/event/event14.lua")
prequire("s/event/event15.lua")
prequire("s/event/event16.lua")
prequire("s/event/event17.lua")
prequire("s/event/event18.lua")
prequire("s/event/event19.lua")
prequire("s/event/event20.lua")
prequire("s/event/event21.lua")
prequire("s/event/event22.lua")
prequire("s/event/event23.lua")
prequire("s/event/event24.lua")
prequire("s/event/event25.lua")
prequire("s/event/event26.lua")
prequire("s/event/event27.lua")
prequire("s/event/event28.lua")
prequire("s/event/event29.lua")
prequire("s/event/event30.lua")
prequire("s/event/event31.lua")
prequire("s/event/event32.lua")
prequire("s/event/event33.lua")
prequire("s/event/event34.lua")
prequire("s/event/event35.lua")
prequire("s/event/event36.lua")
prequire("s/event/event37.lua")
prequire("s/event/event38.lua")
prequire("s/event/event39.lua")
prequire("s/event/event40.lua")
prequire("s/event/event41.lua")
prequire("s/event/event42.lua")
prequire("s/event/event43.lua")
prequire("s/event/event44.lua")
prequire("s/event/event45.lua")
prequire("s/event/event46.lua")
prequire("s/event/event47.lua")
prequire("s/event/event48.lua")
prequire("s/event/event49.lua")
prequire("s/event/event50.lua")
prequire("s/event/event51.lua")
prequire("s/event/event52.lua")
prequire("s/event/event53.lua")
prequire("s/event/event54.lua")
prequire("s/event/event55.lua")
prequire("s/event/event56.lua")
prequire("s/event/event57.lua")
prequire("s/chr/_Scoreget.lua")
prequire("s/chr/_Itemputout.lua")
prequire("s/chr/_Nockback.lua")
prequire("s/chr/_Boss_Cursor.lua")
prequire("s/chr/_Ec_Hitwall.lua")
prequire("s/chr/_Ec_Nockback.lua")
prequire("s/chr/_Ec_Lifebar.lua")
prequire("s/chr/_Ec_Lockon.lua")
prequire("s/chr/_Pc_Lifebar.lua")
prequire("s/chr/_Boss_Lifebar_A.lua")
prequire("s/nowloading.lua")
prequire("s/gfx_setup.lua")
prequire("s/gfx_ef_b.lua")
prequire("s/gfx.lua")
prequire("s/enemy.lua")
prequire("s/Item.lua")
prequire("s/mission.lua")
prequire("s/se.lua")
prequire("s/startpara.lua")
prequire("s/movie.lua")
prequire("s/stagemake.lua")
prequire("s/stagecommon.lua")
prequire("s/stagecommon_start.lua")
prequire("s/stageclose.lua")
prequire("s/afterevent.lua")
prequire("s/stage1.lua")
prequire("s/stage2.lua")
prequire("s/stage3.lua")
prequire("s/stage4.lua")
prequire("s/stage4a.lua")
prequire("s/stage5.lua")
prequire("s/stage6.lua")
prequire("s/stage7.lua")
prequire("s/stage7a.lua")
prequire("s/stage8.lua")
prequire("s/stage9.lua")
prequire("s/stage9a.lua")
prequire("s/stage10.lua")
prequire("s/stage11.lua")
prequire("s/stage12.lua")
prequire("s/stage13.lua")
prequire("s/stage13a.lua")
prequire("s/stage14.lua")
prequire("s/stage15.lua")
prequire("s/stage16.lua")
prequire("s/stage17.lua")
prequire("s/stage18.lua")
prequire("s/stage19.lua")
prequire("s/stage20.lua")
prequire("s/stage21.lua")
prequire("s/stage22.lua")
prequire("s/stage23.lua")
prequire("s/stage23a.lua")
prequire("s/stage24.lua")
prequire("s/stage24a.lua")
prequire("s/stage25.lua")
prequire("s/scene/frame.lua")
prequire("s/chr/Pc_Clarino.lua")
prequire("s/chr/Pc_ShadowA.lua")
prequire("s/chr/Pc_ShadowB.lua")
prequire("s/chr/Pc_Second.lua")
prequire("s/chr/Pc_Diska.lua")
prequire("s/chr/Pc_Reminisce.lua")
prequire("s/chr/Ef_Blade_Hit.lua")
prequire("s/chr/Ef_Blade_Hit_L.lua")
prequire("s/chr/Ef_Blade_Hit_Green.lua")
prequire("s/chr/Ef_Ec_Lifeback.lua")
prequire("s/chr/Ef_Ec_Lifebar.lua")
prequire("s/chr/Ef_Teleport.lua")
prequire("s/chr/Ef_Teleport2.lua")
prequire("s/chr/Ef_Blast_01.lua")
prequire("s/chr/Ef_Blast_Tip.lua")
prequire("s/chr/Ef_Bossblast_01.lua")
prequire("s/chr/Ef_Bossblast_02_Deep.lua")
prequire("s/chr/Ef_Bossblast_02_Light.lua")
prequire("s/chr/Ef_Booster_LR.lua")
prequire("s/chr/Ef_Booster_UD.lua")
prequire("s/chr/Ef_Burstblast_Deep.lua")
prequire("s/chr/Ef_Burstblast_Light.lua")
prequire("s/chr/Ef_Burst_Chargefoton.lua")
prequire("s/chr/Ef_Burst_Chargeline.lua")
prequire("s/chr/Ef_Ice_Tip.lua")
prequire("s/chr/Ef_Smoke.lua")
prequire("s/chr/Ef_Hit_Red.lua")
prequire("s/chr/Ef_Hit_Blue.lua")
prequire("s/chr/Ef_Hit_Green.lua")
prequire("s/chr/Ef_Hit_Silver.lua")
prequire("s/chr/Ef_Hit_Purple.lua")
prequire("s/chr/Ef_Hit_Tip.lua")
prequire("s/chr/Ef_Wind.lua")
prequire("s/chr/Ef_Colorback.lua")
prequire("s/chr/Ef_Slow_Foton.lua")
prequire("s/chr/Ef_Bit_Red_Blade.lua")
prequire("s/chr/Ef_Rem_PillarLaser.lua")
prequire("s/chr/Ef_Rem_Energy.lua")
prequire("s/chr/Ef_Warning_L.lua")
prequire("s/chr/Ef_Stagescore.lua")
prequire("s/chr/Ef_Stagerate.lua")
prequire("s/chr/Ef_Lvup_Flash.lua")
prequire("s/chr/Ef_Lvup_Font.lua")
prequire("s/chr/Ef_Trans.lua")
prequire("ap/ap_root.lua")
OnLoad = function()
  -- function num : 0_0
  loadsavesys = loadFile("save/savesys")
  savesys = deserialize(loadsavesys)
  if savesys.KeyCheck == 1 then
    if savesys.Window == 0 then
      setWindowMode(true)
    else
      setWindowMode(false)
    end

    if savesys.Ekey ~= "number" then
      if savesys.Akey ~= 1 and savesys.Bkey ~= 1 and savesys.Ckey ~= 1 and savesys.Dkey ~= 1 then
        savesys.Ekey = 1
      elseif savesys.Akey ~= 2 and savesys.Bkey ~= 2 and savesys.Ckey ~= 2 and savesys.Dkey ~= 2 then
          savesys.Ekey = 2
      elseif savesys.Akey ~= 3 and savesys.Bkey ~= 3 and savesys.Ckey ~= 3 and savesys.Dkey ~= 3 then
          savesys.Ekey = 3
      elseif savesys.Akey ~= 4 and savesys.Bkey ~= 4 and savesys.Ckey ~= 4 and savesys.Dkey ~= 4 then
          savesys.Ekey = 4
      elseif savesys.Akey ~= 5 and savesys.Bkey ~= 5 and savesys.Ckey ~= 5 and savesys.Dkey ~= 5 then
          savesys.Ekey = 5
      else
        savesys.Ekey = 6
      end
    end
  else
    savesys = {}
    savesys.Akey = 1
    savesys.Bkey = 2
    savesys.Ckey = 3
    savesys.Dkey = 4
    savesys.Ekey = 5
    savesys.KeyCheck = 1
    savesys.autoNext = 1
    savesys.Window = 0
    savesys.RecSaveDataNo = 1
    savesys = serialize(savesys)
    saveFile("save/savesys", savesys)
  end
end

Demoplay = 0
Clarino_DEAD = 0
StageClear = 0
boot_OnStart = function()
  -- function num : 0_1
  cls()
  clearLayerSettings()
end

boot_OnStep = function()
  -- function num : 0_2
  FONT_TEXT = createTextFont("‚l‚r ‚oƒSƒVƒbƒN", 14, false, false)
  FONT_TEXT_L = createTextFont("‚l‚r ‚oƒSƒVƒbƒN", 18, false, false)
  FONT_TEXT_ED = createTextFont("‚l‚r ‚oƒSƒVƒbƒN", 36, false, false)
  FONT_TEXT_ED_L = createTextFont("‚l‚r ‚oƒSƒVƒbƒN", 48, false, false)
  changeScene("nowloading")
end

boot_OnClose = function()
  -- function num : 0_3
  cls()
end

OnVanish = function()
  -- function num : 0_4
  deleteAllGraphic(G)
  deleteAllSound(S)
end


