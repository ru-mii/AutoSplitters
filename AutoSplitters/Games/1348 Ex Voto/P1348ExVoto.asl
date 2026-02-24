state("P1348-Win64-Shipping"){}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");
}

init
{
	vars.Utils = vars.Uhara.CreateTool("UnrealEngine", "Utils");
	vars.Events = vars.Uhara.CreateTool("UnrealEngine", "Events");
	
    vars.Resolver.Watch<uint>("WorldFName", vars.Utils.GWorld, 0x18);
	vars.Resolver.Watch<byte>("CharacterHiddenFlag", vars.Events.FunctionParentPtr("BPC_FocusSystem_C", "BPC_FocusSystem", ""), 0xA8, 0x58);
	
	current.AllowedToStart = false;
	current.WorldName = "";
}

update
{
	vars.Uhara.Update();

	string worldName = vars.Utils.FNameToString(current.WorldFName);
    if (!string.IsNullOrEmpty(worldName) && worldName != "None")
		current.WorldName = worldName;
	
	if (current.WorldName == "MAP_MenuStart")
		current.AllowedToStart = true;
}

onStart
{
	current.AllowedToStart = false;
}

start
{
	return
	current.AllowedToStart &&
	current.CharacterHiddenFlag != old.CharacterHiddenFlag &&
	(current.CharacterHiddenFlag & 128) == 0 &&
	(old.CharacterHiddenFlag & 128) != 0;
	
	if (current.CharacterHiddenFlag != old.CharacterHiddenFlag)
		print(current.CharacterHiddenFlag.ToString());
}

reset
{
	return current.WorldName != old.WorldName && current.WorldName == "MAP_MenuStart";
}