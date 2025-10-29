state("TormentedSouls2-Win64-Shipping"){}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
	vars.Uhara.EnableDebug();
}

init
{
	IntPtr gWorld = vars.Uhara.ScanRel(3, "48 8B 1D ?? ?? ?? ?? 48 85 DB 74 ?? 41 B0 01");
	IntPtr gEngine = vars.Uhara.ScanRel(3, "48 8B 0D ?? ?? ?? ?? 66 0F 5A C9 E8");
	IntPtr fNames = vars.Uhara.ScanRel(7, "8B D9 74 ?? 48 8D 15 ?? ?? ?? ?? EB");

	if (gWorld == IntPtr.Zero || gEngine == IntPtr.Zero || fNames == IntPtr.Zero)
		throw new Exception("Not all required addresses could be found by scanning.");
	
	// ---
	vars.Tool = vars.Uhara.CreateTool("UnrealEngine", "Events");
	//vars.Resolver.Watch<ulong>("StartLoad", vars.Tool.FunctionParentPtr("W_BlackScreen_C", "", "PreConstruct"));
	//vars.Resolver.Watch<ulong>("EndLoad", vars.Tool.FunctionParentPtr("W_BlackScreen_C", "", "PreConstruct"));
	
	// ---
	{
		vars.Resolver.Watch<byte>("InputMap", gEngine, 0x11F8, 0x510);
		vars.Resolver.Watch<uint>("GWorldName", gWorld, 0x18);
		vars.Resolver.WatchString("LevelName", ReadStringType.UTF16, gEngine, 0x11F8, 0x260, 0x0);
	}
	
	// ---
	vars.StartAllowed = false;
}


update
{
	vars.Uhara.Update();
	
	var world = vars.Tool.FNameToString(current.GWorldName);
	if (!string.IsNullOrEmpty(world) && world != "None")
		current.World = world;

	if (old.LevelName == "opening_cinematic_b")
		vars.StartAllowed = true;
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
	//return current.InputMap == 0;
}

reset
{
	return current.LevelName != old.LevelName && current.LevelName == "opening_cinematic_b";
}