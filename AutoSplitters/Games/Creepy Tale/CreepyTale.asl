state("CreepyTale"){}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	Assembly.Load(File.ReadAllBytes("Components/uhara5")).CreateInstance("Main");
	vars.Helper.GameName = "Creepy Tale";
	vars.Helper.LoadSceneManager = true;
	vars.Helper.AlertLoadless();

	dynamic[,] _settings =
	{
		{ "Reset", true, "Reset on retun to Menu", null },
		{ "Chapters", true, "Chapters Splits", null },
			{ "1", true, "Chapter 1", "Chapters" },
			{ "2", true, "Chapter 2", "Chapters" },
			{ "3", true, "Chapter 3", "Chapters" },
			{ "4", true, "Chapter 4", "Chapters" },
			{ "5", true, "Chapter 5", "Chapters" },
			{ "6", true, "Chapter 6", "Chapters" },
			{ "7", true, "Chapter 7", "Chapters" },
			{ "8", true, "Chapter 8", "Chapters" },
	};

	vars.Helper.Settings.Create(_settings);
	vars.VisitedLevel = new List<string>();
}

init
{
	vars.JitSave = vars.Uhara.CreateTool("UnityCS", "JitSave");
	IntPtr EndLoad = vars.JitSave.Add("LoaderBg", "HideLoader", 0, 1, 23,
	new byte[] { 0x80, 0x3C, 0x24, 0xE9, 0x75, 0x08, 0x48, 0x83, 0x05, 0xEA, 0xFF, 0xFF, 0xFF, 0x01 });
	vars.JitSave.ProcessQueue();
	
	vars.Helper["EndLoad"] = vars.Helper.Make<int>(EndLoad);
	
	current.NowLoading = false;
	
	// vars.JitSave = vars.Uhara.CreateTool("UnityCS", "JitSave");
	// IntPtr PlayerController = vars.JitSave.AddInst("LoaderBg");
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => 
	{
		vars.Helper["Chapter"] = mono.Make<int>("Main", "location");
		vars.Helper["IsPaused"] = mono.Make<bool>("Main", "hero", "pauseMode");
		vars.Helper["ManagerIsPaused"] = mono.Make<bool>("ManagerFunctions", 1, "_instance", "isPause");
		// vars.Helper["loaderBg_alpha"] = mono.Make<float>("LoaderBg", "_instance", "fade", 0x68);
		return true;
	});
}

start
{
	return old.activeScene == "Menu" && current.activeScene == "Game";
}

onStart
{
	vars.VisitedLevel.Clear();
	timer.IsGameTimePaused = true;
}

update
{
	current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
	current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? current.loadingScene;
	
	// if(old.activeScene != current.activeScene) vars.Log("active: " + old.activeScene + "->" + current.activeScene);
	// if(old.loadingScene != current.loadingScene) vars.Log("loading: " + old.loadingScene + "->" + current.loadingScene);
	// if (old.Chapter != current.Chapter) vars.Log("Chapter: " + current.Chapter);
	// if (old.ManagerIsPaused != current.ManagerIsPaused) vars.Log("ManagerIsPaused: " + current.ManagerIsPaused);
	// if (old.IsPaused != current.IsPaused) vars.Log("IsPaused: " + current.IsPaused);
	
	
}

split
{
	if (old.Chapter != current.Chapter && settings[current.Chapter.ToString()] && !vars.VisitedLevel.Contains(current.Chapter.ToString())) 
	{
		vars.VisitedLevel.Add(current.Chapter.ToString());
		return true;
	}
}

reset
{
	if (current.activeScene == "Menu") current.NowLoading = false;
	return settings["Reset"] && old.activeScene == "Game" && current.activeScene == "Menu";
}

isLoading
{
	//return (current.activeScene != current.loadingScene) || current.Chapter == 0 || current.ManagerIsPaused && !current.IsPaused;
	return current.NowLoading;
}