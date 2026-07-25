from worlds.LauncherComponents import Component, Type, components, launch


def run_client(*args: str) -> None:
    # Ideally, you should lazily import your component code so that it doesn't have to be loaded until necessary.
    from .client import launch_lethal_crisis_client

    launch(launch_lethal_crisis_client, name="Lethal Crisis Client", args=args)


components.append(
    Component(
        "Lethal Crisis Client",
        func=run_client,
        game_name="Lethal Crisis",
        component_type=Type.CLIENT,
        supports_uri=True,
    )
)
