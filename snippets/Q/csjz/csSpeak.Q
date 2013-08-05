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
MacroID=3d9f0549-8b80-4a50-a2ad-12d2e19797ff
Description=csSpeak
Enable=0
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
//todo
//1、这样算出的次数是不对的，因为喊话不是瞬间完成
//2、增加分段喊话

UserVar WORD = "大家好!" "内容"
UserVar INTERVAL = 60 "间隔时间（单位：秒）"
UserVar DURATION = 600 "持续时间（单位：分钟）"


Const MAIN_WIN_WIDTH = 900
Const MAIN_WIN_HEIGHT = 700

Const KEY_ENTER = 13

Const CENTER_CLICK_POS_X = 433
Const CENTER_CLICK_POS_Y = 287

Dim MainHwnd, SubHwnd, Sub2Hwnd, Sub3Hwnd, Sub4Hwnd, Hwnd
Dim times
Dim i

MainHwnd = Plugin.Window.Find("IEFrame", 0)
Call Plugin.Window.Size(MainHwnd, MAIN_WIN_WIDTH, MAIN_WIN_HEIGHT)
Delay 1000
TracePrint "main window resized!"

SubHwnd = Plugin.Window.FindEx(MainHwnd, 0, "Frame Tab", 0)
Sub2Hwnd = Plugin.Window.FindEx(SubHwnd, 0, "TabWindowClass", 0)
Sub3Hwnd = Plugin.Window.FindEx(Sub2Hwnd, 0, "Shell DocObject View", 0)
Sub4Hwnd = Plugin.Window.FindEx(Sub3Hwnd, 0, "Internet Explorer_Server", 0)
Hwnd = Plugin.Window.FindEx(Sub4Hwnd, 0, "MacromediaFlashPlayerActiveX", 0)
TracePrint "game Hwnd:" & Hwnd
If Hwnd = 0 Then 
	ExitScript
End If

times = Fix(DURATION * 60 / INTERVAL)
TracePrint "即将喊话" & times & "次"

For i = 1 To times
	TracePrint "准备第" & i & "次喊话：" & WORD
	SpeakOnce (INTERVAL)
Next

Sub SpeakOnce(intervalSeconds)
	//按回车，键盘焦点自动转移到输入框
	Call Plugin.Bkgnd.KeyPress(Hwnd, KEY_ENTER)
	Delay 1000
	//调整个人电脑输入法为中文才不会有问题
	Call Plugin.Bkgnd.SendString(Hwnd, "哪位朋友有用不着的一转装备,借我用用")
	Delay 1000
	//按回车发送说话内容
	Call Plugin.Bkgnd.KeyPress(Hwnd, KEY_ENTER)
	Delay 500
	//转移键盘焦点到别处
	Call Plugin.Bkgnd.LeftClick(Hwnd, CENTER_CLICK_POS_X, CENTER_CLICK_POS_Y)
	
	Delay 10000
	
	//按回车，键盘焦点自动转移到输入框
	Call Plugin.Bkgnd.KeyPress(Hwnd, KEY_ENTER)
	Delay 1000
	//调整个人电脑输入法为中文才不会有问题
	Call Plugin.Bkgnd.SendString(Hwnd, "朋友们帮帮忙。有偿的啦，5万元")
	Delay 1000
	//按回车发送说话内容
	Call Plugin.Bkgnd.KeyPress(Hwnd, KEY_ENTER)
	Delay 500
	//转移键盘焦点到别处
	Call Plugin.Bkgnd.LeftClick(Hwnd, CENTER_CLICK_POS_X, CENTER_CLICK_POS_Y)
	
	Delay 10000
	
	//按回车，键盘焦点自动转移到输入框
	Call Plugin.Bkgnd.KeyPress(Hwnd, KEY_ENTER)
	Delay 1000
	//调整个人电脑输入法为中文才不会有问题
	Call Plugin.Bkgnd.SendString(Hwnd, "宝起价。有的私聊我。")
	Delay 1000
	//按回车发送说话内容
	Call Plugin.Bkgnd.KeyPress(Hwnd, KEY_ENTER)
	Delay 500
	//转移键盘焦点到别处
	Call Plugin.Bkgnd.LeftClick(Hwnd, CENTER_CLICK_POS_X, CENTER_CLICK_POS_Y)
	
	Delay 10000
	
	//按回车，键盘焦点自动转移到输入框
	Call Plugin.Bkgnd.KeyPress(Hwnd, KEY_ENTER)
	Delay 1000
	//调整个人电脑输入法为中文才不会有问题
	Call Plugin.Bkgnd.SendString(Hwnd, "若人不在，加QQ2879170569。")
	Delay 1000
	//按回车发送说话内容
	Call Plugin.Bkgnd.KeyPress(Hwnd, KEY_ENTER)
	Delay 500
	//转移键盘焦点到别处
	Call Plugin.Bkgnd.LeftClick(Hwnd, CENTER_CLICK_POS_X, CENTER_CLICK_POS_Y)
	
	TracePrint "一次喊话结束"
	Delay 1000 * intervalSeconds
End Sub



