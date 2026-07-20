-- Decompiled using luadec 2.2 rev: 895d923 for Lua 5.1 from https://github.com/viruscamp/luadec
-- Command line: LCPatched/S/FUNCTION/TEXT_APMESSAGE.LUA 

-- params : ...
-- function num : 0
text_apmessage = function(ap_number)
  -- function num : 0_0
  fillGraphic(G.Apmessage, 0, 0, 0, 0)

  if not ap_text[ap_number] then
    return
  end

  for i, text in pairs(ap_text[ap_number]) do
    drawAATextToGraphic(G.Apmessage, FONT_TEXT_L, 0, (i - 1) * 22, text, 255, 255, 255, 255, false)
  end
end

ap_text = {
    [1] = {
        "A standard Blade with a three hit combo.",
        "It has excellent defence, with wide coverage and few gaps.",
        "The third hit launches enemies upward and applies a lock."
    },
    [2] = {
        "Utilizes a barrage of short, small attacks.",
        "Unlike other Blades, swinging it doesn\'t influence movement.",
        "Range expands as LV increases."
    },
    [4] = {
        "Advances quickly, cutting all enemies it crosses.",
        "Though there is a wind-up before the attack, you cannot be",
        "hit during the dash, so it can be used for evasion."
    },
    [5] = {
        "Spins, attacking in all directions.",
        "In addition, it enables faster left and right movement.",
        "The blade blocks bullets, so it\'s useful when surrounded."
    },
    [6] = {
        "Fires a spinning blade forward.",
        "Rather than shooting, the attack is \'placed\'.",
        "After a fixed time, it automatically returns."
    },
    [7] = {
        "Pierces enemies with a sharp, thin sword.",
        "Becomes random thrusts if the button",
        "is pushed rapidly."
    },
    [8] = {
        "Thrusts out a sword and jumps.",
        "While it can hit enemies to the side,",
        "it shows its true worth when attacking upwards."
    },
    [9] = {
        "Jumps, then attacks while falling.",
        "When used in midair, the initial",
        "jump is skipped, and you immediately",
        "begin falling."
    },
    [10] = {
        "Applies a lock and knocks away enemies that are hit.",
        "Suitable for a long range combat style."
    },
    [12] = {
        "A high speed thrust directly to the side.",
        "Applies a lock and knocks away enemies horizontally."
    },
    [13] = {
        "If at the same height as a locked enemy,",
        "teleports behind them and strongly",
        "knocks them upward.",
        "If no locked enemy in position,",
        "swings in place instead."
    },
    [14] = {
        "If a locked enemy is directly overhead,",
        "teleports to their side and strongly",
        "knocks them downward.",
        "If no locked enemy in position,",
        "swings in place instead."
    },
    [15] = {
        "If a locked enemy is in front and below,",
        "performs a suicide attack against them.",
        "Most enemy attacks are ignored while",
        "executing this attack."
    },
    [17] = {
        "A quick 5 hit combo.",
        "It has impressive reach in front and behind."
    },
    [18] = {
        "Builds up multiple slashes in your general area.",
        "Its wide range gives it excellent defense,",
        "but it\'s hard to hit a specific target."
    },
    [20] = {
        "Stabs enemies with an enormous blade.",
        "It has a long wind-up and high EP cost, but delivers",
        "a strong attack that ignores the enemy\'s defense."
    },
    [22] = {
        "Increases in reach while the button is held down.",
        "At its longest, covers nearly the whole screen."
    },
    [25] = {
        "Charges at high speed, dealing a",
        "crosswise attack to the first enemy hit.",
        "Completely invincible during the charge."
    },
    [30] = {
        "Launches blades that can hit enemies at long range.",
        "Also knocks away enemies hit at short range."
    },
    [33] = {
        "Leaves damaging fog in the wake of its attack.",
        "The higher the chain, the longer the",
        "fog lingers in place."
    },
    [41] = {
        "Basic and easy to handle.",
        "Nullifies several bullets or a single melee attack.",
        "Automatically homes in on locked on enemies."
    },
    [42] = {
        "Can only dash in the four cardinal directions.",
        "Highly resistant to bullets, with a wide attack range."
    },
    [43] = {
        "Turn into a ball and charge.",
        "Has weak bullet resistance and no homing,",
        "but the trajectory can be affected by",
        "pushing the direction keys in flight."
    },
    [44] = {
        "Has an aura like a pincushion.",
        "Pushes enemies in the direction of travel,",
        "allowing for chain hits.",
        "Produces a damaging explosion on contact with the wall."
    },
    [52] = {
        "Has no barrier at all.",
        "However, enemy attacks or taking damage",
        "will not cause you to flinch during use.",
        "Also applies a lock to enemies hit."
    },
    [50] = {
        "Turn into a small ball and charge.",
        "Can freely change directions in flight by",
        "pressing the movement keys.",
        "Also has the smallest hitbox among Assaults."
    },
    [55] = {
        "The fastest of all Assaults.",
        "It can easily dodge any kind of attack,",
        "but its high speed risks accidental collisions."
    },
    [60] = {
        "Combines lock on and homing.",
        "If you can land even one hit,",
        "it will continue to hit enemies automatically.",
        "Has good synergy with other homing weapons."
    },
    [70] = {
        "Prepared for Clarino by Diska.",
        "However, it\'s not truly an Assault,",
        "but instead produces a rapid succession of Blades.",
        "High consumption, but excellent clashing and bullet cancellation."
    },
    [81] = {
        "Fires two or more daggers in an arc.",
        "Automatically homes in on locked on enemies.",
    },
    [82] = {
        "Could be called the foundation of shmups.",
        "Fires straight forward.",
        "Can be fired rapidly, but has low damage,",
        "making it ineffective against heavy armor."
    },
    [83] = {
        "Locks on to hit enemies.",
        "Has high speed, but the lowest power of all Shots.",
        "Penetrates enemies that already have a lock on."
    },
    [84] = {
        "Stuns hit enemies.",
        "Its reload time is suitably long (2 sec),",
        "so it must be combined with other weapons.",
        "Not effective on all enemies."
    },
    [85] = {
        "Rises from behind, then drops down in front.",
        "Hard to use, but with high power.",
        "Deals splash damage around the impact point."
    },
    [86] = {
        "Homes in on locked on enemies at low speed.",
        "Because it simply drifts around with a lock on,",
        "it can be fired and saved up.",
        "However, only three may be active at once."
    },
    [87] = {
        "Homes in on locked on enemies at low speed.",
        "Gradually grows large and increases in strength.",
        "Rapid fire is impossible, as only one can be active at once."
    },
    [88] = {
        "Remains where it is placed by firing.",
        "Has relatively high power for its EP cost, but",
        "it\'s difficult to connect with because it doesn\'t move.",
        "Up to 10 can be active at once."
    },
    [89] = {
        "Bounces on impact with a wall.",
        "Bounces upwards after hitting an enemy.",
        "Powerful in close quarters.",
        "Its firing angle is a little imprecise."
    },
    [90] = {
        "Flies straight forward, dealing decent damage.",
        "Also the standard weapon of Skyside officers.",
        "A safe weapon, for better or worse."
    },
    [92] = {
        "Applies a lock on to hit enemies,",
        "and homes in on locked on enemies.",
        "Once you land one hit, the rest is automatic.",
        "In addition, the projectile is fairly fast."
    },
    [94] = {
        "Pierces all walls and enemies.",
        "Notably, passes through blocks without causing damage."
    },
    [95] = {
        "Jumps upward, then fires straight down.",
        "Creates an explosion on impact with the floor.",
        "When used in midair, the jump is omitted."
    },
    [96] = {
        "Fires short lasers in a random spread within a",
        "45 degree angle.",
        "Because the scatter is extreme, it\'s hard to aim.",
        "Number of shots increases with level."
    },
    [97] = {
        "Blocks bullets and returns fire.",
        "Can produce a terrifying barrage depending on the enemy.",
        "Usable as a shield, but has limited durability."
    },
    [99] = {
        "Produces an expanding circle around you.",
        "Also applies a lock on to hit enemies.",
        "Short range, but expands quickly and has good coverage.",
        "Well suited to close quarters combat."
    },
    [100] = {
        "Creates an anti-air tornado.",
        "When used in a space with no ceiling,",
        "becomes correspondingly massive."
    },
    [105] = {
        "Launches 7 bullets forward in a 120 degree arc.",
        "Overwhelmingly powerful against small enemies.",
        "However, because the damage of each projectile is low,",
        "it\'s ineffective against enemies with high defence."
    },
    [110] = {
        "Produces a pillar of flame that carpets the ground.",
        "Keeps going until a break in the terrain.",
        "Misfires if the first shot doesn\'t touch the floor."
    },
    [121] = {
        "Low power for a Charge Shot, but penetrates",
        "walls and enemies and applies a lock on.",
        "Can be fired diagonally by pressing up or down."
    },
    [122] = {
        "Calls down lightning in front of you.",
        "Hit enemies are knocked downward.",
        "Generates additional lightning for any",
        "locked on enemies."
    },
    [123] = {
        "Fires an energy ball forward.",
        "Can be charged further after a full charge,",
        "with increased power and size corresponding to charge time.",
        "However, charge resets to 0 upon taking damage.",
        "(Light hits can be endured.)"
    },
    [130] = {
        "A special Charge Shot that creates a block.",
        "Provides a powerful defence against enemies.",
        "Can be placed elsewhere by pressing up or down.",
        "The block can be destroyed enemies or you."
    },
    [135] = {
        "Generates a round shockwave.",
        "Hit enemies produce the same shockwave.",
        "If used in a crowded space, the chain reaction",
        "can cause mass destruction."
    },
    [140] = {
        "Destroys all bullets on the screen,",
        "deals heavy damage to all enemies, and applies a lock on.",
        "A very strong charge shot.",
        "However, can only be used 3 times per stage."
    },
    [162] = {
        "A different Blade can be assigned to each of",
        "「B」「→B」「↓B」「↑B」.",
        "Allows four Blades to be used at once."
    },
    [163] = {
        "A different Shot can be assigned to each of",
        "「S」「→S」「↓S」「↑S」.",
        "Allows four Shots to be used at once."
    },
    [164] = {
        "Charge Shot time is reduced to 1/4."
    },
    [166] = {
        "Fully restores LIFE the first time LIFE hits 0.",
        "If Burst Mode is in effect, it remains in effect."
    },
    [168] = {
        "Increases horizontal movement speed by a factor of 1.5.",
        "Allows horizontal movement even in midair.",
        "Uses no EP."
    },
    [169] = {
        "Reduces Blade energy consumption to 0."
    },
    [170] = {
        "Reduces Assault energy consumption to 0.",
        "In this game, filled with powerful applications,",
        "this one magnificently took 1st place:",
        "The King of Balance Crushers."
    },
    [171] = {
        "Reduces Shot energy consumption to 0."
    },
    [172] = {
        "Reduces Charge Shot energy consumption to 0."
    },
    [173] = {
        "Reduces all applications\' energy consumption",
        "to 2/3."
    },
    [180] = {
        "Continuously fires the Shot at half reload speed",
        "while the button remains held down.",
        "Charge Shot cannot be used when equipped."
    },
    [181] = {
        "Continuously fires the Charge Shot",
        "while the button remains held down.",
        "Shot cannot be used when equipped."
    },
    [185] = {
        "Eliminates knockback from enemies and forced movement.",
        "May cause stiffness."
    },
    [187] = {
        "No longer lose lock on even when taking damage.",
        "Lock can still be released by button 4."
    },
    [190] = {
        "Applies a lock on to all enemies who enter the circle.",
        "Button 4 turns it on or off."
    },
    [195] = {
        "Removes the effect of gravity,",
        "allowing free movement in any direction.",
        "Consumes no Energy, and allows",
        "recovery when not attacking."
    },
    [198] = {
        "Converts the user into virus data",
        "for the purpose of infecting the opponent.",
        "Can be unequipped after the infection succeeds.",
        "...However, the change is irreversible."
    },
    [200] = {
        "Unite with Applica.",
        "Absorbs energy from enemies when dealing damage,",
        "and absorbing energy also recovers life.",
        "In addition, increases weapon max level and allows level ups in battle.",
        "　　　　　　　　※Can only be used in stage 16."
    }
}