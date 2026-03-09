state("HorrorMarket-Win64-Shipping") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");
    vars.Uhara.EnableDebug();
}

init
{
    vars.Utils = vars.Uhara.CreateTool("UnrealEngine", "Utils");
    vars.Events = vars.Uhara.CreateTool("UnrealEngine", "Events");
    
	vars.Events.FunctionFlag("EndDemo", "BP_EndDemoGift_C", "BP_EndDemoGift_C", "ExecuteUbergraph_BP_EndDemoGift");
	
    vars.Resolver.Watch<uint>("WorldFName", vars.Utils.GWorld, 0x18);
	vars.Resolver.Watch<float>("SomeTimer", vars.Utils.GEngine, 0x11F8, 0x38, 0x0, 0x30, 0x2E8, 0x198);
	
	vars.StartAllowed = false;
	
	current.WorldName = "";
}

update
{
    vars.Uhara.Update();
    
	// ---
    string worldName = vars.Utils.FNameToString(current.WorldFName);
	if (!string.IsNullOrEmpty(worldName) && worldName != "None") current.WorldName = worldName;
    //if (current.WorldName != old.WorldName) vars.Uhara.Log(current.WorldName);
	
	// ---
	if (current.WorldName == "L_MainMenu") vars.StartAllowed = true;
}

onStart
{
	vars.StartAllowed = false;
}

start
{
	return vars.StartAllowed && current.SomeTimer > 0 && old.SomeTimer == 0;
}

split
{
	return vars.Resolver.CheckFlag("EndDemo");
}

reset
{
	return current.WorldName != old.WorldName && current.WorldName == "L_MainMenu";
}