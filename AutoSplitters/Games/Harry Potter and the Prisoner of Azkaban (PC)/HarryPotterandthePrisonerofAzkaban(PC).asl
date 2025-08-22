state("hppoa")
{
	bool LoadingFlag: "Engine.dll", 0x04C660C, 0x740, 0x574;
}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/hppoa-lib")).CreateInstance("Main");
}

init
{
	IntPtr AlAudioDll = modules.Where(m => m.ModuleName.Equals("alaudio.dll",
		StringComparison.OrdinalIgnoreCase)).First().BaseAddress;
		
	IntPtr EngineDll = modules.Where(m => m.ModuleName.Equals("engine.dll",
		StringComparison.OrdinalIgnoreCase)).First().BaseAddress;
		
	IntPtr CoreDll = modules.Where(m => m.ModuleName.Equals("core.dll",
		StringComparison.OrdinalIgnoreCase)).First().BaseAddress;

	vars.Portfel.SetData(game, EngineDll, AlAudioDll, CoreDll);
	vars.Portfel.Initialize(variant: 3);

	IntPtr LoadState = vars.Portfel.GetLoadState();
	vars.Watchers = new Dictionary<string, MemoryWatcher>
    {
        { "LoadState", new MemoryWatcher<int>(new DeepPointer(LoadState)) }
    };
	
	vars.LoadingNow = false;
}

onReset
{
	vars.LoadingNow = false;
}

update
{
	foreach (var watcher in vars.Watchers.Values)
        watcher.Update(game);
		
	if (current.LoadingFlag) vars.LoadingNow = true;
	if (vars.Watchers["LoadState"].Current != vars.Watchers["LoadState"].Old)
		vars.LoadingNow = false;
}

start
{
	return current.LoadingFlag == true && old.LoadingFlag == false;
}

onStart
{
	timer.IsGameTimePaused = true;
}

isLoading
{
	return vars.LoadingNow;
}