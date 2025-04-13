state("Awaria") { }

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	Assembly.Load(File.ReadAllBytes("Components/uhara5")).CreateInstance("Main");
}

init
{
	vars.JitSave = vars.Uhara.CreateTool("UnityCS", "JitSave");
	IntPtr StartRun = vars.JitSave.AddFlag("MenuScript", "NextLevel", 1, 1, 14);
	IntPtr MenuScript = vars.JitSave.AddInst("MenuScript");
	vars.JitSave.ProcessQueue();
		
	vars.Helper["StartRun"] = vars.Helper.Make<int>(StartRun);
	vars.Helper["CurrentMenu"] = vars.Helper.Make<int>(MenuScript, 0xA8);
	
	// =============================================================
	
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        vars.Helper["NextLevel"] = mono.Make<int>("ManagerScript", "instance", "nextLevel");
        return true;
    });
}

start
{
	return current.StartRun != old.StartRun && current.NextLevel == 1 && current.CurrentMenu == 7;
}

split
{
	return current.NextLevel > old.NextLevel;
}

reset
{
	return current.CurrentMenu != old.CurrentMenu && current.CurrentMenu == 1;
}

update
{
	//print(current.CurrentMenu.ToString());
}