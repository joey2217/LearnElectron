
::chcp 65001

cd /d %~dp0

@set DestPath=%cd%\FilesToInstall\
@echo off& setlocal EnableDelayedExpansion
@set DestFiles=%cd%\SetupScripts\app.nsh
if exist %DestFiles% del /f %DestFiles%
@set total=1

@echo off

@rem ͳ���ļ����� 
for /f  "tokens=*" %%a in ('dir /s/b/a-d %DestPath%') do (
	@set /a total+=1
)

@set curr=0
@set tmpValue=1

@rem ���׼�Ŀ¼���� 
for /f "delims=*" %%d in ('dir /a-d/b %DestPath%') do (
	set /a curr+=1
	@echo Push !total!  >> %DestFiles%
	@echo Push !curr!  >> %DestFiles%
	@echo Call ExtractCallback >> %DestFiles%
	@echo File "%DestPath%%%d"  >> %DestFiles%
	@rem @echo  "%%d"
)

@rem ѭ������������Ŀ¼�����д�������NSISָ�� 
@set dstString=
for /f "delims=*" %%a in ('dir /s/ad/b %DestPath%') do (


	@set foldername=%%a
	@set "foldername=!foldername:%DestPath%=%dstString%!"
	@rem @echo !foldername!
	@rem ��ȡ������ص�Ŀ¼ ����OutputPath

	@echo SetOutPath "$INSTDIR\!foldername!" >> %DestFiles%

	@rem �ж��ļ����Ƿ�Ϊ��
	dir /a /s /b %%a | findstr . >nul && (
		@rem ѭ�����µ��ļ�
		for /f "delims=*" %%c in ('dir /a-d/b %%a') do (
			@set /a curr+=1
			@echo Push !total!  >> %DestFiles%
			@echo Push !curr!  >> %DestFiles%
			@echo Call ExtractCallback >> %DestFiles%
			@echo File "%%a\%%c"  >> %DestFiles%
			@rem @echo  "%%c"
		)
	)
)
@echo Push %total%  >> %DestFiles%
@echo Push %total%  >> %DestFiles%
@echo Call ExtractCallback >> %DestFiles%

::chcp 936 
