state("CloverPit") { }

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	Assembly.Load(File.ReadAllBytes("Components/uhara5")).CreateInstance("Main");
	vars.Helper.GameName = "CloverPit";
}

init
{
	vars.JitSave = vars.Uhara.CreateTool("UnityCS", "JitSave");
	IntPtr GameplayData = vars.JitSave.AddInst("GameplayData", "Stats_PlayTime_AddSeconds", 1, 0x2B, 18);
	vars.JitSave.ProcessQueue();
	
	vars.Helper["SpinsLeft"] = vars.Helper.Make<ulong>(GameplayData, 0x350);
}

update
{
	if (current.SpinsLeft != null)
	{
		print(current.SpinsLeft.ToString());
	}
}