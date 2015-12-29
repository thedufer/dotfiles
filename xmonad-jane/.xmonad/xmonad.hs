-- Warnings generated from compiling this module will be written to
-- ~/.xmonad/xmonad.errors.
{-# OPTIONS -Wall #-}

import Control.Applicative
import Control.Monad
import Data.Time (getCurrentTime)
import Network.BSD (getHostName)
import System.Directory (doesFileExist, getHomeDirectory)
import System.IO (hPutStrLn)
import System.Posix.User (getGroups, getGroupEntryForName, getRealUserID, groupID)

import XMonad
import XMonad.Hooks.DynamicLog (PP (..), dynamicLogWithPP, xmobarPP)
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks (avoidStruts)
import XMonad.Layout.GridVariants (SplitGrid (..), Orientation (..))
import XMonad.Layout.Named (named)
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.Tabbed (tabbed, shrinkText, defaultTheme)
import XMonad.Prompt (defaultXPConfig)
import XMonad.Prompt.Shell (shellPrompt)
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Run (safeSpawn, spawnPipe)

terminalCommand :: String
terminalCommand = "gnome-terminal"

customBindings :: String -> [(String, X ())]
customBindings uidHostname =
  [ ("M-p", shellPrompt defaultXPConfig)
  , ("M-z", spawn "gnome-screensaver-command -l")
  , ("M-S-\\", sshUidBox uidHostname)
  ]

main :: IO ()
main = do
  uidHostname <- getUIDHostname
  spawn "gnome-screensaver"
  displayHelp
  xmobar <- spawnPipe "xmobar"
  (xmonad . ewmh . (`additionalKeysP` customBindings uidHostname)) defaultConfig
    { layoutHook = (avoidStruts . smartBorders) customLayoutHook
    , logHook = dynamicLogWithPP xmobarPP { ppOutput = hPutStrLn xmobar }
    , modMask = mod4Mask
    , terminal = terminalCommand
    }
  where
    customLayoutHook
      =   named "Split Grid T"
          (SplitGrid T masterRows slaveRows masterRatio aspect increment)
      ||| named "Split Grid L"
          (SplitGrid L masterRows slaveRows masterRatio aspect increment)
      ||| named "Tabbed"
          (tabbed shrinkText defaultTheme)
      where
        masterRows = 1
        slaveRows = 1
        masterRatio = 5/8
        aspect = realToFrac $ (1 + sqrt 5 :: Double) / 2
        increment = 1/20

checkIsIntern :: IO Bool
checkIsIntern = do
  internGroupID <- groupID <$> getGroupEntryForName "interns"
  elem internGroupID <$> getGroups

getUIDHostname :: IO String
getUIDHostname =
  concat <$> sequence [getOffice, pure "-qws-", getPrefix, getUid, pure "a"]
  where
    getOffice = do
      workstationLocation <- takeWhile (/= '-') <$> getHostName
      return $!
        if workstationLocation == "nyc"
        then "igm"
        else workstationLocation
    getPrefix = do
      isIntern <- checkIsIntern
      return $! if isIntern then "i" else "u"
    getUid = show <$> getRealUserID

-- Given a hostname, create an SSH session there, starting in the user's local directory.
sshUidBox :: String -> X ()
sshUidBox hostname =
  safeSpawn terminalCommand
  [ "-e"
  , unwords ["ssh -tC", hostname, "'cd /usr/local/home/$(whoami); bash -l'"]
  ]

-- If this is the first time the user has run xmonad (there is no last-run file), open a
-- reference page for them. Bump the last-run file.
displayHelp :: IO ()
displayHelp = do
  runFile <- (++ "/.xmonad/last-run") <$> getHomeDirectory
  hasBeenRunBefore <- doesFileExist runFile
  isIntern <- checkIsIntern
  let url | isIntern = "http://intern.web/docs/programming/xmonad.html"
          | otherwise = "http://docs/programming/xmonad.html"
  unless hasBeenRunBefore $
    safeSpawn "google-chrome" [url]
  writeFile runFile . unlines . pure . show =<< getCurrentTime
