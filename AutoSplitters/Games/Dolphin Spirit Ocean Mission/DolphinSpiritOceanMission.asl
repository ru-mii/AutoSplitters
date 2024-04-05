state("Dolphin") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	vars.Helper.GameName = "Dolphin Spirit: Ocean Mission";
	vars.Helper.LoadSceneManager = true;
	vars.Helper.AlertLoadless();
}

update
{
	current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
}

start
{
	return (old.activeScene == "Autoload" && current.activeScene == "scn_Intro");
}

isLoading
{
	return current.activeScene == "Autoload";
}
