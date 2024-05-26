state("Baby Sniper In Vietnam") { }

startup
{
	refreshRate = 60;
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	vars.Helper.LoadSceneManager = true; vars.Transition = false;

	settings.Add("gr_Splits", true, "Splits");
	settings.Add("sp_Split1", true, "Level 1 -> Level 2", "gr_Splits");
	settings.Add("sp_Split2", true, "Level 2 -> Level 3", "gr_Splits");
	settings.Add("sp_Split3", true, "Level 2 -> Level 3", "gr_Splits");
	settings.Add("sp_Split4", true, "Level 3 -> Level 4", "gr_Splits");
	settings.Add("sp_Split5", true, "Level 4 -> Level 5", "gr_Splits");
}

init { old.ActiveScene = ""; }
onStart { vars.Level = 1; }

update
{
	current.ActiveScene = vars.Helper.Scenes.Active.Name ?? current.ActiveScene;
}

start
{
	return old.ActiveScene.StartsWith("bl") && current.ActiveScene.StartsWith("fs");
}

split
{
	if (((old.ActiveScene.StartsWith("bl") && current.ActiveScene.StartsWith("fs")) ||
		(old.ActiveScene.StartsWith("fs") && current.ActiveScene.EndsWith("k 12"))) &&
		settings["sp_Split" + vars.Level])
    {
		vars.Level += 1;
		return true;
    }
}

isLoading
{
	return current.ActiveScene.StartsWith("bl");
}

reset
{
	return current.ActiveScene.StartsWith("Ma");
}