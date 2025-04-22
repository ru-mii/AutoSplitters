state("BiodacityMansion") { }

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	Assembly.Load(File.ReadAllBytes("Components/uhara5")).CreateInstance("Main");
}

init
{
	vars.JitSave = vars.Uhara.CreateTool("UnityCS", "JitSave");
	IntPtr AreaManager = vars.JitSave.AddInst("AreaManager", "Awake");
	vars.JitSave.ProcessQueue();
	
	vars.Helper["currentLevel"] = vars.Helper.MakeString(AreaManager, 0x20);
	
	vars.Helper.Update();
	vars.Helper.MapPointers();
}

update
{
	vars.Helper.Update();
	vars.Helper.MapPointers();
	
	print(current.currentLevel.ToString());
}