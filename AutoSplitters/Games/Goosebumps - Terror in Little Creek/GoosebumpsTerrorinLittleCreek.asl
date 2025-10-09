state("goosebumps") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	Assembly.Load(File.ReadAllBytes("Components/uhara9-pre")).CreateInstance("Main");
	vars.Uhara.EnableDebug();
}

init
{
	var Instance = vars.Uhara.CreateTool("Unity", "DotNet", "Instance");
	var Test = Instance.Get("GoosebumpsGame..InventoryManager", "<inventoryItems>k__BackingField"); 
	
	vars.Helper["Test"] = vars.Helper.Make<ulong>(Test.Base, Test.Offsets);
}

update
{
	vars.Helper.Update();
	vars.Helper.MapPointers();
}