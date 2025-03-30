state("ENA-4-DreamBBQ") { }

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	Assembly.Load(File.ReadAllBytes("Components/uhara3")).CreateInstance("Main");
	vars.Helper.GameName = "ENA: Dream BBQ";
	vars.Helper.LoadSceneManager = true;
	vars.Helper.AlertLoadless();
	vars.NowLoading = false;
}

init
{
	vars.JitSave = vars.Uhara.CreateTool("UnityCS", "JitSave");
	
	vars.JitSave.SetOuter("JoelG.ENA4.dll", "JoelG.ENA4.UI");
	IntPtr BootSettingsOverlay = vars.JitSave.AddInst("BootSettingsOverlay");
	
	vars.JitSave.SetOuter("JoelG.ENA4.dll", "JoelG.ENA4");
	IntPtr LoadStart = vars.JitSave.AddFlag("SceneTransition", "OnEnable");
	IntPtr LoadEnd = vars.JitSave.AddFlag("SceneTransition", "OnDisable");
	
	vars.Helper["HeadFade"] = vars.Helper.Make<float>(BootSettingsOverlay, 0x80, 0x74);
	vars.Helper["LoadStart"] = vars.Helper.Make<int>(LoadStart);
	vars.Helper["LoadEnd"] = vars.Helper.Make<int>(LoadEnd);
	
	vars.NowLoading = false;
}

start
{
	if (current.HeadFade < 1 && old.HeadFade == 1)
	{
		vars.NowLoading = false;
		return true;
	}
}

update
{
	vars.Helper.Update();
	vars.Helper.MapPointers();
	
	current.ActiveScene = vars.Helper.Scenes.Active.Name ?? current.ActiveScene;
	
	if ((current.LoadStart != old.LoadStart)) vars.NowLoading = true;
	if (current.LoadEnd != old.LoadEnd) vars.NowLoading = false;
	if (current.LoadStart == 0) vars.NowLoading = false;
	
	//print(current.ActiveScene.ToString());
}

split
{
	return current.ActiveScene != old.ActiveScene && current.ActiveScene != "Hub";
}

isLoading
{
	return vars.NowLoading;
}

reset
{
	return current.ActiveScene != old.ActiveScene && current.ActiveScene == "Menu";
}