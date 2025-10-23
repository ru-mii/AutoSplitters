state("PowerWashSimulator") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
    vars.Uhara.EnableDebug();
}

init
{
    var Instance = vars.Uhara.CreateTool("Unity", "IL2CPP", "Instance");
    var Completion = Instance.Get("PWS:PWS:HUDGameJobCleanPercentageView", "m_previousCompletionTotal");
    var Credits = Instance.Get("PWS:PWS:PlayerCreditsView", "m_currentCredits");
    var Loading = Instance.Get("PWS:PWS:LoadingScreen", "m_visible");
    
    vars.Helper["Completion"] = vars.Helper.Make<int>(Completion.Base, Completion.Offsets);
    vars.Helper["Credits"] = vars.Helper.Make<float>(Credits.Base, Credits.Offsets);
    vars.Helper["Loading"] = vars.Helper.Make<bool>(Loading.Base, Loading.Offsets);
}

update
{
    vars.Helper.Update();
    vars.Helper.MapPointers();
    //if(current.Stars > 0)
        //print("stars: " + current.Stars);
}

start
{
    if (!current.Loading && old.Loading)
    {
        return true;
    }
}

split
{
    // split when the completion reaches 100%
    if (current.Completion == 100 && old.Completion != 100)
    {
        return true;
    }
    
}

isLoading
{
    return current.Loading;
}