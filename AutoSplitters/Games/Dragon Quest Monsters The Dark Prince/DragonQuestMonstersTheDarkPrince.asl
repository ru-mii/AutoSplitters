state("DQMonsters3") { }

startup
{
	Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
	vars.Uhara.EnableDebug();
}

init
{
	vars.Tool = vars.Uhara.CreateTool("Unity", "IL2CPP", "Instance");
	
	// ---
	var LoadingUI = vars.Tool.Get("Scene.Loading:LoadingUI", "_fieldLoadScreenShotImage", "m_Canvas");
	vars.Resolver.Watch<ulong>("NowLoading", LoadingUI.Base, LoadingUI.Offsets);
	
	// ---
	current.NowLoading = 0;
}

update
{
	vars.Uhara.Update();
}

isLoading
{
	return current.NowLoading != 0;
}