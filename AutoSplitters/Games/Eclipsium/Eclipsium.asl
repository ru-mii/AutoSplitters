state("Eclipsium") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	vars.Helper.LoadSceneManager = true;
}

init
{
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        vars.Helper["CPlaying"] = mono.Make<bool>("CutsceneManager", "_instance", "isplaying");
        return true;
    });
}

update
{
	current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
	print(current.activeScene);
}

start
{
	return old.CPlaying && !current.CPlaying;
}

split
{
	return old.CPlaying && !current.CPlaying;
}

reset
{
	return old.activeScene != current.activeScene && current.activeScene == "MainMenuReal"; 
}