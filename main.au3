#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_x64=User_Empowerment_Tools_x64.Exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;此文件为GUI主框架、功能为引用外部文件、调用函数
#include-once
#include <WinAPI.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>
#include "Ex_tools.au3"

Global $iTools_hWnd = GUICreate("User Tools-Server",450,500,-1,-1,$WS_POPUP,$WS_EX_ACCEPTFILES)
GUISetBkColor(0x999999)

;GUICtrlSetDefBkColor(0xda70d6)

GUICtrlCreateLabel("User Empowerment Tools",0,0,420,30,$SS_CENTERIMAGE,$GUI_WS_EX_PARENTDRAG)
GUICtrlSetBkColor(-1,0x555555)
GUICtrlSetColor(-1,0xFF0000)
GUIctrlSetFont(-1, 16, 400, 0, 'Verdana')

$GUI_CLOSE = GUICtrlCreateLabel("x",420,0,30,30,$SS_CENTER)
GUICtrlSetBkColor(-1,0x444444)
GUICtrlSetColor(-1,0xFF0000)
GUIctrlSetFont(-1, 16, 400, 0, 'Verdana')


Global $Info_Label = GUICtrlCreateLabel("用户权限敏感，赋权需谨慎！",75,60,300,30,$SS_CENTER)
GUICtrlSetColor(-1,0xFF0000)
GUIctrlSetFont(-1, 16, 400, 0, 'Verdana')

Global $Input_DirPath = GUICtrlCreateInput("此处输入路径（绝对路径）",75,100,300,30,$SS_CENTER+$ES_AUTOHSCROLL)
GUICtrlSetFont(-1,13)
GUICtrlSetBkColor(-1,0x555555)
GUICtrlSetLimit($Input_DirPath,0);设置输入框可接受字符数量为无限制字符数量
GUICtrlSetState($Input_DirPath,$GUI_DROPACCEPTED);设置输入框控件接受拖拽文件

global $Input_UserName = GUICtrlCreateInput("此处输入需要赋权的用户名",75,160,300,30,$SS_CENTER)
GUICtrlSetFont(-1,13)
GUICtrlSetBkColor(-1,0x555555)

Global $Button_Start_Empowerment = GUICtrlCreateButton("Empowerment",175,205,100,40)
GUICtrlSetFont(-1,10)
GUICtrlSetBkColor(-1,0x555555)

Global $Tools_F = GUICtrlCreateRadio("F（读写）",115,260,70,20)
GUICtrlSetState(-1,1)

Global $Tools_R = GUICtrlCreateRadio("R（只读）",200,260,70,20)

Global $Tools_Deny = GUICtrlCreateRadio("Deny（禁止访问、不可见）",280,260,160,20)

Global $Tools_TF = GUICtrlCreateRadio("F(文件所有权)",10,260,100,20)

Global $Tools_F_A = GUICtrlCreateRadio("F(读写&&不继承传播)",10,290,130,20)

;##############################################################################################################################
Global $Iput_AddUser = GUICtrlCreateInput("此处输入要创建的用户名（英文）",75,350,300,30,$SS_CENTER)
GUICtrlSetFont(-1,13)
GUICtrlSetBkColor(-1,0x555555)

Global $Button_Create_User = GUICtrlCreateButton("Create",100,395,100,40)
GUICtrlSetFont(-1,10)
GUICtrlSetBkColor(-1,0x555555)

Global $Button_Delete_User = GUICtrlCreateButton("Delete",250,395,100,40)
GUICtrlSetFont(-1,10)
GUICtrlSetBkColor(-1,0x555555)
;##################################################################################################################################
GUISetState(@SW_SHOW,$iTools_hWnd)
iSetLayeredWindowAttributes($iTools_hWnd,0xFFFFFF,255,0x02)
#cs
;判断是否有管理员权限
If Not IsAdmin Then 
	MsgBox(16,"Error","确认当前用户是否有管理员权限！(尝试以管理员身份运行)")
	Exit
EndIf
#ce
while 1
    switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            Exit
		Case $GUI_CLOSE
			If MsgBox($MB_ICONQUESTION+$MB_YESNO,"Info","确认关闭？") = $IDYES Then Exit
        Case $Button_Start_Empowerment
            User_Empowerment();赋权函数，执行用户的赋权操作，定义在“Ex_tools.au3”
    EndSwitch
WEnd
;设置窗口透明度
Func iSetLayeredWindowAttributes($hWnd,$iColor,$iAlpha,$iLWA_ALPHA)
	Local $ihWnd = WinGetHandle($hWnd)
	Local $dwExStyle = DllCall("user32.dll", "long", "GetWindowLong", "hwnd", $ihWnd, "int", $GWL_EXSTYLE)
	DllCall("user32.dll", "long", "SetWindowLong", "hwnd", $ihWnd, "int", $GWL_EXSTYLE, "long", BitOR($dwExStyle[0], $WS_EX_LAYERED))

	; 设置透明度
	DllCall("user32.dll", "bool", "SetLayeredWindowAttributes", "hwnd", $ihWnd, "dword", 0x00FF00, "byte", 240, "dword", $LWA_COLORKEY + $LWA_ALPHA)

EndFunc
