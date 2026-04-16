state("Trees Hate You") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");
	
	vars.CompletedSplits = new HashSet<int>();
	settings.Add("ResetMainMenu", true, "Reset on MainMenu");
	settings.Add("GRP_Splits", true, "Checkpoints", null);
		settings.Add("SPL_0", true, "0", "GRP_Splits");
		settings.Add("SPL_1", true, "1", "GRP_Splits");
		settings.Add("SPL_2", true, "2", "GRP_Splits");
		settings.Add("SPL_3", true, "3", "GRP_Splits");
}

init
{
    vars.Utils = vars.Uhara.CreateTool("Unity", "Utils");
    vars.Instance = vars.Uhara.CreateTool("Unity", "DotNet", "Instance");
	
	vars.Instance.Watch<int>("CheckpointNum", "PlayerData", "activeFile", "checkpoint");
}

update
{
    vars.Uhara.Update();
	
	current.ActiveScene = vars.Utils.GetActiveSceneName() ?? current.ActiveScene;
	current.LoadingScene = vars.Utils.GetLoadingSceneName() ?? current.LoadingScene;
}

onStart
{
	vars.CompletedSplits.Clear();
}

start
{
	return current.ActiveScene != old.ActiveScene && current.ActiveScene == "1-1_picnic";
}

isLoading
{
	return current.ActiveScene != current.LoadingScene;
}

split
{
	bool flag = false;
	if (current.CheckpointNum > old.CheckpointNum && settings["SPL_" + current.CheckpointNum.ToString()]) flag = true;
	else if (current.ActiveScene != old.ActiveScene && current.ActiveScene == "end") flag = true;
	
	if (!flag) return;
	else return vars.CompletedSplits.Add(current.CheckpointNum);
}

reset
{
	return settings["ResetMainMenu"] && current.ActiveScene != old.ActiveScene && current.ActiveScene == "start";
}