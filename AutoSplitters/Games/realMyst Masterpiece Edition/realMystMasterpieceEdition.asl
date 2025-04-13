state("realMyst") { }

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	Assembly.Load(File.ReadAllBytes("Components/uhara5")).CreateInstance("Main");
	vars.Helper.GameName = "realMyst: Masterpiece Edition";
	vars.Helper.LoadSceneManager = true;
}

init
{
	
}

update
{
	vars.Helper.Update();
	vars.Helper.MapPointers();
	current.ActiveScene = vars.Helper.Scenes.Active.Name ?? null;
}