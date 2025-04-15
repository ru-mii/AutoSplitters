state("SouthOfMidnight") { }

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
}

init
{
	IntPtr GEngine = vars.Helper.ScanRel(3, "48 8B 0D ?? ?? ?? ?? 48 8B 01 FF 90 68 03 00 00 84 C0 75 2D 48 8B CB E8 ?? ?? ?? ?? 48 8B CE");
	
	// start
	vars.Helper["RelativeLocationX"] = vars.Helper.Make<float>(GEngine, 0xD58, 0x38, 0x0, 0x30, 0x270, 0x11C);
	vars.Helper["RelativeLocationY"] = vars.Helper.Make<float>(GEngine, 0xD58, 0x38, 0x0, 0x30, 0x270, 0x120);
	vars.Helper["RelativeLocationZ"] = vars.Helper.Make<float>(GEngine, 0xD58, 0x38, 0x0, 0x30, 0x270, 0x124);
	vars.Helper["RelativeRotationPitch"] = vars.Helper.Make<float>(GEngine, 0xD58, 0x38, 0x0, 0x30, 0x270, 0x128);
	
	// isLoading
	vars.Helper["NowLoading"] = vars.Helper.Make<int>(GEngine, 0xD58, 0x198, 0x1C0, 0x370, 0x28, 0x10, 0x118, 0xD8, 0xB0, 0xA08);
	
	// split
	vars.ChapterCount = 1;
	vars.Helper["ChapterNumber"] = vars.Helper.Make<int>(GEngine, 0xD58, 0x30, 0x280, 0x538, 0x8, 0x1E8, 0x68, 0x38);
	
	// finish
	vars.Helper["Credits"] = vars.Helper.Make<ulong>(GEngine, 0xD58, 0x38, 0x0, 0x30, 0x360, 0x170, 0xF70, 0x28);
	
	vars.Helper.Update();
	vars.Helper.MapPointers();
}

update
{
	vars.Helper.Update();
	vars.Helper.MapPointers();
}

onStart
{
	vars.ChapterCount = 1;
}

start
{
	return
	current.RelativeLocationX == -21570.71289f &&
	current.RelativeLocationY == -6321.435547f &&
	current.RelativeLocationZ == 459.6126099f &&
	current.RelativeRotationPitch == 0 &&
	old.RelativeRotationPitch != 0 &&
	current.ChapterNumber == 1;
}

split
{
	if (current.ChapterNumber != old.ChapterNumber)
	{
		if (current.ChapterNumber > vars.ChapterCount)
		{
				vars.ChapterCount = current.ChapterNumber;
				return true;
		}
	}
	
	return current.Credits != old.Credits && current.Credits != 0;
}

isLoading
{
	return current.NowLoading == 0 || current.NowLoading == 1;
}

exit
{
	timer.IsGameTimePaused = true;
}