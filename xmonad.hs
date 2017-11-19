import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Layout.NoBorders
import XMonad.Config.Xfce
import XMonad.Layout.PerWorkspace

import qualified XMonad.StackSet as W
import qualified Data.Map as M

main = xmonad $ xfceConfig
        { focusFollowsMouse  = True
        , borderWidth        = 1
        , modMask            = mod4Mask
        , workspaces         = ["1","2","3","4","5","6","7","8","media"]
        , normalBorderColor  = "#dddddd"
        , focusedBorderColor = "#ff0000"
        , keys               = \c -> myKeys c `M.union` keys def c
        , manageHook         = manageDocks <+> myManageHook
        , layoutHook         = myLayout
        , logHook            = ewmhDesktopsLogHook
        , terminal           = "xfce4-terminal"
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
           ratio = toRational(2/(1+sqrt(5))::Double) -- golden cut
           delta = 3/100


myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "Xfce4-appfinder"  --> doFloat
    , className =? "Xfrun4"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]



myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((modMask,               xK_p     ), spawn "xfce4-appfinder") ]
    ++
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_F1 .. xK_F9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_plus, 0x1ec, 0x1b9] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
