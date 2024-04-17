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
                uint relative = memory.ReadValue<uint>((IntPtr)gameStateFunction + 1);
                vars.StateAddress = (gameStateFunction + relative + 5) + 0x100;
            }
        }
    }

    current.State = 0;
    current.Level = 0;
}

onStart
{
    current.State = 0;
    current.Level = 0;
}

update
{
    if (vars.StateAddress != 0)
    {
        uint resolvePointer = memory.ReadValue<uint>((IntPtr)(vars.StateAddress));
        if (resolvePointer != 0) current.State = memory.ReadValue<uint>((IntPtr)(resolvePointer + 0xAC));
    }
}

start
{
    if (current.State == 0 && old.State == 1) return true;
}

reset
{
    return current.State == 1 && old.State != 1;
}

split
{
    if (current.State == 0 && old.State == 4)
    {
        if (current.Level == 0 && settings["split_Level1"] ||
        current.Level == 1 && settings["split_Level2"] ||
        current.Level == 2 && settings["split_Level3"] || 
        current.Level == 3 && settings["split_Level4"] || 
        current.Level == 4 && settings["split_Level5"]
        && memory.ReadValue<byte>((IntPtr)vars.Dummy) != 0)
        {
            current.Level += 1;
            return true;
        }
    }
}