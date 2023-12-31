;此文件为实现赋权、创建、删除用户、遍历列出计算机用户    功能函数
;-----------------声明“main.au3”中的全局变量-------------------------
Global $Input_DirPath
Global $Input_UserName
Global $Tools_F
Global $Tools_R
Global $Tools_Deny
Global $Tools_TF
Global $Tools_F_A
;-----------------注意：这样声明可能会导致错误-----------------------
Global $_Path;用以存储读取路径输入框输入的字符
Global $_UserName;用以存储读取输入的用户名字符
#include-once
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include <Array.au3>
#include <Process.au3>

Func User_Empowerment()
	If _FileExists() = 1 And UserExists() = 1 Then
		_Empowerment_Select()
	EndIf
EndFunc

Func _Empowerment_Select()
	Select
		Case GUICtrlRead($Tools_F) = 1
			;MsgBox(64,"info","icacls " & $_Path & " /deny " & $_UserName & ":(OI)(CI)(F) /t")
			Run(@ComSpec & " /C " & "icacls " & $_Path & " /grant:r " & $_UserName & ":(OI)(CI)(F) /t");注意：继承权限（递归所有目录）
		Case GUICtrlRead($Tools_R) = 1
			Run(@ComSpec & " /C " & "icacls " & $_Path & " /grant:r " & $_UserName & ":(OI)(CI)(R) /t");注意：继承权限（递归所有目录）
		Case GUICtrlRead($Tools_Deny) = 1
			Run(@ComSpec & " /C " & "icacls " & $_Path & " /deny " & $_UserName & ":(OI)(CI)(F) /t");注意：继承权限（递归所有目录）
		Case GUICtrlRead($Tools_TF) = 1
			;MsgBox(64,"info",":" & $_Path)
			Run(@ComSpec & " /C " & "takeown /f " &$_Path & " /r /d y");获取文件所有权
		Case GUICtrlRead($Tools_F_A) = 1
			Run(@ComSpec & " /C " & "icacls " & $_Path & " /grant:r " & $_UserName & ":(F)");注意：不继承传播权限
	EndSelect
EndFunc



Func _FileExists()
	$_Path = GUICtrlRead($Input_DirPath)
	Switch FileExists($_Path)
		Case 0
			MsgBox(16,"Error","The Path Not Found!" & @error)
			SetError(-1)
			Return 0
		Case 1
			Return 1;表示输入的绝对路径文件或文件夹存在
	EndSwitch
EndFunc

Func UserExists()
	$_UserName = GUICtrlRead($Input_UserName)
	Local $tUserInfo = DllStructCreate("wchar[256];wchar[256];dword;dword")
	Local $iResult = DllCall("netapi32.dll", "long", "NetUserGetInfo", "wstr", @ComputerName, "wstr", $_UserName, "dword", 0, "ptr*", DllStructGetPtr($tUserInfo))
	;_ArrayDisplay($iResult)
	If $iResult[0] = 0  Or $_UserName = "everyone" Then
		return 1;表示输入的用户名存在
	Else
		
		MsgBox(16,"Error","User Not Found!")
		return 0
	EndIf
Endfunc
