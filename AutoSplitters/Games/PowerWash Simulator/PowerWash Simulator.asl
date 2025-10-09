state("PowerWashSimulator") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
    vars.Uhara.EnableDebug();
}

init
{
    var Instance = vars.Uhara.CreateTool("Unity", "IL2CPP", "Instance");
    var Test = Instance.Get("PWS:PWS.States:LoadingLocationState");
    
    vars.Helper["Test"] = vars.Helper.Make<ulong>(Test.Base, Test.Offsets);
}

update
{
    vars.Helper.Update();
    vars.Helper.MapPointers();
    
    //print(current.Test.ToString("X"));
}