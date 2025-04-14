state("Megabonk Demo") { }

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	Assembly.Load(File.ReadAllBytes("Components/megabonk-lib")).CreateInstance("Main");
	vars.Helper.GameName = "Megabonk Demo";
	vars.Helper.LoadSceneManager = true;
}

init
{
	IntPtr Address = vars.Megabonk.Start();
	
	if (Address != IntPtr.Zero)
	{
		vars.Helper["StartTimer"] = vars.Helper.Make<ulong>(Address);
		vars.Helper["SplitTimer"] = vars.Helper.Make<ulong>(Address + 0x8);
	}
}

update
{
	vars.Helper.Update();
	vars.Helper.MapPointers();
	current.ActiveScene = vars.Helper.Scenes.Active.Index ?? null;
}

start
{
	return current.StartTimer != old.StartTimer;
}

split
{
	return current.SplitTimer != old.SplitTimer;
}

reset
{
	if (current.StartTimer != old.StartTimer) return true;
	return current.ActiveScene != old.ActiveScene && current.ActiveScene == 0;
}