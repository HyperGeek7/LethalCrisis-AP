from __future__ import annotations

from functools import partial
from typing import TYPE_CHECKING

from BaseClasses import CollectionState, Region
from rule_builder.rules import Has, HasAll, HasAny

from . import names

if TYPE_CHECKING:
    from .world import LethalCrisisWorld


def create_and_connect_regions(world: LethalCrisisWorld) -> None:
    create_all_regions(world)
    connect_regions(world)


def create_all_regions(world: LethalCrisisWorld) -> None:
    intermission = Region("Intermission", world.player, world.multiworld)
    stage1 = Region("Stage 1", world.player, world.multiworld)
    stage2 = Region("Stage 2", world.player, world.multiworld)
    stage3 = Region("Stage 3", world.player, world.multiworld)
    stage4 = Region("Stage 4", world.player, world.multiworld)
    stage5 = Region("Stage 5", world.player, world.multiworld)
    stage6 = Region("Stage 6", world.player, world.multiworld)
    stage7 = Region("Stage 7", world.player, world.multiworld)
    stage8 = Region("Stage 8", world.player, world.multiworld)
    stage9 = Region("Stage 9", world.player, world.multiworld)
    stage10 = Region("Stage 10", world.player, world.multiworld)
    stage11 = Region("Stage 11", world.player, world.multiworld)
    stage12 = Region("Stage 12", world.player, world.multiworld)
    stage13 = Region("Stage 13", world.player, world.multiworld)
    stage14 = Region("Stage 14", world.player, world.multiworld)
    stage15 = Region("Stage 15", world.player, world.multiworld)
    stage16 = Region("Stage 16", world.player, world.multiworld)
    stage7B = Region("Stage 7B", world.player, world.multiworld)
    stage10B = Region("Stage 10B", world.player, world.multiworld)
    stage11B = Region("Stage 11B", world.player, world.multiworld)
    stage12B = Region("Stage 12B", world.player, world.multiworld)
    stage13B = Region("Stage 13B", world.player, world.multiworld)
    stage14B = Region("Stage 14B", world.player, world.multiworld)
    stage15B = Region("Stage 15B", world.player, world.multiworld)
    stage16B = Region("Stage 16B", world.player, world.multiworld)
    stage17B = Region("Stage 17B", world.player, world.multiworld)

    regions = [
        intermission,
        stage1,
        stage2,
        stage3,
        stage4,
        stage5,
        stage6,
        stage7,
        stage8,
        stage9,
        stage10,
        stage11,
        stage12,
        stage13,
        stage14,
        stage15,
        stage16,
        stage7B,
        stage10B,
        stage11B,
        stage12B,
        stage13B,
        stage14B,
        stage15B,
        stage16B,
        stage17B,
    ]

    world.multiworld.regions += regions


def connect_regions(world: LethalCrisisWorld) -> None:
    intermission = world.get_region("Intermission")

    # LC has a central "intermission" menu that can be used to access any stage you have access to.
    # There are no other connections between stages, and most stages simply require that you clear the previous stage.
    # Which is to say, you've gotten the D rank of the previous stage in the sequence.

    stage1 = world.get_region("Stage 1")
    intermission.connect(stage1, "Start Stage 1")

    for stage_num in range(2, 9):
        _ = intermission.connect(
            world.get_region(f"Stage {stage_num}"), f"Start Stage {stage_num}", Has(f"Stage {stage_num - 1}-D Clear")
        )

    # Stage 9 is special. Maybe.
    # Under normal play, you must have the C ranks from stages 1 - 8 to get into stage 9.
    # I'm unsure if setting the GameClear flag removes this restriction, but we'll
    # leave the requirement in logic regardless.
    stage9 = world.get_region("Stage 9")
    _ = intermission.connect(
        stage9, "Start Stage 9", HasAll("Stage 8-D Clear", *(f"Stage {stage}-C Clear" for stage in range(1, 9)))
    )

    for stage_num in range(10, 16):
        _ = intermission.connect(
            world.get_region(f"Stage {stage_num}"), f"Start Stage {stage_num}", Has(f"Stage {stage_num - 1}-D Clear")
        )

    # TODO: This should really be an option.
    # You can *technically* do stage 16 without Applica, and, indeed, this is required for
    # the S rank. But I don't want the rando to expect me to get any of the other ranks without
    # her as backup, so I'm making her required.
    _ = intermission.connect(world.get_region(f"Stage 16"), "Start Stage 16", HasAll("Stage 15-D Clear", names.applica))

    # 7B and 10B are oddballs in that they require specific items in addition all "normal" D-ranks.
    normal_d_ranks = [f"Stage {stage_num}-D Clear" for stage_num in range(1, 17)]

    stage7B = world.get_region("Stage 7B")
    _ = intermission.connect(
        stage7B, "Start Stage 7B", HasAll(*normal_d_ranks) & HasAny(names.unlock_7b, names.unlock_10b)
    )

    stage10B = world.get_region("Stage 10B")
    _ = intermission.connect(stage10B, "Start Stage 10B", HasAll(names.unlock_7b, names.unlock_10b, *normal_d_ranks))

    for stage_num in range(11, 18):
        _ = intermission.connect(
            world.get_region(f"Stage {stage_num}B"), f"Start Stage {stage_num}B", Has(f"Stage {stage_num - 1}B-D Clear")
        )
