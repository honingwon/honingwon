[General]
SyntaxVersion=2
BeginHotkey=121
BeginHotkeyMod=0
PauseHotkey=0
PauseHotkeyMod=0
StopHotkey=123
StopHotkeyMod=0
RunOnce=1
EnableWindow=
MacroID=e2161f85-6091-4b37-bcd8-d111c7db2249
Description=ss
Enable=1
AutoRun=0
[Repeat]
Type=0
Number=1
[SetupUI]
Type=2
QUI=
[Relative]
SetupOCXFile=
[Comment]

[Script]
UserVar BSRVD = 1000 "ÍøÂçÑÓ³Ù"
Const CLTD = 500

Dim MainHwnd, iehwnd, gameHwnd
Dim SubHwnd

//IEÖ÷´°¿Ú
MainHwnd = Plugin.Window.Find("IEFrame", 0)
Call Plugin.Window.Size(MainHwnd, 1100, 800)
Delay CLTD
//»ñÈ¡game¾ä±ú
SubHwnd = Plugin.Window.FindEx(MainHwnd, 0, "Frame Tab", 0)
SubHwnd = Plugin.Window.FindEx(SubHwnd, 0, "TabWindowClass", 0)
SubHwnd = Plugin.Window.FindEx(SubHwnd, 0, "Shell DocObject View", 0)
iehwnd = Plugin.Window.FindEx(SubHwnd, 0, "Internet Explorer_Server", 0)
TracePrint iehwnd

Dim times
times = 0

Rem start

//start
Call Plugin.Bkgnd.LeftClick(iehwnd, 329, 492)
Delay BSRVD * 12

TracePrint "game loaded"

gameHwnd = getGameHwnd()
TracePrint gameHwnd

Call Plugin.Bkgnd.KeyPress(gameHwnd, 27)
Delay CLTD

Call Plugin.Bkgnd.KeyPress(gameHwnd, 67)
Delay CLTD

Call Plugin.Bkgnd.LeftClick(gameHwnd, 306,161)
Delay CLTD

Call Plugin.Bkgnd.LeftClick(gameHwnd, 486,409)
Delay CLTD

/*MoveTo 648, 340
MoveTo 829, 340
MoveTo 648, 428
MoveTo 829, 428*/

Call Plugin.Bkgnd.LeftClick(gameHwnd, 648, 340)
Delay CLTD

Call Plugin.Bkgnd.KeyPress(gameHwnd, 8)
Delay CLTD

Call Plugin.Bkgnd.SendString(gameHwnd, "11")
Delay CLTD

//MoveTo 715, 339
//MoveTo 891, 339
//MoveTo 713, 424
//MoveTo 885, 429

Call Plugin.Bkgnd.LeftClick(gameHwnd, 715, 339)
Delay CLTD

Call Plugin.Bkgnd.LeftClick(gameHwnd, 515,393)
Delay CLTD

Delay BSRVD

Call Plugin.Bkgnd.LeftClick(iehwnd, 1071,16)
Delay CLTD * 2

times = times + 1

TracePrint  times

Goto start


//Call Plugin.Web.Refresh(0)

Function getGameHwnd()
	getGameHwnd = Plugin.Window.FindEx(iehwnd, 0, "MacromediaFlashPlayerActiveX", 0)
End Function

Sub OnScriptExit()
	//Call Plugin.Web.Tips("script ends") 
End Sub 