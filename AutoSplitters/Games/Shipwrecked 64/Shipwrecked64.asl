﻿state("SW64-Win64-Shipping") { }

startup
{
	vars.CompletedSplits = new HashSet<string>();
	vars.TrueEndingSplits = new HashSet<string>()
	{
		"GardenPrototype", "Cabin", "Cabin2", "Layer2",
		"Layer3", "Layer3Depths", "Layer4", "Layer4Museum",
		"FleshCave", "disclaimer", "Layer4Ending", "Layer4Remnants",
		"FightEnd","Balcony",
	};

	vars.OhHiOliviaSplits = new HashSet<string>()
	{
		"WulfDeath", "WulfSpook", "WulfDone", "Boat"
	};

	settings.Add("group_OhHiOlivia", false, "Oh. (Hi Olivia!)");
	settings.Add("split_WulfDeath", false, "Wulf Death", "group_OhHiOlivia");
	settings.Add("split_WulfSpook", false, "Wulf Spook", "group_OhHiOlivia");
	settings.Add("split_WulfDone", false, "Wulf Done", "group_OhHiOlivia");
	settings.Add("split_Boat", false, "Boat", "group_OhHiOlivia");

	settings.Add("group_TrueEnding", true, "True Ending");
	settings.Add("split_Layer2", true, "Layer2", "group_TrueEnding");
	settings.Add("split_Layer3", true, "Layer3", "group_TrueEnding");
	settings.Add("split_Layer3Depths", true, "Layer3Depths", "group_TrueEnding");
	settings.Add("split_Layer4", true, "Layer4", "group_TrueEnding");
	settings.Add("split_Layer4Remnants", true, "Layer4Remnants", "group_TrueEnding");
	settings.Add("split_FightEnd", true, "FightEnd", "group_TrueEnding");

	settings.Add("group_ExtraSplits", false, "Extra Splits");
	settings.Add("split_Cabin2", false, "Cabin2", "group_ExtraSplits");
	settings.Add("split_GardenPrototype", false, "GardenPrototype", "group_ExtraSplits");
	settings.Add("split_Cabin", false, "Cabin", "group_ExtraSplits");
	settings.Add("split_Layer4Museum", false, "Layer4Museum", "group_ExtraSplits");
	settings.Add("split_FleshCave", false, "FleshCave", "group_ExtraSplits");
	settings.Add("split_disclaimer", false, "disclaimer", "group_ExtraSplits");
	settings.Add("split_Layer4Ending", false, "Layer4Ending", "group_ExtraSplits");
	settings.Add("split_Balcony", false, "Balcony", "group_ExtraSplits");

	settings.Add("group_ResetIn", true, "Reset In");
	settings.Add("reset_Selection", true, "Selection", "group_ResetIn");
	settings.Add("reset_SaveRoom", true, "SaveRoom", "group_ResetIn");
	settings.Add("reset_Menu", true, "Menu", "group_ResetIn");
}

onStart { vars.CompletedSplits.Clear(); }

init
{
	vars.DerefRelative = (Func<IntPtr, int, IntPtr>)((a_Address, a_Offset) =>
	{
		ulong address = (ulong)a_Address + (ulong)a_Offset;
		ulong bigOffset = (ulong)memory.ReadValue<uint>((IntPtr)(address));
		return (IntPtr)(address + bigOffset + 4);
	});

	var scanner = new SignatureScanner(game, game.MainModule.BaseAddress, (int)game.MainModule.ModuleMemorySize);
	vars.FNames = vars.DerefRelative(scanner.Scan(new SigScanTarget("89 5C 24 ?? 89 44 24 ?? 74 ?? 48 8D 15")), 13);
	vars.GEngine = vars.DerefRelative(scanner.Scan(new SigScanTarget("48 39 35 ?? ?? ?? ?? 0F 85 ?? ?? ?? ?? 48 8B 0D")), 3);

	vars.GetObjectName = (Func<IntPtr, string>)((uObject) =>
	{
		ulong fName = memory.ReadValue<ulong>(uObject + 0x18);
		var nameIdx = (fName & 0x000000000000FFFF) >> 0x00;
		var chunkIdx = (fName & 0x00000000FFFF0000) >> 0x10;
		var number = (fName & 0xFFFFFFFF00000000) >> 0x20;

		IntPtr chunk = memory.ReadValue<IntPtr>((IntPtr)vars.FNames + 0x10 + (int)chunkIdx * 0x8);
		IntPtr entry = chunk + (int)nameIdx * sizeof(short);

		int length = memory.ReadValue<short>(entry) >> 6;
		string name = memory.ReadString(entry + sizeof(short), length);

		return number == 0 ? name : name + "_" + number;
	});

	old.ControlCamera = new Vector3f(0, 0, 0);
	old.LevelName = "";
}

update
{
	current.GameInstance = new DeepPointer(vars.GEngine, 0xDE8).Deref<IntPtr>(game);
	current.PlayerController = new DeepPointer(current.GameInstance + 0x38, 0x0, 0x30).Deref<IntPtr>(game);
	current.ControlCamera = new DeepPointer(current.PlayerController + 0x288).Deref<Vector3f>(game);
	current.CameraCap1 = new DeepPointer(current.PlayerController + 0x2B8, 0x24C).Deref<float>(game);
	current.CameraCap2 = new DeepPointer(current.PlayerController + 0x2B8, 0x250).Deref<float>(game);
	current.CameraCap3 = new DeepPointer(current.PlayerController + 0x2B8, 0x254).Deref<float>(game);
	current.CameraCap4 = new DeepPointer(current.PlayerController + 0x2B8, 0x258).Deref<float>(game);
	current.CameraFade = new DeepPointer(current.PlayerController + 0x2B8, 0x25C).Deref<float>(game);
	current.CameraLocationZ = new DeepPointer(current.PlayerController + 0x2B8, 0xE88).Deref<float>(game);
	current.GWorld = new DeepPointer(vars.GEngine, 0x780, 0x78).Deref<IntPtr>(game);
	current.LevelName = vars.GetObjectName(current.GWorld);

	current.WulfDeath = new DeepPointer(current.GameInstance + 0x1CC).Deref<byte>(game);
	current.WulfSpook = new DeepPointer(current.GameInstance + 0x1CD).Deref<byte>(game);
	current.WulfDone = new DeepPointer(current.GameInstance + 0x1CE).Deref<byte>(game);

	if (current.CameraCap1 == 1.0f && current.CameraCap2 == 1.0f &&
		current.CameraCap3 == 1.0f && current.CameraCap4 == 1.0f) vars.CameraCap = true;
	else vars.CameraCap = false;

	if (current.CameraFade == 1.0f || current.PlayerController == IntPtr.Zero) vars.LoadingNow = true;
	else if (current.CameraFade != 1.0f && current.PlayerController != IntPtr.Zero) vars.LoadingNow = false;
}

split
{
	print(current.LevelName);

	// true ending
	foreach (string split in vars.TrueEndingSplits)
		if (current.LevelName == split && vars.CompletedSplits.Add(split) && settings["split_" + split])
			return true;

	// oh, hi olivia
	foreach (string split in vars.OhHiOliviaSplits)
    {
		if (settings["split_" + split])
        {
			if (split == "WulfDeath" && old.WulfDeath == 0 && current.WulfDeath == 1 &&
				vars.CompletedSplits.Add(split)) return true;

			else if (split == "WulfSpook" && old.WulfSpook == 0 && current.WulfSpook == 1 &&
				vars.CompletedSplits.Add(split)) return true;

			else if (split == "WulfDone" && current.WulfDone == 1 && old.LevelName != current.LevelName &&
				current.LevelName == "Crevace2" && vars.CompletedSplits.Add(split)) return true;

			else if (split == "Boat" && old.LevelName != current.LevelName &&
				current.LevelName == "ending1" && vars.CompletedSplits.Add(split)) return true;
		}
    }

	return current.CameraLocationZ == -5370.0f && vars.CompletedSplits.Add("TheEnd");
}

start
{
	return old.ControlCamera.Y != current.ControlCamera.Y && current.ControlCamera.Y == 100.000145f &&
		current.ControlCamera.X + current.ControlCamera.Z == 0 && current.CameraFade < 1.0f;
}

isLoading
{
	return vars.LoadingNow && !vars.CameraCap;
}

reset
{
	return (current.LevelName == "Selection" && settings["reset_Selection"]) ||
		(current.LevelName == "SaveRoom" && settings["reset_SaveRoom"]) ||
		(current.LevelName == "Menu" && settings["reset_Menu"]);
}