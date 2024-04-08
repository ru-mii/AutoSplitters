state("A Difficult Game About Climbing") {}

startup
{
	refreshRate = 60; vars.helperActive = false;
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	
	// -----------------------------------

	vars.pointersFound = false;
	vars.animControlPList = new Dictionary<DeepPointer, int> {
		{ new DeepPointer("UnityPlayer.dll", 0x1AD8388, 0x0, 0x3A0, 0x0, 0x10, 0x30, 0x38, 0x28), 0x0 },
		{ new DeepPointer("UnityPlayer.dll", 0x1A8C3C0, 0x328, 0x50, 0x168, 0x30, 0x78, 0x30, 0x38, 0x28), 0x0 },
		{ new DeepPointer("UnityPlayer.dll", 0x1AD81D0, 0x940, 0x1F8, 0x298, 0x150, 0x68, 0x68, 0x38, 0x28), 0x0 },
		{ new DeepPointer("UnityPlayer.dll", 0x1AD8388, 0x0, 0x3A0, 0x0, 0x28, 0x10, 0x0, 0x30, 0x38, 0x28), 0x0 },
		{ new DeepPointer("UnityPlayer.dll", 0x1A8C3C0, 0xF0, 0xE8, 0x50, 0x168, 0x30, 0x78, 0x30, 0x38, 0x28), 0x0 },
		{ new DeepPointer("UnityPlayer.dll", 0x1A8C280, 0x50, 0x128, 0xE8, 0x78, 0xC8, 0x30, 0x30, 0x38, 0x28), 0x0 },
		{ new DeepPointer("UnityPlayer.dll", 0x1A8C3C0, 0x2A0, 0x0, 0x18, 0x10, 0xD0, 0x30, 0x30, 0x38, 0x28), 0x0 },
		{ new DeepPointer("UnityPlayer.dll", 0x1B15160, 0x8, 0x8, 0x28, 0x0, 0x10, 0x30, 0x30, 0x38, 0x28), 0x0 },
		{ new DeepPointer("UnityPlayer.dll", 0x1AD81C8, 0x40, 0xD78, 0xC8, 0x298, 0x150, 0x68, 0x68, 0x38, 0x28), 0x0 },
		{ new DeepPointer("UnityPlayer.dll", 0x1AD8388, 0x0, 0x5F8, 0x3B0, 0x0, 0x10, 0x30, 0x158, 0x48, 0x28), 0x0 },
	};

	vars.positionObjectPList = new Dictionary<DeepPointer, int> {
		{ new DeepPointer("UnityPlayer.dll", 0x1A8C3C0, 0x328, 0x78, 0xC8, 0x30, 0x30, 0x48), 0x0 },
		{ new DeepPointer("UnityPlayer.dll", 0x1AD8388, 0x0, 0x3A0, 0x0, 0x10, 0x30, 0x48, 0x90), 0x0 },
		{ new DeepPointer("UnityPlayer.dll", 0x1A8C3C0, 0x328, 0x78, 0xC8, 0x140, 0x30, 0x30, 0x48), 0x0 },
		{ new DeepPointer("UnityPlayer.dll", 0x1AD8388, 0x0, 0x3A0, 0x0, 0x10, 0x30, 0x168, 0x80), 0x0 },
		{ new DeepPointer("UnityPlayer.dll", 0x1A8C3C0, 0x328, 0x78, 0xC8, 0x30, 0x30, 0x48, 0x90), 0x0 },
		{ new DeepPointer("UnityPlayer.dll", 0x1A8C3C0, 0x328, 0x78, 0xC8, 0x30, 0x30, 0x48, 0x90), 0x0 },
		{ new DeepPointer("UnityPlayer.dll", 0x1B15160, 0x8, 0x8, 0x28, 0x0, 0xA0, 0x18, 0x0), 0x10 },
		{ new DeepPointer("UnityPlayer.dll", 0x1B15168, 0x8, 0x48, 0x28, 0x0, 0xA0, 0x18, 0x0), 0x10 },
		{ new DeepPointer("UnityPlayer.dll", 0x1B1AAF8, 0x0, 0x88, 0x28, 0x0, 0xA0, 0x18, 0x0), 0x10 },
		{ new DeepPointer("UnityPlayer.dll", 0x1A8C3C0, 0xF0, 0xE8, 0x78, 0xC8, 0x30, 0x30, 0x48, 0xE0), 0x0 },
	};

	// -----------------------------------

	vars.list_Segments = new string[]
	{
		"Jungle", "Gears", "Pool", "Construction", "Cave", "Ice", "Ending"
	};
	
	vars.split_Flags = new bool[vars.list_Segments.Length];
	
	for (int i = 0; i < vars.split_Flags.Length; i++)
		vars.split_Flags[i] = true;

	vars.allowedToSplit = true;
	vars.finalPosition = new Vector3f(0, 0, 0);

	// -----------------------------------

	settings.Add("group_Splits", true, "Splits");
	settings.Add("split_Jungle", true, "Jungle", "group_Splits");
	settings.Add("split_Gears", true, "Gears", "group_Splits");
	settings.Add("split_Pool", true, "Pool", "group_Splits");
	settings.Add("split_Construction", true, "Construction", "group_Splits");
	settings.Add("split_Cave", true, "Cave", "group_Splits");
	settings.Add("split_Ice", true, "Ice", "group_Splits");
	settings.Add("split_Ending", true, "Ending", "group_Splits");

	settings.Add("group_Other", false, "Other");
	settings.Add("debug_All", false, "Log debug", "group_Other");
}

init
{
	vars.helperActive = false;
	vars.helperDelay = 2;
	vars.helperIterations = 8;
	vars.helperCounter = 0;
	vars.helperFinished = false;
	vars.helperCatchTime = DateTimeOffset.UtcNow.ToUnixTimeSeconds() + vars.helperDelay;
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => { vars.monoGlobal = mono; return true; });
}


update
{
	vars.pointersFound = false;

	if (!vars.helperFinished && vars.helperCatchTime <= DateTimeOffset.UtcNow.ToUnixTimeSeconds())
	{
		bool foundErrors = false;
		try { vars.classic = vars.monoGlobal["LiveSplitHelper", "LiveSplitHelper"]; }
		catch { foundErrors = true; }

		if (!foundErrors)
        {
			vars.helperFinished = true;
			vars.helperActive = true;
        }

		vars.helperCounter += 1;
		vars.helperCatchTime = DateTimeOffset.UtcNow.ToUnixTimeSeconds() + vars.helperDelay;
		if (vars.helperCounter == vars.helperIterations) vars.helperFinished = true;
	}

	if (vars.helperActive)
	{
		vars.Helper["leftHandGrabbed"] = vars.classic.Make<bool>("leftHandGrabbed");
		vars.Helper["rightHandGrabbed"] = vars.classic.Make<bool>("rightHandGrabbed");
		vars.Helper["position"] = vars.classic.MakeArray<float>("position");
		vars.helperFinished = true;
	}

	if (!vars.helperActive)
    {
		bool firstPassed = false;
		vars.passCounterHand = 0;
		vars.passCounterPosition = 0;

		foreach (KeyValuePair<DeepPointer, int> animControlPointer in vars.animControlPList)
		{
			ulong animControlInstance = animControlPointer.Key.Deref<ulong>(game) + (ulong)animControlPointer.Value;
			float leftStrength = new DeepPointer((IntPtr)animControlInstance + 0x20, 0x18, 0x18, 0x18, 0xC0).Deref<float>(game);

			if (leftStrength == 75f)
			{
				vars.finalLeftIsGrabbed = new DeepPointer((IntPtr)animControlInstance + 0x20, 0xA0, 0x34).Deref<int>(game);
				vars.finalRightIsGrabbed = new DeepPointer((IntPtr)animControlInstance + 0x18, 0xA0, 0x34).Deref<int>(game);
				vars.finalLeftStrength = new DeepPointer((IntPtr)animControlInstance + 0x20, 0xC0).Deref<float>(game);
				vars.finalLeftForce = new DeepPointer((IntPtr)animControlInstance + 0x20, 0xC8).Deref<ulong>(game);
				vars.finalLeftListen = new DeepPointer((IntPtr)animControlInstance + 0x20, 0xFC).Deref<bool>(game);
				firstPassed = true;
				break;
			}

			vars.passCounterHand += 1;
		}

		// -----------------------------------

		if (firstPassed)
        {
			foreach (KeyValuePair<DeepPointer, int> positionObjectPointer in vars.positionObjectPList)
			{
				ulong positionObject = positionObjectPointer.Key.Deref<ulong>(game) + (ulong)positionObjectPointer.Value;

				if (memory.ReadValue<float>((IntPtr)(positionObject + 0xE8)) == -0.5f)
				{
					vars.holderVector = memory.ReadValue<Vector3f>((IntPtr)(positionObject + 0xE0));

					// check if splitting should be disabled due to teleport
					float xDifference = Math.Abs(vars.holderVector.X - vars.finalPosition.X);
					float yDifference = Math.Abs(vars.holderVector.Y - vars.finalPosition.Y);

					if (xDifference > 5 || yDifference > 5) vars.allowedToSplit = false;

					// assign position
					vars.finalPosition = vars.holderVector;
					vars.pointersFound = true;
					break;
				}

				vars.passCounterPosition += 1;
			}
		}
	}

	// -----------------------------------

	if (settings["debug_All"])
    {
		string fullLog = "";
		if (vars.pointersFound)
		{
			fullLog = "---------------------" + "\n" +
			"handValidatedPointer: " + vars.passCounterHand + "\n" +
			"positionValidatedPointer: " + vars.passCounterPosition + "\n" +
			"finalLeftIsGrabbed: " + vars.finalLeftIsGrabbed + "\n" +
			"finalRightIsGrabbed: " + vars.finalRightIsGrabbed + "\n" +
			"finalLeftStrength: " + vars.finalLeftStrength + "\n" +
			"finalLeftForce: " + (vars.finalLeftForce > 0) + "\n" +
			"finalLeftListen: " + vars.finalLeftListen + "\n" +
			"finalPosition: " + vars.finalPosition + "\n" +
			"---------------------";
		}
		else fullLog = "---------------------" + "\n" +
				"validatedPointer: None" + "\n" +
				"---------------------";

		print(fullLog);
	}
}

start
{
	if (vars.pointersFound && !vars.helperActive)
    {
		bool grabbingSomething = (vars.finalLeftIsGrabbed == 1 || vars.finalLeftIsGrabbed == 2 || 
			vars.finalRightIsGrabbed == 1 || vars.finalRightIsGrabbed == 2);

		bool positionStartable = (vars.finalPosition.Y < 2f);
		bool inputsAllowed = vars.finalLeftListen;

		if (grabbingSomething && positionStartable && inputsAllowed)
        {
			for (int i = 0; i < vars.split_Flags.Length; i++)
				vars.split_Flags[i] = false;

			vars.allowedToSplit = true;
			return true;
		}
	}
	else if (vars.helperActive)
    {
		if (current.position[1] < 2f && (current.leftHandGrabbed || current.rightHandGrabbed))
		{
			for (int i = 0; i < vars.split_Flags.Length; i++)
				vars.split_Flags[i] = false; ;

			vars.allowedToSplit = true;
			return true;
		}
	}
}

reset
{
	if (vars.pointersFound && !vars.helperActive)
    {
		bool positionFlag = vars.finalPosition.Y < -3f;
		bool handFlag = (vars.finalLeftForce == 0 && !vars.finalLeftListen);

		return (positionFlag || handFlag);
	}
	else if (vars.helperActive) return current.position[1] < -3f;
}

split
{
	if (vars.allowedToSplit)
	{
		float posX = 0, posY = 0;
		bool goodToRead = false;

		if (vars.pointersFound && !vars.helperActive)
		{
			goodToRead = vars.finalPosition.Y < 260f;

			if (goodToRead)
			{
				posX = vars.finalPosition.X;
				posY = vars.finalPosition.Y;
			}
		}
		else if (vars.helperActive)
		{
			posX = current.position[0];
			posY = current.position[1];
		}

		if ((!vars.helperActive && goodToRead) || vars.helperActive)
		{
			if (settings["split_Jungle"] && !vars.split_Flags[0])
			{
				if (posY > 31f)
				{
					vars.split_Flags[0] = true;
					return true;
				}
			}

			if (settings["split_Gears"] && !vars.split_Flags[1])
			{
				if (posY > 55f && posX < 0f)
				{
					vars.split_Flags[1] = true;
					return true;
				}
			}

			if (settings["split_Pool"] && !vars.split_Flags[2])
			{
				if (posY > 80f && posY < 87f && posX > 8f)
				{
					vars.split_Flags[2] = true;
					return true;
				}
			}

			if (settings["split_Construction"] && !vars.split_Flags[3])
			{
				if (posY > 109f && posX < 20f)
				{
					vars.split_Flags[3] = true;
					return true;
				}
			}

			if (settings["split_Cave"] && !vars.split_Flags[4])
			{
				if (posY > 135f)
				{
					vars.split_Flags[4] = true;
					return true;
				}
			}

			if (settings["split_Ice"] && !vars.split_Flags[5])
			{
				if (posY > 152f)
				{
					vars.split_Flags[5] = true;
					return true;
				}
			}

			if (settings["split_Ending"] && !vars.split_Flags[6])
			{
				if (posY > 204f && posX < 47f)
				{
					vars.split_Flags[6] = true;
					return true;
				}
			}

			if (posY > 247f)
			{
				if (vars.pointersFound && !vars.helperActive) return (vars.finalLeftIsGrabbed == 0 && vars.finalRightIsGrabbed == 0);
				else if (vars.helperActive) return (!current.leftHandGrabbed && !current.rightHandGrabbed);
			}
		}
	}
}