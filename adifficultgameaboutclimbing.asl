state("A Difficult Game About Climbing")
{
	long leftHandGrabbedSurface : "mono-2.0-bdwgc.dll", 0x7280F8, 0xA0, 0xA98;
	long rightHandGrabbedSurface : "mono-2.0-bdwgc.dll", 0x7280F8, 0xA0, 0xBD8;
	
	bool listenToInput : "mono-2.0-bdwgc.dll", 0x7280F8, 0xA0, 0xAF4;
	float positionX : "UnityPlayer.dll", 0x1B2ACB0, 0x20, 0x5E0, 0x28, 0x270, 0xC8, 0x4C, 0x20, 0x10, 0x20;
	float positionY : "UnityPlayer.dll", 0x1B2ACB0, 0x20, 0x5E0, 0x28, 0x270, 0xC8, 0x4C, 0x20, 0x10, 0x24;
}

startup
{
	refreshRate = 60;
	vars.currSplit = 0;

	vars.list_Segments = new string[]
	{
		"Jungle", "Gears", "Pool", "Construction", "Cave", "Ice", "Credits"
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
	settings.Add("split_Credits", true, "Credits", "group_Splits");
}

init {}

start
{
	if ((old.leftHandGrabbedSurface == 0 && current.leftHandGrabbedSurface != 0) ||
	(old.rightHandGrabbedSurface == 0 && current.rightHandGrabbedSurface != 0) &&
	current.positionY < 2f)
	{
		for (int i = 0; i < vars.split_Flags.Length; i++)
		vars.split_Flags[i] = false;
		
		return true;
	}
}

reset
{
	return (!current.listenToInput && current.positionY < -3f);
}

split
{
	if (settings["split_Jungle"] && !vars.split_Flags[0])
	{
		if (current.positionY > 31f)
		{
			vars.split_Flags[0] = true;
			return true;
		}
	}
	
	if (settings["split_Gears"] && !vars.split_Flags[1])
	{
		if (current.positionY > 55f && current.positionX < 0f)
		{
			vars.split_Flags[1] = true;
			return true;
		}
	}
	
	if (settings["split_Pool"] && !vars.split_Flags[2])
	{
		if (current.positionY > 80f && current.positionY < 87f && current.positionX > 8f)
		{
			vars.split_Flags[2] = true;
			return true;
		}
	}
	
	if (settings["split_Construction"] && !vars.split_Flags[3])
	{
		if (current.positionY > 109f && current.positionX < 20f)
		{
			vars.split_Flags[3] = true;
			return true;
		}
	}
	
	if (settings["split_Cave"] && !vars.split_Flags[4])
	{
		if (current.positionY > 135f)
		{
			vars.split_Flags[4] = true;
			return true;
		}
	}
	
	if (settings["split_Ice"] && !vars.split_Flags[5])
	{
		if (current.positionY > 152f)
		{
			vars.split_Flags[5] = true;
			return true;
		}
	}
	
	if (settings["split_Credits"] && !vars.split_Flags[6])
	{
		if (current.positionY > 204f && current.positionX < 47f)
		{
			vars.split_Flags[6] = true;
			return true;
		}
	}

	return (current.positionY > 245f);
}
