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
MacroID=ae4c6bec-b566-4965-9ada-c632003f1898
Description=37CreateRole
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

/****用户配置。代表网络延迟基数，网络延迟越高，此项需配置得越大。****/
UserVar BSRVD = 1000 "网络延迟基数，默认1000。"
/****CLIENT_DELAY 客户端操作延迟****/
Const CLTD = 500

Const MAIN_WIN_WIDTH = 650
Const MAIN_WIN_HEIGHT = 710

Const LOGIN_CLICK_POS_X = 28
Const LOGIN_CLICK_POS_Y = 17

Const NAME_CLICK_POS_X = 281
Const NAME_CLICK_POS_Y = 536

Const BTN_CREATE_X = 278
Const BTN_CREATE_Y = 585

Const TAB_CLOSE_CLICK_POS_X = 381
Const TAB_CLOSE_CLICK_POS_Y = 27

Dim tmpSubHwnd

//主窗口不关闭，就不变(chrome tab不变LoginPageHwnd就不变)
Dim ChromeHwnd, LoginPageHwnd

//随tab变化而变化
Dim ChromeGameHwnd

Dim i

//获取Chrome主窗口
ChromeHwnd = Plugin.Window.Find("Chrome_WidgetWin_1", "entrance - Google Chrome")
TracePrint "获取Chrome主窗口成功，句柄为：" & ChromeHwnd	

//获取登录页面。可获取，此时登录页面tab必须激活。
tmpSubHwnd = Plugin.Window.FindEx(ChromeHwnd, 0, "Chrome_WidgetWin_0", 0)
LoginPageHwnd = Plugin.Window.FindEx(tmpSubHwnd, 0, "Chrome_RenderWidgetHostHWND", 0)
TracePrint "获取登录页面成功，句柄为：" & LoginPageHwnd	

Call Plugin.Window.Size(ChromeHwnd, MAIN_WIN_WIDTH, MAIN_WIN_HEIGHT)
Delay CLTD * 2
Call Plugin.Window.Move(ChromeHwnd, 0, 0)
Delay CLTD * 2
TracePrint "Chrome窗口大小、位置已重置。"

Rem go

//点击登录表单link，有网络延迟
Call Plugin.Bkgnd.LeftClick(LoginPageHwnd, LOGIN_CLICK_POS_X, LOGIN_CLICK_POS_Y)
//页面加载+登录ajax+跳转延迟
Delay BSRVD * 2
//角色模块加载延迟
Delay BSRVD * 7	

//进入游戏场景,获取【动态变化着】chrome游戏界面句柄
Call getChromeGameHwnd()

//点击人物名字输入框
Call Plugin.Bkgnd.LeftClick(ChromeGameHwnd, NAME_CLICK_POS_X, NAME_CLICK_POS_Y)
Delay CLTD

Dim num, nick
//清空随机种子数
Rem start
Randomize
//得到 1~999999999 之间的一个随机数
num = Int((999999999 * Rnd) + 1)
//判断这个数字是否8位数字，如果不是8位数字，就重新生成
If num<100000000 Then
    Goto start
End If 
nick = "s" & num

Call Plugin.Bkgnd.SendString(Hwnd, nick)
Delay CLTD * 2

//创建
Call Plugin.Bkgnd.LeftClick(ChromeGameHwnd, BTN_CREATE_X, BTN_CREATE_Y)
Delay BSRVD * 5

//关闭当前tab
Call Plugin.Bkgnd.LeftClick(ChromeHwnd, TAB_CLOSE_CLICK_POS_X, TAB_CLOSE_CLICK_POS_Y)
Delay CLTD

Goto go

Sub getChromeGameHwnd()
	//获取ChromeGameHwnd句柄
	tmpSubHwnd = Plugin.Window.FindEx(ChromeHwnd, 0, "Chrome_WidgetWin_0", 0)
	tmpSubHwnd = Plugin.Window.FindEx(tmpSubHwnd, 0, "Chrome_RenderWidgetHostHWND", 0)
	tmpSubHwnd = Plugin.Window.FindEx(tmpSubHwnd, 0, "WrapperNativeWindowClass", 0)
	ChromeGameHwnd = Plugin.Window.FindEx(tmpSubHwnd, 0, "NativeWindowClass", 0)
	TracePrint "获取Chrome game成功，句柄为：" & ChromeGameHwnd	
End Sub