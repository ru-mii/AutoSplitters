state("SuperSorry") { }

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	Assembly.Load(File.ReadAllBytes("Components/uhara4")).CreateInstance("Main");
	vars.Helper.LoadSceneManager = true;
	vars.Helper.GameName = "SuperSorry";
}

init
{
	vars.JitSave = vars.Uhara.CreateTool("UnityCS", "JitSave");
	IntPtr InGameSceneVM = vars.JitSave.AddInst("InGameSceneVM", 15);
	IntPtr ClearPanel = vars.JitSave.AddFlag("ClearPanel", "Show");
	
	vars.Helper["StageText"] = vars.Helper.MakeString(InGameSceneVM, 0x30, 0x48, 0xC0, 0x14);
	vars.Helper["ClearPanel"] = vars.Helper.Make<int>(ClearPanel);
}

start
{
	return current.ActiveScene != old.ActiveScene && current.ActiveScene == "InGame";
}

update
{
	vars.Helper.Update();
	vars.Helper.MapPointers();
	current.ActiveScene = vars.Helper.Scenes.Active.Name ?? null;
}

split
{
	if (current.ClearPanel != old.ClearPanel) return true;
	else return
		(old.StageText.StartsWith("Tutorial") && current.StageText.StartsWith("Office")) ||
		(old.StageText.StartsWith("Office") && current.StageText.StartsWith("Home")) ||
		(old.StageText.StartsWith("Home") && current.StageText.StartsWith("Park")) ||
		(old.StageText.StartsWith("Park") && current.StageText.StartsWith("Mall")) ||
		(old.StageText.StartsWith("Mall") && current.StageText.StartsWith("City")) ||
		(old.StageText.StartsWith("City") && current.StageText.StartsWith("Station")) ||
		(old.StageText.StartsWith("Station") && current.StageText.StartsWith("Police")) ||
		(old.StageText.StartsWith("Police") && current.StageText.StartsWith("Court")) ||
		(old.StageText.StartsWith("Court") && current.StageText.StartsWith("Prison"));
}

reset
{
	return current.ActiveScene == "Home" && current.ActiveScene != old.ActiveScene;
}