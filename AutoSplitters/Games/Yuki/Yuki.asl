state("yumenikki-Win64-Shipping") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
    vars.Uhara.EnableDebug();
	
	dynamic[,] _settings =
	{
		{ "GRP_Splits", true, "Splits", null },
			{ "GRP_OnEnter", false, "On Enter", "GRP_Splits" },
				{ "GRP_IntroRoom1", false, "IntroRoom", "GRP_OnEnter" },
				{ "GRP_Exterior1", false, "Exterior", "GRP_OnEnter" },
				{ "GRP_Closet1", false, "Closet", "GRP_OnEnter" },
				{ "GRP_3F1", false, "3F", "GRP_OnEnter" },
				{ "GRP_Restrooms1", false, "Restrooms", "GRP_OnEnter" },
				{ "GRP_RPG1", false, "RPG", "GRP_OnEnter" },
				{ "GRP_ClassroomsTransition1", false, "ClassroomsTransition", "GRP_OnEnter" },
				{ "GRP_Classrooms1", false, "Classrooms", "GRP_OnEnter" },
				{ "GRP_TeachersRoom1", false, "TeachersRoom", "GRP_OnEnter" },
				{ "GRP_Nowhere1", false, "Nowhere", "GRP_OnEnter" },
				{ "GRP_SunsetCorridor1", false, "SunsetCorridor", "GRP_OnEnter" },
				{ "GRP_Garden1", false, "Garden", "GRP_OnEnter" },
				{ "GRP_Library1", false, "Library", "GRP_OnEnter" },
				{ "GRP_Ending_Hatred1", false, "Ending_Hatred", "GRP_OnEnter" },
				{ "GRP_Ending_Credits1", false, "Ending_Credits", "GRP_OnEnter" },
			{ "GRP_OnLeave", false, "On Leave", "GRP_Splits" },
				{ "GRP_IntroRoom2", false, "IntroRoom", "GRP_OnLeave" },
				{ "GRP_Exterior2", false, "Exterior", "GRP_OnLeave" },
				{ "GRP_Closet2", false, "Closet", "GRP_OnLeave" },
				{ "GRP_3F2", false, "3F", "GRP_OnLeave" },
				{ "GRP_Restrooms2", false, "Restrooms", "GRP_OnLeave" },
				{ "GRP_RPG2", false, "RPG", "GRP_OnLeave" },
				{ "GRP_ClassroomsTransition2", false, "ClassroomsTransition", "GRP_OnLeave" },
				{ "GRP_Classrooms2", false, "Classrooms", "GRP_OnLeave" },
				{ "GRP_TeachersRoom2", false, "TeachersRoom", "GRP_OnLeave" },
				{ "GRP_Nowhere2", false, "Nowhere", "GRP_OnLeave" },
				{ "GRP_SunsetCorridor2", false, "SunsetCorridor", "GRP_OnLeave" },
				{ "GRP_Garden2", false, "Garden", "GRP_OnLeave" },
				{ "GRP_Library2", false, "Library", "GRP_OnLeave" },
				{ "GRP_Ending_Hatred2", false, "Ending_Hatred", "GRP_OnLeave" },
				{ "GRP_Ending_Credits2", false, "Ending_Credits", "GRP_OnLeave" },
	};
	
	vars.Uhara.Settings.Create(_settings);
}

init
{
	vars.Utils = vars.Uhara.CreateTool("UnrealEngine", "Utils");
	vars.Resolver.Watch<uint>("WorldFName", vars.Utils.GWorld, 0x18);
}

update
{
	vars.Uhara.Update();
	
	string tempWorldName = vars.Utils.FNameToString(current.WorldFName);
	if (!string.IsNullOrEmpty(tempWorldName) && tempWorldName != "None")
		current.WorldName = tempWorldName;
	
	if (current.WorldName != old.WorldName)
	{
		string enter = "GRP_" + current.WorldName + "1";
		string leave = "GRP_" + old.WorldName + "2";
		
		return settings[enter] || settings[leave];
	}
}