state("TiltFrog") {}

startup
{
	refreshRate = 60;
	timer.CurrentTimingMethod = TimingMethod.GameTime;
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
}

init
{
	vars.ResetScheduled = false;

	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
		vars.Helper["IsInGame"] = mono.Make<bool>("SpeedrunAutosplit", "IsInGame");
		vars.Helper["VisitedSections"] = mono.Make<int>("SpeedrunAutosplit", "VisitedSections");
		vars.Helper["ResetRunsCount"] = mono.Make<int>("SpeedrunAutosplit", "ResetRunsCount");
		return true;
    });
}

start
{
	if (vars.ResetScheduled || current.IsInGame && current.IsInGame != old.IsInGame)
	{
		vars.ResetScheduled = false;
		return true;
	}
}

split
{
	return current.VisitedSections != 0 && current.VisitedSections != old.VisitedSections;
}

reset
{
	if (current.ResetRunsCount != old.ResetRunsCount)
	{
		vars.ResetScheduled = true;
		return true;
	}
}

isLoading
{
	return !current.IsInGame;
}