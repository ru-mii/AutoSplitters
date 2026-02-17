state("REANIMAL"){}

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
	IntPtr gSyncLoadCount = vars.Uhara.ScanRel(5, "89 43 60 8B 05 ?? ?? ?? ??");

	if (gWorld == IntPtr.Zero || gEngine == IntPtr.Zero || fNames == IntPtr.Zero)
		throw new Exception("Not all required addresses could be found by scanning.");
	
	// ---
	vars.Events = vars.Uhara.CreateTool("UnrealEngine", "Events");
	vars.Resolver.Watch<byte>("EndscreenTitle", vars.Events.FunctionParentPtr("UI_DEMO_Public_PreEndscreen_C", "", "OnInitialized"), 0x460, 0xDC);
	vars.Resolver.Watch<float>("CameraDepth", gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x3AC);
	vars.Resolver.Watch<uint>("GWorldName", gWorld, 0x18);
	
	// ---
	vars.LastUpdatedWorld = "";
}


update
{
	vars.Uhara.Update();
	
	var world = vars.Events.FNameToString(current.GWorldName);
	if (!string.IsNullOrEmpty(world) && world != "None")
		current.World = world;

	if (current.World != old.World)
		vars.LastUpdatedWorld = old.World;
}

onStart
{
	vars.LastUpdatedWorld = "X";
}

start
{
	return current.CameraDepth < old.CameraDepth && old.CameraDepth > 1f &&
		current.World == "MLVL_EverholmWorld" && (vars.LastUpdatedWorld == "LVL_MainMenu" || vars.LastUpdatedWorld == "");
}

split
{
	return current.EndscreenTitle == 0 && old.EndscreenTitle == 2;
}

reset
{
	return current.World != old.World && current.World == "LVL_MainMenu";
}