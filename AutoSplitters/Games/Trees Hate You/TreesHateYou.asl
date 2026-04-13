state("Trees Hate You"){}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");
	
	settings.Add("ResetMainMenu", true, "Reset on MainMenu");
	settings.Add("SplitCheckpoints", true, "Split on Checkpoints");
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
	if (settings["SplitCheckpoints"])
	{
		if (current.CheckpointNum - old.CheckpointNum == 1 && current.CheckpointNum > 0) return true;
		else if (current.CheckpointNum == 1 && old.CheckpointNum == -1) return true;
	}
		
	return current.ActiveScene != old.ActiveScene && current.ActiveScene == "end";
}

reset
{
	return settings["ResetMainMenu"] && current.ActiveScene != old.ActiveScene && current.ActiveScene == "start";
}