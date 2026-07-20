from __future__ import annotations
from enum import IntEnum
from typing import NamedTuple, TYPE_CHECKING

from BaseClasses import Item, ItemClassification
from . import names

if TYPE_CHECKING:
    from .world import LethalCrisisWorld

# 16751, Clarino's height and weight
LC_ITEM_BASE = 167511000

class ApplicationType(IntEnum):
    BLADE = 0
    SHOT = 1
    ASSAULT = 2
    CHARGE = 3
    CUSTOM = 4
    STAT_UPS = 5
    STAGE_UNLOCKS = 6


class ItemData(NamedTuple):
    code: int
    category: ApplicationType
    classification: ItemClassification

# The temptation to mark some applications as filler is strong,
# but I'm not going to pretend I'm the world's best LC player or know
# what's genuinely good and what isn't.
# Unless they're mandatory to beat the game, applications are marked as useful but not priority.
GENERAL_APPLICATION = ItemClassification.useful | ItemClassification.deprioritized

blades = {
    names.trislash: ItemData(1, ApplicationType.BLADE, GENERAL_APPLICATION),
    names.strider: ItemData(2, ApplicationType.BLADE, GENERAL_APPLICATION),
    names.ghost_fluerette: ItemData(4, ApplicationType.BLADE, ItemClassification.progression),
    names.whirlpool: ItemData(5, ApplicationType.BLADE, GENERAL_APPLICATION),
    names.yo_yo: ItemData(6, ApplicationType.BLADE, GENERAL_APPLICATION),
    #names.tack_rush: ItemData(7, ApplicationType.BLADE, GENERAL_APPLICATION),
    names.altrise: ItemData(8, ApplicationType.BLADE, GENERAL_APPLICATION),
    names.headhunt: ItemData(9, ApplicationType.BLADE, GENERAL_APPLICATION),
    names.smash: ItemData(10, ApplicationType.BLADE, GENERAL_APPLICATION),
    names.eintraf: ItemData(12, ApplicationType.BLADE, GENERAL_APPLICATION),
    names.zweitraf: ItemData(13, ApplicationType.BLADE, GENERAL_APPLICATION),
    names.dreitraf: ItemData(14, ApplicationType.BLADE, GENERAL_APPLICATION),
    #names.trafia: ItemData(15, ApplicationType.BLADE, GENERAL_APPLICATION),
    names.whipper: ItemData(17, ApplicationType.BLADE, GENERAL_APPLICATION),
    names.nettle: ItemData(18, ApplicationType.BLADE, GENERAL_APPLICATION),
    names.spike: ItemData(20, ApplicationType.BLADE, ItemClassification.progression),
    names.clarity: ItemData(22, ApplicationType.BLADE, GENERAL_APPLICATION),
    names.southern_cross: ItemData(25, ApplicationType.BLADE, GENERAL_APPLICATION),
    names.murakumo: ItemData(30, ApplicationType.BLADE, GENERAL_APPLICATION),
    names.muramasa: ItemData(33, ApplicationType.BLADE, GENERAL_APPLICATION),
}

assaults = {
    names.step_arrow: ItemData(41, ApplicationType.ASSAULT, GENERAL_APPLICATION),
    names.aura_assault: ItemData(42, ApplicationType.ASSAULT, GENERAL_APPLICATION),
    names.junk_ball: ItemData(43, ApplicationType.ASSAULT, GENERAL_APPLICATION),
    names.pressure: ItemData(44, ApplicationType.ASSAULT, GENERAL_APPLICATION),
    names.sharpness: ItemData(50, ApplicationType.ASSAULT, GENERAL_APPLICATION),
    names.kamikaze: ItemData(52, ApplicationType.ASSAULT, GENERAL_APPLICATION),
    names.silpheed: ItemData(55, ApplicationType.ASSAULT, GENERAL_APPLICATION),
    names.biting: ItemData(60, ApplicationType.ASSAULT, GENERAL_APPLICATION),
    names.vjorum: ItemData(70, ApplicationType.ASSAULT, GENERAL_APPLICATION),
}

# TODO: Maybe we should randomly pick one of the chain weapons to mark as progression
# per seed and leave the others as general? How do other games handle this?
shots = {
    names.throw_dagger: ItemData(81, ApplicationType.SHOT, GENERAL_APPLICATION),
    names.twin_shot: ItemData(82, ApplicationType.SHOT, ItemClassification.progression_deprioritized_skip_balancing),
    names.stamp: ItemData(83, ApplicationType.SHOT, GENERAL_APPLICATION),
    names.cold_spear: ItemData(84, ApplicationType.SHOT, GENERAL_APPLICATION),
    names.starfall: ItemData(85, ApplicationType.SHOT, GENERAL_APPLICATION),
    names.blue_wisp: ItemData(86, ApplicationType.SHOT, GENERAL_APPLICATION),
    names.red_wisp: ItemData(87, ApplicationType.SHOT, GENERAL_APPLICATION),
    names.green_wisp: ItemData(88, ApplicationType.SHOT, GENERAL_APPLICATION),
    names.bounder: ItemData(89, ApplicationType.SHOT, GENERAL_APPLICATION),
    names.plasma_rifle: ItemData(90, ApplicationType.SHOT, GENERAL_APPLICATION),
    names.shell_flow: ItemData(92, ApplicationType.SHOT, GENERAL_APPLICATION),
    names.antimaterial: ItemData(94, ApplicationType.SHOT, GENERAL_APPLICATION),
    names.bunker_buster: ItemData(95, ApplicationType.SHOT, GENERAL_APPLICATION),
    names.slug_laser: ItemData(96, ApplicationType.SHOT, GENERAL_APPLICATION),
    names.mirror_wall: ItemData(97, ApplicationType.SHOT, GENERAL_APPLICATION),
    names.pulse: ItemData(99, ApplicationType.SHOT, GENERAL_APPLICATION),
    names.tornado: ItemData(100, ApplicationType.SHOT, GENERAL_APPLICATION),
    names.seven_way: ItemData(105, ApplicationType.SHOT, ItemClassification.progression_deprioritized_skip_balancing),
    names.grand_blaze: ItemData(110, ApplicationType.SHOT, GENERAL_APPLICATION),
}

charges = {
    names.lock_shot: ItemData(121, ApplicationType.CHARGE, GENERAL_APPLICATION),
    names.lightning: ItemData(122, ApplicationType.CHARGE, GENERAL_APPLICATION),
    names.nova: ItemData(123, ApplicationType.CHARGE, GENERAL_APPLICATION),
    names.solomon: ItemData(130, ApplicationType.CHARGE, GENERAL_APPLICATION),
    names.howling: ItemData(135, ApplicationType.CHARGE, GENERAL_APPLICATION),
    names.stgb: ItemData(140, ApplicationType.CHARGE, GENERAL_APPLICATION),
}

customs = {
    names.b_commander: ItemData(162, ApplicationType.CUSTOM, ItemClassification.progression),
    names.s_commander: ItemData(163, ApplicationType.CUSTOM, GENERAL_APPLICATION),
    names.c_quick: ItemData(164, ApplicationType.CUSTOM, GENERAL_APPLICATION),
    names.auto_repair: ItemData(166, ApplicationType.CUSTOM, GENERAL_APPLICATION),
    names.free_vernier: ItemData(168, ApplicationType.CUSTOM, GENERAL_APPLICATION),
    names.b_mastery: ItemData(169, ApplicationType.CUSTOM, GENERAL_APPLICATION),
    names.a_mastery: ItemData(170, ApplicationType.CUSTOM, GENERAL_APPLICATION),
    names.s_mastery: ItemData(171, ApplicationType.CUSTOM, GENERAL_APPLICATION),
    names.c_mastery: ItemData(172, ApplicationType.CUSTOM, GENERAL_APPLICATION),
    names.ep_saving: ItemData(173, ApplicationType.CUSTOM, GENERAL_APPLICATION),
    names.s_full_auto: ItemData(180, ApplicationType.CUSTOM, GENERAL_APPLICATION),
    names.c_full_auto: ItemData(181, ApplicationType.CUSTOM, GENERAL_APPLICATION),
    names.balancer: ItemData(185, ApplicationType.CUSTOM, GENERAL_APPLICATION),
    names.hard_lock: ItemData(187, ApplicationType.CUSTOM, GENERAL_APPLICATION),
    names.lock_circle: ItemData(190, ApplicationType.CUSTOM, GENERAL_APPLICATION),
    names.floater: ItemData(195, ApplicationType.CUSTOM, GENERAL_APPLICATION),
    names.virus_transform: ItemData(198, ApplicationType.CUSTOM, ItemClassification.progression_skip_balancing),
    # Applica *technically* isn't required, but I'm marking her as necessary for stage 16 in logic.
    names.applica: ItemData(200, ApplicationType.CUSTOM, ItemClassification.progression),
}

stat_ups = {
    names.small_life: ItemData(-1, ApplicationType.STAT_UPS, ItemClassification.filler),
    names.med_life: ItemData(-2, ApplicationType.STAT_UPS, ItemClassification.progression_deprioritized_skip_balancing),
    names.large_life: ItemData(-3, ApplicationType.STAT_UPS, ItemClassification.progression_deprioritized_skip_balancing),
    names.small_energy: ItemData(-11, ApplicationType.STAT_UPS, ItemClassification.filler),
    names.med_energy: ItemData(-12, ApplicationType.STAT_UPS, ItemClassification.progression_deprioritized_skip_balancing),
    names.large_energy: ItemData(-13, ApplicationType.STAT_UPS, ItemClassification.progression_deprioritized_skip_balancing),
}

# Stage unlocks are...weird. The game keeps track of which stages you have access to via a simple integer counter.
# Getting the D rank on any stage besides 16, 7B, or 17B increments the counter, allowing access to the next stage
# in sequence. Stage rewards -21 and -22 also increment the counter. -21 is 7's S-rank and unlocks access to 7B.
# -22 is is 9's S-rank and unlocks access to 10B. Notably, there's no actual logic to say that -21 unlocks 7B:
# in normal gameplay, you can't get 7-S without having already beaten 16-D, and you can't get 9-S without having
# beaten 7B-S, so these are just progressive unlocks. The next stage you unlock after 16 is always 7B, then 10B.
# In practice, I _think_ I can have the AP manager inside the game just hard set the unlock counter depending on
# what locations you've checked and which unlock items you have. But I could also _not_ do that. Might make for a
# fun/cursed option to just let -21 and -22 increment your stage access regardless of where they are.
stage_unlocks = {
    names.unlock_7b: ItemData(-21, ApplicationType.STAGE_UNLOCKS, ItemClassification.progression_skip_balancing),
    names.unlock_10b: ItemData(-22, ApplicationType.STAGE_UNLOCKS, ItemClassification.progression_skip_balancing)
}

all_items = blades | assaults | shots | charges | customs | stat_ups | stage_unlocks

ITEM_NAME_TO_ID: dict[str, int] = {
    k: v.code + LC_ITEM_BASE for k, v in all_items.items()
}

def get_random_filler_item_name(world: LethalCrisisWorld):
    # There's potential for traps in this world,
    # but for now, let's just pick a helpful filler at random.
    return world.random.choice([
        names.small_energy,
        names.small_life
    ])

def create_item_with_correct_classification(world: LethalCrisisWorld, name: str):
    item = all_items[name]
    return LethalCrisisItem(name, item.classification, item.code + LC_ITEM_BASE, world.player)

def create_all_items(world: LethalCrisisWorld, starting_gear: list[str]):
    # Stat items are the only ones that can duplicate, so we'll handle them in a moment.
    non_stat_items = blades | assaults | shots | charges | customs | stage_unlocks

    itempool = [world.create_item(name) for name in non_stat_items if name not in starting_gear]

    stat_up_counts = {
        names.small_life: 5,
        names.med_life: 14,
        names.large_life: 11,
        names.small_energy: 3,
        names.med_energy: 13,
        names.large_energy: 11
    }

    # Yes, this could be a single list comprehension.
    # Yes, that would probably be more efficient.
    # No, I'm not doing it. Multi-layer list comprehensions
    # hurt my brain.
    for name, count in stat_up_counts.items():
        itempool += [world.create_item(name) for _ in range(count)]
    
    # Just in case...
    empty_count = len(world.multiworld.get_unfilled_locations(world.player)) - len(itempool)
    itempool += [world.create_filler() for _ in range(empty_count)]

    world.multiworld.itempool += itempool

class LethalCrisisItem(Item):
    game = "Lethal Crisis"