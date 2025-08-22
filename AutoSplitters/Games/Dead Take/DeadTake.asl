state("DeadTake") { }

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    Assembly.Load(File.ReadAllBytes("Components/uhara7")).CreateInstance("Main");

    vars.Helper.GameName = "DeadTake";
    vars.Helper.AlertGameTime();
}

init
{
	vars.CatchInstance = vars.Uhara.CreateTool("UnrealEngine", "CatchInstance");
    
    IntPtr SomeObject = vars.CatchInstance.Add("W_LoadingScreen1_C");
    
    vars.CatchInstance.ProcessQueue();
    
    // asl-help
    vars.Helper["TestObject"] = vars.Helper.Make<ulong>(SomeObject);
}

update
{
    vars.Helper.Update();;
    vars.Helper.MapPointers();
    
	
	if (current.TestObject != old.TestObject)
	{
		print("0x" + current.TestObject.ToString("X"));
	}
}