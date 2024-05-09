state("SW64-Win64-Shipping") { }

startup
{
	vars.CompletedSplits = new HashSet<string>();
	vars.AllSplits = new HashSet<string>()
	{
		"Layer2",
		//"GardenPrototype",
		//"Cabin",
		//"Cabin2",
		//"Layer3",
		"Layer3Depths",
		"Layer4",
		//"Layer4Museum",
		//"FleshCave",
		//"disclaimer",
		//"Layer4Ending",
		"Layer4Remnants",
		"FightEnd",
		//"Balcony",
	};
}

onStart
{
	vars.CompletedSplits.Clear();
}

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

	vars.UpdateOldVars = new Action(() =>
	{
		old.PlayerController = current.PlayerController;
		old.ControlCamera = current.ControlCamera;
		old.CameraFaded = current.CameraFaded;
		old.CameraLocationZ = current.CameraLocationZ;
		old.GWorld = current.GWorld;
		old.LevelName = current.LevelName;
	});

	old.ControlCamera = new Vector3f(0, 0, 0);
	old.LevelName = "";
}

update
{
	current.PlayerController = new DeepPointer(vars.GEngine, 0xDE8, 0x38, 0x0, 0x30).Deref<IntPtr>(game);
	current.ControlCamera = new DeepPointer(current.PlayerController + 0x288).Deref<Vector3f>(game);
	current.CameraFaded = new DeepPointer(current.PlayerController + 0x2B8, 0x25C).Deref<float>(game);
	current.CameraLocationZ = new DeepPointer(current.PlayerController + 0x2B8, 0xE88).Deref<float>(game);
	current.GWorld = new DeepPointer(vars.GEngine, 0x780, 0x78).Deref<IntPtr>(game);
	current.LevelName = vars.GetObjectName(current.GWorld);

	if (current.CameraFaded == 1.0f || current.PlayerController == IntPtr.Zero) vars.LoadingNow = true;
	else if (current.CameraFaded != 1.0f && current.PlayerController != IntPtr.Zero) vars.LoadingNow = false;
}

split
{
	foreach (string split in vars.AllSplits)
		if (current.LevelName == split && vars.CompletedSplits.Add(split))
			return true;

	if (current.CameraLocationZ == -5370.0f) return vars.CompletedSplits.Add("TheEnd");
}

start
{
	bool flag = current.LevelName == "Layer1" && vars.CompletedSplits.Add("Layer1");

	// --------------------
	vars.UpdateOldVars();
	return flag;
}

isLoading
{
	return vars.LoadingNow;
}