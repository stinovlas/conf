import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageDocks (checkDock)
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Actions.CycleWS
import System.IO
import System.Exit
import XMonad.Config.Xfce
import XMonad.Layout.PerWorkspace
 
import qualified XMonad.StackSet as W
import qualified Data.Map as M

main = xmonad xfceConfig 
		{ focusFollowsMouse  = True
		, borderWidth        = 1
        , modMask            = mod4Mask
        , workspaces         = ["1","2","3","4","5","6","7","8","media"]
        , normalBorderColor  = "#dddddd"
        , focusedBorderColor = "#ff0000"
        , mouseBindings      = myMouseBindings
        , keys               = myKeys
        , manageHook         = myManageHook <+> manageHook defaultConfig
        , layoutHook         = myLayout
        , logHook    		 = ewmhDesktopsLogHook
		, terminal 			 = "xfce4-terminal"
		, startupHook        = ewmhDesktopsStartup >> setWMName "LG3D"
    	}


myLayout = onWorkspace "media" ( noBorders Full ) $ generalLayout

generalLayout = avoidStruts $ 
           smartBorders $ 
           usual
        where 
           usual = tiled ||| Mirror tiled ||| Full
           tiled = Tall nmaster delta ratio
           nmaster = 1 
           ratio = toRational(2/(1+sqrt(5))::Double) -- zlaty rez
           delta = 3/100


myManageHook = composeOne 
		[ checkDock -?> doIgnore
        , className =? "MPlayer"	-?> doFloat
        , className =? "mplayer2"	-?> doFloat
        , title =? "MaM: Bludiste"	-?> doFloat
        , className =? "sun-applet-Main" 	-?> doFloat
        , className =? "sun-applet-AppletViewer" 	-?> doFloat
    	]


myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w)) -- set the window to floating mode and move by dragging
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster)) -- raise the window to the top of the stack
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w)) -- set the window to floating mode and resize by dragging
    , ((modMask, button4), (\_ -> prevWS)) -- switch to previous workspace
    , ((modMask, button5), (\_ -> nextWS)) -- switch to next workspace
    ]


myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    -- launch a terminal
    [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    -- close focused window 
    , ((modMask .|. shiftMask, xK_c     ), kill)
     -- Rotate through the available layout algorithms
    , ((modMask,               xK_space ), sendMessage NextLayout)
    --  Reset the layouts on the current workspace to default
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    -- Resize viewed windows to the correct size
    , ((modMask,               xK_n     ), refresh)
    -- Move focus to the next window
    , ((modMask,               xK_Tab   ), windows W.focusDown)
    -- Move focus to the next window
    , ((modMask,               xK_j     ), windows W.focusDown)
    -- Move focus to the previous window
    , ((modMask,               xK_k     ), windows W.focusUp  )
    -- Move focus to the master window
    , ((modMask,               xK_m     ), windows W.focusMaster  )
    -- Swap the focused window and the master window
    , ((modMask,               xK_Return), windows W.swapMaster)
    -- Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  )
    -- Swap the focused window with the previous window
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    )
    -- Shrink the master area
    , ((modMask,               xK_h     ), sendMessage Shrink)
    -- Expand the master area
    , ((modMask,               xK_l     ), sendMessage Expand)
    -- Push window back into tiling
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink)
    -- Increment the number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1))
    -- Deincrement the number of windows in the master area
    , ((modMask              , xK_period), sendMessage (IncMasterN (-1)))
    -- Quit xmonad
    , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    -- Restart xmonad
    , ((modMask              , xK_q     ), restart "xmonad" True)
    -- Cycling WS
    , ((modMask              , xK_Left ), prevWS)
    , ((modMask              , xK_Right ), nextWS)
	, ((modMask              , xK_semicolon), spawn "amixer set PCM 1%-")
	, ((modMask              , xK_plus), spawn "amixer set PCM 1%+")
    {- , ((modMask .|. shiftMask, xK_Left ), shifToPrevWS)
    , ((modMask .|. shiftMask, xK_Right ), shiftToNextWS) -}
    ]
    ++
    [ ((m .|. modMask, k), (windows $ f i))
        | (i, k) <- zip (XMonad.workspaces conf) [xK_F1 .. xK_F9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)] ]

