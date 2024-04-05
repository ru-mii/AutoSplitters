
[LiveSplitHelper == OFF]

    AnimControl (INSTANCE) as animControlInstance (in .asl)

        vars.leftHandGrabbed        = AnimControl -> armLeft -> grabbedSurface -> isGrabbed (int)
        vars.rightHandGrabbed       = AnimControl -> armRight -> otherArm -> grabbedSurface -> isGrabbed (int)
        vars.leftHandStrength       = AnimControl -> armLeft -> strength (float)
        vars.leftHandForce          = AnimControl -> armLeft -> force (ulong)
        vars.leftHandListen         = AnimControl -> armLeft -> listenToInput (bool)
        vars.positionX              = AnimControl -> m_CachedPtr -> position -> x (float)
        vars.positionY              = AnimControl -> m_CachedPtr -> position -> y (float)
        vars.positionZ              = AnimControl -> m_CachedPtr -> position -> z (float)

        How to find AnimControl (INSTANCE)?
            
            AnimControl:Update+12(?)
            mov rcx,[rsi+18] -> AnimControl in RSI
            48 81 EC D0 00 00 00 48 89 75 F8 48 8B F1 48
            Check: image1.JPG

------------------------------

[LiveSplitHelper == ON]

    Data exposed by a mod, for details check
    https://github.com/ru-mii/ADGAC-LiveSplitHelper/blob/main/LiveSplitHelper/LiveSplitHelper.cs