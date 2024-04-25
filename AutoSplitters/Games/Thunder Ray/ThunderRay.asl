state("ThunderRay") {}

startup
{
	refreshRate = 60;
	Assembly.Load(File.ReadAllBytes(@"Components/asl-help")).CreateInstance("Unity");
}

init
{
	vars.HelperActive = false; vars.HelperDelay = 2; vars.HelperIterations = 7;
	vars.HelperCounter = 0; vars.HelperFinished = false;

	vars.HelperCatchTime = DateTimeOffset.UtcNow.ToUnixTimeSeconds() + vars.HelperDelay;
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => { vars.monoGlobal = mono; return true; });
}

update
{
	if (!vars.HelperFinished && vars.HelperCatchTime <= DateTimeOffset.UtcNow.ToUnixTimeSeconds())
	{
		bool foundErrors = false;
		try { vars.Classic = vars.monoGlobal["Thunder", "Thunder"]; }
		catch { foundErrors = true; }

		if (!foundErrors)
		{
			vars.Helper["mStart"] = vars.Classic.Make<bool>("mStart");
			vars.Helper["mSplit"] = vars.Classic.Make<bool>("mSplit");
			vars.Helper["mReset"] = vars.Classic.Make<bool>("mReset");
			vars.Helper["mLoading"] = vars.Classic.Make<bool>("mLoading");
			vars.HelperFinished = true;
			vars.HelperActive = true;
		}

		vars.HelperCounter += 1;
		vars.HelperCatchTime = DateTimeOffset.UtcNow.ToUnixTimeSeconds() + vars.HelperDelay;
		if (vars.HelperCounter == vars.HelperIterations)
		{
			vars.HelperFinished = true;
			if (!vars.HelperActive)
            {
				if (MessageBox.Show("The speedrun mod was not detected and therefore the autosplitter won't work, " +
                    "the speedrun mod for this game is recommended as it adds features like practice mode and allows you to clean " +
                    "your save files which is not supported by the game and won't work even if you remove the files manually, do " +
                    "you want to download the mod now?", "Speedrun Mod", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                {
					Process.Start("https://www.speedrun.com/Thunder_Ray/resources/pljct");
                }
            }
			else vars.Helper.Update();
		}
	}
}

start
{
	if (vars.HelperActive)
    {
		return current.mStart != old.mStart;
	}
}

split
{
	if (vars.HelperActive)
	{
		return current.mSplit != old.mSplit;
	}
}

isLoading
{
	if (vars.HelperActive)
	{
		return current.mLoading;
	}
}

reset
{
	if (vars.HelperActive)
	{
		return current.mReset != old.mReset;
	}
}