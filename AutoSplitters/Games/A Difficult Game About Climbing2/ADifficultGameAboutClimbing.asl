state("A Difficult Game About Climbing") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	Assembly.Load(File.ReadAllBytes("Components/uhara-pre")).CreateInstance("Main");
	vars.Uhara.EnableDebug();
}

init
{
	var Instance = vars.Uhara.CreateTool("Unity", "DotNet", "Instance");
	var Something = Instance.Get("PauseMenu");
	
	vars.Helper["Something"] = vars.Helper.Make<ulong>(Something.Base, Something.Offsets);
	
	print("BASE: " + Something.Base.ToString("X"));
}

update
{
	vars.Helper.Update();
	vars.Helper.MapPointers();
	
	//if (current.Something != old.Something)
		//print("GG: " + current.Something.ToString("X"));
}