state("Project_Plague-Win64-Shipping") { }

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    Assembly.Load(File.ReadAllBytes("Components/uhara7")).CreateInstance("Main");

    vars.Helper.GameName = "Project_Plague-Win64-Shipping";
    vars.Helper.AlertGameTime();
}

init
{
    // uhara
    vars.CatchInstance = vars.Uhara.CreateTool("UnrealEngine", "CatchInstance");
	IntPtr TestObject = vars.CatchInstance.Add("WB_LoadingAsync_C");
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
		print("[UHARA] -> " + current.TestObject.ToString());;
	}
}