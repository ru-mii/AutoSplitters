state("A Difficult Game About Climbing") {}

startup
{
	refreshRate = 60;
	
	// -----------------------------------
	
	vars.leftHandGrabbed = new long[4];
	vars.rightHandGrabbed = new long[4];
	vars.leftHandStrength = new float[4];
	vars.leftHandForce = new long[4];
	vars.leftHandListen = new bool[4];
	
	vars.positionX = new float[3];
	vars.positionY = new float[3];
	vars.positionZ = new float[3];
	
	vars.indexHand = 0;
	vars.indexPosition = 0;
	
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

init {}

update
{
	vars.leftHandGrabbed[0] = new DeepPointer("mono-2.0-bdwgc.dll", 0x72B200, 0xE90, 0x1E0, 0xEC8).Deref<long>(game);
	vars.rightHandGrabbed[0] = new DeepPointer("mono-2.0-bdwgc.dll", 0x72B200, 0xE90, 0x1E0, 0x1008).Deref<long>(game);
	vars.leftHandStrength[0] = new DeepPointer("mono-2.0-bdwgc.dll", 0x72B200, 0xE90, 0x1E0, 0xEE8).Deref<float>(game);
	vars.leftHandForce[0] = new DeepPointer("mono-2.0-bdwgc.dll", 0x72B200, 0xE90, 0x1E0, 0xEF0).Deref<long>(game);
	vars.leftHandListen[0] = new DeepPointer("mono-2.0-bdwgc.dll", 0x72B200, 0xE90, 0x1E0, 0xF24).Deref<bool>(game);
	
	vars.positionX[0] = new DeepPointer("UnityPlayer.dll", 0x1B2ACB0, 0x20, 0x5E0, 0x28, 0x270, 0xC8, 0x4C, 0x20, 0x10, 0x20).Deref<float>(game);
	vars.positionY[0] = new DeepPointer("UnityPlayer.dll", 0x1B2ACB0, 0x20, 0x5E0, 0x28, 0x270, 0xC8, 0x4C, 0x20, 0x10, 0x24).Deref<float>(game);
	vars.positionZ[0] = new DeepPointer("UnityPlayer.dll", 0x1B2ACB0, 0x20, 0x5E0, 0x28, 0x270, 0xC8, 0x4C, 0x20, 0x10, 0x28).Deref<float>(game);
	
	// -----------------------------------
	
	vars.leftHandGrabbed[1] = new DeepPointer("UnityPlayer.dll", 0x1B15160, 0x8, 0x8, 0x28, 0x0, 0xB0, 0x60, 0x20, 0x98).Deref<long>(game);
	vars.rightHandGrabbed[1] = new DeepPointer("UnityPlayer.dll", 0x1B15160, 0x8, 0x8, 0x28, 0x0, 0xB0, 0x60, 0x20, 0x1D8).Deref<long>(game);
	vars.leftHandStrength[1] = new DeepPointer("UnityPlayer.dll", 0x1B15160, 0x8, 0x8, 0x28, 0x0, 0xB0, 0x60, 0x20, 0xB8).Deref<float>(game);
	vars.leftHandForce[1] = new DeepPointer("UnityPlayer.dll", 0x1B15160, 0x8, 0x8, 0x28, 0x0, 0xB0, 0x60, 0x20, 0xC0).Deref<long>(game);
	vars.leftHandListen[1] = new DeepPointer("UnityPlayer.dll", 0x1B15160, 0x8, 0x8, 0x28, 0x0, 0xB0, 0x60, 0x20, 0xF4).Deref<bool>(game);
	
	vars.positionX[1] = new DeepPointer("UnityPlayer.dll", 0x1AD8388, 0x0, 0x3A0, 0x8, 0x20, 0x0, 0x58, 0xE0).Deref<float>(game);
	vars.positionY[1] = new DeepPointer("UnityPlayer.dll", 0x1AD8388, 0x0, 0x3A0, 0x8, 0x20, 0x0, 0x58, 0xE4).Deref<float>(game);
	vars.positionZ[1] = new DeepPointer("UnityPlayer.dll", 0x1AD8388, 0x0, 0x3A0, 0x8, 0x20, 0x0, 0x58, 0xE8).Deref<float>(game);
	
	// -----------------------------------
	
	vars.leftHandGrabbed[2] = new DeepPointer("UnityPlayer.dll", 0x1B366B0, 0xD0, 0x8, 0x18, 0x48, 0x20, 0x98).Deref<long>(game);
	vars.rightHandGrabbed[2] = new DeepPointer("UnityPlayer.dll", 0x1B366B0, 0xD0, 0x8, 0x18, 0x48, 0x20, 0x1D8).Deref<long>(game);
	vars.leftHandStrength[2] = new DeepPointer("UnityPlayer.dll", 0x1B366B0, 0xD0, 0x8, 0x18, 0x48, 0x20, 0xB8).Deref<float>(game);
	vars.leftHandForce[2] = new DeepPointer("UnityPlayer.dll", 0x1B366B0, 0xD0, 0x8, 0x18, 0x48, 0x20, 0xC0).Deref<long>(game);
	vars.leftHandListen[2] = new DeepPointer("UnityPlayer.dll", 0x1B366B0, 0xD0, 0x8, 0x18, 0x48, 0x20, 0xF4).Deref<bool>(game);
	
	vars.positionX[2] = new DeepPointer("UnityPlayer.dll", 0x1A8C3C0, 0x328, 0x78, 0xC8, 0x30, 0x30, 0x48, 0xE0).Deref<float>(game);
	vars.positionY[2] = new DeepPointer("UnityPlayer.dll", 0x1A8C3C0, 0x328, 0x78, 0xC8, 0x30, 0x30, 0x48, 0xE4).Deref<float>(game);
	vars.positionZ[2] = new DeepPointer("UnityPlayer.dll", 0x1A8C3C0, 0x328, 0x78, 0xC8, 0x30, 0x30, 0x48, 0xE8).Deref<float>(game);
	
	// -----------------------------------
	
	vars.leftHandGrabbed[3] = new DeepPointer("mono-2.0-bdwgc.dll", 0x7280F8, 0xA0, 0xA98).Deref<long>(game);
	vars.rightHandGrabbed[3] = new DeepPointer("mono-2.0-bdwgc.dll", 0x7280F8, 0xA0, 0xBD8).Deref<long>(game);
	vars.leftHandStrength[3] = new DeepPointer("mono-2.0-bdwgc.dll", 0x7280F8, 0xA0, 0xAB8).Deref<float>(game);
	vars.leftHandForce[3] = new DeepPointer("mono-2.0-bdwgc.dll", 0x7280F8, 0xA0, 0xAC0).Deref<long>(game);
	vars.leftHandListen[3] = new DeepPointer("mono-2.0-bdwgc.dll", 0x7280F8, 0xA0, 0xAF4).Deref<bool>(game);
	
	// -----------------------------------
	
	for (int i = 0; i < 4; i++)
	{
		if (vars.leftHandStrength[i] == 75f)
		{
			vars.indexHand = i;
			break;
		}
	}
	
	for (int i = 0; i < 3; i++)
	{
		if (vars.positionZ[i] == -0.5f)
		{
			vars.indexPosition = i;
			break;
		}
	}
}

start
{
	bool grabbingSomething = (vars.leftHandGrabbed[vars.indexHand] != 0 || vars.rightHandGrabbed[vars.indexHand] != 0);
	bool positionStartable = !((vars.positionY[vars.indexPosition] > 2f && vars.positionZ[vars.indexPosition] == -0.5f));

	// -----------------------------------

	if (grabbingSomething && positionStartable)
	{
		for (int i = 0; i < vars.split_Flags.Length; i++)
		vars.split_Flags[i] = false;;
		
		return true;
	}
}

reset
{
	bool positionFlag = (vars.positionY[vars.indexPosition] == -4f);
	bool handFlag = (vars.leftHandStrength[vars.indexHand] == 75f && vars.leftHandForce[vars.indexHand] == 0 &&
		vars.leftHandListen[vars.indexHand] == 0);
	
	// -----------------------------------
	
	return (positionFlag || handFlag);
}

split
{
	if (settings["split_Jungle"] && !vars.split_Flags[0])
	{
		if (vars.positionY[vars.indexPosition] > 31f)
		{
			vars.split_Flags[0] = true;
			return true;
		}
	}
	
	if (settings["split_Gears"] && !vars.split_Flags[1])
	{
		if (vars.positionY[vars.indexPosition] > 55f && vars.positionX[vars.indexPosition] < 0f)
		{
			vars.split_Flags[1] = true;
			return true;
		}
	}
	
	if (settings["split_Pool"] && !vars.split_Flags[2])
	{
		if (vars.positionY[vars.indexPosition] > 80f && vars.positionY[vars.indexPosition] < 87f && vars.positionX[vars.indexPosition] > 8f)
		{
			vars.split_Flags[2] = true;
			return true;
		}
	}
	
	if (settings["split_Construction"] && !vars.split_Flags[3])
	{
		if (vars.positionY[vars.indexPosition] > 109f && vars.positionX[vars.indexPosition] < 20f)
		{
			vars.split_Flags[3] = true;
			return true;
		}
	}
	
	if (settings["split_Cave"] && !vars.split_Flags[4])
	{
		if (vars.positionY[vars.indexPosition] > 135f)
		{
			vars.split_Flags[4] = true;
			return true;
		}
	}
	
	if (settings["split_Ice"] && !vars.split_Flags[5])
	{
		if (vars.positionY[vars.indexPosition] > 152f)
		{
			vars.split_Flags[5] = true;
			return true;
		}
	}
	
	if (settings["split_Ending"] && !vars.split_Flags[6])
	{
		if (vars.positionY[vars.indexPosition] > 204f && vars.positionX[vars.indexPosition] < 47f)
		{
			vars.split_Flags[6] = true;
			return true;
		}
	}

	if (vars.positionY[vars.indexPosition] > 247f)
		return true;
}
