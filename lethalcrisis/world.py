from typing import override

from worlds.AutoWorld import World

from . import options as lethalcrisis_options
from . import regions, locations, items, rules, names

class LethalCrisisWorld(World):
    """Lethal Crisis"""

    game = "Lethal Crisis"

    options_dataclass = lethalcrisis_options.LethalCrisisOptions
    options: lethalcrisis_options.LethalCrisisOptions

    origin_region_name = "Intermission"

    location_name_to_id = locations.LOCATION_NAME_TO_ID
    item_name_to_id = items.ITEM_NAME_TO_ID

    starting_blade = names.trislash
    starting_assault = names.step_arrow
    starting_shot = names.throw_dagger
    starting_charge = names.lock_shot

    @override
    def create_regions(self):
        regions.create_and_connect_regions(self)
        locations.create_all_locations(self)

    @override
    def set_rules(self):
        rules.set_all_rules(self)
    
    @override
    def generate_early(self) -> None:
        if self.options.shuffle_starting_equipment:
            self.starting_blade = self.random.choice(list(items.blades.keys()))
            self.starting_assault = self.random.choice(list(items.assaults.keys()))
            self.starting_shot = self.random.choice(list(items.shots.keys()))
            self.starting_charge = self.random.choice(list(items.charges.keys()))

    @override
    def create_items(self):
        starting_gear = [self.starting_blade, self.starting_assault, self.starting_shot, self.starting_charge]
        for item_name in starting_gear:
            self.push_precollected(self.create_item(item_name))

        items.create_all_items(self, starting_gear)
    
    @override
    def fill_slot_data(self):
        return {
            "starting_blade": items.ITEM_NAME_TO_ID[self.starting_blade] - items.LC_ITEM_BASE,
            "starting_assault": items.ITEM_NAME_TO_ID[self.starting_assault] - items.LC_ITEM_BASE,
            "starting_shot": items.ITEM_NAME_TO_ID[self.starting_shot] - items.LC_ITEM_BASE,
            "starting_charge": items.ITEM_NAME_TO_ID[self.starting_charge] - items.LC_ITEM_BASE,
        }
    
    @override
    def create_item(self, name: str):
        return items.create_item_with_correct_classification(self, name)
    
    @override
    def get_filler_item_name(self) -> str:
        return items.get_random_filler_item_name(self)
