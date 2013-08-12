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
UserVar BSRVD = 1000 "网络延迟"
Const CLTD = 500

Dim MainHwnd, pageHwnd, gameHwnd
Dim tmpSubHwnd

//主窗口
MainHwnd = Plugin.Window.Find("Chrome_WidgetWin_1", "朋友网（腾讯朋友） - 应用 - Google Chrome")
Call Plugin.Window.Size(MainHwnd, 1100, 700)
Delay CLTD

tmpSubHwnd = Plugin.Window.FindEx(MainHwnd, 0, "Chrome_WidgetWin_0", 0)
pageHwnd = Plugin.Window.FindEx(tmpSubHwnd, 0, "Chrome_RenderWidgetHostHWND", 0)
TracePrint pageHwnd

Dim times
times = 0

Rem start

//start
Call Plugin.Bkgnd.LeftClick(pageHwnd, 339, 500)
Delay BSRVD * 9

TracePrint "game loaded"

gameHwnd = getGameHwnd()
TracePrint gameHwnd

Call Plugin.Bkgnd.KeyPress(gameHwnd, 27)
Delay CLTD

Call Plugin.Bkgnd.KeyPress(gameHwnd, 67)
Delay CLTD

Call Plugin.Bkgnd.LeftClick(gameHwnd, 300, 101)
Delay CLTD

Call Plugin.Bkgnd.LeftClick(gameHwnd, 488, 352)
Delay CLTD

/*MoveTo 647, 278
MoveTo 827, 280
MoveTo 647, 367
MoveTo 828, 370
MoveTo 649, 457
MoveTo 826, 457*/

Call Plugin.Bkgnd.LeftClick(gameHwnd, 826, 457)
Delay CLTD

Call Plugin.Bkgnd.KeyPress(gameHwnd, 8)
Delay CLTD

Call Plugin.Bkgnd.SendString(gameHwnd, "1")
Delay CLTD

/*MoveTo 703, 280
MoveTo 893, 277
MoveTo 713, 365
MoveTo 892, 368
MoveTo 709, 455
MoveTo 885, 454*/

Call Plugin.Bkgnd.LeftClick(gameHwnd, 885, 454)
Delay CLTD

Call Plugin.Bkgnd.LeftClick(gameHwnd, 515,333)
Delay CLTD

Delay BSRVD

Call Plugin.Bkgnd.LeftClick(pageHwnd, 1069, 14)
Delay CLTD * 2

times = times + 1

TracePrint  times

Goto start

Function getGameHwnd()
	tmpSubHwnd = Plugin.Window.FindEx(pageHwnd, 0, "WrapperNativeWindowClass", 0)
	getGameHwnd = Plugin.Window.FindEx(tmpSubHwnd, 0, "NativeWindowClass", 0)
	TracePrint "获取Chrome game成功，句柄为：" & getGameHwnd	
End Function

Sub OnScriptExit()
	//Call Plugin.Web.Tips("script ends") 
End Sub 