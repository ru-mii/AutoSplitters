state("Leaf it Alone"){}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");
	vars.CompletedSplits = new HashSet<int>();
	
	MessageBox.Show("Developers of this game decided to obfuscate their GameAssembly.dll essentially breaking this Autosplitter." + "\n\n" +
	"Please head to speedrun.com to find the discord server for this game, then head to pinned messages to find the integrated server " +
	"version of an autosplitter made by the devs." + "\n\n" + 
	"If you still want to use this specific Autosplitter make sure you downpatched your game, otherwise LiveSplit will freeze." + "\n\n" +
	"download_depot 3981100 3981101 3378561525283786503");
}

init
{
	string exePath = game.MainModule.FileName;
	if (string.IsNullOrEmpty(exePath)) throw new Exception();
	string exeDir = Path.GetDirectoryName(exePath);
	if (string.IsNullOrEmpty(exeDir)) throw new Exception();
	string gameAssemblyPath = Path.Combine(exeDir, "GameAssembly.dll");
	
	if (File.Exists(gameAssemblyPath))
	{
		vars.Instance = vars.Uhara.CreateTool("Unity", "IL2CPP", "Instance");
		vars.JitSave = vars.Uhara.CreateTool("Unity", "IL2CPP", "JitSave");
	}
	else
	{
		vars.Instance = vars.Uhara.CreateTool("Unity", "DotNet", "Instance");
		vars.JitSave = vars.Uhara.CreateTool("Unity", "DotNet", "JitSave");
	}
	
	
	// ---
	vars.Instance.SetDefaultNames("Eternity.Gameplay", "Eternity.Gameplay");
	vars.Instance.Watch<double>("InGameTime", "GameplayApplication", "GameSave", "PlayTime");
	
	// ---
	vars.Instance.SetDefaultNames("Eternity.Gameplay", "Eternity.Gameplay.Progress.UI");
	
	var ATG = vars.Instance.Get("ProgressView", "leafAreaBehaviour", "dataModel", "CollectedLeavesByPlotArea");
	vars.Resolver.WatchList<int>("CollectedLeaves", ATG.Base, ATG.Offsets);
	
	var JKA = vars.Instance.Get("ProgressView", "leafAreaBehaviour", "dataModel", "TotalLeavesByPlotArea");
	vars.Resolver.WatchList<int>("TotalLeaves", JKA.Base, JKA.Offsets);
	
	// ---
	vars.JitSave.SetOuter("Eternity.Gameplay.dll", "Eternity.Gameplay.Ending");
	vars.Resolver.Watch<ulong>("SayCheese", vars.JitSave.AddFlag("EndingTimelineBehaviour", "OnTakePhoto"));
	vars.JitSave.ProcessQueue();
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