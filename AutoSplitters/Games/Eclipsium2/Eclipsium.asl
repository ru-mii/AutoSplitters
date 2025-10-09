state("SHf-Win64-Shipping"){}
state("SHf-WinGDK-Shipping"){}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
    vars.Helper.GameName = "Silent Hill f";
    vars.Helper.AlertLoadless();
	vars.Uhara.EnableDebug();
}

init
{
    IntPtr gWorld = vars.Helper.ScanRel(3, "48 8B 05 ???????? 48 85 C0 75 ?? 48 83 C4 ?? 5B");
    IntPtr gEngine = vars.Helper.ScanRel(3, "48 8B 0D ???????? 48 8B BC 24 ???????? 48 8B 9C 24");
    IntPtr fNames = vars.Helper.ScanRel(3, "48 8D 0D ???????? E8 ???????? C6 05 ?????????? 0F 10 07");

    vars.GEngine = gEngine;

    if (gWorld == IntPtr.Zero || gEngine == IntPtr.Zero || fNames == IntPtr.Zero)
        throw new Exception("Not all required addresses could be found by scanning.");
	
	current.Cutscene = "";

	// uhara
	vars.Events = vars.Uhara.CreateTool("UnrealEngine", "Events");
	IntPtr WBP_Cutscene_C = vars.Events.InstancePtr("WBP_Cutscene_C", "");
	
	vars.Helper["CutsceneName"] = vars.Helper.Make<uint>(WBP_Cutscene_C, 0x460);
	vars.Helper["CutsceneName"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;
}

update
{
    vars.Helper.Update();
    vars.Helper.MapPointers();

	if (current.CutsceneName != old.CutsceneName)
	{
		if (current.CutsceneName != 0)
		{
			string cutscene = vars.Events.FNameToString(current.CutsceneName);
			if (!string.IsNullOrEmpty(cutscene)) current.Cutscene = cutscene;
		}
		else current.Cutscene = "";
	}

    if (old.Cutscene != current.Cutscene) vars.Log("Cutscene: " + current.Cutscene);
}