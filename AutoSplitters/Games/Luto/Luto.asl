state("Luto-Win64-Shipping") { }

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    Assembly.Load(File.ReadAllBytes("Components/uhara7")).CreateInstance("Main");

	vars.Uhara.EnableDebug();
    vars.Helper.GameName = "Luto";
    vars.Helper.AlertGameTime();
}

init
{
    // uhara
    vars.CatchInstance = vars.Uhara.CreateTool("UnrealEngine", "CatchInstance");
	IntPtr TestObject = vars.CatchInstance.Add("WB_PauseMenu_C");
    vars.CatchInstance.ProcessQueue();
    
    // asl-help
    vars.Helper["TestObject"] = vars.Helper.Make<ulong>(TestObject);
}

update
{
    vars.Helper.Update();
    vars.Helper.MapPointers();
    
	
	if (current.TestObject != old.TestObject)
	{
		print("[UHARA] -> 0x" + current.TestObject.ToString("X"));
	}
}