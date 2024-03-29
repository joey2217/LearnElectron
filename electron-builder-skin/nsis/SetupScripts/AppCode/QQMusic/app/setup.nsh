
# ===================== 外部插件以及宏 =============================
!include "StrFunc.nsh"
!include "WordFunc.nsh"
!include "StdUtils.nsh"
${StrRep}
${StrStr}
!include "LogicLib.nsh"
!include "nsDialogs.nsh"
!include "common.nsh"
!include "x64.nsh"
!include "MUI.nsh"
!include "WinVer.nsh" 
!include "..\commonfunc.nsh"

!insertmacro MUI_LANGUAGE "SimpChinese"
# ===================== 安装包版本 =============================
VIProductVersion             		"${PRODUCT_VERSION}"
VIAddVersionKey "ProductVersion"    "${PRODUCT_VERSION}"
VIAddVersionKey "ProductName"       "${PRODUCT_NAME}"
VIAddVersionKey "CompanyName"       "${PRODUCT_PUBLISHER}"
VIAddVersionKey "FileVersion"       "${PRODUCT_VERSION}"
VIAddVersionKey "InternalName"      "${EXE_NAME}"
VIAddVersionKey "FileDescription"   "${PRODUCT_NAME}"
VIAddVersionKey "LegalCopyright"    "${PRODUCT_LEGAL}"

!define INSTALL_PAGE_CONFIG 			0
;!define INSTALL_PAGE_LICENSE 			1
!define INSTALL_PAGE_PROCESSING 		1
!define INSTALL_PAGE_FINISH 			2
!define INSTALL_PAGE_UNISTCONFIG 		3
!define INSTALL_PAGE_UNISTPROCESSING 	4
!define INSTALL_PAGE_UNISTFINISH 		5

# 自定义页面
Page custom DUIPage

# 卸载程序显示进度
UninstPage custom un.DUIPage

# ======================= DUILIB 自定义页面 =========================
Var hInstallDlg
Var hInstallSubDlg
Var sCmdFlag
Var sCmdSetupPath
Var sSetupPath 
#卸载时是否保留数据 
Var sReserveData   
#是在安装中还是安装完成  
Var InstallState   
 #卸载的进度
Var UnInstallValue 
; 安装进度
Var InstallProgress
; 插件安装进度
Var PlugInInstallProgress

; 安装入口
Function DUIPage
	#设置未安装完成状态
    StrCpy $InstallState "0"
	#设置安装进度
    StrCpy $InstallProgress 0
	#设置插件安装进度
    StrCpy $PlugInInstallProgress 0
	; 初始化插件目录	
	InitPluginsDir   	
	SetOutPath "$PLUGINSDIR"
	; 读取服务协议文件
	File "${INSTALL_LICENCE_FILENAME}"
	; 读取资源文件
    File "${INSTALL_RES_PATH}"
	; 读取Logo文件，此处的目标文件一定是logo.ico，否则控件将找不到文件 
	File /oname=logo.ico "${INSTALL_ICO}"
	#指定插件路径及协议文件名称
	nsNiuniuSkin::InitSkinPage "$PLUGINSDIR\" "${INSTALL_LICENCE_FILENAME}" 
    Pop $hInstallDlg
   	
	#获取默认的安装路径
    Call GenerateSetupAddress
	#设置控件显示安装路径 
    nsNiuniuSkin::SetControlAttribute $hInstallDlg "editDir" "text" "$INSTDIR\"

	; 设置安装路径控件变化响应事件
	Call OnRichEditTextChange

	#设置安装包的标题及任务栏显示  
	nsNiuniuSkin::SetWindowTile $hInstallDlg "${PRODUCT_NAME}安装程序"
	; 初始化安装页分页
	nsNiuniuSkin::ShowPageItem $hInstallDlg "wizardTab" ${INSTALL_PAGE_CONFIG}
	; 设置文本名称
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "licensename" "text" "QQMusic用户协议"
	;控件绑定
    Call BindUIControls
	; 显示分页
    nsNiuniuSkin::ShowPage 0	
FunctionEnd

; 卸载入口
Function un.DUIPage
	StrCpy $InstallState "0"
	; 初始化插件目录
    InitPluginsDir
	SetOutPath "$PLUGINSDIR"
	; 安装资源路径，指向skin.zip
    File "${INSTALL_RES_PATH}"
	#此处的目标文件一定是logo.ico，否则控件将找不到文件
	File /oname=logo.ico "${UNINSTALL_ICO}" 
	#指定插件路径
	nsNiuniuSkin::InitSkinPage "$PLUGINSDIR\" "" 
    Pop $hInstallDlg
	; 设置卸载分页
	nsNiuniuSkin::ShowPageItem $hInstallDlg "wizardTab" ${INSTALL_PAGE_UNISTCONFIG}
	#设置安装包的标题及任务栏显示  
	nsNiuniuSkin::SetWindowTile $hInstallDlg "${PRODUCT_NAME}卸载程序"
	; 绑定卸载相关事件
	Call un.BindUnInstUIControls
	; 保留数据默认选项(默认保留)
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "chkAutoRun" "selected" "true"
	; 显示分页
    nsNiuniuSkin::ShowPage 0
FunctionEnd

#卸载-绑定卸载的事件 
Function un.BindUnInstUIControls
	; 卸载页面，确认按钮
	GetFunctionAddress $0 un.onUninstall
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnUnInstall" $0

	; 卸载页面，取消按钮
	GetFunctionAddress $0 un.ExitDUISetup
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnClose" $0

	; 卸载完成页面-完成按钮
	GetFunctionAddress $0 un.ExitDUISetup
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnUninstalled" $0
FunctionEnd

#安装-绑定安装的界面事件 
Function BindUIControls

	; 安装界面，卸载界面，对话框-关闭按钮
    GetFunctionAddress $0 OnExitDUISetup
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnClose" $0

	; 安装界面-一键安装按钮
    GetFunctionAddress $0 OnBtnInstall
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnMainInstall" $0

	; 安装界面，同意协议选项框
	GetFunctionAddress $0 OnCheckLicenseClick
    nsNiuniuSkin::BindCallBack $hInstallDlg "chkAgree" $0

	; 安装界面-用户服务中转按钮
	GetFunctionAddress $0 OnBtnLicenseClick
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnAgreement" $0

	; 安装界面，自定义安装按钮
	GetFunctionAddress $0 OnBtnShowMore
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnShowMore" $0

	; 自定义安装界面-立即安装按钮
	GetFunctionAddress $0 OnBtnInstall
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnMoreInstall" $0
    
	; 自定义安装界面-目录选择按钮
    GetFunctionAddress $0 OnBtnSelectDir
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnSelectDir" $0

	; 自定义安装界面，返回按钮
	GetFunctionAddress $0 OnBtnHideMore
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnHideMore" $0
    
	; 用户协议界面-同意
	GetFunctionAddress $0 OnBtnShowConfig
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnAgree" $0

	#安装路径变化的通知事件 
	GetFunctionAddress $0 OnRichEditTextChange
    nsNiuniuSkin::BindCallBack $hInstallDlg "editDir" $0
        
    # 安装完成页面-立即体验
    GetFunctionAddress $0 OnFinished
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnRun" $0

	#绑定窗口通过alt+f4等方式关闭时的通知事件 
	GetFunctionAddress $0 OnSysCommandCloseEvent
    nsNiuniuSkin::BindCallBack $hInstallDlg "syscommandclose" $0
FunctionEnd

#安装-路径变化通知 
Function OnRichEditTextChange
	#可在此获取路径，判断是否合法等处理 
	nsNiuniuSkin::GetControlAttribute $hInstallDlg "editDir" "text"
    Pop $0	
	StrCpy $INSTDIR "$0"
	
	Call IsSetupPathIlleagal
	${If} $R5 == "0"
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "local_space" "text" "路径非法"
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "local_space" "textcolor" "#ffff0000"
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnMainInstall" "enabled" "false"
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnMoreInstall" "enabled" "false"
		goto TextChangeAbort
    ${EndIf}
	
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "local_space" "textcolor" "#FF999999"
	${If} $R0 > 1024                               #400即程序安装后需要占用的实际空间，单位：MB  
		IntOp $R1  $R0 % 1024	
		IntOp $R0  $R0 / 1024;		
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "local_space" "text" "剩余空间：$R0.$R1GB"
	${Else}
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "local_space" "text" "剩余空间：$R0.$R1MB"
     ${endif}
	
	nsNiuniuSkin::GetControlAttribute $hInstallDlg "chkAgree" "selected"
    Pop $0
	${If} $0 == "1"        
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnMainInstall" "enabled" "true"
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnMoreInstall" "enabled" "true"
	${Else}
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnMainInstall" "enabled" "false"
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnMoreInstall" "enabled" "false"
    ${EndIf}
	
TextChangeAbort:
FunctionEnd

#安装-用户协议选项框通知(控制立即按钮状态)
Function OnCheckLicenseClick
	nsNiuniuSkin::GetControlAttribute $hInstallDlg "chkAgree" "selected"
    Pop $0
	${If} $0 == "0"        
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnMainInstall" "enabled" "true"
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnMoreInstall" "enabled" "true"
	${Else}
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnMainInstall" "enabled" "false"
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnMoreInstall" "enabled" "false"
    ${EndIf}
FunctionEnd

; 安装-显示用户协议
Function OnBtnLicenseClick
	; nsNiuniuSkin::SetControlAttribute $hInstallDlg "licenseshow" "visible" "true"
	; nsNiuniuSkin::GetControlAttribute $hInstallDlg "moreconfiginfo" "visible"
	; Pop $0
	; ${If} $0 = 0        
	; 	nsNiuniuSkin::SetControlAttribute $hInstallDlg "licenseshow" "pos" "5,35,475,385"
	; 	nsNiuniuSkin::SetControlAttribute $hInstallDlg "editLicense" "height" "270"		
	; ${Else}
	; 	nsNiuniuSkin::SetControlAttribute $hInstallDlg "licenseshow" "pos" "5,35,475,495"
	; 	nsNiuniuSkin::SetControlAttribute $hInstallDlg "editLicense" "height" "375"
    ; ${EndIf}
	${OpenURL} "${TERMS_URL}"
FunctionEnd

# 安装-添加一个静默安装的入口
Section "silentInstallSec" SEC01
	; ; 读取传递参数
	; ; 备注 传递的/D参数已默认赋值给 $INSTDIR,直接使用$INSTDIR即可
	; ${Getparameters} $R0
	; ; 读取InstallPath参数
	; ${GetOptions} $R0 "/InstallPath=" $R1
	
	#启动一个低优先级的后台线程
    GetFunctionAddress $0 ExtractFunc
    BgWorker::CallAndWait
SectionEnd

; 安装-弹出提示框
Function ShowMsgBox
	nsNiuniuSkin::InitSkinSubPage "msgBox.xml" "btnOK" "btnCancel,btnClose"  ; "提示" "${PRODUCT_NAME} 正在运行，请退出后重试!" 0
	Pop $hInstallSubDlg
	nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "lblTitle" "text" "提示"
	nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "lblMsg" "text" "$R8"
	${If} "$R7" == "1"
		; 更新确认按钮坐标
		nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "btnOK" "pos" "50,0,150,40"
		; 显示取消按钮
		nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "btnCancel" "visible" "true"
	${Else}
		; 更新确认按钮坐标
		nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "btnOK" "pos" "150,0,250,40"
		; 显示取消按钮
		nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "btnCancel" "visible" "false"
	${EndIf}
	nsNiuniuSkin::ShowSkinSubPage 0 
FunctionEnd

; 结束进程
; 返回0 表示结束成功 返回1 表示退出安装
Function KillProc
	#此处检测当前是否有程序正在运行，如果正在运行，提示先卸载再安装 
	nsProcess::_FindProcess "${EXE_NAME}"
	Pop $R0

	#验证查询结果
	${If} $R0 == 0
		; 弹框提示
        StrCpy $R8 "检测到 ${EXE_NAME} 正在运行。点击 “确定” 结束进程${EXE_NAME}，继续安装。点击 “取消” 退出安装程序。"
		StrCpy $R7 "1"
		Call ShowMsgBox

		Pop $0
		; 结束进程
		${If} $0 == 1
			; 设置安装提示
			nsNiuniuSkin::SetControlAttribute $hInstallDlg "progress_tip" "text" "正在安全的结束进程,请稍后..."
			#结束进程
   			KillProcDLL::KillProc "${EXE_NAME}"
		${Else}
			#设置返回值
			push 1
			; 退出
			goto KillProcEnd
		${EndIf}

		#循环验证
   		${For} $R1 0 100
		   	#等待100毫秒再查询结果
      		Sleep 100
			#接收结果
			nsProcess::_FindProcess "${EXE_NAME}"
			#检测进程
			Pop $R0
			; 判断进程是否存在
			${If} $R0 != 0
				#设置返回值
				push 0
				; 查找进程结束
				goto KillProcEnd
			${EndIf}
		${Next}

		; 弹框提示
        StrCpy $R8 "我们无法安全的结束正在运行的 ${EXE_NAME} 应用程序,请手动退出应用程序,再尝试安装!"
		StrCpy $R7 "0"
		Call ShowMsgBox
		#设置返回值
		push 1
	; 结束
	KillProcEnd:
    ${EndIf}
FunctionEnd

;创建任务栏快捷方式
Function CreateBarlnk    
  ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" "CurrentVersion"    
  ${if} $R0 >= 6.0  
     SetOutPath $INSTDIR  
	 ;注意这句与下一句是有先后顺序的(与ExecShell taskbarpin关联)
     CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${EXE_NAME}"
     ;创建任务栏快捷方式(win10系统会失败,并且导致程序运行)
     ;ExecShell taskbarpin "$DESKTOP\${PRODUCT_NAME}.lnk"
	 ${StdUtils.InvokeShellVerb} $0 "$INSTDIR" "${EXE_NAME}" ${StdUtils.Const.ShellVerb.PinToTaskbar}
  ${else}   
     CreateShortCut "$QUICKLAUNCH\${PRODUCT_NAME}.lnk" "$INSTDIR\${EXE_NAME}"  
  ${Endif}  
FunctionEnd  

; 创建开机启动
; 备注:开机启动的项目不能为管理员身份启动，否则会启动不起来
Function CreateBootStart
	WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "${PRODUCT_NAME}" "$INSTDIR\${EXE_NAME}"
FunctionEnd

Function ExtractFunc
	#安装文件的7Z压缩包
	SetOutPath $INSTDIR
  ; 设置文件替换方式(on 覆盖(默认值))
	SetOverwrite on
	#根据宏来区分是否走非NSIS7Z的进度条  
!ifdef INSTALL_WITH_NO_NSIS7Z
    !include "..\app.nsh"
!else
    File "${INSTALL_7Z_PATH}"
    GetFunctionAddress $R9 ExtractCallback
    nsis7zU::ExtractWithCallback "$INSTDIR\${INSTALL_7Z_NAME}" $R9
	Delete "$INSTDIR\${INSTALL_7Z_NAME}"
!endif
	Sleep 100
FunctionEnd



# 安装-一键安装，立即安装
Function OnBtnInstall
	; 验证用户服务协议是否勾选
    nsNiuniuSkin::GetControlAttribute $hInstallDlg "chkAgree" "selected"
    Pop $0
	StrCpy $0 "1"

	#如果未同意，直接退出 
	StrCmp $0 "0" InstallAbort 0
	
	; 路径验证
	nsNiuniuSkin::GetControlAttribute $hInstallDlg "editDir" "text"
    Pop $0
    StrCmp $0 "" InstallAbort 0
	
	#校正路径（追加）  
	Call AdjustInstallPath
	StrCpy $sSetupPath "$INSTDIR"	
	
	Call IsSetupPathIlleagal
	${If} $R5 == "0"
		StrCpy $R8 "路径非法，请使用正确的路径安装!"
		StrCpy $R7 "0"
		Call ShowMsgBox
		goto InstallAbort
    ${EndIf}	
	${If} $R5 == "-1"
		StrCpy $R8 "目标磁盘空间不足，请使用其他的磁盘安装!"
		StrCpy $R7 "0"
		Call ShowMsgBox
		goto InstallAbort
    ${EndIf}

	; 将关闭按钮设置为不可点击
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnClose" "enabled" "false"
	; 切换到安装页面
	nsNiuniuSkin::ShowPageItem $hInstallDlg "wizardTab" ${INSTALL_PAGE_PROCESSING}
    
	; 设置进度条最小值，最大值
    nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrProgress" "min" "0"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrProgress" "max" "100"

	; 设置安装提示
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "progress_tip" "text" "进程检测..."
	#验证进程是否存在
    GetFunctionAddress $0 KillProc
    BgWorker::CallAndWait
	
	Pop $R0
	; 退出安装
	${If} $R0 == 1
		#设置安装状态
		StrCpy $InstallState "1"
		#调用退出安装
		Call OnExitDUISetup
		goto InstallAbort
	${EndIf}
	
	; 设置安装提示
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "progress_tip" "text" "解压应用程序文件..."

    #启动一个低优先级的后台线程
    GetFunctionAddress $0 ExtractFunc
    BgWorker::CallAndWait

	; 文件安装完成
	push 100
	; 完成标志
	push true
	Call SetInstallProgress
	; 设置安装提示
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "progress_tip" "text" "解压完成"

	#根据复选框的值来决定是否添加任务栏快捷方式  
	nsNiuniuSkin::GetControlAttribute $hInstallDlg "chkbox_quick_start" "selected"
	Pop $R0	
	${If} $R0 == "1"	
		; 设置安装提示
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "progress_tip" "text" "创建任务栏图标"
		; 执行任务栏创建
		Call CreateBarlnk
	${Else}
		#根据复选框的值来决定是否添加桌面快捷方式  
		nsNiuniuSkin::GetControlAttribute $hInstallDlg "chkbox_desktop_ico" "selected"
		Pop $R0	
		${If} $R0 == "1"
			; 设置安装提示
			nsNiuniuSkin::SetControlAttribute $hInstallDlg "progress_tip" "text" "创建桌面图标"
			#添加到桌面快捷方式的动作在此添加  
			SetShellVarContext all
			CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${EXE_NAME}"	
			SetShellVarContext current	
		${EndIf}
	${EndIf}

	#根据复选框的值来决定是否添加开机启动
	nsNiuniuSkin::GetControlAttribute $hInstallDlg "chkbox_boot_start" "selected"
	Pop $R0	
	${If} $R0 == "1"	
		; 设置安装提示
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "progress_tip" "text" "设置开机启动"
		; 创建开机启动
		Call CreateBootStart
	${EndIf}
	
	; 设置安装提示
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "progress_tip" "text" "创建开始菜单"
	; 创建开始菜单
	Call CreateAppShortcut
	; 设置安装提示
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "progress_tip" "text" "创建卸载信息"
	; 创建卸载信息
	Call CreateUninstall

	; 设置安装提示
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "progress_tip" "text" "安装完成"
	
	; 设置关闭按钮
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnClose" "enabled" "true"		
	StrCpy $InstallState "1"
	#如果不想完成立即启动的话，需要屏蔽下面的OnFinished的调用，并且打开显示INSTALL_PAGE_FINISH
	#Call OnFinished
	#跳转至安装完成页面 
	nsNiuniuSkin::ShowPageItem $hInstallDlg "wizardTab" ${INSTALL_PAGE_FINISH}
InstallAbort:
FunctionEnd

; 安装-安装进度回调
Function ExtractCallback
	; 变更进度
	Pop $0
	; 文件数量
    Pop $1
	; 进度换算
    System::Int64Op $0 * 100
    Pop $2
	; 当前进度百分比
    System::Int64Op $2 / $1
    Pop $3

	; 插件进度判断
	${If} $PlugInInstallProgress != 0
		; 计算文件安装剩余占用百分比
    	System::Int64Op 100 - $PlugInInstallProgress
		Pop $4

		; 计算文件百分比
		System::Int64Op $3 * $4
		Pop $5

		; 百分比占用计算
		System::Int64Op $5 / 100
		Pop $6

		; 总的占用百分比
		System::Int64Op $PlugInInstallProgress + $6
		Pop $7

		; 拷贝进度
		StrCpy $3 $7
	${Endif}
	
	; 进度值
	push $3
	; 完成标志
	push false
	Call SetInstallProgress

    ${If} $1 == $0 
		; 进度值
		push 100
		; 完成标志
		push true
		Call SetInstallProgress
    ${EndIf}
FunctionEnd

#设置安装进度
Function SetInstallProgress
	; 安装完成
    Pop $0
	; 变更进度
    Pop $1

	; 进度验证
	${If} $1 > $InstallProgress
		; 拷贝安装进度
		StrCpy $InstallProgress $1
		; 设置进度
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrProgress" "value" "$InstallProgress"	
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "progress_pos" "text" "$InstallProgress%"
		; 完成验证
		${If} $0 == true
			; 设置进度
			nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrProgress" "value" "100"	
			nsNiuniuSkin::SetControlAttribute $hInstallDlg "progress_pos" "text" "100%"
		${EndIf}
	${EndIf}
FunctionEnd

#安装-CTRL+F4关闭时的事件通知 
Function OnSysCommandCloseEvent
	Call OnExitDUISetup
FunctionEnd

#安装-退出安装逻辑 
Function OnExitDUISetup
	; 安装状态验证
	${If} $InstallState == "0"		
		StrCpy $R8 "安装尚未完成，您确定退出安装么？"
		StrCpy $R7 "1"
		Call ShowMsgBox
		pop $0
		${If} $0 == 0
			goto endfun
		${EndIf}
	${EndIf}
	nsNiuniuSkin::ExitDUISetup
endfun:    
FunctionEnd

; 安装-窗口最小化
Function OnBtnMin
    SendMessage $hInstallDlg ${WM_SYSCOMMAND} 0xF020 0
FunctionEnd

; 安装-完成安装
Function OnFinished	
	#立即启动
    Exec "$INSTDIR\${EXE_NAME}"
    Call OnExitDUISetup
FunctionEnd

; 安装-选择安装路径
Function OnBtnSelectDir
    nsNiuniuSkin::SelectInstallDirEx $hInstallDlg "请选择安装路径"
    Pop $0
	${Unless} "$0" == ""
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "editDir" "text" $0
	${EndUnless}
FunctionEnd

; 安装-设置窗口高度(增加高度动画)
; Function StepHeightSizeAsc
; ${ForEach} $R0 390 500 + 10
;   nsNiuniuSkin::SetWindowSize $hInstallDlg 480 $R0
;   Sleep 5
; ${Next}
; FunctionEnd

; 安装-设置窗口高度(减少高度动画)
; Function StepHeightSizeDsc
; ${ForEach} $R0 480 390 - 10
;   nsNiuniuSkin::SetWindowSize $hInstallDlg 480 $R0
;   Sleep 5
; ${Next}
; FunctionEnd

; 安装-显示自定安装
Function OnBtnShowMore	
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "defalutconfiginfo" "visible" "false"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "moreconfiginfo" "visible" "true"
	; ;调整窗口高度 (包含动画)
	;  GetFunctionAddress $0 StepHeightSizeAsc
    ; BgWorker::CallAndWait
	; nsNiuniuSkin::SetWindowSize $hInstallDlg 480 500
FunctionEnd

; 安装-显示默认安装界面
Function OnBtnHideMore
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "defalutconfiginfo" "visible" "true"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "moreconfiginfo" "visible" "false"
	; ;调整窗口高度 (包含动画)
	;  GetFunctionAddress $0 StepHeightSizeDsc
    ; BgWorker::CallAndWait
	; nsNiuniuSkin::SetWindowSize $hInstallDlg 480 390
FunctionEnd

; 安装-隐藏用户服务窗口
Function OnBtnShowConfig
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "licenseshow" "visible" "false"
FunctionEnd

; 卸载-弹出对话框
Function un.ShowMsgBox
	; 初始化窗口
	nsNiuniuSkin::InitSkinSubPage "msgBox.xml" "btnOK" "btnCancel,btnClose"
	Pop $hInstallSubDlg
	; 初始窗口标题
	nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "lblTitle" "text" "提示"
	; 初始化提示内容
	nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "lblMsg" "text" "$R8"

	; 显示确认与取消按钮
	${If} "$R7" == "1"
		; 更新确认按钮坐标
		nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "btnOK" "pos" "50,0,150,40"
		; 显示取消按钮
		nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "btnCancel" "visible" "true"
	; 仅显示确认按钮
	${Else}
		; 更新确认按钮坐标
		nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "btnOK" "pos" "150,0,250,40"
		; 显示取消按钮
		nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "btnCancel" "visible" "false"
	${EndIf}
	nsNiuniuSkin::ShowSkinSubPage 0 
FunctionEnd

; 卸载-退出
Function un.ExitDUISetup
	nsNiuniuSkin::ExitDUISetup
FunctionEnd


# 卸载-添加一个静默卸载的入口 
Section "un.silentInstallSec" SEC02
    #MessageBox MB_OK|MB_ICONINFORMATION "Test silent install. you can add your silent uninstall code here."
SectionEnd

; 卸载-结束进程
; 返回0 表示结束成功 返回1 表示退出安装
Function un.KillProc
	#此处检测当前是否有程序正在运行，如果正在运行，提示先卸载再安装 
	nsProcess::_FindProcess "${EXE_NAME}"
	Pop $R0

	#验证查询结果
	${If} $R0 == 0
		; 设置安装提示
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "un_progress_tip" "text" "正在安全的退出进程,请稍后..."
		#结束进程
		KillProcDLL::KillProc "${EXE_NAME}"
		#循环验证
   		${For} $R1 0 100
		   	#等待100毫秒再查询结果
      		Sleep 100
			#接收结果
			nsProcess::_FindProcess "${EXE_NAME}"
			#检测进程
			Pop $R0
			; 判断进程是否存在
			${If} $R0 != 0
				#设置返回值
				push 0
				; 查找进程结束
				goto KillProcEnd
			${EndIf}
		${Next}

		; 弹框提示
        StrCpy $R8 "我们无法安全的结束正在运行的 ${EXE_NAME} 应用程序,请手动退出QQMusic应用程序,再尝试卸载!"
		StrCpy $R7 "0"
		Call un.ShowMsgBox
		#设置返回值
		push 1
	; 结束
	KillProcEnd:
    ${EndIf}
FunctionEnd

;卸载时删除快捷方式 
Function un.DelBarlnk
  ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" "CurrentVersion"  
  ${if} $R0 >= 6.0  
  ;win10系统会有问题
  ExecShell taskbarunpin "$DESKTOP\${PRODUCT_NAME}.lnk"
  ${StdUtils.InvokeShellVerb} $0 "$INSTDIR" "${EXE_NAME}" ${StdUtils.Const.ShellVerb.UnpinFromTaskbar}

  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"  
  ${else}  
  delete "$QUICKLAUNCH\${PRODUCT_NAME}.lnk"  
  ${Endif}  
FunctionEnd

;卸载时删除开机启动 
Function un.DelBootStart
  DeleteRegValue HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "${PRODUCT_NAME}"
FunctionEnd

#卸载-执行具体的卸载 
Function un.onUninstall
	; 保存数据选项验证
	nsNiuniuSkin::GetControlAttribute $hInstallDlg "chkbox_userdata" "selected"
    Pop $0
	StrCpy $sReserveData $0

	Pop $R0
	; 退出安装
	${If} $R0 == 1
		#设置安装状态
		StrCpy $InstallState "1"
		#调用退出卸载
		Call un.ExitDUISetup
		goto InstallAbort
	${EndIf}

	; 关闭按钮设置不可点击
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnClose" "enabled" "false"
	; 跳转到卸载分页
	nsNiuniuSkin::ShowPageItem $hInstallDlg "wizardTab" ${INSTALL_PAGE_UNISTPROCESSING}
	
	; 设置卸载进度条
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrUnInstProgress" "min" "0"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrUnInstProgress" "max" "100"

	; 设置卸载提示
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "un_progress_tip" "text" "正在卸载,请稍后..."

	; 变更卸载进度
	IntOp $UnInstallValue 0 + 1
	
	; 设置进度条
	Call un.SetProgress
	#验证进程是否存在
    GetFunctionAddress $0 un.KillProc
    BgWorker::CallAndWait

	; 设置卸载提示
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "un_progress_tip" "text" "删除图标及卸载信息"

	; 变更卸载进度
	IntOp $UnInstallValue $UnInstallValue + 5
	; 设置进度条
	Call un.SetProgress

	; 删除桌面图标及卸载信息
	Call un.DeleteShotcutAndInstallInfo
	; 删除任务栏快捷方式
	Call un.DelBarlnk
	; 删除开机启动
	Call un.DelBootStart
	; 变更卸载进度
	IntOp $UnInstallValue $UnInstallValue + 8
	; 设置进度条
	Call un.SetProgress

	#删除文件
	GetFunctionAddress $0 un.RemoveFiles
    BgWorker::CallAndWait
	; 设置卸载提示
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "un_progress_tip" "text" "卸载完成"
	InstallAbort:
FunctionEnd

#在线程中删除文件，以便显示进度 
Function un.RemoveFiles
	; 设置卸载提示
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "un_progress_tip" "text" "删除安装文件..."
	#删除安装目录文件
	${Locate} "$INSTDIR" "/G=0 /M=*.*" "un.onDeleteFileFound"
	; 删除安装目录
	RMDir "$INSTDIR"

	; 验证是否删除用户配置
	${If} $sReserveData == 0
		; 设置卸载提示
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "un_progress_tip" "text" "删除用户配置..."
		#清理文件
		${Locate} "${LOCAL_APPDATA_DIR}" "/G=0 /M=*.*" "un.onDeleteFileFound"
		; 删除配置目录
		RMDir "${LOCAL_APPDATA_DIR}"
	${EndIf}

	; 设置卸载状态
	StrCpy $InstallState "1"
	; 设置关闭按钮状态
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnClose" "enabled" "true"
	; 变更卸载进度
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrUnInstProgress" "value" "100"
	; 跳转至卸载完成页面
	nsNiuniuSkin::ShowPageItem $hInstallDlg "wizardTab" ${INSTALL_PAGE_UNISTFINISH}
FunctionEnd


#卸载程序时删除文件的流程，如果有需要过滤的文件，在此函数中添加  
Function un.onDeleteFileFound
    ; $R9    "path\name"
    ; $R8    "path"
    ; $R7    "name"
    ; $R6    "size"  ($R6 = "" if directory, $R6 = "0" if file with /S=)

	#是否过滤删除  
	Delete "$R9"
	RMDir /r "$R9"
    RMDir "$R9"
	
	#变更卸载进度
	IntOp $UnInstallValue $UnInstallValue + 2
	; 验证卸载进度
	${If} $UnInstallValue > 100
		IntOp $UnInstallValue 100 + 0
		; 设置进度条
		Call un.SetProgress
	${Else}
		; 设置进度条
		Call un.SetProgress
	${EndIf}	
	undelete:
	Push "LocateNext"	
FunctionEnd

; 设置卸载进度条
Function un.SetProgress
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrUnInstProgress" "value" "$UnInstallValue"	
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "un_progress_pos" "text" "$UnInstallValue%"
FunctionEnd