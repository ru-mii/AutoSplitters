state("jarlson") { }

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    Assembly.Load(File.ReadAllBytes("Components/uhara8")).CreateInstance("Main");
	vars.Uhara.EnableDebug();

    vars.Helper.GameName = "Jarlson";
    vars.Helper.AlertGameTime();
}

onStart
{
    //print("has finished? " + current.hasFinished + "\nis playing? " + current.playing + "\nfull game time: " + current.igt);
}

init // huge thanks to ru-mii for writing this init action and for the uhara5 component
{
    vars.JitSave = vars.Uhara.CreateTool("Unity", "DotNet", "JitSave");
    IntPtr GameManagerScript = vars.JitSave.AddInst("GameManagerScript");
    vars.JitSave.ProcessQueue();
    
    vars.Helper["hasFinished"] = vars.Helper.Make<bool>(GameManagerScript, 0x31);
    vars.Helper["playing"] = vars.Helper.Make<bool>(GameManagerScript, 0x18, 0x2C);
    vars.Helper["igt"] = vars.Helper.Make<float>(GameManagerScript, 0x18, 0x1C);;
	
	vars.Helper.Update();
    vars.Helper.MapPointers();
}

gameTime
{
    return TimeSpan.FromSeconds(Math.Round(current.igt, 3));
}

start
{
    return !old.playing && current.playing || old.igt > current.igt;
}

reset
{
    return old.igt > current.igt || !current.playing;
}

split
{
    return !old.hasFinished && current.hasFinished;
}

update
{
    vars.Helper.Update();
    vars.Helper.MapPointers();
	
	print(current.igt.ToString());;
}

isLoading
{
    return true;
}