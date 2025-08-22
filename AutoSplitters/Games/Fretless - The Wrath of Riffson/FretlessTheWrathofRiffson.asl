state("Fretless The Wrath of Riffson") { }

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	Assembly.Load(File.ReadAllBytes("Components/uhara7")).CreateInstance("Main");
	
	vars.Uhara.EnableDebug();
	vars.Helper.GameName = "Fretless The Wrath of Riffson";;
	vars.Helper.AlertLoadless();
	
	vars.NowLoading = false;
}

init
{
	var JitSave = vars.Uhara.CreateTool("Unity", "DotNet", "JitSave");
	vars.Helper["StartLoading"] = vars.Helper.Make<ulong>(JitSave.AddFlag("LoadScreenManager", "BeginLoadingScreen"));
	vars.Helper["EndLoading1"] = vars.Helper.Make<ulong>(JitSave.AddFlag("LoadScreenManager", "EndLoadingScreen"));
	vars.Helper["StartGame"] = vars.Helper.Make<ulong>(JitSave.AddFlag("StartScreenMgr", "LoadInstance_OnLoadGame"));
	JitSave.SetOuter("Assembly-CSharp.dll", "Pixelplacement");
	vars.Helper["EndLoading2"] = vars.Helper.Make<ulong>(JitSave.AddFlag("Tween", "CanvasGroupAlpha", 9, 0, 0));
	JitSave.ProcessQueue();
}

onStart
{
	vars.NowLoading = false;
}

start
{
	return current.StartGame != old.StartGame;
}

update
{
	vars.Helper.Update();
	vars.Helper.MapPointers();
	
	if (current.StartLoading != old.StartLoading) vars.NowLoading = true;
	if (current.EndLoading2 != old.EndLoading2) vars.NowLoading = false;
	if (current.EndLoading1 != old.EndLoading1) vars.NowLoading = false;
}

isLoading
{
	return vars.NowLoading;
}