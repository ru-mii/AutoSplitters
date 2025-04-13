state("ENA-4-DreamBBQ") { }

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	Assembly.Load(File.ReadAllBytes("Components/uhara3")).CreateInstance("Main");
	vars.Helper.GameName = "ENA: Dream BBQ";
	vars.Helper.LoadSceneManager = true;
	vars.Helper.AlertLoadless();
	vars.NowLoading = false;
	
	settings.Add("gr_Splits", true, "Splits");
	settings.Add("sp_SceneSplits", true, "Scene splits", "gr_Splits");
	settings.Add("sp_EndSplit", true, "End split", "gr_Splits");
}

init
{
	vars.JitSave = vars.Uhara.CreateTool("UnityCS", "JitSave");
	
	vars.JitSave.SetOuter("JoelG.ENA4.dll", "JoelG.ENA4.UI");
	IntPtr BootSettingsOverlay = vars.JitSave.AddInst("BootSettingsOverlay");
	IntPtr PlayingVideo = vars.JitSave.AddFlag("ScreenSpaceVideoPlayableDirector", "Awake");
	IntPtr ResetTimer = vars.JitSave.AddFlag("BootSettingsOverlay");
	
	vars.JitSave.SetOuter("JoelG.ENA4.dll", "JoelG.ENA4");
	IntPtr LoadStart = vars.JitSave.AddFlag("SceneTransition", "CommitToScene");
	IntPtr LoadEnd1 = vars.JitSave.Add("SceneTransition", "OnLevelFinishedLoading", 2, 1, 14, new byte[] { 0x48, 0x83, 0x05, 0xF0, 0xFF, 0xFF, 0xFF, 0x01 } );
	IntPtr LoadEnd2 = vars.JitSave.AddFlag("SceneTransition", "CompleteEffect");
	
	vars.JitSave.SetOuter("JoelG.ENA4.dll", "JoelG.ENA4.Locations");
	//IntPtr TetrahedralAttacher = vars.JitSave.AddInst("TetrahedralAttacher", "Start");
	
	//vars.JitSave.ProcessQueue();
	
	vars.Helper["HeadFade"] = vars.Helper.Make<float>(BootSettingsOverlay, 0x80, 0x74);
	vars.Helper["LoadStart"] = vars.Helper.Make<int>(LoadStart);
	vars.Helper["LoadEnd1"] = vars.Helper.Make<int>(LoadEnd1);
	vars.Helper["LoadEnd2"] = vars.Helper.Make<int>(LoadEnd2);
	//vars.Helper["Targets"] = vars.Helper.Make<int>(TetrahedralAttacher, 0x20, 0x1C);
	vars.Helper["PlayingVideo"] = vars.Helper.Make<int>(PlayingVideo);
	vars.Helper["ResetTimer"] = vars.Helper.Make<int>(ResetTimer);
	
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
	
	//print(current.SmallTest.ToString());
	
	if ((current.LoadStart != old.LoadStart)) vars.NowLoading = true;
	if (current.LoadEnd1 != old.LoadEnd1) vars.NowLoading = false;
	if (current.LoadEnd2 != old.LoadEnd2) vars.NowLoading = false;
	if (current.LoadStart == 0) vars.NowLoading = false;
}

split
{
	//if (current.PlayingVideo != old.PlayingVideo && current.ActiveScene == "D1Grey" && current.Targets >= 16) return true;
	if (current.PlayingVideo != old.PlayingVideo && current.ActiveScene == "D1Grey" && settings["sp_EndSplit"]) return true;
	return current.ActiveScene != old.ActiveScene && current.ActiveScene != "Hub" && current.ActiveScene != "Menu" &&
		old.ActiveScene != "Menu" && settings["sp_SceneSplits"];
}

isLoading
{
	return vars.NowLoading;
}

reset
{
	return current.ResetTimer != old.ResetTimer;
}