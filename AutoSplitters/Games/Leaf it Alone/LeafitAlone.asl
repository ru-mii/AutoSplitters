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
	Instance.SetDefaultNames("Eternity.Gameplay", "Eternity.Gameplay");
	Instance.Watch<double>("InGameTime", "GameplayApplication", "<GameSave>k__BackingField", "<PlayTime>k__BackingField");
	
	// ---
	Instance.SetDefaultNames("Eternity.Gameplay", "Eternity.Gameplay.Progress.UI");
	
	var ATG = Instance.Get("ProgressView", "leafAreaBehaviour", "dataModel", "<CollectedLeavesByPlotArea>k__BackingField");
	vars.Resolver.WatchList<int>("CollectedLeaves", ATG.Base, ATG.Offsets);
	
	var JKA = Instance.Get("ProgressView", "leafAreaBehaviour", "dataModel", "<TotalLeavesByPlotArea>k__BackingField");
	vars.Resolver.WatchList<int>("TotalLeaves", JKA.Base, JKA.Offsets);
	
	// ---
	JitSave.SetOuter("Eternity.Gameplay.dll", "Eternity.Gameplay.Ending");
	vars.Resolver.Watch<ulong>("SayCheese", JitSave.AddFlag("EndingTimelineBehaviour", "OnTakePhoto"));
	JitSave.ProcessQueue();
}

start
{
	return current.InGameTime < 1 && current.InGameTime != 0 && old.InGameTime == 0;
}

onStart
{
	vars.CompletedSplits.Clear();
}

update
{
    vars.Uhara.Update();
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