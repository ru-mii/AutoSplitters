state("Awaria") { }

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	Assembly.Load(File.ReadAllBytes("Components/uhara5")).CreateInstance("Main");
}

init
{
	vars.JitSave = vars.Uhara.CreateTool("UnityCS", "JitSave");
	IntPtr StartRun = vars.JitSave.Add("MenuScript", "NextLevel", 1, 1, 14,
		new byte[] { 0x48, 0x81, 0x7C, 0x24, 0x10, 0x12, 0x00, 0x00, 0x00, 0x90,
		0x75, 0x07, 0x83, 0x05, 0xE5, 0xFF, 0xFF, 0xFF, 0x01 } );
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
	return current.StartRun != old.StartRun && current.NextLevel == 1;
}

split
{
	return current.NextLevel > old.NextLevel;
}

reset
{
	return current.CurrentMenu != old.CurrentMenu && current.CurrentMenu == 1;
}