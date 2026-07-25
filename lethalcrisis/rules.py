from __future__ import annotations

from functools import partial
from typing import TYPE_CHECKING

from BaseClasses import CollectionState
from rule_builder.rules import Has, HasAll, HasAny

from . import names
from .locations import rank_location_name

if TYPE_CHECKING:
    from .world import LethalCrisisWorld

STARTING_LIFE = 1000
STARTING_ENERGY = 1000


# I'm trying to add some logic to make sure ranks are doable, but it may be a
# bit too restrictive now - e.g. it's almost certainly possible to get the high chain
# ranks without Twin Shot or 7-Way, but *I* can't do it reliably, so that's how I'm
# building the logic out for now. It can be tuned later, and/or made into options
# if anyone who's actually good at this game wants to pick up the AP.

# Twin Shot and 7-Way are the "standard" way to get chain ranks.
HAS_CHAINING_WEAPON = HasAny(names.twin_shot, names.seven_way)

# To the best of my knowledge, B-Commander, Ghost Fluerette, and Spike are absolutely required
# to enter the secret room and get rank 7-S and all of 7B's ranks.
CAN_ENTER_SECRET_ROOM = HasAll(names.b_commander, names.ghost_fluerette, names.spike)

# Have a "fast" assault option to make time trial ranks a bit more feasible.
HAS_FAST_ASSAULT = HasAny(names.silpheed, names.aura_assault, names.sharpness, names.junk_ball)

# A couple of "wide-range murder" buttons. These are, again, probably not strictly necessary for
# the ranks I've assigned this rule to, but it makes them a bit more feasible.
HAS_SCREEN_CLEAR = HasAny(names.nova, names.stgb)

# TODO: In my experience, 10-A basically requires some fiddly offscreen aiming to kill a
# high up block without jumping. Screen clear would handle this, and I've used 7-Way to
# get it in the past. Southern Cross or Ghost Fluerette _might_ let you make up enough
# horizontal speed to just jump for it anyways.
# Point is, there should probably be _some_ logic around that check, but I'm not sure
# what to actually make it.


def set_all_rules(world: LethalCrisisWorld):
    set_all_location_rules(world)
    set_completion_condition(world)


def set_all_location_rules(world: LethalCrisisWorld):
    def has_max_life(state: CollectionState, life_target: int, player: int) -> bool:
        life_total = (
            STARTING_LIFE
            + (state.count(names.small_life, player) * 50)
            + (state.count(names.med_life, player) * 100)
            + (state.count(names.large_life, player) * 200)
        )
        return life_total >= life_target

    # These ranks require a chain greater than 100.
    # We should ensure access to one of the weapons that makes this feasible.
    # Consider adding a similar rule to score ranks?
    # Chains are by far the easiest way to build up a high score,
    # but generally not the *only* way.
    chain_ranks = [
        rank_location_name("4", "S"),
        rank_location_name("8", "C"),
        rank_location_name("11", "S"),
        rank_location_name("12", "C"),
        rank_location_name("14", "B"),
        rank_location_name("10B", "A"),
        rank_location_name("12B", "B"),
        rank_location_name("14B", "C"),
        rank_location_name("15B", "B"),
        rank_location_name("16B", "A"),
        rank_location_name("17B", "B"),
    ]

    for rank in chain_ranks:
        world.set_rule(world.get_location(rank), HAS_CHAINING_WEAPON)

    # These ranks require you to finish with a certain amount of life left in the tank.
    # Burst abuse can generally be used to get all of your life back right as the stage ends,
    # but your max has to be at least at the target.
    world.set_rule(
        world.get_location(rank_location_name(6, "A")), partial(has_max_life, life_target=1200, player=world.player)
    )
    world.set_rule(
        world.get_location(rank_location_name(9, "A")), partial(has_max_life, life_target=1600, player=world.player)
    )
    world.set_rule(
        world.get_location(rank_location_name("13B", "S")), partial(has_max_life, life_target=3000, player=world.player)
    )

    # 7-S requires a specific set of applications equipped
    world.set_rule(world.get_location(rank_location_name(7, "S")), CAN_ENTER_SECRET_ROOM)

    # All ranks in 7B require the secret room, same as 7-S
    world.set_rule(world.get_location(rank_location_name("7B", "S")), CAN_ENTER_SECRET_ROOM)
    world.set_rule(world.get_location(rank_location_name("7B", "A")), CAN_ENTER_SECRET_ROOM)
    world.set_rule(world.get_location(rank_location_name("7B", "B")), CAN_ENTER_SECRET_ROOM)
    world.set_rule(world.get_location(rank_location_name("7B", "C")), CAN_ENTER_SECRET_ROOM)
    world.set_rule(world.get_location(rank_location_name("7B", "D")), CAN_ENTER_SECRET_ROOM)

    # 9-S requires one specific application
    world.set_rule(world.get_location(rank_location_name(9, "S")), Has(names.virus_transform))

    # These are time trial ranks. They probably don't strictly require one of the "fast" assaults
    # on my list, but putting them in logic makes it less likely the player will get blocked.
    time_ranks = [
        rank_location_name(4, "B"),
        rank_location_name(5, "S"),
        rank_location_name(7, "A"),
        rank_location_name(10, "S"),
        rank_location_name(11, "A"),
        rank_location_name(13, "A"),
        rank_location_name("10B", "S"),
        rank_location_name("12B", "S"),
        rank_location_name("14B", "S"),
    ]
    for rank in time_ranks:
        world.set_rule(world.get_location(rank), HAS_FAST_ASSAULT)

    screen_clear_ranks = [
        rank_location_name(8, "A"),
        rank_location_name(10, "C"),
    ]
    for rank in screen_clear_ranks:
        world.set_rule(world.get_location(rank), HAS_SCREEN_CLEAR)


def set_completion_condition(world: LethalCrisisWorld):
    world.set_completion_rule(Has("Stage 17B-D Clear"))
