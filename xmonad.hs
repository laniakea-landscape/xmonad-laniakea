import XMonad
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import System.Exit
import System.Directory (getHomeDirectory)
import System.FilePath.Posix (joinPath)
import Graphics.X11.Xlib
import Graphics.X11.ExtraTypes.XF86
--import IO (Handle, hPutStrLn)
import qualified System.IO
import XMonad.Actions.CycleWS (nextScreen,prevScreen)
import Data.List

import XMonad.Config.Desktop

-- Prompts
import XMonad.Prompt
import XMonad.Prompt.Shell

-- Actions
import XMonad.Actions.MouseGestures
import XMonad.Actions.UpdatePointer
import XMonad.Actions.GridSelect
import XMonad.Actions.CycleWS

-- Utils
import XMonad.Util.Run (spawnPipe, safeSpawn)
import XMonad.Util.Loggers
import XMonad.Util.EZConfig
import XMonad.Util.Scratchpad
import XMonad.Util.NamedWindows

import qualified XMonad.StackSet as W
-- Hooks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.Place
import XMonad.Hooks.EwmhDesktops

-- Layouts
import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen
import XMonad.Layout.LayoutCombinators hiding ((|||))
import XMonad.Layout.Grid
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed

import Data.Ratio ((%))
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.Spacing
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Gaps
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName


defaults = desktopConfig {
    terminal		= "xterm"
  , workspaces		= myWorkSpaces
  , modMask		= mod4Mask
  , layoutHook		= myLayoutHook
  , manageHook          = myManageHook
  , startupHook		= myStartupHook
  , borderWidth		= 2
  , normalBorderColor	= "#303030"
  , focusedBorderColor	= "#A0A0A0"
  } `additionalKeys` myKeys

myKeys = [
    ((mod4Mask, xK_g), goToSelected defaultGSConfig)
  , ((mod4Mask, xK_s), spawnSelected defaultGSConfig ["vivaldi","idea","thunderbird","code","telegram-desktop"])
  , ((mod4Mask, xK_c), spawn "ps -eo pcpu,pid,user,args | sort -r | head -5 >> ~/cpu-report")
  , ((mod4Mask, xK_grave), nextWS)
  , ((0, xF86XK_AudioRaiseVolume), spawn "amixer -D pulse sset Master 3%+ && ~/.xmonad/getvolume.sh >> /tmp/.volume-pipe")
  , ((0, xF86XK_AudioLowerVolume), spawn "amixer -D pulse sset Master 3%- && ~/.xmonad/getvolume.sh >> /tmp/.volume-pipe")
  , ((0, xF86XK_AudioMute), spawn "amixer -D pulse sset Master toggle && ~/.xmonad/getvolume.sh >> /tmp/.volume-pipe")
  , ((0, xF86XK_MonBrightnessUp), spawn "xbacklight -inc 2")
  , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -dec 2")
  , ((0, xK_Print), spawn "(cd ~/pics/screenshots && scrot)")
  , ((shiftMask, xK_Print), spawn "(cd ~/pics/screenshots && scrot -s)")
  ]

myWorkSpaces :: [String]
myWorkSpaces = [
    "<action=`xdotool key Super_L+1`> |1| </action>"
  , "<action=`xdotool key Super_L+2`> |2| </action>"
  , "<action=`xdotool key Super_L+3`> |3| </action>"
  , "<action=`xdotool key Super_L+4`> |4| </action>"
  , "<action=`xdotool key Super_L+5`> |5| </action>"
  , "<action=`xdotool key Super_L+6`> |6| </action>"
  , "<action=`xdotool key Super_L+7`> |7| </action>"
  , "<action=`xdotool key Super_L+8`> |8| </action>"
  , "<action=`xdotool key Super_L+9`> |9| </action>"
  ]

-- tab theme default
myTabConfig = defaultTheme {
    activeColor         = "#666666"
  , activeBorderColor   = "#000000"
  , inactiveColor       = "#666666"
  , inactiveBorderColor = "#000000"
  , decoHeight          = 10
 }

xmobarTitleColor = "#FFB6B0"
xmobarCurrentWorkspaceColor = "#FFB6B0"
xmobarUrgentWorkspaceColor = "#45A5F5"
xmobarHiddenNoWindowsColor = "#A4A19F"

myStartupHook = do
  startupHook defaultConfig
  setWMName "LG3D"
  spawn "~/.xmonad/getvolume.sh >> /tmp/.volume-pipe"

myLayoutHook =
    avoidStruts $
    spacing 6 $
    toggleLayouts (noBorders Full) $ smartBorders $ 
    Grid ||| spiral (6/7) ||| tabbedAlways shrinkText defaultTheme

myManageHook = manageDocks <+> manageHook desktopConfig
 
data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)
instance UrgencyHook LibNotifyUrgencyHook where
    urgencyHook LibNotifyUrgencyHook w = do
        name     <- getName w
        safeSpawn "notify-send" [show name]

main = do
  xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobar.hs"
  xmonad $ docks $ withUrgencyHook LibNotifyUrgencyHook $ fullscreenSupport $ defaults {
            logHook =  dynamicLogWithPP $ defaultPP {
                ppOutput = System.IO.hPutStrLn xmproc
              , ppTitle = xmobarColor xmobarTitleColor "" . shorten 65
              , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor "" . wrap "" ""
              , ppUrgent = xmobarColor xmobarUrgentWorkspaceColor "" . wrap "" ""
              , ppHiddenNoWindows = xmobarColor xmobarHiddenNoWindowsColor {-"#7e7c7a"-} "" . wrap "" ""
              , ppSep = "   "
              , ppWsSep = ""
              , ppLayout  = (\ x -> case x of
                  "Spacing Grid"       	-> "[ Grid ]"
                  "Spacing Spiral"          -> "[Spiral]"
                  _                         -> x )
            }
        }
