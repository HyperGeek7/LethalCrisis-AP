from __future__ import annotations

from typing import TYPE_CHECKING

from BaseClasses import Location, LocationProgressType

from .items import LethalCrisisItem

if TYPE_CHECKING:
    from .world import LethalCrisisWorld

# 16751, Clarino's height and weight
LC_LOC_BASE = 167512000

LOCATION_NAME_TO_ID: dict[str, int] = {}


def rank_location_name(stage: str | int, rank: str):
    return f"Stage {stage} Rank {rank}"


# May as well use the same codes LC uses internally.
# These are always in the form (stage_code * 10) + [1-5] for ranks [S-D].

# For the first 16 stages, the stage code matches the player-facing stage name.
for i in range(1, 17):
    LOCATION_NAME_TO_ID[rank_location_name(i, "S")] = 1 + (i * 10) + LC_LOC_BASE
    LOCATION_NAME_TO_ID[rank_location_name(i, "A")] = 2 + (i * 10) + LC_LOC_BASE
    LOCATION_NAME_TO_ID[rank_location_name(i, "B")] = 3 + (i * 10) + LC_LOC_BASE
    LOCATION_NAME_TO_ID[rank_location_name(i, "C")] = 4 + (i * 10) + LC_LOC_BASE
    LOCATION_NAME_TO_ID[rank_location_name(i, "D")] = 5 + (i * 10) + LC_LOC_BASE

# Stage 7B is 17
LOCATION_NAME_TO_ID[rank_location_name("7B", "S")] = 171 + LC_LOC_BASE
LOCATION_NAME_TO_ID[rank_location_name("7B", "A")] = 172 + LC_LOC_BASE
LOCATION_NAME_TO_ID[rank_location_name("7B", "B")] = 173 + LC_LOC_BASE
LOCATION_NAME_TO_ID[rank_location_name("7B", "C")] = 174 + LC_LOC_BASE
LOCATION_NAME_TO_ID[rank_location_name("7B", "D")] = 175 + LC_LOC_BASE

# Stages 10B - 17B are 18 - 25
for i in range(18, 26):
    stage = f"{i - 8}B"
    LOCATION_NAME_TO_ID[rank_location_name(stage, "S")] = 1 + (i * 10) + LC_LOC_BASE
    LOCATION_NAME_TO_ID[rank_location_name(stage, "A")] = 2 + (i * 10) + LC_LOC_BASE
    LOCATION_NAME_TO_ID[rank_location_name(stage, "B")] = 3 + (i * 10) + LC_LOC_BASE
    LOCATION_NAME_TO_ID[rank_location_name(stage, "C")] = 4 + (i * 10) + LC_LOC_BASE
    LOCATION_NAME_TO_ID[rank_location_name(stage, "D")] = 5 + (i * 10) + LC_LOC_BASE


class LethalCrisisLocation(Location):
    game = "Lethal Crisis"


class ExcludedLethalCrisisLocation(LethalCrisisLocation):
    progress_type = LocationProgressType.EXCLUDED


def create_all_locations(world: LethalCrisisWorld) -> None:
    create_regular_locations(world)
    create_events(world)


# Thanks, APQuest!
def get_location_names_with_ids(location_names: list[str]) -> dict[str, int | None]:
    return {location_name: LOCATION_NAME_TO_ID[location_name] for location_name in location_names}


def create_regular_locations(world: LethalCrisisWorld) -> None:
    # The good news is that every stage has exactly 5 checks, and they all follow
    # the same naming format, so we can just generate this nonsense programmatically.

    stage_nums = [str(i) for i in range(1, 17)] + ["7B"] + [f"{i}B" for i in range(10, 18)]

    excluded_locations: list[str] = []
    if world.options.exclude_stage_14b_a_rank:
        excluded_location = rank_location_name("14B", "A")
        excluded_locations.append(excluded_location)
        world.get_region("Stage 14B").add_locations(
            get_location_names_with_ids(
                [
                    excluded_location,
                ]
            ),
            ExcludedLethalCrisisLocation,
        )

    for stage in stage_nums:
        stage_region = world.get_region(f"Stage {stage}")
        stage_locations = [
            rank_location_name(stage, "S"),
            rank_location_name(stage, "A"),
            rank_location_name(stage, "B"),
            rank_location_name(stage, "C"),
            rank_location_name(stage, "D"),
        ]

        normal_locations = [location for location in stage_locations if location not in excluded_locations]
        stage_region.add_locations(get_location_names_with_ids(normal_locations), LethalCrisisLocation)


def create_events(world: LethalCrisisWorld):
    stage_nums = [f"Stage {i}" for i in range(1, 17)] + [f"Stage {i}B" for i in range(10, 18)]
    for stage_num in stage_nums:
        # All stages except for 16, 7B, and 17B unlock another stage when you clear their D rank,
        # so add an event to track each of these. Also add one for 17B anyways because that's how
        # you clear the game, and one for 16 because that's a prerequisite to opening the B stages.
        stage_region = world.get_region(stage_num)
        stage_region.add_event(f"{stage_num}-D Clear", location_type=LethalCrisisLocation, item_type=LethalCrisisItem)

    # The first 8 stages must also have their C ranks cleared to unlock stage 9.

    for i in range(1, 9):
        stage_num = f"Stage {i}"
        stage_region = world.get_region(stage_num)
        stage_region.add_event(f"{stage_num}-C Clear", location_type=LethalCrisisLocation, item_type=LethalCrisisItem)

    # The below is true in "normal" play, but I'm going to shuffle the unlock items in the first pass,
    # so 7-S and 9-S are no longer magic.
    """
    # Stages 7 and 9 unlock new stages with their S ranks, so put an event for each of those as well.
    stage_7 = world.get_region("Stage 7")
    stage_7.add_event("Stage 7-S Clear", location_type = LethalCrisisLocation, item_type = LethalCrisisItem)

    stage_9 = world.get_region("Stage 9")
    stage_9.add_event("Stage 9-S Clear", location_type = LethalCrisisLocation, item_type = LethalCrisisItem)
    """
