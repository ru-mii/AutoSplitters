state("A Difficult Game About Climbing") {}

startup
{
	refreshRate = 60;
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	
	// -----------------------------------
	
	vars.leftHandGrabbed = new long[4];
	vars.rightHandGrabbed = new long[4];
	vars.leftHandStrength = new float[4];
	vars.leftHandForce = new long[4];
	vars.leftHandListen = new bool[4];
	
	vars.positionX = new float[3];
	vars.positionY = new float[3];
	vars.positionZ = new float[3];
	
	vars.dxHand = 0;
	vars.dxPosition = 0;
	
	// -----------------------------------

	vars.list_Segments = new string[]
	{
		"Jungle", "Gears", "Pool", "Construction", "Cave", "Ice", "Ending"
	};
	
	vars.split_Flags = new bool[vars.list_Segments.Length];
	
	for (int i = 0; i < vars.split_Flags.Length; i++)
		vars.split_Flags[i] = true;

	// -----------------------------------

	settings.Add("group_Splits", true, "Splits");
	settings.Add("split_Jungle", true, "Jungle", "group_Splits");
	settings.Add("split_Gears", true, "Gears", "group_Splits");
	settings.Add("split_Pool", true, "Pool", "group_Splits");
	settings.Add("split_Construction", true, "Construction", "group_Splits");
	settings.Add("split_Cave", true, "Cave", "group_Splits");
	settings.Add("split_Ice", true, "Ice", "group_Splits");
	settings.Add("split_Ending", true, "Ending", "group_Splits");
}

init
{
	vars.position = new float[2]; vars.position[0] = 0; vars.position[1] = 0;

	vars.helperActive = false;
	vars.helperDelay = 8;
	vars.helperIterations = 1;
	vars.helperCounter = 0;
	vars.helperFinished = false;
	vars.helperCatchTime = DateTimeOffset.UtcNow.ToUnixTimeSeconds() + vars.helperDelay;
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {vars.monoGlobal = mono; return true; });
}

update
{
	if (!vars.helperFinished && vars.helperCatchTime <= DateTimeOffset.UtcNow.ToUnixTimeSeconds())
	{
		var bytes = "85 1E A7 85 C5 33 A3 AF 50 BC";
		vars.helperActive = vars.Helper.ScanPages(true, 0, bytes) != IntPtr.Zero;
		
		if (vars.helperActive)
		{
			var classic = vars.monoGlobal["LiveSplitHelper", "LiveSplitHelper"];
			vars.Helper["leftHandGrabbed"] = classic.Make<bool>("leftHandGrabbed");
			vars.Helper["rightHandGrabbed"] = classic.Make<bool>("rightHandGrabbed");
			vars.Helper["position"] = classic.MakeArray<float>("position");
			vars.helperFinished = true;
		}
		
		vars.helperCounter += 1;
		vars.helperCatchTime = DateTimeOffset.UtcNow.ToUnixTimeSeconds() + vars.helperDelay;
		if (vars.helperCounter == vars.helperIterations) vars.helperFinished = true;
	}
	
	if (!vars.helperActive)
	{
		vars.leftHandGrabbed[0] = new DeepPointer("mono-2.0-bdwgc.dll", 0x72B200, 0xE90, 0x1E0, 0xED0, 0x34).Deref<long>(game);
		vars.rightHandGrabbed[0] = new DeepPointer("mono-2.0-bdwgc.dll", 0x72B200, 0xE90, 0x1E0, 0x1020, 0x34).Deref<long>(game);
		vars.leftHandStrength[0] = new DeepPointer("mono-2.0-bdwgc.dll", 0x72B200, 0xE90, 0x1E0, 0xEF0).Deref<float>(game);
		vars.leftHandForce[0] = new DeepPointer("mono-2.0-bdwgc.dll", 0x72B200, 0xE90, 0x1E0, 0xEF8).Deref<long>(game);
		vars.leftHandListen[0] = new DeepPointer("mono-2.0-bdwgc.dll", 0x72B200, 0xE90, 0x1E0, 0xF2C).Deref<bool>(game);
		
		vars.positionX[0] = new DeepPointer("UnityPlayer.dll", 0x1B2ACB0, 0x20, 0x5E0, 0x28, 0x270, 0xC8, 0x4C, 0x20, 0x10, 0x20).Deref<float>(game);
		vars.positionY[0] = new DeepPointer("UnityPlayer.dll", 0x1B2ACB0, 0x20, 0x5E0, 0x28, 0x270, 0xC8, 0x4C, 0x20, 0x10, 0x24).Deref<float>(game);
		vars.positionZ[0] = new DeepPointer("UnityPlayer.dll", 0x1B2ACB0, 0x20, 0x5E0, 0x28, 0x270, 0xC8, 0x4C, 0x20, 0x10, 0x28).Deref<float>(game);
		
		// -----------------------------------
		
		vars.leftHandGrabbed[1] = new DeepPointer("UnityPlayer.dll", 0x1B15160, 0x8, 0x8, 0x28, 0x0, 0xB0, 0x60, 0x20, 0xA0, 0x34).Deref<long>(game);
		vars.rightHandGrabbed[1] = new DeepPointer("UnityPlayer.dll", 0x1B15160, 0x8, 0x8, 0x28, 0x0, 0xB0, 0x60, 0x20, 0x1F0, 0x34).Deref<long>(game);
		vars.leftHandStrength[1] = new DeepPointer("UnityPlayer.dll", 0x1B15160, 0x8, 0x8, 0x28, 0x0, 0xB0, 0x60, 0x20, 0xC0).Deref<float>(game);
		vars.leftHandForce[1] = new DeepPointer("UnityPlayer.dll", 0x1B15160, 0x8, 0x8, 0x28, 0x0, 0xB0, 0x60, 0x20, 0xC8).Deref<long>(game);
		vars.leftHandListen[1] = new DeepPointer("UnityPlayer.dll", 0x1B15160, 0x8, 0x8, 0x28, 0x0, 0xB0, 0x60, 0x20, 0xFC).Deref<bool>(game);
		
		vars.positionX[1] = new DeepPointer("UnityPlayer.dll", 0x1AD8388, 0x0, 0x3A0, 0x8, 0x20, 0x0, 0x58, 0xE0).Deref<float>(game);
		vars.positionY[1] = new DeepPointer("UnityPlayer.dll", 0x1AD8388, 0x0, 0x3A0, 0x8, 0x20, 0x0, 0x58, 0xE4).Deref<float>(game);
		vars.positionZ[1] = new DeepPointer("UnityPlayer.dll", 0x1AD8388, 0x0, 0x3A0, 0x8, 0x20, 0x0, 0x58, 0xE8).Deref<float>(game);
		
		// -----------------------------------
		
		vars.leftHandGrabbed[2] = new DeepPointer("UnityPlayer.dll", 0x1B366B0, 0xD0, 0x8, 0x18, 0x48, 0x20, 0xA0, 0x34).Deref<long>(game);
		vars.rightHandGrabbed[2] = new DeepPointer("UnityPlayer.dll", 0x1B366B0, 0xD0, 0x8, 0x18, 0x48, 0x20, 0x1F0, 0x34).Deref<long>(game);
		vars.leftHandStrength[2] = new DeepPointer("UnityPlayer.dll", 0x1B366B0, 0xD0, 0x8, 0x18, 0x48, 0x20, 0xC0).Deref<float>(game);
		vars.leftHandForce[2] = new DeepPointer("UnityPlayer.dll", 0x1B366B0, 0xD0, 0x8, 0x18, 0x48, 0x20, 0xC8).Deref<long>(game);
		vars.leftHandListen[2] = new DeepPointer("UnityPlayer.dll", 0x1B366B0, 0xD0, 0x8, 0x18, 0x48, 0x20, 0xFC).Deref<bool>(game);
		
		vars.positionX[2] = new DeepPointer("UnityPlayer.dll", 0x1A8C3C0, 0x328, 0x78, 0xC8, 0x30, 0x30, 0x48, 0xE0).Deref<float>(game);
		vars.positionY[2] = new DeepPointer("UnityPlayer.dll", 0x1A8C3C0, 0x328, 0x78, 0xC8, 0x30, 0x30, 0x48, 0xE4).Deref<float>(game);
		vars.positionZ[2] = new DeepPointer("UnityPlayer.dll", 0x1A8C3C0, 0x328, 0x78, 0xC8, 0x30, 0x30, 0x48, 0xE8).Deref<float>(game);
		
		// -----------------------------------
		
		vars.leftHandGrabbed[3] = new DeepPointer("mono-2.0-bdwgc.dll", 0x7280F8, 0xA0, 0xAA0, 0x34).Deref<long>(game);
		vars.rightHandGrabbed[3] = new DeepPointer("mono-2.0-bdwgc.dll", 0x7280F8, 0xA0, 0xBF0, 0x34).Deref<long>(game);
		vars.leftHandStrength[3] = new DeepPointer("mono-2.0-bdwgc.dll", 0x7280F8, 0xA0, 0xAC0).Deref<float>(game);
		vars.leftHandForce[3] = new DeepPointer("mono-2.0-bdwgc.dll", 0x7280F8, 0xA0, 0xAC8).Deref<long>(game);
		vars.leftHandListen[3] = new DeepPointer("mono-2.0-bdwgc.dll", 0x7280F8, 0xA0, 0xAFC).Deref<bool>(game);
		
		// -----------------------------------
		
		vars.dxHand = -1;
		for (int i = 0; i < 4; i++)
		{
			if (vars.leftHandStrength[i] == 75f)
			{
				vars.dxHand = i;
				break;
			}
		}
		
		vars.dxPosition = -1;
		for (int i = 0; i < 3; i++)
		{
			if (vars.positionZ[i] == -0.5f)
			{
				vars.dxPosition = i;
				break;
			}
		}
	}
}

start
{
	if (!vars.helperActive)
	{
		if (vars.dxHand != -1 && vars.dxPosition != -1)
		{
			bool grabbingSomething = (vars.leftHandGrabbed[vars.dxHand] == 1 || vars.rightHandGrabbed[vars.dxHand] == 1);
			bool positionStartable = !((vars.positionY[vars.dxPosition] > 2f && vars.positionZ[vars.dxPosition] == -0.5f));
			bool inputsAllowed = vars.leftHandListen[vars.dxHand];

			// -----------------------------------

			if (grabbingSomething && positionStartable && inputsAllowed)
			{
				for (int i = 0; i < vars.split_Flags.Length; i++)
				vars.split_Flags[i] = false;;
				
				return true;
			}
		}
	}
	else
	{
		if (current.position[1] < 2f && (current.leftHandGrabbed || current.rightHandGrabbed))
		{
			for (int i = 0; i < vars.split_Flags.Length; i++)
				vars.split_Flags[i] = false;;
				
			return true;
		}
	}
}

reset
{
	if (!vars.helperActive)
	{
		if (vars.dxHand != -1 && vars.dxPosition != -1)
		{
			bool positionFlag = (vars.positionY[vars.dxPosition] == -4f);
			bool handFlag = (vars.leftHandForce[vars.dxHand] == 0 && !vars.leftHandListen[vars.dxHand]);
			
			// -----------------------------------
			
			return (positionFlag || handFlag);
		}
	}
	else return current.position[1] < -3f;
}

split
{
	float posX = 0, posY = 0;
	bool goodToRead = false;

	if (!vars.helperActive)
	{
		goodToRead = (vars.dxHand != -1 && vars.dxPosition != -1 && vars.positionY[vars.dxHand] < 260f);
		if (goodToRead)
		{
			posX = vars.positionX[vars.dxPosition];
			posY = vars.positionY[vars.dxPosition];
		}
	}
	else
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
			if (!vars.helperActive) return (vars.leftHandGrabbed[vars.dxHand] == 0 && vars.rightHandGrabbed[vars.dxHand] == 0);
			else return (!current.leftHandGrabbed && !current.rightHandGrabbed);
		}
	}
}
