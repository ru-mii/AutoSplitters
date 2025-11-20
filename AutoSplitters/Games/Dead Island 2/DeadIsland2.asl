state("DeadIsland-Win64-Shipping") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
    vars.Uhara.EnableDebug(); vars.Uhara.AlertLoadless();
}

init
{
	vars.Uhara.SetProcess(game);
    vars.Events = vars.Uhara.CreateTool("UnrealEngine", "Events");
	
	// ---
	vars.Resolver.WatchString("ActiveMission", vars.Events.FunctionParentPtr("BP_DIMissionSystemManager_C", "BP_DIMissionSystemManager_C", ""), 0xE8, 0x0, 0x78, 0x28, 0x28, 0x0);
	
	IntPtr questTotalOffsetFunc = vars.Uhara.ScanSingle("48 89 5C 24 08 48 89 7C 24 10 8B 41 ?? 41 0F B6 F8");
	if (questTotalOffsetFunc == IntPtr.Zero) throw new Exception("Couldn't find quests offset");
	int questTotalOffset = vars.Resolver.Read<byte>(questTotalOffsetFunc + 12);
	if (questTotalOffset < 0x30) throw new Exception("Quest offset read failed");
	
	vars.Resolver.Watch<int>("QuestTotal", vars.Events.InstancePtr("QuestStatsTrackerRuntimeState", "QuestStatsTrackerRuntimeState"), questTotalOffset);
	vars.Resolver.Watch<int>("Loading", vars.Events.InstancePtr("TextChatTutorialHelper", "TextChatTutorialHelper"), 0x68);
	vars.Resolver.Watch<int>("InCutscene", vars.Events.InstancePtr("InputMapperActionFilterInstance", "ActionFilterInstance_Cutscene"), 0x48);
}

update
{
	vars.Uhara.Update();
}

start
{
	return
	current.QuestTotal == 0 &&
	current.InCutscene != old.InCutscene && current.InCutscene == 0 &&
	!string.IsNullOrEmpty(current.ActiveMission) && current.ActiveMission == "MQ01 (WIP) DEATH FLIGHT 71";
}

isLoading
{
    return current.Loading == 0 || current.InCutscene == 1 || current.InCutscene == 2;
}

split
{
    return current.QuestTotal == old.QuestTotal + 1;
}

exit
{
	timer.IsGameTimePaused = true;
}