state("PiecedTogether"){}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
	vars.Uhara.EnableDebug();
}

init
{
	vars.Tool = vars.Uhara.CreateTool("Unity", "Utils");
}

update
{
	current.ActiveScene = vars.Tool.GetActiveSceneName() ?? current.ActiveScene;
	current.LoadingScene = vars.Tool.GetLoadingSceneName() ?? current.ActiveScene;
}

start
{
	return current.ActiveScene != old.ActiveScene && current.ActiveScene == "TutorialLevel";
}

isLoading
{
	return current.ActiveScene != current.LoadingScene;
}

split
{
	return current.ActiveScene != old.ActiveScene && current.ActiveScene != "TutorialLevel";
}

reset
{
	return current.ActiveScene != old.ActiveScene &&
		(current.ActiveScene == "MainMenuReloadedScene" || current.ActiveScene == "MainMenuScene");
}