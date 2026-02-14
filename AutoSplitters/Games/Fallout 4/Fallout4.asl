state("Fallout4") { }

startup
{
	Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");
    vars.Uhara.AlertLoadless();
}

init
{
	print("--------------------------");
	
	// IsLoadingScreen
	{
		print("## IsLoadingScreen");
		IntPtr scanResult = vars.Uhara.ScanSingle("FF 92 ?? ?? 00 00 48 8B C8 E8 ?? ?? ?? ?? 8B 84 24 ?? 00 00 00");
		if (scanResult == IntPtr.Zero) throw new Exception();
		else print(scanResult.ToString("1LSVXFXVB: " + scanResult.ToString("X")));
		
		byte[] opBytes = vars.Resolver.ReadBytes(scanResult, size: 0x1000);
		if (opBytes == null || opBytes.Length == 0) throw new Exception();
		else print("SZQFGRHS: " + opBytes.Length.ToString("X"));
		
		var instructions = vars.Uhara.Disassemble(opBytes, scanResult);
		if (instructions == null || instructions.Length == 0) throw new Exception();
		else print("PMSSQUOB: " + instructions.Length.ToString("X"));
		
		ulong dsAddress = 0;
		int dsInsLength = 0;
		foreach (var instr in instructions)
		{
			if (!instr.ToString().StartsWith("movzx")) continue;
			if (!instr.ToString().EndsWith("]")) continue;
			dsAddress = instr.Offset;
			dsInsLength = instr.Length;
			break;
		}
		if (dsAddress == 0 || dsInsLength == 0) throw new Exception();
		else print("UBTWWUHN: " + dsAddress.ToString("X") + " " + dsInsLength.ToString("X"));
		
		int relValue = vars.Resolver.Read<int>(dsAddress + (ulong)dsInsLength - 4);
		if (relValue == 0) throw new Exception();
		else print("JSQNBICB: " + relValue.ToString("X"));
		
		ulong finalResult = (ulong)((long)dsAddress + relValue + dsInsLength);
		if (finalResult == 0) throw new Exception();
		else print("ZUIWKRXA: " + finalResult.ToString("X"));
		
		vars.Resolver.Watch<bool>("IsLoadingScreen", finalResult);
	}
	
	print("--------------------------");
	
	// IsQuickLoading
	{
		print("## IsQuickLoading");
		IntPtr scanResult = vars.Uhara.ScanSingle("C6 05 ?? ?? ?? ?? 00 E8 ?? ?? ?? ?? 43");
		if (scanResult == IntPtr.Zero) throw new Exception();
		else print(scanResult.ToString("DCTTPREL: " + scanResult.ToString("X")));
		
		int relValue = vars.Resolver.Read<int>(scanResult + 2);
		if (relValue == 0) throw new Exception();
		else print("NPRCQJQU: " + relValue.ToString("X"));
		
		ulong finalResult = (ulong)((long)scanResult + relValue + 7);
		if (finalResult == 0) throw new Exception();
		else print("RCMKQMBJ: " + finalResult.ToString("X"));
		
		vars.Resolver.Watch<bool>("IsQuickLoading", finalResult);
	}
	
	print("--------------------------");
	
	// IsCellTransition
	{
		print("## IsCellTransition");
		IntPtr scanResult = vars.Uhara.ScanSingle("E8 ?? ?? ?? ?? 41 80 A6 ?? ?? ?? ?? FB ");
		if (scanResult == IntPtr.Zero) throw new Exception();
		else print("GINIBHYY: " + scanResult.ToString("X"));
		
		byte[] opBytes = vars.Resolver.ReadBytes(scanResult, size: 0x1000);
		if (opBytes == null || opBytes.Length == 0) throw new Exception();
		else print("FSGMKUZA: " + opBytes.Length.ToString("X"));
		
		var instructions = vars.Uhara.Disassemble(opBytes, scanResult);
		if (instructions == null || instructions.Length == 0) throw new Exception();
		else print("XYSODSVX: " + instructions.Length.ToString("X"));
		
		ulong dsAddress = 0;
		int dsInsLength = 0;
		foreach (var instr in instructions)
		{
			if (!instr.ToString().StartsWith("movzx eax, byte")) continue;
			if (!instr.ToString().EndsWith("]")) continue;
			dsAddress = instr.Offset;
			dsInsLength = instr.Length;
			break;
		}
		if (dsAddress == 0 || dsInsLength == 0) throw new Exception();
		else print("CNVQKYHT: " + dsAddress.ToString("X") + " " + dsInsLength.ToString("X"));
		
		int relValue = vars.Resolver.Read<int>(dsAddress + (ulong)dsInsLength - 4);
		if (relValue == 0) throw new Exception();
		else print("PQRJBHBR: " + relValue.ToString("X"));
		
		ulong finalResult = (ulong)((long)dsAddress + relValue + dsInsLength);
		if (finalResult == 0) throw new Exception();
		else print("SYHMCBBP: " + finalResult.ToString("X"));
		
		vars.Resolver.Watch<bool>("IsCellTransition", finalResult);
	}
	
	print("--------------------------");
	
	// IsWaiting
	{
		print("## IsWaiting");
		IntPtr scanResult = vars.Uhara.ScanSingle("EB 07 0F B6 05 ?? ?? ?? ?? 84 C0 75");
		if (scanResult == IntPtr.Zero) throw new Exception();
		else print(scanResult.ToString("ZCPTOMTX: " + scanResult.ToString("X")));
		
		scanResult += 2;
		int relValue = vars.Resolver.Read<int>(scanResult + 3);
		if (relValue == 0) throw new Exception();
		else print("SWYEYUNQ: " + relValue.ToString("X"));
		
		ulong finalResult = (ulong)((long)scanResult + relValue + 7);
		if (finalResult == 0) throw new Exception();
		else { finalResult -= 2; print("AJZLVWUX: " + finalResult.ToString("X")); }
		
		vars.Resolver.Watch<byte>("IsWaiting", finalResult);
	}
	
	print("--------------------------");
}

update
{
	vars.Uhara.Update();
	
	//print(current.IsLoadingScreen.ToString());
	//print(current.IsQuickLoading.ToString());
	//print(current.IsCellTransition.ToString());
	//print(current.IsWaiting.ToString());
}

onStart
{
	timer.IsGameTimePaused = false;
}

isLoading
{
	return
	current.IsLoadingScreen ||
	current.IsQuickLoading ||
	current.IsCellTransition ||
	current.IsWaiting == 68;
}

exit
{
	Time currTime = timer.CurrentTime;
	if (currTime.GameTime.HasValue && currTime.GameTime.Value.TotalMilliseconds > 0)
	{
		timer.IsGameTimePaused = true;
	}
}