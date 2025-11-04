state("DQMonsters3") { }

startup
{
	Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
	vars.Uhara.EnableDebug(); vars.Uhara.AlertLoadless();
}

init
{
	var Tool = vars.Uhara.CreateTool("Unity", "IL2CPP", "Instance");
	
	Tool.Watch<ulong>("NowLoading", "Scene.Loading:LoadingUI", "_fieldLoadScreenShotImage", "m_Canvas");
	vars.Uhara["NowLoading"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;
	
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