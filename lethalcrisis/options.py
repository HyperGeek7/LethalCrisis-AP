from dataclasses import dataclass

from Options import PerGameCommonOptions, Toggle


class ShuffleStartingEquipment(Toggle):
    """
    Start with a random Blade, Assault, Shot, and Charge
    """

    display_name = "Shuffle Starting Equipment"
    default = Toggle.option_false


class ExcludeStage14BARank(Toggle):
    """
    Exclude Stage 14B's A Rank from randomized locations
    """

    # This particular rank feels absurdly difficult to me.
    # Like, get every other rank in the game and still throw dozens
    # of attempts at it hard. That's _probably_ just me being bad,
    # but since I'm not really anticipating anyone else playing this
    # world, I'm adding an option to kick this stage out. So there.
    display_name = "Exclude Stage 14B's A Rank"


@dataclass
class LethalCrisisOptions(PerGameCommonOptions):
    shuffle_starting_equipment: ShuffleStartingEquipment
    exclude_stage_14b_a_rank: ExcludeStage14BARank
