state("DQIandIIHD2DRemake") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
	vars.Uhara.EnableDeveloperMode();
    vars.Uhara.EnableDebug();
	
	// ---
	vars.NowLoading = false;
}

init
{
	vars.Uhara.RejectOnFound("4C8B028B4A??440FB74A??440FB6");
    vars.Events = vars.Uhara.CreateTool("UnrealEngine", "Events");
	vars.Resolver.Watch<ulong>("StartLoading", vars.Events.FunctionFlag("WB_SimpleLoading_WindowFlipbook_C", "FlipbookWindow", "PreConstruct"));
	vars.Resolver.Watch<ulong>("EndLoading", vars.Events.FunctionFlag("WB_LoadingIcon_Item_New_C", "LoadingIcon*", "Destruct"));
}

onStart
{
	vars.NowLoading = false;
}

update
{
    vars.Uhara.Update();
	
	if (vars.Resolver.CheckFlag("StartLoading")) vars.NowLoading = true;
	if (vars.Resolver.CheckFlag("EndLoading")) vars.NowLoading = false;
}

isLoading
{
	return vars.NowLoading;
}