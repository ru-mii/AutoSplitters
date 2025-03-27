state("Yasuke Simulator") { }

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	vars.Helper.GameName = "Yasuke Simulator";
	vars.Helper.LoadSceneManager = true;
	vars.Helper.AlertLoadless();
}

init
{
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        vars.Helper["GTime"] = mono.Make<float>("Scr_GameMananger", "instance", "time");
        return true;
    });
}

update
{
	current.ActiveScene = vars.Helper.Scenes.Active.Name ?? current.ActiveScene;
	print(current.ActiveScene.ToString() + " " + current.GTime.ToString());
}

start
{
	return current.ActiveScene == "Scene_Prologue" && current.GTime > 0f && current.GTime < 1f;
}

split
{
	return current.ActiveScene != old.ActiveScene;
}

reset
{
	return current.ActiveScene == "Menu";
}