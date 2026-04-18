state("MOUSE") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");
	vars.Uhara.Settings.CreateFromXml("Components/MousePIForHire.Settings.xml");
	vars.CompletedQuests = new HashSet<string>();
	vars.AllowedToStart = false;
}

init
{
    vars.Utils = vars.Uhara.CreateTool("Unity", "Utils");
    vars.Instance = vars.Uhara.CreateTool("Unity", "DotNet", "Instance");
	
	vars.Instance.Watch<byte>("PlayerStunned", "Mouse::Player", "Instance", "stunned");
	vars.Instance.Watch<byte>("IsLoadingNative", "Mouse::LoadingScreenController", "_isLoading");
	vars.Instance.Watch<byte>("IsLoadingScene", "Mouse::SceneLoadingManager", "IsLoading");
	vars.Instance.Watch<byte>("IsNewGameOpen", "Mouse::NewGameDifficultyController", "IsOpen");
	
	var currentQuestsPtr = vars.Instance.Get("Mouse::QuestSystemController", "Instance", "currentQuests"); 
	vars.Resolver.WatchList<IntPtr>("CurrentQuests", currentQuestsPtr.Base, currentQuestsPtr.Offsets);;
}

onStart
{
	vars.CompletedQuests = new HashSet<string>();
	vars.AllowedToStart = false;
}

start
{
	return vars.AllowedToStart && old.PlayerStunned == 1 && current.PlayerStunned == 0 && current.SolidScene == "S_Zeppelin23";
}

update
{
    vars.Uhara.Update();
	
	current.ActiveScene = vars.Utils.GetActiveSceneName() ?? current.ActiveScene;
	current.SolidScene = vars.Utils.GetActiveSceneName2() ?? current.SolidScene;
	current.LoadingScene = vars.Utils.GetLoadingSceneName() ?? current.LoadingScene;
	
	if (current.SolidScene != old.SolidScene)
		//print(current.SolidScene);
	
	// ---
	if (current.IsNewGameOpen == 1 || old.IsNewGameOpen == 0) vars.AllowedToStart = true;
	else if (current.IsNewGameOpen == 0 || old.IsNewGameOpen == 1) vars.AllowedToStart = false;
}

isLoading
{
	return current.IsLoadingNative == 1 || current.IsLoadingScene == 1;
}

split
{
	foreach (IntPtr questState in current.CurrentQuests)
	{
		byte questCompleted = vars.Resolver.Read<byte>(questState + 0x20);
		if (questCompleted != 1) continue;
		
		string questId = vars.Resolver.ReadString(64, ReadStringType.UTF8, questState + 0x10, 0x14);
		if (string.IsNullOrEmpty(questId)) continue;
		
		byte raceQuestCompleted = vars.Resolver.Read<byte>(questState + 0x20);
		if (raceQuestCompleted != 1) continue;
		
		string raceQuestId = vars.Resolver.ReadString(64, ReadStringType.UTF8, questState + 0x10, 0x14);
		if (string.IsNullOrEmpty(raceQuestId) || raceQuestId != questId) continue;
		
		if (!settings["SPL_" + questId]) continue;
		if (!vars.CompletedQuests.Add(questId)) continue;
		
		print(questState.ToString("X") + " | " + questId + " | " + questCompleted.ToString());
		return true;
	}
}