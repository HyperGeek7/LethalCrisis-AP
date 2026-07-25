from BaseClasses import Tutorial
from worlds.AutoWorld import WebWorld


class LethalCrisisWebWorld(WebWorld):
    game = "Lethal Crisis"
    theme = "ocean"
    setup_en = Tutorial(
        "Multiworld Setup Guide",
        "A guide to setting up Lethal Crisis for MultiWorld.",
        "English",
        "setup_en.md",
        "setup/en",
        ["HyperGeek"],
    )

    tutorials = [
        setup_en,
    ]
