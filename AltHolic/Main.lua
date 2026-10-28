------------------------------------------------------------------------------------------
-- Main file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
import "Homeopatix.AltHolic.Librarys";

------------------------------------------------------------------------------------------
-- Startup order matters: the information window must exist before the visibility flags
-- are reset, and the main window is then built exactly once with its final size.
------------------------------------------------------------------------------------------
CreateInfosWindow();
InitWindowsDatas();
UpdateMainWindow(true);
CreateBarWindow();
MiniMizedIconHandler();
UpdateMinimizedIcon();
InstallHudKeyListener();

-- Secondary windows are created lazily by their open/click handlers.
