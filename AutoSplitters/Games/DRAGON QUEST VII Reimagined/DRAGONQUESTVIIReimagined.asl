state("DQ7R_DEMO-Win64-Shipping"){}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");
	vars.Uhara.AlertLoadless();
}

init
{
	vars.Events = vars.Uhara.CreateTool("UnrealEngine", "Events");
	
	vars.Events.FunctionFlag("StartLoading1_1", "BP_MapStateFieldStart_C", "BP_MapStateFieldStart_C", "Initialize");
	vars.Events.FunctionFlag("StartLoading1_2", "BP_MapStateFieldStart_C", "BP_MapStateFieldStart_C", "FuncPlayerMapChangeBeforeStart");
	vars.Events.FunctionFlag("EndLoading1_1", "BP_MapStateFieldStart_C", "BP_MapStateFieldStart_C", "FuncPlayerMapChangeAfterEnd");
	vars.Events.FunctionFlag("EndLoading1_2", "BP_MapStateFieldStart_C", "BP_MapStateFieldStart_C", "Finalize");
	
	vars.Events.FunctionFlag("StartLoading2_1", "BP_MapStateLoading_C", "BP_MapStateLoading_C", "Initialize");
	vars.Events.FunctionFlag("EndLoading2_1", "BP_MapStateLoading_C", "BP_MapStateLoading_C", "FactoryNextMapState");
	vars.Events.FunctionFlag("EndLoading2_2", "BP_MapStateLoading_C", "BP_MapStateLoading_C", "Finalize");
	
	current.NowLoading1 = false;
	current.NowLoading2 = false;
}

update
{
	vars.Uhara.Update();

	if (vars.Resolver.CheckFlag("StartLoading1_1")) current.NowLoading1 = true;
	if (vars.Resolver.CheckFlag("StartLoading1_2")) current.NowLoading1 = true;
	if (vars.Resolver.CheckFlag("EndLoading1_1")) current.NowLoading1 = false;
	if (vars.Resolver.CheckFlag("EndLoading1_2")) current.NowLoading1 = false;
	
	if (vars.Resolver.CheckFlag("StartLoading2_1")) current.NowLoading2 = true;
	if (vars.Resolver.CheckFlag("EndLoading2_1")) current.NowLoading2 = false;
	if (vars.Resolver.CheckFlag("EndLoading2_2")) current.NowLoading2 = false;
}

onStart
{
	current.NowLoading1 = false;
	current.NowLoading2 = false;
}

isLoading
{
	return current.NowLoading1 || current.NowLoading2;
}