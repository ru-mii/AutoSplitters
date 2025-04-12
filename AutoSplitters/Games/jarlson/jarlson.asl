state("jarlson") { }

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    Assembly.Load(File.ReadAllBytes("Components/uhara5")).CreateInstance("Main");
}

init
{
    vars.JitSave = vars.Uhara.CreateTool("UnityCS", "JitSave");
    IntPtr GameManagerScript = vars.JitSave.AddInst("GameManagerScript");
	vars.JitSave.ProcessQueue();
    
    vars.Helper["hasFinished"] = vars.Helper.Make<bool>(GameManagerScript, 0x31);
    vars.Helper["playing"] = vars.Helper.Make<bool>(GameManagerScript, 0x18, 0x2C);
    vars.Helper["igt"] = vars.Helper.Make<float>(GameManagerScript, 0x18, 0x1C);
}

update
{
    vars.Helper.Update();
    vars.Helper.MapPointers();
}