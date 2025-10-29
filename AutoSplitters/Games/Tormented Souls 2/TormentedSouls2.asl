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
	IntPtr gSyncLoadCount = vars.Uhara.ScanRel(5, "89 43 60 8B 05 ?? ?? ?? ??");

	if (gWorld == IntPtr.Zero || gEngine == IntPtr.Zero || fNames == IntPtr.Zero)
		throw new Exception("Not all required addresses could be found by scanning.");
	
	// ---
	vars.Resolver.Watch<byte>("NowLoading", gEngine, 0x11F8, 0x510);
	
	// ---
	//vars.Events = vars.Uhara.CreateTool("UnrealEngine", "Events");
	//vars.Resolver.Watch<ulong>("StartLoad", vars.Events.FunctionParentPtr("W_BlackScreen_C", "", "PreConstruct"));
	//vars.Resolver.Watch<ulong>("EndLoad", vars.Events.FunctionParentPtr("W_BlackScreen_C", "", "PreConstruct"));
}


update
{
	vars.Uhara.Update();
}

isLoading
{
	return current.NowLoading == 0;
}