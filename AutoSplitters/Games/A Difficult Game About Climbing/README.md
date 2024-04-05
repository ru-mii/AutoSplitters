
[LiveSplitHelper == OFF]

    AnimControl (INSTANCE) as animControlInstance (in .asl)

        vars.leftHandGrabbed        = AnimControl -> armLeft -> grabbedSurface -> isGrabbed (int)
        vars.rightHandGrabbed       = AnimControl -> armRight -> otherArm -> grabbedSurface -> isGrabbed (int)
        vars.leftHandStrength       = AnimControl -> armLeft -> strength (float)
        vars.leftHandForce          = AnimControl -> armLeft -> force (ulong)
        vars.leftHandListen         = AnimControl -> armLeft -> listenToInput (bool)

        How to find?
            
            AnimControl:Update+12(?)
            mov rcx,[rsi+18] -> AnimControl in RSI
            48 81 EC D0 00 00 00 48 89 75 F8 48 8B F1 48
            Check: image1.JPG

    Climber_Hero_Body_Prefab (?)as positionObject (in .asl)

        vars.finalPosition           = PlayerSpawner/Climber5(Clone)/Climber_Hero_Body_Prefab -> transform -> position

        How to find?
            AnimControl -> 0x10 -> 0x250 (Vector3), (should almost always be there)

------------------------------

[LiveSplitHelper == ON]

    Data exposed by a mod, for details check
    https://github.com/ru-mii/ADGAC-LiveSplitHelper/blob/main/LiveSplitHelper/LiveSplitHelper.cs