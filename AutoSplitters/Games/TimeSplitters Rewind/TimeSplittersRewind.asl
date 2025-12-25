state("TimeSplittersRewind-Win64-Shipping") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");
	vars.CompletedSplits = new HashSet<string>();
}

init
{
	vars.Utils = vars.Uhara.CreateTool("UnrealEngine", "Utils");
    vars.Tool = vars.Uhara.CreateTool("UnrealEngine", "Events");
	
	vars.Resolver.Watch<uint>("WorldFName", vars.Utils.GWorld, 0x18);
	
	vars.Tool.FunctionFlag("StartTimer", "LOADING_C", "", "Destruct");
	vars.Tool.FunctionFlag("SplitTimer", "*Timer_C", "", "AllObjectivesComplete_Event");
	
	// ---
	current.WorldName = "";
}

update
{
    vars.Uhara.Update();
	
	string worldName = vars.Utils.FNameToString(current.WorldFName);
	if (!string.IsNullOrEmpty(worldName) && worldName != "None")
		current.WorldName = worldName;
	
	//if (current.WorldName != old.WorldName) vars.Uhara.Log(worldName);
}

start
{
	return
	vars.Resolver.CheckFlag("StartTimer") &&
	current.WorldName != "SPobby" &&
	current.WorldName != "Entry" &&
	current.WorldName != "Startup" &&
	current.WorldName != "Introduction";
}

onStart
{
	vars.CompletedSplits.Clear();
}

split
{
	return vars.Resolver.CheckFlag("SplitTimer") && vars.CompletedSplits.Add(current.WorldName);
}