// start & loading logic remains the same as the original asl made by Doublemoses
state("AI-LIMIT") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");
	
    vars.waitForNewGame = false;
    vars.waitForFirstLoad = false;
}

init
{
	Thread.Sleep(5000);
    vars.Instance = vars.Uhara.CreateTool("Unity", "IL2CPP", "Instance");
	
	vars.Instance.Watch<bool>("mainMenuActive", "SenseGame.Logic::TitleView", "_ISActive");
	vars.Instance.Watch<bool>("loadingScreenActive", "SenseGame.Logic::LoadingView", "_ISActive");
	vars.Instance.Watch<uint>("levelID", "SenseGame.Logic::LevelLoadManager", "Instance", "CurLevelRoot", "StorySceneID");
}

update
{
    vars.Uhara.Update();
}

start
{
    if (current.mainMenuActive) vars.waitForNewGame = true;
    if (vars.waitForNewGame && current.loadingScreenActive && current.levelID == 800001)
    {
        vars.waitForNewGame = false;
        vars.waitForFirstLoad = true;
    }

    if (vars.waitForFirstLoad && !current.loadingScreenActive && !current.mainMenuActive && current.levelID == 800001)
    {
        vars.waitForNewGame = false;
        vars.waitForFirstLoad = false;
        return true;
    }
}

onReset
{
    vars.waitForNewGame = false;
    vars.waitForFirstLoad = false;
}

isLoading
{
    return current.loadingScreenActive || current.mainMenuActive;
}

exit
{
    timer.IsGameTimePaused = true;
}