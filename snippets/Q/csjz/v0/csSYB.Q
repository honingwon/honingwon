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
MacroID=3896a7ba-6774-43ad-9723-e07d6f824eb1
Description=csSYB
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
//漏号原因：
//1、退出登录策略有问题, 循环登录基本可以解决此问题，可以在帐号列表中填入多次帐号
//2、剔除未建角色的号
//3、无意义的寄售。解决办法：a，判断第一个格子是否有物品，没有物品再寄售。b，把所有格子填满，再运行程序

UserVar PRICE = 0 "商品上架价格"

Const BAG_KEY = 66
Const KEY_BACKSPACE = 8
Const KEY_ENTER = 13

Const MY_STORE_POS_X = 470
Const MY_STORE_POS_Y = 541

Const ITEM_POS_X = 413
Const ITEM_POS_Y = 143

Const ACCOUNT_FIELD_CLICK_POS_X = 349
Const ACCOUNT_FIELD_CLICK_POS_Y = 304

Const PRICE_FIELD_CLICK_POS_X = 343
Const PRICE_FIELD_CLICK_POS_Y = 334

Const CONFIRM_BUTTON_CLICK_POS_X = 276
Const CONFIRM_BUTTON_CLICK_POS_Y = 377

Const ENABLE_MY_STORE_CLICK_POS_X = 294
Const ENABLE_MY_STORE_CLICK_POS_Y = 516

Const CLOSE_BAG_CLICK_POS_X = 335
Const CLOSE_BAG_CLICK_POS_Y = 104

Const CLOSE_MY_STORE_CLICK_POS_X = 680
Const CLOSE_MY_STORE_CLICK_POS_Y = 106

Const LOGOUT_CLICK_POS_X = 94
Const LOGOUT_CLICK_POS_Y = 18

Const LOGIN_CLICK_POS_X = 28
Const LOGIN_CLICK_POS_Y = 17

Const CHROME_GAME_TAB_CLICK_POS_X = 285
Const CHROME_GAME_TAB_CLICK_POS_Y = 31

Const LOGIN_FORM_SUBMIT_CLICK_POS_X = 64
Const LOGIN_FORM_SUBMIT_CLICK_POS_Y = 34

Const CG_CLICK_POS_X = 442
Const CG_CLICK_POS_Y = 152

Const NAME_CLICK_POS_X = 70
Const NAME_CLICK_POS_Y = 476

Const PLAYER_MENU_CLICK_POS_X = 143
Const PLAYER_MENU_CLICK_POS_Y = 609

Const MY_STORE_ITEM_CLICK_POS_X = 32
Const MY_STORE_ITEM_CLICK_POS_Y = 126

Const BUY_CONFIRM_CLICK_POS_X = 258
Const BUY_CONFIRM_CLICK_POS_Y = 373

Const TAB_CLOSE_CLICK_POS_X = 381
Const TAB_CLOSE_CLICK_POS_Y = 27



//主窗口不关闭，就不变(chrome tab不变L,oginPageHwnd就不变)
Dim ChromeHwnd, LoginPageHwnd, IEHwnd, IEGameHwnd
//随tab变化而变化
Dim ChromeGameHwnd,LoginFormPageHwnd
Dim SubHwnd, Sub2Hwnd, Sub3Hwnd, Sub4Hwnd
Dim CGSubHwnd
Dim LSubHwnd, LFSubHwnd
Dim i

//获取Chrome主窗口
ChromeHwnd = Plugin.Window.Find("Chrome_WidgetWin_1", "entrance - Google Chrome")
TracePrint "获取Chrome主窗口成功，句柄为：" & ChromeHwnd	

//获取登录页面。可获取，此时登录页面tab必须激活。
LSubHwnd = Plugin.Window.FindEx(ChromeHwnd, 0, "Chrome_WidgetWin_0", 0)
LoginPageHwnd = Plugin.Window.FindEx(LSubHwnd, 0, "Chrome_RenderWidgetHostHWND", 0)
TracePrint "获取登录页面成功，句柄为：" & LoginPageHwnd	

//获取IE主窗口
IEHwnd = Plugin.Window.Find("IEFrame", "二次封测区 -- 创世九州 - Windows Internet Explorer")
TracePrint "获取IE主窗口成功，句柄为：" & IEHwnd

//获取IE game
SubHwnd = Plugin.Window.FindEx(IEHwnd, 0, "Frame Tab", 0)
Sub2Hwnd = Plugin.Window.FindEx(SubHwnd, 0, "TabWindowClass", 0)
Sub3Hwnd = Plugin.Window.FindEx(Sub2Hwnd, 0, "Shell DocObject View", 0)
Sub4Hwnd = Plugin.Window.FindEx(Sub3Hwnd, 0, "Internet Explorer_Server", 0)
IEGameHwnd = Plugin.Window.FindEx(Sub4Hwnd, 0, "MacromediaFlashPlayerActiveX", 0)
TracePrint "获取IE game成功，句柄为：" & IEGameHwnd

Call Plugin.Window.Size(ChromeHwnd, 650, 710)
Delay 1000
Call Plugin.Window.Move(ChromeHwnd, 710, 0)
Delay 1000
TracePrint "Chrome窗口大小、位置已重置。"
Call Plugin.Window.Size(IEHwnd, 700, 710)
Delay 1000
Call Plugin.Window.Move(IEHwnd, 0, 0)
Delay 1000
TracePrint "IE窗口大小、位置已重置。"

For 400

//退出登录，有网络延迟
Call Plugin.Bkgnd.LeftClick(LoginPageHwnd, LOGOUT_CLICK_POS_X, LOGOUT_CLICK_POS_Y)
Delay 500
Call Plugin.Bkgnd.LeftClick(LoginPageHwnd, LOGOUT_CLICK_POS_X, LOGOUT_CLICK_POS_Y)
Delay 500
Delay 1000

//点击登录表单link，有网络延迟（fuck，竟然在后台打开登录表单tab页）
Call Plugin.Bkgnd.LeftClick(LoginPageHwnd, LOGIN_CLICK_POS_X, LOGIN_CLICK_POS_Y)
Delay 1000

//确认切换到到登录表单tab页
Call Plugin.Bkgnd.LeftClick(ChromeHwnd, CHROME_GAME_TAB_CLICK_POS_X, CHROME_GAME_TAB_CLICK_POS_Y)
Delay 500

//获取【动态变化着】的登录表单页
Call getLoginFormPageHwnd()

//点击登录按钮登录，有网络延迟，
Call Plugin.Bkgnd.LeftClick(LoginFormPageHwnd, LOGIN_FORM_SUBMIT_CLICK_POS_X, LOGIN_FORM_SUBMIT_CLICK_POS_X)
Delay 1000

//等待页面跳转
Delay 500*2

//游戏资源加载时间很长，有网络延迟
Delay 10 * 1000

//进入游戏场景,获取【动态变化着】chrome游戏界面句柄
Call getChromeGameHwnd()

//快速点击鼠标左键，以求快速过掉动画,准备好购买的状态
For i = 0 To 70
	Call Plugin.Bkgnd.LeftClick(ChromeGameHwnd, CG_CLICK_POS_X, CG_CLICK_POS_Y)
	Delay 200
Next

//open my bag，有网络延迟
Call Plugin.Bkgnd.KeyPress(IEGameHwnd, BAG_KEY)
Delay 1000

//open my store ，有网络延迟
Call Plugin.Bkgnd.LeftClick(IEGameHwnd, MY_STORE_POS_X, MY_STORE_POS_Y)
Delay 1000

//售卖指定坐标物品一次，有网络延迟
Call SellItemFromPos(ITEM_POS_X, ITEM_POS_Y)
Delay 1000

//开店，有网络延迟
Call Plugin.Bkgnd.LeftClick(IEGameHwnd, ENABLE_MY_STORE_CLICK_POS_X, ENABLE_MY_STORE_CLICK_POS_Y)
Delay 2000

//按回车，键盘焦点自动转移到输入框
Call Plugin.Bkgnd.KeyPress(IEGameHwnd, KEY_ENTER)
Delay 500

//调整个人电脑输入法为中文才不会有问题
Call Plugin.Bkgnd.SendString(IEGameHwnd, ".")
Delay 500

//按回车发送说话内容,有网络延迟
Call Plugin.Bkgnd.KeyPress(IEGameHwnd, KEY_ENTER)
Delay 1000

//点击人物名字
Call Plugin.Bkgnd.LeftClick(ChromeGameHwnd, NAME_CLICK_POS_X, NAME_CLICK_POS_Y)
Delay 500

//点击人物商店link，有网络延迟
Call Plugin.Bkgnd.LeftClick(ChromeGameHwnd, PLAYER_MENU_CLICK_POS_X, PLAYER_MENU_CLICK_POS_Y)
Delay 1000

//双击购买物品
Call Plugin.Bkgnd.LeftClick(ChromeGameHwnd, MY_STORE_ITEM_CLICK_POS_X, MY_STORE_ITEM_CLICK_POS_Y)
Delay 20
Call Plugin.Bkgnd.LeftClick(ChromeGameHwnd, MY_STORE_ITEM_CLICK_POS_X, MY_STORE_ITEM_CLICK_POS_Y)
Delay 20
Call Plugin.Bkgnd.LeftClick(ChromeGameHwnd, MY_STORE_ITEM_CLICK_POS_X, MY_STORE_ITEM_CLICK_POS_Y)
Delay 20
Call Plugin.Bkgnd.LeftClick(ChromeGameHwnd, MY_STORE_ITEM_CLICK_POS_X, MY_STORE_ITEM_CLICK_POS_Y)
Delay 20
Call Plugin.Bkgnd.LeftClick(ChromeGameHwnd, MY_STORE_ITEM_CLICK_POS_X, MY_STORE_ITEM_CLICK_POS_Y)
Delay 20
Call Plugin.Bkgnd.LeftClick(ChromeGameHwnd, MY_STORE_ITEM_CLICK_POS_X, MY_STORE_ITEM_CLICK_POS_Y)
Delay 20

Delay 500

//确认购买，有网络延迟
Call Plugin.Bkgnd.LeftClick(ChromeGameHwnd, BUY_CONFIRM_CLICK_POS_X, BUY_CONFIRM_CLICK_POS_Y)
Delay 1000

//关闭当前tab
Call Plugin.Bkgnd.LeftClick(ChromeHwnd, TAB_CLOSE_CLICK_POS_X, TAB_CLOSE_CLICK_POS_Y)
Delay 500

//打烊
Call Plugin.Bkgnd.LeftClick(IEGameHwnd, ENABLE_MY_STORE_CLICK_POS_X, ENABLE_MY_STORE_CLICK_POS_Y)
Delay 2000

//关闭商店窗口
Call Plugin.Bkgnd.LeftClick(IEGameHwnd, CLOSE_MY_STORE_CLICK_POS_X, CLOSE_MY_STORE_CLICK_POS_Y)
Delay 500

//关闭背包
Call Plugin.Bkgnd.LeftClick(IEGameHwnd, CLOSE_BAG_CLICK_POS_X, CLOSE_BAG_CLICK_POS_Y)
Delay 500

Next

Sub SellItemFromPos(posX, posY)

	//move to the item and click it
	Call Plugin.Bkgnd.LeftClick(IEGameHwnd, posX, posY)
	Delay 500
	// to sell
	Call Plugin.Bkgnd.LeftClick(IEGameHwnd, posX + 66, posY)
	Delay 500
	
	//fill the account field
	Call Plugin.Bkgnd.LeftClick(IEGameHwnd, ACCOUNT_FIELD_CLICK_POS_X, ACCOUNT_FIELD_CLICK_POS_Y)
	Delay 500
	//delete three char
 	Call PressKeyRepeatedly(IEGameHwnd, KEY_BACKSPACE, 3, 200)	
	//enter account 1
	Call Plugin.Bkgnd.SendString(IEGameHwnd, "1")
	Delay 500
	
	//fill the price field
	Call Plugin.Bkgnd.LeftClick(IEGameHwnd, PRICE_FIELD_CLICK_POS_X, PRICE_FIELD_CLICK_POS_Y)
	Delay 500	
	//delete three char
 	Call PressKeyRepeatedly(IEGameHwnd, KEY_BACKSPACE, 3, 200) 	
	//enter price
	Call Plugin.Bkgnd.SendString(IEGameHwnd, PRICE)
	Delay 500
	
	//to confirm
	Call Plugin.Bkgnd.LeftClick(IEGameHwnd, CONFIRM_BUTTON_CLICK_POS_X, CONFIRM_BUTTON_CLICK_POS_y)
End Sub

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


