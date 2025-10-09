state("UnrealGame-Win64-Shipping") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	Assembly.Load(File.ReadAllBytes("Components/uhara8")).CreateInstance("Main");
}

init
{
	var Events = vars.Uhara.CreateTool("UnrealEngine", "Events");
	vars.Helper["StartTimer"] = vars.Helper.Make<ulong>(Events.FunctionFlag("", "", "BlueprintBeginPlay"));
	vars.Helper["EndTimer"] = vars.Helper.Make<ulong>(Events.FunctionFlag("", "", "BndEvt__WB_AccuseScene_Button*"));
	vars.Helper["ResetTimer"] = vars.Helper.Make<ulong>(Events.FunctionFlag("", "", "ExecuteUbergraph_BP_MainMenuUI"));;
	current.StartTimer = (ulong)0; current.EndTimer = (ulong)0; current.ResetTimer = (ulong)0;
}

update
{
	vars.Helper.Update();
	vars.Helper.MapPointers();
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
	return current.ResetTimer != old.ResetTimer && current.ResetTimer != 0;
}