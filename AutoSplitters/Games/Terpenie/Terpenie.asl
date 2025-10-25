state("TERPENIE-Win64-Shipping") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
	vars.Uhara.EnableDebug();
}

init
{
	IntPtr GWorld = vars.Uhara.ScanRel(3, "48 8B 1D ?? ?? ?? ?? 48 85 DB 74 ?? 41 B0 01");
	IntPtr GEngine = vars.Uhara.ScanRel(3, "48 8B 0D ?? ?? ?? ?? 66 0F 5A C9 E8");
	IntPtr FNames = vars.Uhara.ScanRel(7, "8B D9 74 ?? 48 8D 15 ?? ?? ?? ?? EB");

	if (GWorld == IntPtr.Zero || GEngine == IntPtr.Zero || FNames == IntPtr.Zero)
		throw new Exception("Not all required addresses could be found by scanning.");
	
	// ---
	vars.Tool = vars.Uhara.CreateTool("UnrealEngine", "Events");
	vars.Resolver.Watch<ulong>("StartTimer", vars.Tool.InstanceFlag("World", "StreetUnderBalkony"));
	vars.Resolver.Watch<ulong>("EndTimer", vars.Tool.FunctionFlag("NC_HasCompletedDataTask_C", "", "CheckCondition"));
	
	// ---
	vars.Resolver.Watch<uint>("GWorldName", GWorld, 0x18);
}

update
{
	vars.Uhara.Update();
	
	var world = vars.Tool.FNameToString(current.GWorldName);
	if (!string.IsNullOrEmpty(world) && world != "None")
		current.World = world;
}

start
{
	return current.StartTimer != old.StartTimer && current.StartTimer != 0;
}

split
{
	return current.EndTimer != old.EndTimer && current.EndTimer != 0;
}

reset
{
	return current.World != old.World && current.World == "MainMenu";
}