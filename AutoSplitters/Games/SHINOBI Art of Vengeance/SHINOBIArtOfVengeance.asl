state("SHINOBI_AOV_DEMO")
{
}

startup
{
    vars.Log = (Action<object>)(output => print("[Shinobi: Art of Vengeance] " + output));

    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    Assembly.Load(File.ReadAllBytes("Components/uhara7")).CreateInstance("Main");

    vars.Helper.GameName = "Shinobi: Art of Vengeance";
    vars.Helper.LoadSceneManager = true;

    settings.Add("AOV", true, "Shinobi: Art of Vengeance");
        settings.Add("Story", true, "Story Mode Splits", "AOV");
            settings.Add("StoryDEMO_Oboro_Village_Scene_Gameplay", true, "Oboro Village", "Story");
            settings.Add("StoryDEMO_Bamboo_Forest_Scene_Gameplay", true, "Bamboo Forest", "Story");
            settings.Add("StoryDEMO_Temple_Scene_Gameplay", true, "Temple", "Story");
            settings.Add("StoryDEMO_Boss_Scene_Gameplay", true, "Kozaru", "Story");
        settings.Add("Arcade", true, "Arcade Mode Splits", "AOV");
            settings.Add("ArcadeDEMO_Oboro_Village_Scene_Gameplay", true, "Oboro Village", "Arcade");
            settings.Add("ArcadeDEMO_Bamboo_Forest_Scene_Gameplay", true, "Bamboo Forest", "Arcade");
            settings.Add("ArcadeDEMO_Temple_Scene_Gameplay", true, "Temple", "Arcade");
            settings.Add("ArcadeDarkKatana", true, "Kozaru", "Arcade");

    vars.Splits = new HashSet<string>();
}

init
{
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
         var fcb = mono["FightControllerBase"];
         //vars.Helper["BossFight"] = fcb.Make<int>("FightControllerBase", "StateEnum");
         //vars.Helper["BossFightOutro"] = fcb.Make<bool>("FightControllerBase", "OutroSequence", "IsPlaying");

        return true;
    });
}

update
{
    vars.Helper.Update();
    vars.Helper.MapPointers();

    current.SceneCount = vars.Helper.Scenes.Count;
    current.activeScene = vars.Helper.Scenes.Active.Name == null ? current.activeScene : vars.Helper.Scenes.Active.Name;
    current.loadingScene = vars.Helper.Scenes.Loaded[0].Name == null ? current.loadingScene : vars.Helper.Scenes.Loaded[0].Name;

    if(current.activeScene != old.activeScene)
    {
        vars.Log("Current Scene: " + current.activeScene + " <- " + old.activeScene);
    }

    if(current.loadingScene != old.loadingScene)
    {
        vars.Log("Loading?: " + current.loadingScene);
    }
	
	//print(current.CurrentGameMode.ToString("X"));
}

isLoading
{
    return current.SceneCount <= 5 && current.activeScene == "Global";
}

start
{
    return current.activeScene == "Global" && old.activeScene == "MainMenu";
}

onStart
{
    vars.Splits.Clear();
}

split
{
    if(!current.activeScene.Contains("Gameplay") && old.activeScene.Contains("Gameplay") && !current.loadingScene.Contains("Gameplay") && current.GameMode == 1 && !vars.Splits.Contains("Story"+old.activeScene))
    {
        return settings["Story"+old.activeScene] && vars.Splits.Add("Story"+old.activeScene);
    }

    if(!current.activeScene.Contains("Gameplay") && old.activeScene.Contains("Gameplay") && !current.loadingScene.Contains("Gameplay") && current.GameMode == 3 && !vars.Splits.Contains("Arcade"+old.activeScene))
    {
        return settings["Arcade"+old.activeScene] && vars.Splits.Add("Arcade"+old.activeScene);
    }

    if(current.activeScene == "DEMO_Boss_Scene_Gameplay" && current.GameMode == 3 && current.Collectible == 9000 && current.ChestStatus == 2 && !vars.Splits.Contains("ArcadeDarkKatana"))
    {
        return settings["ArcadeDarkKatana"] && vars.Splits.Add("ArcadeDarkKatana");
    }
}

exit
{
    timer.IsGameTimePaused = true;
}