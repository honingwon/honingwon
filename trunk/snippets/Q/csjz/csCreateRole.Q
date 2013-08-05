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
Description=createRole
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
//退出登录策略有问题, 循环登录基本可以解决此问题，可以在帐号列表中填入多次帐号

/****用户配置。代表网络延迟基数，网络延迟越高，此项需配置得越大。****/
UserVar BSRVD = 1000 "网络延迟基数，默认1000。"
/****CLIENT_DELAY 客户端操作延迟****/
Const CLTD = 500

Const MAIN_WIN_WIDTH = 650
Const MAIN_WIN_HEIGHT = 710

Const LOGOUT_CLICK_POS_X = 94
Const LOGOUT_CLICK_POS_Y = 18

Const LOGIN_CLICK_POS_X = 28
Const LOGIN_CLICK_POS_Y = 17

Const CHROME_GAME_TAB_CLICK_POS_X = 285
Const CHROME_GAME_TAB_CLICK_POS_Y = 31

Const LOGIN_FORM_SUBMIT_CLICK_POS_X = 64
Const LOGIN_FORM_SUBMIT_CLICK_POS_Y = 34

Const LOGIN_FORM_INPUT_X = 138
Const LOGIN_FORM_INPUT_Y = 8

Const NAME_CLICK_POS_X = 281
Const NAME_CLICK_POS_Y = 535

Const BTN_CREATE_X = 276
Const BTN_CREATE_Y = 585

Const TAB_CLOSE_CLICK_POS_X = 381
Const TAB_CLOSE_CLICK_POS_Y = 27

//主窗口不关闭，就不变(chrome tab不变LoginPageHwnd就不变)
Dim ChromeHwnd, LoginPageHwnd
Dim LSubHwnd

//随tab变化而变化
Dim ChromeGameHwnd,LoginFormPageHwnd
Dim CGSubHwnd, LFSubHwnd

Dim LoginAlertHwnd,GameAlertHwnd

Dim i

//获取Chrome主窗口
ChromeHwnd = Plugin.Window.Find("Chrome_WidgetWin_1", "entrance - Google Chrome")
TracePrint "获取Chrome主窗口成功，句柄为：" & ChromeHwnd	

//获取登录页面。可获取，此时登录页面tab必须激活。
LSubHwnd = Plugin.Window.FindEx(ChromeHwnd, 0, "Chrome_WidgetWin_0", 0)
LoginPageHwnd = Plugin.Window.FindEx(LSubHwnd, 0, "Chrome_RenderWidgetHostHWND", 0)
TracePrint "获取登录页面成功，句柄为：" & LoginPageHwnd	

Call Plugin.Window.Size(ChromeHwnd, MAIN_WIN_WIDTH, MAIN_WIN_HEIGHT)
Delay CLTD * 2
Call Plugin.Window.Move(ChromeHwnd, 0, 0)
Delay CLTD * 2
TracePrint "Chrome窗口大小、位置已重置。"

Rem go

//退出登录，有网络延迟
Call Plugin.Bkgnd.LeftClick(LoginPageHwnd, LOGOUT_CLICK_POS_X, LOGOUT_CLICK_POS_Y)
Delay CLTD
Call Plugin.Bkgnd.LeftClick(LoginPageHwnd, LOGOUT_CLICK_POS_X, LOGOUT_CLICK_POS_Y)
Delay CLTD
Delay BSRVD * 2
TracePrint "已退出登录"

//点击登录表单link，有网络延迟（fuck，竟然在后台打开登录表单tab页）
Call Plugin.Bkgnd.LeftClick(LoginPageHwnd, LOGIN_CLICK_POS_X, LOGIN_CLICK_POS_Y)
Delay BSRVD * 2
//确认切换到到登录表单tab页
Call Plugin.Bkgnd.LeftClick(ChromeHwnd, CHROME_GAME_TAB_CLICK_POS_X, CHROME_GAME_TAB_CLICK_POS_Y)
Delay CLTD
TracePrint "确认切换到到登录表单tab页"

//获取【动态变化着】的登录表单页
Call getLoginFormPageHwnd()

Dim GetColor
//如果没帐号了退出脚本
GetColor = Plugin.Bkgnd.GetPixelColor(LoginFormPageHwnd, 540, 5)
If GetColor = 000000 Then 
	TracePrint "has no acc left"
	EndScript
End If

//点击表单输入框
Call Plugin.Bkgnd.LeftClick(LoginFormPageHwnd, LOGIN_FORM_INPUT_X, LOGIN_FORM_INPUT_Y)
Delay CLTD

//LoginFormPageHwnd客户区左上角坐标分量
Dim offsetX,offsetY
Dim Rec,MyArray
Rec = Plugin.Window.GetClientRect(LoginFormPageHwnd)	
//下面这句用于分割字符串,将横坐标和纵坐标分成两个字符串
MyArray = Split(Rec, "|")
//下面这句将字符串转换成数值
offsetX = Clng(MyArray(0)) : offsetY = Clng(MyArray(1))

MoveTo LOGIN_FORM_INPUT_X + offsetX, LOGIN_FORM_INPUT_Y + offsetY
LeftDoubleClick 1

//ctrl+c
KeyDown "Ctrl", 1
Delay CLTD
KeyPress "C", 1
Delay CLTD
KeyUp "Ctrl", 1
Delay CLTD

//点击登录按钮登录，有网络延迟，
Call Plugin.Bkgnd.LeftClick(LoginFormPageHwnd, LOGIN_FORM_SUBMIT_CLICK_POS_X, LOGIN_FORM_SUBMIT_CLICK_POS_X)
Delay BSRVD

Call getLoginAlertHwnd()
//弹出密码错误框，密码错误就完蛋了，先用记事本记录帐号，再把帐号列表第一个帐号删除
//密码错误会是什么原因
If (LoginAlertHwnd > 0) Then 
	Call Plugin.Bkgnd.KeyPress(LoginAlertHwnd, 13)
	Delay CLTD
End If

TracePrint "等待页面跳转"
//等待页面跳转
Delay CLTD * 2

TracePrint "游戏资源加载时间很长，有网络延迟 BSRVD * 5"
//游戏资源加载时间很长，有网络延迟
Delay BSRVD * 5

Call getGameAlertHwnd()

//如果出现‘请从官网登录游戏’警告
If (GameAlertHwnd > 0) Then 
	Call Plugin.Bkgnd.KeyPress(GameAlertHwnd, 13)
	Delay CLTD
Else
	//进入游戏场景,获取【动态变化着】chrome游戏界面句柄
	Call getChromeGameHwnd()
	
	//点击人物名字输入框
	Call Plugin.Bkgnd.LeftClick(ChromeGameHwnd, NAME_CLICK_POS_X, NAME_CLICK_POS_Y)
	Delay CLTD
	
	//ctrl+v
	KeyDown "Ctrl", 1
	Delay CLTD
	KeyPress "V", 1
	Delay CLTD
	KeyUp "Ctrl", 1
	Delay CLTD
	
	//创建
	Call Plugin.Bkgnd.LeftClick(ChromeGameHwnd, BTN_CREATE_X, BTN_CREATE_Y)
	Delay BSRVD * 2
End If

//关闭当前tab
Call Plugin.Bkgnd.LeftClick(ChromeHwnd, TAB_CLOSE_CLICK_POS_X, TAB_CLOSE_CLICK_POS_Y)
Delay CLTD

Goto go

/*
* 指定句柄按下指定键指定的次数
* @param hwnd
* @param key
* @param times
* @param interval
*/
Sub PressKeyRepeatedly(hwnd, key, times, interval)
	For times
		Call Plugin.Bkgnd.KeyPress(hwnd, key)
		Delay interval
	Next
End Sub

Sub getChromeGameHwnd()
	//获取ChromeGameHwnd句柄
	CGSubHwnd = Plugin.Window.FindEx(ChromeHwnd, 0, "Chrome_WidgetWin_0", 0)
	CGSubHwnd = Plugin.Window.FindEx(CGSubHwnd, 0, "Chrome_RenderWidgetHostHWND", 0)
	CGSubHwnd = Plugin.Window.FindEx(CGSubHwnd, 0, "WrapperNativeWindowClass", 0)
	ChromeGameHwnd = Plugin.Window.FindEx(CGSubHwnd, 0, "NativeWindowClass", 0)
	TracePrint "获取Chrome game成功，句柄为：" & ChromeGameHwnd	
End Sub

Sub getLoginFormPageHwnd()
	//获取登录表单页
	LFSubHwnd = Plugin.Window.FindEx(ChromeHwnd, 0, "Chrome_WidgetWin_0", 0)
	LoginFormPageHwnd = Plugin.Window.FindEx(LFSubHwnd, 0, "Chrome_RenderWidgetHostHWND", 0)
	TracePrint "获取登录表单页成功，句柄为：" & LoginFormPageHwnd	
End Sub

Sub getLoginAlertHwnd()
	//获取登录警告
	LoginAlertHwnd = Plugin.Window.Find("Chrome_WidgetWin_1", "login.qule.com 上的网页显示：")
	TracePrint "获取登录警告成功，句柄为：" & LoginAlertHwnd	
End Sub

Sub getGameAlertHwnd()
	//获取登录操作后游戏警告
	GameAlertHwnd = Plugin.Window.Find("Chrome_WidgetWin_1", "9.qule.com 上的网页显示：")
	TracePrint "获取登录后游戏警告成功，句柄为：" & GameAlertHwnd	
End Sub