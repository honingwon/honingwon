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
MacroID=eee3091a-b1af-4dab-8e82-d798bb4fb309
Description=captcha
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
Const CLTD = 500
Const BSRVD = 1000

Const KEY_BACKSPACE = 8

//获取Chrome主窗口
ChromeHwnd = Plugin.Window.Find("Chrome_WidgetWin_1", "reg.qule.com/register.jsp - Google Chrome")
TracePrint "获取Chrome主窗口成功，句柄为：" & ChromeHwnd	

SubHwnd = Plugin.Window.FindEx(ChromeHwnd, 0, "Chrome_WidgetWin_0", 0)
PageHwnd = Plugin.Window.FindEx(SubHwnd, 0, "Chrome_RenderWidgetHostHWND", 0)
TracePrint "获取验证码页面成功，句柄为：" & PageHwnd

Const TOP_Y = 9
Const LEFT_X = 108

//18列
Const N9 = "7344120,7348220,14696446,14696446,14711839,14710799,14708743,14708743,15757319,7352327,8140815,8330270,4194302,2097148,1048568,262128"
//Const N9 = "2016,7344120,7348220,14696446,14696446,14711839,14710799,14708743,14708743,15757319,7352327,8140815,8330270,4194302,2097148,1048568,262128,65408"

//18列
Const N8 = "4178160,4187132,8386556,8388606,16285694,15736719,14683911,14687751,14687751,14695943,15761167,16318463,8387582,8385534,4186620,2080888"
//Const N8 = "1015808,4178160,4187132,8386556,8388606,16285694,15736719,14683911,14687751,14687751,14695943,15761167,16318463,8387582,8385534,4186620,2080888,1015808"

//16列
Const N7 = "14680079,16252943,16646159,16744463,16760847,2093071,260111,65039,16143,4047,1007,511,127,63"
//Const N7 = "15,14680079,16252943,16646159,16744463,16760847,2093071,260111,65039,16143,4047,1007,511,127,63,31"

//18列
Const N6 = "524256,2097136,4194296,8388604,7878910,15735838,14683151,14683663,14683655,14683655,15736327,16268807,8388103,8387591,4192270,2093070"
//Const N6 = "130816,524256,2097136,4194296,8388604,7878910,15735838,14683151,14683663,14683655,14683655,15736327,16268807,8388103,8387591,4192270,2093070,516096"

//15列
Const N5 = "7344127,14684159,14683663,14683663,14683663,14687759,14687759,15744015,7896079,8387599,8386575,4190223,2093071"
//Const N5 = "7344127,7344127,14684159,14683663,14683663,14683663,14687759,14687759,15744015,7896079,8387599,8386575,4190223,2093071,507919"

//19列，头1尾2
Const N4 = "258048,260096,252928,249344,247680,246720,246240,246000,245816,245788,16777215,16777215,16777215,16777215,16777215,245760"
//Const N4 = "253952,258048,260096,252928,249344,247680,246720,246240,246000,245816,245788,16777215,16777215,16777215,16777215,16777215,245760,245760,245760"

//16列
Const N3 = "7340046,14687239,14687239,14687239,14687239,14687239,14687751,14695943,15744783,16285695,8385534,8385534,4186620,2081016"
//Const N3 = "7340046,7340046,14687239,14687239,14687239,14687239,14687239,14687751,14695943,15744783,16285695,8385534,8385534,4186620,2081016,1015808"

//17列
Const N2 = "16515100,16646158,16711694,16744454,15974407,15843335,15785991,15757319,15759367,15744015,15736351,15736830,15732734,15730684,15729660"
//Const N2 = "16252928,16515100,16646158,16711694,16744454,15974407,15843335,15785991,15757319,15759367,15744015,15736351,15736830,15732734,15730684,15729660,15729136"

//15列
Const N1 = "14680120,14680092,14680092,14680092,16777214,16777214,16777214,16777215,16777215,14680064,14680064,14680064,14680064"
//Const N1 = "14680120,14680120,14680092,14680092,14680092,16777214,16777214,16777214,16777215,16777215,14680064,14680064,14680064,14680064,14680064"

Dim NList(9) 
NList(1) = N1
NList(2) = N2
NList(3) = N3
NList(4) = N4
NList(5) = N5
NList(6) = N6
NList(7) = N7
NList(8) = N8
NList(9) = N9

Dim tmpX, tmpY, c
Dim R, G, B
Dim i, j, k
Dim Matrix(23, 99)
Dim MatrixForShow(23, 99)

Dim rowStr
Dim TimerStart,TimerEnd,Duration

Rem go

TimerStart = Plugin.Sys.GetTime()
For i = 1 To 24
	rowStr = ""
	For j = 1 To 100
		Call getAbsoluteCoordinate(i, j)
		//难道是后台的原因
		c = Plugin.Bkgnd.GetPixelColor(PageHwnd, tmpX, tmpY)
		Call Plugin.Color.ColorToRGB(c, R, G, B)
		If ((R + G + B) > 500) Then 
			Matrix(i - 1, j - 1) = 0
			MatrixForShow(i - 1, j - 1) = "."
		Else 
			Matrix(i - 1, j - 1) = 1
			MatrixForShow(i - 1,j - 1) = "1"
		End If
		rowStr = rowStr & MatrixForShow(i - 1,j - 1) 
	Next
	TracePrint rowStr
Next
TracePrint "end of scan"

Dim colSum, colSumStr
colSumStr = "|"
For j = 0 To 99
	colSum = 0
	For i = 0 To 23
		colSum = colSum + ((2^i) * Matrix(i,j)) 
	Next
	colSumStr = colSumStr & colSum & "," 
Next
TracePrint colSumStr

Dim Result(3),ResultStr
Dim FoundIndex, Pos, Start
ResultStr = ""
Start = 1

FoundIndex = 0
For k = 1 To 9
	Pos = InStr(Start, colSumStr, NList(k))
	If Pos > 0 Then 
		If FoundIndex = 0 Or Pos < FoundIndex Then 
			FoundIndex = Pos
			Result(0) = k
		End If			
	End If
Next
TracePrint "第1个数字为" & Result(0)
ResultStr = ResultStr & Result(0)
Start = FoundIndex + 1

FoundIndex = 0
For k = 1 To 9
	Pos = InStr(Start, colSumStr, NList(k))
	If Pos > 0 Then 
		If FoundIndex = 0 Or Pos < FoundIndex Then 
			FoundIndex = Pos
			Result(1) = k
		End If			
	End If
Next
TracePrint "第2个数字为" & Result(1)
ResultStr = ResultStr & Result(1)
Start = FoundIndex + 1

FoundIndex = 0
For k = 1 To 9
	Pos = InStr(Start, colSumStr, NList(k))
	If Pos > 0 Then 
		If FoundIndex = 0 Or Pos < FoundIndex Then 
			FoundIndex = Pos
			Result(2) = k
		End If			
	End If
Next
TracePrint "第3个数字为" & Result(2)
ResultStr = ResultStr & Result(2)
Start = FoundIndex + 1

FoundIndex = 0
For k = 1 To 9
	Pos = InStr(Start, colSumStr, NList(k))
	If Pos > 0 Then 
		If FoundIndex = 0 Or Pos < FoundIndex Then 
			FoundIndex = Pos
			Result(3) = k
		End If			
	End If
Next
TracePrint "第4个数字为" & Result(3)
ResultStr = ResultStr & Result(3)
Start = FoundIndex + 1

TimerEnd = Plugin.Sys.GetTime()
Duration = TimerEnd - TimerStart
TracePrint ResultStr & "，耗时" & Duration & "毫秒"

Call Plugin.Bkgnd.LeftClick(PageHwnd,48,17)
Delay CLTD
Call Plugin.Bkgnd.LeftClick(PageHwnd,48,17)
Delay CLTD
//delete three char
Call PressKeyRepeatedly(PageHwnd, KEY_BACKSPACE, 4, 200) 
Call Plugin.Bkgnd.SendString(PageHwnd,ResultStr)
Delay CLTD
Call Plugin.Bkgnd.LeftClick(PageHwnd,6,49)
Delay BSRVD * 2

Goto go

//获取绝对坐标
Sub getAbsoluteCoordinate(row, col)
	Dim offsetX, offsetY
	offsetX = LEFT_X
	offsetY = TOP_Y
	tmpX = offsetX + col - 1
	tmpY = offsetY + row - 1
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
