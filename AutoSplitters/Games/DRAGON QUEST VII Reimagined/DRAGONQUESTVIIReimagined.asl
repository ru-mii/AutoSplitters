state("DQ7R_DEMO-Win64-Shipping"){}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");
}

init
{
	vars.Events = vars.Uhara.CreateTool("UnrealEngine", "Events");
	
	vars.Events.FunctionFlag("StartLoading1_1", "BP_MapStateFieldStart_C", "BP_MapStateFieldStart_C", "Initialize");
	vars.Events.FunctionFlag("StartLoading1_2", "BP_MapStateFieldStart_C", "BP_MapStateFieldStart_C", "FuncPlayerMapChangeBeforeStart");
	vars.Events.FunctionFlag("EndLoading1_1", "BP_MapStateFieldStart_C", "BP_MapStateFieldStart_C", "Finalize");
	
	vars.Events.FunctionFlag("StartLoading2_1", "BP_MapStateLoading_C", "BP_MapStateLoading_C", "Initialize");
	vars.Events.FunctionFlag("EndLoading2_1", "BP_MapStateLoading_C", "BP_MapStateLoading_C", "Finalize");
	
	vars.NowLoading1 = false;
	vars.NowLoading2 = false;
}

update
{
	vars.Uhara.Update();

	if (vars.Resolver.CheckFlag("StartLoading1_1")) vars.NowLoading1 = true;
	if (vars.Resolver.CheckFlag("StartLoading1_2")) vars.NowLoading1 = true;
	if (vars.Resolver.CheckFlag("EndLoading1_1")) vars.NowLoading1 = false;
	
	if (vars.Resolver.CheckFlag("StartLoading2_1")) vars.NowLoading2 = true;
	if (vars.Resolver.CheckFlag("EndLoading2_1")) vars.NowLoading2 = false;
}

onStart
{
	vars.NowLoading1 = false;
	vars.NowLoading2 = false;
}

isLoading
{
	return vars.NowLoading1 || vars.NowLoading2;
}