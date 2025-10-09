state("Eclipsium") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
	vars.Uhara.EnableDebug();
}

init
{
	var Instance = vars.Uhara.CreateTool("Unity", "DotNet", "Instance");
	var Test = Instance.Get("CutsceneController", "isPlaying");
	
	print("0x" + Test.Base.ToString("X"));
	vars.Helper["CutscenePlaying"] = vars.Helper.Make<bool>(Test.Base, Test.Offsets);
}

update
{
	vars.Helper.Update();
	vars.Helper.MapPointers();
	
	print(current.CutscenePlaying.ToString());
}