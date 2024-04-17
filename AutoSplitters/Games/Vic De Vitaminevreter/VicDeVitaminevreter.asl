state("flashplayer_32_sa") { }

startup
{
    refreshRate = 60;
    settings.Add("group_Splits", true, "Splits");
    settings.Add("split_Level1", true, "Level 1", "group_Splits");
    settings.Add("split_Level2", true, "Level 2", "group_Splits");
    settings.Add("split_Level3", true, "Level 3", "group_Splits");
    settings.Add("split_Level4", true, "Level 4", "group_Splits");
    settings.Add("split_Level5", true, "Level 5", "group_Splits");

    vars.bState = 0;
    vars.State = 0;
    vars.Level = 0;
    vars.Dummy = 0;
}

init
{
    var scanner = new SignatureScanner(game, game.MainModule.BaseAddress, (int)game.MainModule.ModuleMemorySize);
    uint gameStateFunction = (uint)scanner.Scan(new SigScanTarget("83 C4 08 84 C0 ?? ?? DD 45 F8 83 EC 08 8B CE"));

    if (gameStateFunction != 0)
    {
        gameStateFunction += 0x0F;
        byte[] gutBytes = { 0xDD, 0x1C, 0x24, 0xFF, 0x75, 0x0C };
        byte[] foundBytes = memory.ReadBytes((IntPtr)gameStateFunction, gutBytes.Length);

        if (foundBytes.Length == gutBytes.Length)
        {
            if (gutBytes.SequenceEqual(foundBytes))
            {
                vars.Dummy = gameStateFunction;
                uint allocatedMemory = (uint)memory.AllocateMemory(0x200);

                if (allocatedMemory != 0)
                {
                    vars.StateAddress = allocatedMemory + 0x100;

                    byte[] s1 = { 0xE9 };
                    byte[] s2 = BitConverter.GetBytes(allocatedMemory - gameStateFunction - 5);
                    byte[] s3 = { 0x90 };
                    byte[] start = s1.Concat(s2).Concat(s3).ToArray();

                    byte[] e1 = { 0x89, 0x0D };
                    byte[] e2 = BitConverter.GetBytes((uint)vars.StateAddress);
                    byte[] e3 = gutBytes;
                    byte[] e4 = { 0xE9 };
                    byte[] e5 = BitConverter.GetBytes(gameStateFunction - 6 - allocatedMemory - 6 + gutBytes.Length - 5);
                    byte[] end = e1.Concat(e2).Concat(e3).Concat(e4).Concat(e5).ToArray();

                    memory.WriteBytes((IntPtr)allocatedMemory, end);
                    memory.WriteBytes((IntPtr)gameStateFunction, start);
                }
            }
            else if (foundBytes[0] == 0xE9 && foundBytes[5] == 0x90)
            {
                vars.Dummy = gameStateFunction;
                uint relative = memory.ReadValue<uint>((IntPtr)gameStateFunction + 1);
                vars.StateAddress = (gameStateFunction + relative + 5) + 0x100;
            }
        }
    }
}

update
{
    if (vars.bState != vars.State) vars.bState = vars.State;
    if (vars.StateAddress != 0)
    {
        uint resolvePointer = memory.ReadValue<uint>((IntPtr)(vars.StateAddress));
        if (resolvePointer != 0) vars.State = memory.ReadValue<uint>((IntPtr)(resolvePointer + 0xAC));
    }
}

start
{
    if (vars.State == 0 && vars.bState == 1)
    {
        vars.Level = 0;
        return true;
    }
}

reset
{
    return vars.State == 1 && vars.bState != 1;
}

split
{
    if ((vars.State != vars.bState) && vars.bState == 4)
    {
        if (vars.Level == 0 && settings["split_Level1"] ||
        vars.Level == 1 && settings["split_Level2"] ||
        vars.Level == 2 && settings["split_Level3"] ||
        vars.Level == 3 && settings["split_Level4"] ||
        vars.Level == 4 && settings["split_Level5"]
        && memory.ReadValue<byte>((IntPtr)vars.Dummy) != 0)
        {
            vars.Level += 1;
            return true;
        }
    }
}