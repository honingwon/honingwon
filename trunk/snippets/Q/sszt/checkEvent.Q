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
UEsDBBQAAgAIAGo5EENW/yYz1AAAADgBAAAPABEAZnJpZW5kQWxlcnQuYm1wVVQNAAep0A1SqdANUqHQDVJz8rVgZAADMyDWAGIOKGZkUACLMwHlhbghGAYMoucyWCXMAmOf0i0MCX1HGUIbd4DF+XQLGCyy1zC4l6xn8K7exxDSdJQhsfc8Q3zrIbA8CDuX7wJjmFzm7FtgGmQWiE6cdhmOixfdBWOQOMi86qV3wfryFt0H66tb8xqMQezC2TfA8uJevWD5vt1fGabs/w7Hqy//Z0ibeYZBPmoWg3fTXoa2ra/BeNre9wwbr/1gmHr4C4OSWz1D8/onDAapyxncq7eCzQTxQeqM02YyiDjWAEMAAFBLAwQUAAIACACqOBBD1sjOz6kAAAA4AQAADgARAHNraWxsQWxlcnQuYm1wVVQNAAchzw1SIc8NUiHPDVJz8rVgZAADMyDWAGIOKGZkUACLMwHlhbghGBk0RyiBMQi0Pv8PxgbR6QyG2upgOsZKiKHJWwBFPnTNCQYlQWYGg7QKhkgjAYYqLy4GIwUuhoDOaWDMI6/CkOHMBxar9RdgaA0QYCiw52OwU2VncFLnBavvCpUE0yAMMh+EQWyQehC7zQcoHiwB5sNwlQ8/XA1IvjtaHqwG5H6YPDINkoepgWGYWSA2AwMAUEsDBBQAAgAIAFA5EEPaEeI67AAAADgBAAAPABEAeHVld2VpQWxlcnQuYm1wVVQNAAdw0A1ScNANUm3QDVJz8rVgZAADMyDWAGIOKGZkUACLMwHlhbghGAby3LkZvG1kGZTE2Rli5m9g6H39H4zdctsZnDTYGKrDlBksJRnAfJB47o4TDMIm9mD1nelKDBVRWgzROpIMZhqiYPNA4pUpgQyTstwZJqQIM1Q4yjAsbS9iuHJgA8P0jhqGtbNKGRY02ILFcl04wOpAcmB89TzDoe2rGPbOLmCYUhXDUJ3sBBZ/+eQWQ173Eobpa4+B1YDEQGpAen+8vsSwdO16hqo5exhaVp0G0yD+4fWVDBPTDMHqbXMnMYQ1L2JI6FjBkDBpG5gGuQXkfgYGAFBLAQIXCxQAAgAIAGo5EENW/yYz1AAAADgBAAAPAAkAAAAAAAAAIACAgQAAAABmcmllbmRBbGVydC5ibXBVVAUAB6nQDVJQSwECFwsUAAIACACqOBBD1sjOz6kAAAA4AQAADgAJAAAAAAAAACAAgIESAQAAc2tpbGxBbGVydC5ibXBVVAUAByHPDVJQSwECFwsUAAIACABQORBD2hHiOuwAAAA4AQAADwAJAAAAAAAAACAAgIH4AQAAeHVld2VpQWxlcnQuYm1wVVQFAAdw0A1SUEsFBgAAAAADAAMA0QAAACIDAAAAAA==


[Script]
Const RESOURCE_PATH = "c:\sszt"

Dim timerScriptLoad, timerScriptExit, workingTime
Dim hwnd, dm_ret
Dim gameTopLeftX, gameTopLeftY, gameBottomRightX, gameBottomRightY
Dim gameWidth, gameHeight
Dim checkEventRectTopLeftX, checkEventRectTopLeftY, checkEventRectBottomRightX, checkEventRectBottomRightY
Dim checkEventRetX,checkEventRetY

//PutAttachment RESOURCE_PATH, "*.bmp"'释放字库，全部TXT格式文件

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
//dm_ret = dm.Capture(0,0,2000,2000,"screen.bmp")
//ExitScript

//获取game客户区
dm_ret = dm.GetClientRect(hwnd, gameTopLeftX, gameTopLeftY, gameBottomRightX, gameBottomRightY)
gameWidth = gameBottomRightX - gameTopLeftX
gameHeight = gameBottomRightY - gameTopLeftY
TracePrint gameWidth & "|" & gameHeight & "|" & gameTopLeftX & "," & gameTopLeftY & "," & gameBottomRightX & "," & gameBottomRightY

//////
Call getCheckEventRect()
Call checkEvent("xueweiAlert.bmp")
If checkEventRetX >= 0 and checkEventRetY >= 0 Then
    TracePrint "找到【穴位】"
    TracePrint checkEventRetX & "&" &  checkEventRetY
End If

ExitScript

Sub getCheckEventRect()
	checkEventRectTopLeftX = 0
	checkEventRectTopLeftY = gameHeight - 153	
	checkEventRectBottomRightX = gameWidth
	checkEventRectBottomRightY = gameHeight - 133
	TracePrint checkEventRectTopLeftX & "," & checkEventRectTopLeftY & "," & checkEventRectBottomRightX & "," & checkEventRectBottomRightY
End Sub

Sub checkEvent(picPath)
	dm_ret = dm.FindPic(checkEventRectTopLeftX,checkEventRectTopLeftY,checkEventRectBottomRightX,checkEventRectBottomRightY,picPath,"000000",0.9,0,checkEventRetX,checkEventRetY)
End Sub

Sub OnScriptExit()
	dm_ret = dm.UnBindWindow() 

    timerScriptExit = Plugin.Sys.GetTime()
    workingTime = timerScriptExit - timerScriptLoad
    TracePrint "workingTime(ms):" & workingTime
End Sub
