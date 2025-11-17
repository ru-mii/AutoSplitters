state("Leaf it Alone"){}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
	vars.Uhara.EnableDebug();
	
	vars.CompletedSplits = new HashSet<int>();
}

init
{
    var Instance = vars.Uhara.CreateTool("Unity", "DotNet", "Instance");
	var JitSave = vars.Uhara.CreateTool("Unity", "DotNet", "JitSave");
	
	// ---
	Instance.SetDefaultNames("Eternity.Gameplay", "Eternity.Gameplay.Progress.UI");
	
	//var YME = "0x" + Instance.Get("ProgressEntry", "lastProgress").Offsets[0].ToString("X");
	//Instance.Watch<float>("Progress", "ProgressView", "currentArea + 0x8", YME);
	
	var ABB = Instance.Get("ProgressEntry", "titleText", "m_text").Offsets;
	var KNE = "0x" + ABB[0].ToString("X"); var GSU = "0x" + ABB[1].ToString("X");
	var PJH = Instance.Get("ProgressView", "currentArea + 0x8", KNE, GSU, "0x14");
	vars.Resolver.WatchString("Ground", PJH.Base, PJH.Offsets);
	
	var ATG = Instance.Get("ProgressView", "leafAreaBehaviour", "dataModel", "<CollectedLeavesByPlotArea>k__BackingField");
	vars.Resolver.WatchList<int>("CollectedLeaves", ATG.Base, ATG.Offsets);
	
	var JKA = Instance.Get("ProgressView", "leafAreaBehaviour", "dataModel", "<TotalLeavesByPlotArea>k__BackingField");
	vars.Resolver.WatchList<int>("TotalLeaves", JKA.Base, JKA.Offsets);
	
	// ---
	JitSave.SetOuter("Eternity.Gameplay.dll", "Eternity.Gameplay.Ending");
	vars.Resolver.Watch<ulong>("SayCheese", JitSave.AddFlag("EndingTimelineBehaviour", "OnTakePhoto"));
	JitSave.ProcessQueue();
	
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
	vars.CompletedSplits.Clear();
	vars.StartAllowed = false;
}

update
{
    vars.Uhara.Update();
	
	if (string.IsNullOrEmpty(current.Ground))
		vars.StartAllowed = true;
}

split
{
	if (current.CollectedLeaves.Count == current.TotalLeaves.Count)
	{
		for (int i = 0; i < current.CollectedLeaves.Count; i++)
		{
			return current.TotalLeaves[i] > 0 &&
			current.CollectedLeaves[i] == current.TotalLeaves[i] &&
			vars.CompletedSplits.Add(i);
		}
	}
	
	return vars.Resolver.CheckFlag("SayCheese");
}