state("Trees Hate You"){}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");
}

init
{
    vars.Utils = vars.Uhara.CreateTool("Unity", "Utils");
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

split
{
	return current.ActiveScene != old.ActiveScene && current.ActiveScene == "end";
}