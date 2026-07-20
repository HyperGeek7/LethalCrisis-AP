from __future__ import annotations

import asyncio
import json
import multiprocessing
from collections import Counter
from typing import Any, Optional, override

from CommonClient import CommonContext, get_base_parser, gui_enabled, logger, server_loop
from NetUtils import ClientStatus
from Utils import async_start, init_logging

from .items import LC_ITEM_BASE
from .locations import LC_LOC_BASE


class LethalCrisisContext(CommonContext):
    game = "Lethal Crisis"
    items_handling = 0b001
    pending_messages: list[dict[str, Any]]
    proxy_server: Optional[asyncio.Server] = None
    server_task: Optional[asyncio.Task] = None
    client_reader: Optional[asyncio.StreamReader] = None
    client_writer: Optional[asyncio.StreamWriter] = None
    welcome_packet: list[dict[str, Any]]

    def __init__(self, server_address: Optional[str] = None, password: Optional[str] = None) -> None:
        super().__init__(server_address, password)
        self.pending_messages = []
        self.welcome_packet = []

    async def server_auth(self, password_requested: bool = False):
        if password_requested and not self.password:
            await super(LethalCrisisContext, self).server_auth(password_requested)

        await self.get_username()
        await self.send_connect()
        self.proxy_server = await self.start_proxy_server()

    def run_gui(self):
        from kvui import GameManager

        class LethalCrisisManager(GameManager):
            logging_pairs = [("Client", "Archipelago")]
            base_title = "Archipelago Lethal Crisis Client"

        self.ui = LethalCrisisManager(self)
        self.ui_task = asyncio.create_task(self.ui.async_run(), name="UI")

    @override
    def on_package(self, cmd: str, args: dict):
        logger.debug(f"%s: %s", cmd, args)

        if cmd == "Connected":
            logger.info("Waiting for Lethal Crisis...")
            async_start(
                self.send_msgs(
                    [
                        {
                            "cmd": "LocationScouts",
                            "locations": self.server_locations,
                            "create_as_hint": 0,
                        }
                    ]
                )
            )
            if "slot_data" in args and len(args["slot_data"]):
                slot_data = {
                    "type": "SlotData",
                    "slot_data": args["slot_data"],
                }
                self.welcome_packet.append(slot_data)

                # self.pending_messages.append(slot_data)
        elif cmd == "LocationInfo":
            location_rewards: dict[int, str | int] = {}
            for location in args["locations"]:
                if self.slot_concerns_self(location.player):
                    location_rewards[location.location - LC_LOC_BASE] = location.item - LC_ITEM_BASE
                else:
                    player_name = self.player_names[location.player]
                    item_name = self.item_names.lookup_in_slot(location.item, location.player)
                    location_rewards[location.location - LC_LOC_BASE] = f"{player_name}'s {item_name}"
            logger.debug(location_rewards)
            location_data = {"type": "LocationInfo", "locations": location_rewards}
            self.welcome_packet.append(location_data)
            # self.pending_messages.append(location_data)

    async def start_proxy_server(self):
        return await asyncio.start_server(self.client_connected, host="localhost", port=9292)

    def client_connected(self, client_reader: asyncio.StreamReader, client_writer: asyncio.StreamWriter):
        self.client_reader = client_reader
        self.client_writer = client_writer
        self.server_task = asyncio.create_task(self.server_loop())

    async def server_loop(self):
        while self.client_reader is not None:
            assert self.client_writer is not None
            incoming_data = await self.client_reader.readline()
            if self.client_reader.at_eof():
                break
            logger.debug(incoming_data)
            pending_location_checks: set[int] = set()
            try:
                incoming = json.loads(incoming_data)
                if "type" not in incoming:
                    continue
                elif incoming["type"] == "hello":
                    logger.info("Lethal Crisis has connected!")
                    self.pending_messages.append({"type": "resp_hello"})
                    self.pending_messages.extend(self.welcome_packet)
                elif incoming["type"] == "LocationChecks":
                    if "Victory" in incoming["locations"]:
                        incoming["locations"].remove("Victory")
                        self.finished_game = True
                        async_start(self.send_msgs([{"cmd": "StatusUpdate", "status": ClientStatus.CLIENT_GOAL}]))
                    pending_location_checks = {location + LC_LOC_BASE for location in incoming["locations"]}
            except json.JSONDecodeError:
                logger.error("Unable to decode payload")

            if len(self.checked_locations):
                self.pending_messages.append(
                    {
                        "type": "CheckedLocations",
                        "locations": [location - LC_LOC_BASE for location in self.checked_locations],
                    }
                )

            items_received = Counter(item.item - LC_ITEM_BASE for item in self.items_received)
            if len(items_received):
                self.pending_messages.append({"type": "ItemsReceived", "items": items_received})

            if len(self.pending_messages):
                outgoing_data = json.dumps(self.pending_messages)
                self.pending_messages = []
                self.client_writer.write(outgoing_data.encode("shift-jis"))
                await self.client_writer.drain()
            if len(pending_location_checks):
                async_start(self.check_locations(pending_location_checks))


async def main():
    multiprocessing.freeze_support()
    parser = get_base_parser()
    args = parser.parse_args()
    ctx = LethalCrisisContext(args.connect, args.password)
    ctx.server_task = asyncio.create_task(server_loop(ctx), name="Server Loop")
    if gui_enabled:
        ctx.run_gui()
    ctx.run_cli()

    await ctx.exit_event.wait()
    ctx.server_address = None
    await ctx.shutdown()


def launch_lethal_crisis_client():
    init_logging("LethalCrisisClient")

    import colorama

    colorama.just_fix_windows_console()

    asyncio.run(main())
    colorama.deinit()


if __name__ == "__main__":
    launch_lethal_crisis_client()
