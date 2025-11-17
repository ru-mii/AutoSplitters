state("Leaf it Alone"){}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
	vars.Uhara.EnableDebug();
}

init
{
    var Instance = vars.Uhara.CreateTool("Unity", "DotNet", "Instance");
	
	// ---
	Instance.SetDefaultNames("Eternity.Gameplay", "Eternity.Gameplay.Progress.UI");
	
	var YME = "0x" + Instance.Get("ProgressEntry", "lastProgress").Offsets[0].ToString("X");
	Instance.Watch<float>("Progress", "ProgressView", "currentArea + 0x8", YME);
	
	var ABB = Instance.Get("ProgressEntry", "titleText", "m_text").Offsets;
	var KNE = "0x" + ABB[0].ToString("X"); var GSU = "0x" + ABB[1].ToString("X");
	var PJH = Instance.Get("ProgressView", "currentArea + 0x8", KNE, GSU, "0x14");
	vars.Resolver.WatchString("Ground", PJH.Base, PJH.Offsets);
	
	// ---
	vars.StartAllowed = false;
}

start
{
	return 
	vars.StartAllowed && 
	(current.Ground == "Entrance" || current.Ground == "Porch")
	&& string.IsNullOrEmpty(old.Ground);
}

onStart
{
	vars.StartAllowed = false;
}

update
{
    vars.Uhara.Update();
	
	if (string.IsNullOrEmpty(current.Ground))
		vars.StartAllowed = true;
}