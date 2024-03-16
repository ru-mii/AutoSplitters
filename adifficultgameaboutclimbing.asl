state("A Difficult Game About Climbing")
{
	long leftHand1_GrabbedSurface  : "mono-2.0-bdwgc.dll", 0x72B200, 0xE90, 0x1E0, 0xEC8;
	long rightHand1_GrabbedSurface  : "mono-2.0-bdwgc.dll", 0x72B200, 0xE90, 0x1E0, 0x1008;
	float leftHand1_Strength  : "mono-2.0-bdwgc.dll", 0x72B200, 0xE90, 0x1E0, 0xEE8;
	
	float position1_X : "UnityPlayer.dll", 0x1B2ACB0, 0x20, 0x5E0, 0x28, 0x270, 0xC8, 0x4C, 0x20, 0x10, 0x20;
	float position1_Y : "UnityPlayer.dll", 0x1B2ACB0, 0x20, 0x5E0, 0x28, 0x270, 0xC8, 0x4C, 0x20, 0x10, 0x24;
	float position1_Z : "UnityPlayer.dll", 0x1B2ACB0, 0x20, 0x5E0, 0x28, 0x270, 0xC8, 0x4C, 0x20, 0x10, 0x28;
	
	// -----------------------------------
	
	long leftHand2_GrabbedSurface  : "UnityPlayer.dll", 0x1B15160, 0x8, 0x8, 0x28, 0x0, 0xB0, 0x60, 0x20, 0x98;
	long rightHand2_GrabbedSurface  : "UnityPlayer.dll", 0x1B15160, 0x8, 0x8, 0x28, 0x0, 0xB0, 0x60, 0x20, 0x1D8;
	float leftHand2_Strength  : "UnityPlayer.dll", 0x1B15160, 0x8, 0x8, 0x28, 0x0, 0xB0, 0x60, 0x20, 0xB8;
	
	float position2_X : "UnityPlayer.dll", 0x1B1B068, 0x48, 0x370, 0x70, 0x1D0, 0x48;
	float position2_Y : "UnityPlayer.dll", 0x1B1B068, 0x48, 0x370, 0x70, 0x1D0, 0x4C;
	float position2_Z : "UnityPlayer.dll", 0x1B1B068, 0x48, 0x370, 0x70, 0x1D0, 0x50;
	
	// -----------------------------------
	
	float position3_X : "mono-2.0-bdwgc.dll", 0x7280F8, 0xA0, 0xA88, 0x30, 0x10, 0xE0;
	float position3_Y : "mono-2.0-bdwgc.dll", 0x7280F8, 0xA0, 0xA88, 0x30, 0x10, 0xE4;
	float position3_Z : "mono-2.0-bdwgc.dll", 0x7280F8, 0xA0, 0xA88, 0x30, 0x10, 0xE8;
}

startup
{
	refreshRate = 60;

	vars.list_Segments = new string[]
	{
		"Jungle", "Gears", "Pool", "Construction", "Cave", "Ice", "Ending"
	};
	
	vars.split_Flags = new bool[vars.list_Segments.Length];
	
	for (int i = 0; i < vars.split_Flags.Length; i++)
		vars.split_Flags[i] = true;

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

start
{
	bool hand1_GrabbedSomething = ((old.leftHand1_GrabbedSurface == 0 && current.leftHand1_GrabbedSurface != 0) ||
	(old.rightHand1_GrabbedSurface == 0 && current.rightHand1_GrabbedSurface != 0)) && current.leftHand1_Strength == 75f;
	
	bool hand2_GrabbedSomething = ((old.leftHand2_GrabbedSurface == 0 && current.leftHand2_GrabbedSurface != 0) ||
	(old.rightHand2_GrabbedSurface == 0 && current.rightHand2_GrabbedSurface != 0)) && current.leftHand2_Strength == 75f;
	
	bool hand_GrabbedSomething = (hand1_GrabbedSomething || hand2_GrabbedSomething);
	
	// -----------------------------------
	
	bool positionStartable = !((current.position1_Y > 2f && current.position1_Z == -0.5f) ||
	(current.position2_Y > 2f && current.position2_Z == -0.5f));

	// -----------------------------------

	if (hand_GrabbedSomething && positionStartable)
	{
		for (int i = 0; i < vars.split_Flags.Length; i++)
		vars.split_Flags[i] = false;
		
		return true;
	}
}

reset
{
	bool position1_Resetable = (current.position1_Y == -4f && current.position1_Z == -0.5f);
	bool position2_Resetable = (current.position2_Y == -4f && current.position2_Z == -0.5f);
	bool position_Resetable = (position1_Resetable || position2_Resetable);

	return position_Resetable;
}

split
{
	float positionX = 0, positionY = 0;
	if (current.position3_Z == -0.5f)
	{
	positionX = current.position3_X;
	positionY = current.position3_Y;
	}

	// -----------------------------------
	
	if (settings["split_Jungle"] && !vars.split_Flags[0])
	{
		if (positionY > 31f)
		{
			vars.split_Flags[0] = true;
			return true;
		}
	}
	
	if (settings["split_Gears"] && !vars.split_Flags[1])
	{
		if (positionY > 55f && positionX < 0f)
		{
			vars.split_Flags[1] = true;
			return true;
		}
	}
	
	if (settings["split_Pool"] && !vars.split_Flags[2])
	{
		if (positionY > 80f && positionY < 87f && positionX > 8f)
		{
			vars.split_Flags[2] = true;
			return true;
		}
	}
	
	if (settings["split_Construction"] && !vars.split_Flags[3])
	{
		if (positionY > 109f && positionX < 20f)
		{
			vars.split_Flags[3] = true;
			return true;
		}
	}
	
	if (settings["split_Cave"] && !vars.split_Flags[4])
	{
		if (positionY > 135f)
		{
			vars.split_Flags[4] = true;
			return true;
		}
	}
	
	if (settings["split_Ice"] && !vars.split_Flags[5])
	{
		if (positionY > 152f)
		{
			vars.split_Flags[5] = true;
			return true;
		}
	}
	
	if (settings["split_Ending"] && !vars.split_Flags[6])
	{
		if (positionY > 204f && positionX < 47f)
		{
			vars.split_Flags[6] = true;
			return true;
		}
	}

	if (positionY > 247f)
		return true;
}
