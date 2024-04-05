state("ThunderRay") {}

startup
{
     Assembly.Load(File.ReadAllBytes(@"Components/asl-help")).CreateInstance("Unity");
}

init
{
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
	{
		vars.Helper["lastUnlockedStage"] = mono.Make<int>("MatchData", "instance", "currentStage");
		vars.Helper["finalCutscene"] = mono.Make<bool>("SaveSystem", "finalCutscene");
		vars.Helper["firstCutscene"] = mono.Make<bool>("SaveSystem", "firstCutscene");
		vars.Helper["isLoading"] = mono.Make<bool>("SaveSystem", "isLoading");
		vars.Helper["reset"] = mono.Make<bool>("SaveSystem", "reset");
								
		return true;
	});
}

start
{
	if (current.firstCutscene != old.firstCutscene) return true;
}

split
{

	if (old.lastUnlockedStage != current.lastUnlockedStage && current.lastUnlockedStage != 0) return true;
	if (current.finalCutscene!= old.finalCutscene) return true;
}

isLoading
{
	return current.isLoading;
}

reset
{
	if (current.reset!= old.reset) return true;
}