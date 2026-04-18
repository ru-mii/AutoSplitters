state("MOUSE") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");
	vars.Uhara.Settings.CreateFromXml("Components/MousePIForHire.Settings.xml");
	vars.CompletedQuests = new HashSet<string>();
	vars.AllowedToStart = false;
	
	vars.lcCache = new Dictionary<string, LiveSplit.UI.Components.ILayoutComponent>();
	vars.SetText = (Action<string, object>)((text1, text2) =>
	{
		const string FileName = "LiveSplit.Text.dll";
		LiveSplit.UI.Components.ILayoutComponent lc;

		if (!vars.lcCache.TryGetValue(text1, out lc))
		{
			lc = timer.Layout.LayoutComponents.Reverse().Cast<dynamic>()
				.FirstOrDefault(llc => llc.Path.EndsWith(FileName) && llc.Component.Settings.Text1 == text1)
				?? LiveSplit.UI.Components.ComponentManager.LoadLayoutComponent(FileName, timer);

			vars.lcCache.Add(text1, lc);
		}

		if (!timer.Layout.LayoutComponents.Contains(lc)) timer.Layout.LayoutComponents.Add(lc);
		dynamic tc = lc.Component;
		tc.Settings.Text1 = text1;
		tc.Settings.Text2 = text2.ToString();
	});
	
	vars.RemoveText = (Action<string>)(text1 =>
	{
		LiveSplit.UI.Components.ILayoutComponent lc;
		if (vars.lcCache.TryGetValue(text1, out lc))
		{
			timer.Layout.LayoutComponents.Remove(lc);
			vars.lcCache.Remove(text1);
		}
	});
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
	vars.Resolver.WatchList<IntPtr>("CurrentQuests", currentQuestsPtr.Base, currentQuestsPtr.Offsets);
	
	// ---
	vars.PlayerPositionPath = vars.Instance.Get("Mouse::Player", "PlayerTransform", "0x10", "0x28", "0x90");
	vars.GetPlayerPosition = (Func<float[]>)(() =>
	{
		do
		{
			byte[] posBytes = vars.Resolver.ReadBytes(vars.PlayerPositionPath.Base, 12, vars.PlayerPositionPath.Offsets);
			if (posBytes == null || posBytes.Length == 0) break;
			
			float x = BitConverter.ToSingle(posBytes, 0);
			float y = BitConverter.ToSingle(posBytes, 4);
			float z = BitConverter.ToSingle(posBytes, 8);
			
			return new float[] { x, y, z };
		}
		while (false);
		return null;
	});
	
	vars.SetTextIfEnabled = (Action<string, string, object>)((settingId, label, value) =>
	{
		if (settings[settingId]) vars.SetText(label, value);
		else vars.RemoveText(label);
	});
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
	
	//if (current.SolidScene != old.SolidScene)
		//print(current.SolidScene);
	
	// ---
	if (current.IsNewGameOpen == 1 || old.IsNewGameOpen == 0) vars.AllowedToStart = true;
	else if (current.IsNewGameOpen == 0 || old.IsNewGameOpen == 1) vars.AllowedToStart = false;
	
	// ---
	float[] playerPosition = vars.GetPlayerPosition();
	if (playerPosition == null) playerPosition = new float[] { 0, 0, 0 };
	vars.SetTextIfEnabled("MSC_ShowPlayerPosition", "XYZ: ", 
		playerPosition[0].ToString("N3") + " | " + playerPosition[1].ToString("N3") + " | " + playerPosition[2].ToString("N3"));
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
		
		//print(questState.ToString("X") + " | " + questId + " | " + questCompleted.ToString());
		return true;
	}
}

reset
{
	return current.SolidScene != old.SolidScene &&
	current.SolidScene == "MainMenu" &&
	settings["MSC_MainMenuReset"];
}