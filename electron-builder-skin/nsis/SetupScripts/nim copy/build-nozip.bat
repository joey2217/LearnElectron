@rem ���ǲ���ѹ���Ĵ���ű�

cd /d %~dp0

@call ../../makensiscode.bat

cd /d %~dp0

@call ../../makeskinzip.bat nim

cd /d %~dp0

@rem �������õĳ�������ļ��в������򴴽�
if not exist "..\..\Output" md "..\..\Output"

"..\..\NSIS\makensis.exe" /DINSTALL_WITH_NO_NSIS7Z=1 ".\info.nsi"

@rem ���Ҫ���Դ�����ʹ������Ľű���������򿪱�����棨�����н������Ļ���ʾ��?�ţ�
@rem "..\..\NSIS\makensisw.exe" /DINSTALL_WITH_NO_NSIS7Z=1 ".\info.nsi"

cd /d %~dp0

if exist ".\skin.zip" del /f ".\skin.zip"

if exist "..\app.nsh" del /f "..\app.nsh"

if exist "..\app.7z" del /f "..\app.7z"

@pause