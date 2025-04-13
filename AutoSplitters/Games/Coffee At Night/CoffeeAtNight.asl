state("Coffee at night") { }

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	Assembly.Load(File.ReadAllBytes("Components/uhara5")).CreateInstance("Main");
	vars.Helper.GameName = "Coffee at night";
	vars.Helper.LoadSceneManager = true;
	vars.Starts = 0;
}

init
{
	vars.JitSave = vars.Uhara.CreateTool("UnityCS", "JitSave");
	IntPtr PlayerController = vars.JitSave.AddInst("PlayerController");
	IntPtr OnStart = vars.JitSave.AddFlag("OnStart");
	vars.JitSave.ProcessQueue();
	
	vars.Helper["CanLook"] = vars.Helper.Make<bool>(PlayerController, 0x4D);
	vars.Helper["OnStart"] = vars.Helper.Make<int>(OnStart);
}

update
{
	current.ActiveScene = vars.Helper.Scenes.Active.Name ?? current.ActiveScene;
	
	vars.Helper.Update();
    vars.Helper.MapPointers();
}

reset
{
	return current.ActiveScene == "menu";
}

start
{
	if (current.CanLook && !old.CanLook)
	{
		vars.Starts = current.OnStart;
		return true;
	}
}

split
{
	return current.OnStart - vars.Starts == 1;
}