state("TormentedSouls2-Win64-Shipping"){}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
	vars.Uhara.AlertLoadless(); vars.Uhara.EnableDebug();
}

init
{
	vars.Utils = vars.Uhara.CreateTool("UnrealEngine", "Utils");
	vars.Tool = vars.Uhara.CreateTool("UnrealEngine", "Events");
	
	// ---
	vars.Resolver.Watch<byte>("InputMap", vars.Utils.GEngine, 0x11F8, 0x510);
	vars.Resolver.Watch<byte>("StopGameTime", vars.Utils.GEngine, 0x11F8, 0x52B);
	vars.Resolver.Watch<ulong>("LoadChange", vars.Uhara.CodeHKFlag("4C8BC84C896424204D8BC7498BD6488BCFFFD3"));
	vars.Resolver.Watch<uint>("GWorldName", vars.Utils.GWorld, 0x18);
	vars.Resolver.WatchString("LevelName", ReadStringType.UTF16, vars.Utils.GEngine, 0x11F8, 0x260, 0x0);
	
	// ---
	vars.StartAllowed = false;
	vars.NowLoading = false;
}


update
{
	vars.Uhara.Update();
	
	var world = vars.Utils.FNameToString(current.GWorldName);
	if (!string.IsNullOrEmpty(world) && world != "None")
		current.World = world;

	if (old.LevelName == "opening_cinematic_b")
		vars.StartAllowed = true;
	
	if (current.LoadChange != old.LoadChange && current.LoadChange != 0)
	{
		vars.NowLoading = true;
	}
	
	if (current.StopGameTime != old.StopGameTime && current.StopGameTime == 1)
	{
		vars.NowLoading = true;
	}
	
	if (current.InputMap != 0)
	{
		vars.NowLoading = false;
	}
}

onStart
{
	vars.NowLoading = false;
}

start
{
	if (vars.StartAllowed && current.InputMap > 0 && old.InputMap == 0 && current.LevelName == "church_nunchamber_cinematic_night")
	{
		vars.StartAllowed = false;
		return true;
	}
}

isLoading
{
	return vars.NowLoading;
}

reset
{
	return current.LevelName != old.LevelName && current.LevelName == "opening_cinematic_b";
}