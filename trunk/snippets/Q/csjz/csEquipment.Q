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
MacroID=b15cc405-d70d-45e3-862b-8537033a3951
Description=csEquipment
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
//鉴定、分解
//功能:
//a 同一时间只能进行单一操作（鉴定或者分解）
//b 可配置角色拥有包裹的数量
//c 可配置从指定包裹、位置开始处理（默认从第一个包裹，1行1列开始）
//d 可配置网络延迟
//todo
//a 可配置分解选项（全部分解，不分解极品（极品的定义和检测)）
//b 操作模式可配置（鉴定、分解、鉴定后马上分解）
//c 脚本启动前不需要点开入口面板。思路（先回程、再打开地图找到npc，立即传送，再找到NPC形象，点击）
//d 可配置将要处理的包裹的数量，默认处理到最后一个包裹

UserVar BSRVD = 1000 "网络延迟基数，默认1000。"

UserVar BagAmount = 4 "角色拥有包裹的数量，默认4个。"
UserVar Fun = DropList{"仅鉴定":"identify"|"仅分解":"resolve"} = 0 "请选择功能，默认选择仅鉴定"
UserVar FromBagIndex = 1 "从第几个包裹开始处理，默认为1。"
UserVar FromRowIndex = 1 "从第几行开始处理，默认为1。"
UserVar FromColIndex = 1 "从第几列开始处理，默认为1。"

Const FUN_LIST_VAL_IDENTIFY = "identify"
Const FUN_LIST_VAL_RESOLVE = "resolve"

//CLIENT_DELAY
Const CLTD = 500

Const BAG_COL_AMOUNT = 6
Const BAG_ROW_AMOUNT = 9

Const CELL_WIDTH = 48
Const CELL_HEIGHT = 48

Const BAG_TAB_HEIGHT = 58

Const MAIN_WIN_WIDTH = 900
Const MAIN_WIN_HEIGHT = 700

Const IDENTIFY_UI_ENTRANCE_X = 448
Const IDENTIFY_UI_ENTRANCE_Y = 421

Const RESOLVE_UI_ENTRANCE_X = 450
Const RESOLVE_UI_ENTRANCE_Y = 461

Const IDENTIFY_EX_X = 152
Const IDENTIFY_EX_Y = 533

Const BAG_FIRST_CELL_X = 515
Const BAG_FIRST_CELL_Y = 111

Const BTN_IDENTIFY_X = 289
Const BTN_IDENTIFY_Y = 530

Const BTN_RESOLVE_X = 291 
Const BTN_RESOLVE_Y = 529

Const FIRST_BAG_X = 812
Const FIRST_BAG_Y = 131

//处理配置错误
If FromBagIndex > BagAmount Then 
    MessageBox "起始包裹序号不能大于包裹个数"
    ExitScript
End If

If FromRowIndex > BAG_ROW_AMOUNT Then 
    MessageBox "起始行序号不能大于总行数"
    ExitScript
End If

If FromColIndex > BAG_COL_AMOUNT Then 
    MessageBox "起始列序号不能大于总列数"
    ExitScript
End If

Dim i, j, k

Dim tmpCellPosX, tmpCellPosY
Dim tmpBagTabPosX,tmpBagTabPosY


//IE主窗口
MainHwnd = Plugin.Window.Find("IEFrame", 0)
Call Plugin.Window.Size(MainHwnd, MAIN_WIN_WIDTH, MAIN_WIN_HEIGHT)
Delay CLTD
//获取game句柄
SubHwnd = Plugin.Window.FindEx(MainHwnd, 0, "Frame Tab", 0)
Sub2Hwnd = Plugin.Window.FindEx(SubHwnd, 0, "TabWindowClass", 0)
Sub3Hwnd = Plugin.Window.FindEx(Sub2Hwnd, 0, "Shell DocObject View", 0)
Sub4Hwnd = Plugin.Window.FindEx(Sub3Hwnd, 0, "Internet Explorer_Server", 0)
Hwnd = Plugin.Window.FindEx(Sub4Hwnd, 0, "MacromediaFlashPlayerActiveX", 0)
TracePrint "获取game成功，句柄为：" & Hwnd
If Hwnd = 0 Then 
    ExitScript
End If

If Fun = FUN_LIST_VAL_IDENTIFY Then	
    Call Identify()	
Else 
    Call Resolve()
End If

Sub Identify()
    TracePrint FUN_LIST_VAL_IDENTIFY
	
    Call Plugin.Bkgnd.LeftClick(Hwnd, IDENTIFY_UI_ENTRANCE_X, IDENTIFY_UI_ENTRANCE_Y)
    TracePrint "open identify tab"
    Delay CLTD * 4
	
    Call Plugin.Bkgnd.LeftClick(Hwnd, IDENTIFY_EX_X, IDENTIFY_EX_Y)
    TracePrint "select use YuanBao"
    Delay CLTD	
	
    For k = FromBagIndex To BagAmount
        //点击选择第k个包裹
        Call getBagPosByIndex(k)
        Call Plugin.Bkgnd.LeftClick(Hwnd, tmpBagTabPosX, tmpBagTabPosY)
        Delay CLTD
		
        For i = FromRowIndex To BAG_ROW_AMOUNT
        	If i = BAG_ROW_AMOUNT Then 
        		FromRowIndex = 1
        	End If
            For j = FromColIndex To BAG_COL_AMOUNT
                If j = BAG_COL_AMOUNT Then 
                    FromColIndex = 1
                End If
                Call getCellPos(i, j)
                Call IdentifyEquipFromCellPos(tmpCellPosX, tmpCellPosY)
            Next	
        Next
    Next	
End Sub

Sub Resolve()
    TracePrint FUN_LIST_VAL_RESOLVE
	
    Call Plugin.Bkgnd.LeftClick(Hwnd, RESOLVE_UI_ENTRANCE_X, RESOLVE_UI_ENTRANCE_Y)
    TracePrint "open resolve tab"
    Delay CLTD * 4
	
    For k = FromBagIndex To BagAmount
        //点击选择第k个包裹
        Call getBagPosByIndex(k)
        Call Plugin.Bkgnd.LeftClick(Hwnd, tmpBagTabPosX, tmpBagTabPosY)
        Delay CLTD
        For i = FromRowIndex To BAG_ROW_AMOUNT
        	If i = BAG_ROW_AMOUNT Then 
        		FromRowIndex = 1
        	End If
            For j = FromColIndex To BAG_COL_AMOUNT
                If j = BAG_COL_AMOUNT Then 
                    FromColIndex = 1
                End If
                Call getCellPos(i, j)
                Call ResolveEquipFromCellPos(tmpCellPosX, tmpCellPosY)
            Next	
        Next		
    Next	
End Sub

Sub ResolveEquipFromCellPos(posX, posY)
    Call Plugin.Bkgnd.LeftClick(Hwnd, posX, posY)
    Delay 20
    Call Plugin.Bkgnd.LeftClick(Hwnd, posX, posY)
    Delay 20
    Call Plugin.Bkgnd.LeftClick(Hwnd, posX, posY)
    Delay 20
    Call Plugin.Bkgnd.LeftClick(Hwnd, posX, posY)
    Delay 20
    TracePrint "select an equipment"
    Delay CLTD
    Call Plugin.Bkgnd.LeftClick(Hwnd, BTN_RESOLVE_X, BTN_RESOLVE_Y)
    TracePrint "click btn to resolve"
    Delay CLTD * 4
    Delay BSRVD * 3
	
End Sub

Sub IdentifyEquipFromCellPos(posX, posY)
    Call Plugin.Bkgnd.LeftClick(Hwnd, posX, posY)
    Delay 20
    Call Plugin.Bkgnd.LeftClick(Hwnd, posX, posY)
    Delay 20
    Call Plugin.Bkgnd.LeftClick(Hwnd, posX, posY)
    Delay 20
    Call Plugin.Bkgnd.LeftClick(Hwnd, posX, posY)
    Delay 20
    TracePrint "select an equipment"
    Delay CLTD
    Call Plugin.Bkgnd.LeftClick(Hwnd, BTN_IDENTIFY_X, BTN_IDENTIFY_Y)
    TracePrint "click btn to identify"
    Delay CLTD * 4
    Delay BSRVD * 3
    Call Plugin.Bkgnd.LeftClick(Hwnd, BTN_IDENTIFY_X, BTN_IDENTIFY_Y)
    TracePrint "get the equipment"
    Delay BSRVD * 3	
	
End Sub

Sub getCellPos(row, col)
    Dim offsetX, offsetY
    offsetX = CELL_WIDTH * (col - 1)
    offsetY = CELL_HEIGHT * (row - 1)	
    tmpCellPosX = BAG_FIRST_CELL_X + offsetX
    tmpCellPosY = BAG_FIRST_CELL_Y + offsetY
    TracePrint "cell " & row & "," & col & " pos:" & tmpCellPosX & ", "& tmpCellPosY
End Sub

Sub getBagPosByIndex(index)
    Dim offsetX, offsetY
    offsetX = 0
    offsetY = BAG_TAB_HEIGHT * (index - 1)
    tmpBagTabPosX = FIRST_BAG_X + offsetX
    tmpBagTabPosY = FIRST_BAG_Y + offsetY
    TracePrint "bagTab " & index & " pos:" & tmpBagTabPosX & ", "& tmpBagTabPosY
End Sub
