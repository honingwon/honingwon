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
MacroID=42c41d07-2c0c-4aaa-8d29-4bbc7f8ba1e9
Description=checkEvent
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

[Attachment]
UEsDBBQAAgAIADhIEEOvEGPnvQAAAPgAAAAPABEAZnJpZW5kQWxlcnQuYm1wVVQNAAdY6g1SqdANUqHQDVJz8v3BAAFmQKwBxBxQzMggARY/BMRC3BAMAwbRc60SZgGRT+mWhL6joY07gCJ8ugUW2WvcS9Z7V+8LaTqa2Hs+vvUQUByInMt3ARFEMHP2LSAJ1AgkE6ddhqDiRXeBCCgC1Fu99C5QZd6i+0CVdWteAxGQUTj7BlBc3KsXKN63++uU/d8haPXl/2kzz8hHzfJu2tu29TUQTdv7fuO1H1MPf1Fyq29e/8Qgdbl79VagdiAbKGucNlPEsYaBAQBQSwMEFAACAAgArkgQQ1xjREyaAAAA+AAAAA4AEQBza2lsbEFsZXJ0LmJtcFVUDQAHQ+sNUiHPDVIhzw1Sc/L9wQABZkCsAcQcUMzIIAEWPwTEQtwQjASaI5SACMhoff4fiAyi0w211YFkjJVQk7cAXDx0zQklQWaDtIpII4EqLy4jBa6AzmlAxCOvkuHMB+TW+gu0BggU2PPZqbI7qfMC1XSFSgJJIAKaA0RABlANkNHmw9UULAFkQ1CVDz9ECijeHS0PlAK6ByIOJ4HiECkIgmgEMhgYAFBLAwQUAAIACACuRhBDFynxF8oAAAD4AAAADwARAHh1ZXdlaUFsZXJ0LmJtcFVUDQAHo+gNUnDQDVJt0A1Sc/L9wQABZkCsAcQcUMzIIAEWPwTEQtwQDAN57tzeNrJK4uwx8zf0vv4PRG657U4abNVhypaSDEA2UCR3xwlhE3ugms50pYoorWgdSTMNUaBeoEhlSuCkLPcJKcIVjjJL24uuHNgwvaNm7azSBQ22QG6uCwdQFigIQlfPH9q+au/sgilVMdXJTkCRl09u5XUvmb72GFAKyAVKARX/eH1p6dr1VXP2tKw6DSSB7MPrKyemGQLV2OZOCmtelNCxImHSNiAJtAjoHgYGAFBLAQIXCxQAAgAIADhIEEOvEGPnvQAAAPgAAAAPAAkAAAAAAAAAIACAgQAAAABmcmllbmRBbGVydC5ibXBVVAUAB1jqDVJQSwECFwsUAAIACACuSBBDXGNETJoAAAD4AAAADgAJAAAAAAAAACAAgIH7AAAAc2tpbGxBbGVydC5ibXBVVAUAB0PrDVJQSwECFwsUAAIACACuRhBDFynxF8oAAAD4AAAADwAJAAAAAAAAACAAgIHSAQAAeHVld2VpQWxlcnQuYm1wVVQFAAej6A1SUEsFBgAAAAADAAMA0QAAANoCAAAAAA==


[Script]
Const RESOURCE_PATH = "c:\sszt"
Const CLTD = 500
Const INTERVAL = 1000

Dim timerScriptLoad, timerScriptExit, workingTime

Dim loopCounter
loopCounter = 0

Dim hwnd, dm_ret

Dim gameTopLeftX, gameTopLeftY, gameBottomRightX, gameBottomRightY
Dim gameWidth, gameHeight

Dim checkEventRectTopLeftX, checkEventRectTopLeftY, checkEventRectBottomRightX, checkEventRectBottomRightY
Dim checkEventRetX, checkEventRetY

Dim rolePanelPosX, rolePanelPosY
Dim xueweiStudyBtnPosX, xueweiStudyBtnPosY

Dim addFriendPanelPosX, addFriendPanelPosY
Dim addFriendBtnPosX, addFriendBtnPosY


PutAttachment RESOURCE_PATH, "*.bmp"

timerScriptLoad = Plugin.Sys.GetTime()

//创建dm对象
Set dm = createobject("dm.dmsoft")
Call dm.SetPath(RESOURCE_PATH)
TracePrint dm.Ver()

//后台绑定
hwnd = dm.GetMousePointWindow()
dm_ret = dm.BindWindow(hwnd,"dx2","windows","windows",0)
If dm_ret = 0 Then 
	MessageBox "绑定失败"
End If

//获取game客户区
dm_ret = dm.GetClientRect(hwnd, gameTopLeftX, gameTopLeftY, gameBottomRightX, gameBottomRightY)
gameWidth = gameBottomRightX - gameTopLeftX
gameHeight = gameBottomRightY - gameTopLeftY
//TracePrint gameWidth & "|" & gameHeight & "|" & gameTopLeftX & "," & gameTopLeftY & "," & gameBottomRightX & "," & gameBottomRightY

Call getRolePanelPos()
Call getAddFriendPanelPos()
Call getCheckEventRect()

Do While True

	If loopCounter Mod 5 = 0 Then 
		Call checkEvent("xueweiAlert.bmp")
		Call dealCheckEventResult("xueweiAlert")
		Call checkEvent("friendAlert.bmp")
		Call dealCheckEventResult("friendAlert")		
	End If
	
	If loopCounter Mod 60 = 0 Then 
		Call speak("1")
	End If
	
	loopCounter = loopCounter + 1
	TracePrint "loopCounter " & loopCounter
	
	Delay INTERVAL
	 
Loop

ExitScript 

Sub speak(word)
	dm.KeyPress 13
	Delay CLTD
	dm.SendString hwnd, word
	Delay CLTD
End Sub

Sub dealXuewei()
	TracePrint "找到【穴位】"
    TracePrint checkEventRetX & "&" & checkEventRetY
    dm.MoveTo checkEventRetX, checkEventRetY
    dm.LeftClick
    Delay CLTD
    dm.MoveTo xueweiStudyBtnPosX, xueweiStudyBtnPosY
    dm.LeftClick
    Delay CLTD
    dm.KeyPress 27
    Delay CLTD
End Sub

Sub dealFriend()
	TracePrint "找到【好友】"
    TracePrint checkEventRetX & "&" & checkEventRetY
    dm.MoveTo checkEventRetX, checkEventRetY
    dm.LeftClick
    Delay CLTD
    dm.MoveTo addFriendBtnPosX, addFriendBtnPosY
    dm.LeftClick
    Delay CLTD
    dm.KeyPress 27
    Delay CLTD
End Sub

Sub dealCheckEventResult(typeStr)
	If checkEventRetX >= 0 and checkEventRetY >= 0 Then 
		If typeStr = "xueweiAlert" Then 		
			Call dealXuewei()
		End If	
		If typeStr = "friendAlert" Then
			Call dealFriend()
		End If
    	
	End If
End Sub

Sub checkEvent(picPath)
	dm_ret = dm.FindPic(checkEventRectTopLeftX,checkEventRectTopLeftY,checkEventRectBottomRightX,checkEventRectBottomRightY,picPath,"000000",0.9,0,checkEventRetX,checkEventRetY)
End Sub

Sub getCheckEventRect()
	checkEventRectTopLeftX = 0
	checkEventRectTopLeftY = gameHeight - 153	
	checkEventRectBottomRightX = gameWidth
	checkEventRectBottomRightY = gameHeight - 133
	//TracePrint checkEventRectTopLeftX & "," & checkEventRectTopLeftY & "," & checkEventRectBottomRightX & "," & checkEventRectBottomRightY
End Sub

Sub getAddFriendPanelPos()
	addFriendPanelPosX = Int(gameWidth / 2 - 206)
	addFriendPanelPosY = Int(gameHeight / 2 - 226)
	addFriendBtnPosX = addFriendPanelPosX + 97
	addFriendBtnPosY = addFriendPanelPosY + 282
End Sub

Sub getRolePanelPos()
	rolePanelPosX = Int(gameWidth / 2 - 459)
	rolePanelPosY = Int(gameHeight / 2 - 445 / 2)
	xueweiStudyBtnPosX = rolePanelPosX + 366
	xueweiStudyBtnPosY = rolePanelPosY + 296
End Sub

Sub OnScriptExit()
	dm_ret = dm.UnBindWindow() 

    timerScriptExit = Plugin.Sys.GetTime()
    workingTime = timerScriptExit - timerScriptLoad
    TracePrint "workingTime(ms):" & workingTime
End Sub
