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
	IntPtr NowLoading = vars.Helper.ScanRel(2, "8B 3D ?? ?? ?? ?? 48 8B 1D F9 FD 58 01 85 FF 74 1D ?? ?? ?? ?? 00 48 8B CB E8 C?");
	vars.Helper["NowLoading"] = vars.Helper.Make<int>(NowLoading);
	
	// split
	vars.ChapterCount = 1;
	vars.Helper["ChapterNumber"] = vars.Helper.Make<int>(GEngine, 0xD58, 0x30, 0x280, 0x538, 0x8, 0x1E8, 0x68, 0x38);
}

update
{
	vars.Helper.Update();
	vars.Helper.MapPointers();
	
	//print(current.ChapterNumber.ToString());
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
		if (current.ChapterNumber - vars.ChapterCount == 1)
		{
				vars.ChapterCount++;
				return true;
		}
	}
}

isLoading
{
	return current.NowLoading == 0;
}