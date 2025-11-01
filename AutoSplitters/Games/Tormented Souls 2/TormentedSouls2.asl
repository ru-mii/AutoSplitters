﻿state("TormentedSouls2-Win64-Shipping"){}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
	vars.Uhara.AlertLoadless(); vars.Uhara.EnableDebug();
}

init
{
	vars.Uhara.FileLogger.Start("Components\\TS2_UHARA_LOG.txt");
	
	vars.Utils = vars.Uhara.CreateTool("UnrealEngine", "Utils");
	vars.Tool = vars.Uhara.CreateTool("UnrealEngine", "Events");
	
	// ---
	vars.Resolver.Watch<byte>("InputMap", vars.Utils.GEngine, 0x11F8, 0x510);
	vars.Resolver.Watch<byte>("StopGameTime", vars.Utils.GEngine, 0x11F8, 0x52B);
	vars.Resolver.Watch<ulong>("LoadChange", vars.Uhara.CodeHKFlag("4C8BC84C896424204D8BC7498BD6488BCFFFD3"));
	vars.Resolver.Watch<uint>("GWorldName", vars.Utils.GWorld, 0x18);
	vars.Resolver.WatchString("LevelName", ReadStringType.UTF16, vars.Utils.GEngine, 0x11F8, 0x250, 0x0);;
	
	// ---
	vars.StartAllowed = false;
	vars.NowLoading = false;
}

update
{
	vars.Uhara.Update();
	
	// ---
	if (current.LevelName != old.LevelName)
	{
		vars.Uhara.FileLogger.Log("LEVEL: " + current.LevelName);
		vars.Uhara.Log("LEVEL: " + current.LevelName);
	}
	
	// ---
	var world = vars.Utils.FNameToString(current.GWorldName);
	if (!string.IsNullOrEmpty(world) && world != "None")
		current.World = world;

	if (old.LevelName == "Opening_Cinematic_B")
		vars.StartAllowed = true;
	
	if (current.LoadChange != old.LoadChange && current.LoadChange != 0)
	{
		vars.NowLoading = true;
	}
	
	if (current.StopGameTime != old.StopGameTime && current.StopGameTime == 1)
	{
		vars.NowLoading = true;
	}
	
	if (current.InputMap != 0)
	{
		vars.NowLoading = false;
	}
}

onStart
{
	vars.NowLoading = false;
}

start
{
	if (vars.StartAllowed && current.InputMap > 0 && old.InputMap == 0 && current.LevelName == "Church_NunChamber_cinematic_night")
	{
		vars.StartAllowed = false;
		return true;
	}
}

isLoading
{
	return vars.NowLoading;
}

reset
{
	return current.LevelName != old.LevelName && current.LevelName == "Opening_Cinematic_B";
}