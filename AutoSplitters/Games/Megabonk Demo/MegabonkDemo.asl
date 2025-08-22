state("Megabonk Demo") { }

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    Assembly.Load(File.ReadAllBytes("Components/uhara8")).CreateInstance("Main");
	vars.Uhara.EnableDebug();
	
	vars.Helper.GameName = "Megabonk Demo";
	vars.Helper.LoadSceneManager = true;
}

init
{
	vars.JitSave = vars.Uhara.CreateTool("Unity", "IL2CPP", "JitSave");
    IntPtr OnPortalClose = vars.JitSave.AddFlag("UiManager", "OnPortalClose");
    IntPtr OnBossDefeated = vars.JitSave.AddFlag("ObjectiveUi", "OnBossDefeated");
    vars.JitSave.ProcessQueue();
	
	vars.Helper["OnPortalClose"] = vars.Helper.Make<int>(OnPortalClose);
	vars.Helper["OnBossDefeated"] = vars.Helper.Make<int>(OnBossDefeated);
	
	vars.Helper.Update();
	vars.Helper.MapPointers();
}

update
{
	vars.Helper.Update();
	vars.Helper.MapPointers();
	current.ActiveScene = vars.Helper.Scenes.Active.Index ?? null;
}

start
{
	return current.OnPortalClose != old.OnPortalClose;
}

split
{
	return current.OnBossDefeated != old.OnBossDefeated;
}

reset
{
	if (current.OnPortalClose != old.OnPortalClose) return true;
	return current.ActiveScene != old.ActiveScene && current.ActiveScene == 0;
}