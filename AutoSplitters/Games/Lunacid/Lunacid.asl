state("Lunacid") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	Assembly.Load(File.ReadAllBytes("Components/uhara5")).CreateInstance("Main");
	vars.Helper.GameName = "Lunacid";
	vars.Helper.LoadSceneManager = true;
}

init
{
	vars.JitSave = vars.Uhara.CreateTool("UnityCS", "JitSave");
	IntPtr Level_Load_Effect = vars.JitSave.AddFlag("Level_Load_Effect", "OnEnable");
	vars.JitSave.ProcessQueue();
	
	vars.Helper["NowLoadingTrigger"] = vars.Helper.Make<int>(Level_Load_Effect);
	current.NowLoading = false;
}

start
{
	if (current.ActiveScene == "PITT_A1")
	{
		current.NowLoading = false;
		return true;
	}
}

update
{
	current.ActiveScene = vars.Helper.Scenes.Active.Name ?? current.ActiveScene;
	if (current.ActiveScene != old.ActiveScene) current.NowLoading = false;
	if (current.NowLoadingTrigger != old.NowLoadingTrigger) current.NowLoading = true;
}

isLoading
{
	return current.NowLoading;
}