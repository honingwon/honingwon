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
MacroID=b9e19817-0fc9-4357-b907-b37232a6bbc1
Description=myLib
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
/****用户配置。代表网络延迟基数，网络延迟越高，此项需配置得越大。****/
UserVar BSRVD = 1000 "网络延迟基数，默认1000。"

/****CLIENT_DELAY 客户端操作延迟****/
Const CLTD = 500

/****游戏元素常量，游戏更新版本时需检查****/
//====背包模块====
//背包格子行数和列数
Const BAG_ROW_AMOUNT = 9
Const BAG_COL_AMOUNT = 6
//背包格子尺寸
Const CELL_WIDTH = 48
Const CELL_HEIGHT = 48
//背包选项卡高度
Const BAG_TAB_HEIGHT = 58

/****处理配置错误****/
//例子：
//If FromBagIndex > BagAmount Then 
//    MessageBox "起始包裹序号不能大于包裹个数"
//    ExitScript
//End If

/****变量声明****/
//用于循环
Dim i, j, k

/**** APP ****/
Const MAIN_WIN_WIDTH = 900
Const MAIN_WIN_HEIGHT = 700

Dim MainHwnd,Hwnd
Dim SubHwnd, Sub2Hwnd, Sub3Hwnd, Sub4Hwnd
//获取IE主窗口，并重置其尺寸
MainHwnd = Plugin.Window.Find("IEFrame", 0)
Call Plugin.Window.Size(MainHwnd, MAIN_WIN_WIDTH, MAIN_WIN_HEIGHT)
Delay CLTD
//获取IE game句柄
SubHwnd = Plugin.Window.FindEx(MainHwnd, 0, "Frame Tab", 0)
Sub2Hwnd = Plugin.Window.FindEx(SubHwnd, 0, "TabWindowClass", 0)
Sub3Hwnd = Plugin.Window.FindEx(Sub2Hwnd, 0, "Shell DocObject View", 0)
Sub4Hwnd = Plugin.Window.FindEx(Sub3Hwnd, 0, "Internet Explorer_Server", 0)
Hwnd = Plugin.Window.FindEx(Sub4Hwnd, 0, "MacromediaFlashPlayerActiveX", 0)
TracePrint "获取IE game成功，句柄为：" & Hwnd
If Hwnd = 0 Then 
    ExitScript
End If
