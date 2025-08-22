state("Escape Simulator") { }

startup
{
    Assembly.Load(File.ReadAllBytes("Components/uhara6")).CreateInstance("Main");
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    // ...
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        var jit = vars.Uhara.CreateTool("UnityCS", "JitSave");

		jit.SetOuter("EscapeSimulator.Core", "");
        var gameClass = mono["EscapeSimulator.Core", "Game"];
        var gameInstance = jit.AddInst("Game");

        jit.ProcessQueue();

        vars.Helper["Time"] = vars.Helper.Make<float>(gameInstance, gameClass["timerCurrentTime"]);

        return true;
    });
}