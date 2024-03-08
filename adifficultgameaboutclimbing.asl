state("A Difficult Game About Climbing")
{
	long leftHandGrabbedSurface : "mono-2.0-bdwgc.dll", 0x7280F8, 0xA0, 0xA98;
	long rightHandGrabbedSurface : "mono-2.0-bdwgc.dll", 0x7280F8, 0xA0, 0xBD8;
	
	bool listenToInput : "mono-2.0-bdwgc.dll", 0x7280F8, 0xA0, 0xAF4;
	float positionY : "UnityPlayer.dll", 0x1B2ACB0, 0x20, 0x5E0, 0x28, 0x270, 0xC8, 0x4C, 0x20, 0x10, 0x24;
}

init {}

start
{
	return ((old.leftHandGrabbedSurface == 0 && current.leftHandGrabbedSurface != 0) ||
	(old.rightHandGrabbedSurface == 0 && current.rightHandGrabbedSurface != 0));
}

reset
{
	return (!current.listenToInput && current.positionY < -3f);
}

split
{
	return (current.positionY >= 246f);
}
