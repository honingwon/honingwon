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
MacroID=42f23db2-cca9-4b5f-91ea-2163e8bc605f
Description=xuewei
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

Const CLTD = 200
Const INTERVAL = 1000

Dim gameHwnd
Dim tmpArr,tmpRect,tmpColor

Dim gameWidth, gameHeight

gameHwnd = Plugin.Window.MousePoint()
tmpRect = Plugin.Window.GetClientRect(gameHwnd)
tmpArr = Split(tmpRect, "|")
gameWidth = Clng(tmpArr(2))
gameHeight = Clng(tmpArr(3))

Dim rolePanelPosX, rolePanelPosY
Dim xueweiTabPosX, xueweiTabPosY, xueweiStudyBtnPosX, xueweiStudyBtnPosY, xueweiStudyingStatePosX, xueweiStudyingStatePosY
Dim xueweiStudyingStatePosColor

rolePanelPosX = Int(gameWidth / 2 - 459)
rolePanelPosY = Int(gameHeight / 2 - 445 / 2)
xueweiTabPosX = rolePanelPosX + 99
xueweiTabPosY = rolePanelPosY + 43
xueweiStudyBtnPosX = rolePanelPosX + 366
xueweiStudyBtnPosY = rolePanelPosY + 296
xueweiStudyingStatePosX = rolePanelPosX + 309
xueweiStudyingStatePosY = rolePanelPosY + 293
xueweiStudyingStatePosColor = "121109"

Dim onlineGiftPosX, onlineGiftPosY
onlineGiftPosX = gameWidth - 210
onlineGiftPosY = 30

			
TracePrint "gameWidth" & gameWidth
TracePrint "gameHeight" & gameHeight
TracePrint "rolePanelPos " & rolePanelPosX  & "," & rolePanelPosY

Call Plugin.Bkgnd.KeyPress(gameHwnd, 67)
Delay CLTD
Call ClickGameOnPos(xueweiTabPosX, xueweiTabPosY)
Delay CLTD

Dim loopCounter
loopCounter = 0
Do While True
	
	If loopCounter Mod 5 = 0 Then 
		Call studyXuewei()
	End If
	
	If loopCounter Mod 10 = 0 Then 
		Call getOnlineGift()
	End If
	
	loopCounter = loopCounter + 1
	TracePrint "loopCounter " & loopCounter
	
	Delay INTERVAL
Loop

Sub studyXuewei()
	tmpColor = Plugin.Bkgnd.GetPixelColor(gameHwnd, xueweiStudyingStatePosX, xueweiStudyingStatePosY)
	TracePrint "color " & tmpColor
	
	If tmpColor = xueweiStudyingStatePosColor Then 
		TracePrint "studying..."	
	Else 
		Call ClickGameOnPos(xueweiStudyBtnPosX, xueweiStudyBtnPosY)
		Delay CLTD
		TracePrint "has click study btn..."
	End If
End Sub

Sub getOnlineGift()
	Call ClickGameOnPos(onlineGiftPosX, onlineGiftPosY)
	Delay CLTD
End Sub

Sub ClickGameOnPos(x, y)
	Call Plugin.Bkgnd.LeftClick(gameHwnd, x, y)
End Sub