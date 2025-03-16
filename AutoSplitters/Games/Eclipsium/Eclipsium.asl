state("Eclipsium") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
}

init
{
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        vars.Helper["CPlaying"] = mono.Make<bool>("CutsceneManager",
			"_instance", "isplaying");

        return true;
    });
}

start
{
	return old.CPlaying && !current.CPlaying;
}

split
{
	return old.CPlaying && !current.CPlaying;
}