# Microsoft Developer Studio Project File - Name="ruby18g" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** 編集しないでください **

# TARGTYPE "Win32 (x86) Application" 0x0101

CFG=ruby18g - Win32 Debug
!MESSAGE これは有効なﾒｲｸﾌｧｲﾙではありません。 このﾌﾟﾛｼﾞｪｸﾄをﾋﾞﾙﾄﾞするためには NMAKE を使用してください。
!MESSAGE [ﾒｲｸﾌｧｲﾙのｴｸｽﾎﾟｰﾄ] ｺﾏﾝﾄﾞを使用して実行してください
!MESSAGE 
!MESSAGE NMAKE /f "ruby18g.mak".
!MESSAGE 
!MESSAGE NMAKE の実行時に構成を指定できます
!MESSAGE ｺﾏﾝﾄﾞ ﾗｲﾝ上でﾏｸﾛの設定を定義します。例:
!MESSAGE 
!MESSAGE NMAKE /f "ruby18g.mak" CFG="ruby18g - Win32 Debug"
!MESSAGE 
!MESSAGE 選択可能なﾋﾞﾙﾄﾞ ﾓｰﾄﾞ:
!MESSAGE 
!MESSAGE "ruby18g - Win32 Release" ("Win32 (x86) Application" 用)
!MESSAGE "ruby18g - Win32 Debug" ("Win32 (x86) Application" 用)
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "ruby18g - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "bin\release"
# PROP Intermediate_Dir "obj\release"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /MD /W3 /GX /O1 /I "..\libruby18\src" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "NT" /D "_WIN32" /D "RUBY_EXPORT" /YX /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x411 /d "NDEBUG"
# ADD RSC /l 0x411 /d "NDEBUG" /d "GUI"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib wsock32.lib /nologo /subsystem:windows /machine:I386 /out:"bin\release/ruby186g.exc"
# Begin Special Build Tool
TargetPath=.\bin\release\ruby186g.exc
SOURCE="$(InputPath)"
PostBuild_Cmds=copy $(TargetPath) ..\..\data\exerb
# End Special Build Tool

!ELSEIF  "$(CFG)" == "ruby18g - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "bin\debug"
# PROP Intermediate_Dir "obj\debug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /YX /FD /GZ /c
# ADD CPP /nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\libruby18\src" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "NT" /D "_WIN32" /D "RUBY_EXPORT" /YX /FD /GZ /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x411 /d "_DEBUG"
# ADD RSC /l 0x411 /d "_DEBUG" /d "GUI"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib wsock32.lib /nologo /subsystem:windows /debug /machine:I386 /out:"bin\debug/ruby186gd.exc" /pdbtype:sept
# Begin Special Build Tool
TargetPath=.\bin\debug\ruby186gd.exc
SOURCE="$(InputPath)"
PostBuild_Cmds=copy $(TargetPath) ..\..\data\exerb
# End Special Build Tool

!ENDIF 

# Begin Target

# Name "ruby18g - Win32 Release"
# Name "ruby18g - Win32 Debug"
# Begin Source File

SOURCE=..\exerb\exerb.cpp
# End Source File
# Begin Source File

SOURCE=..\exerb\exerb.h
# End Source File
# Begin Source File

SOURCE=..\exerb\gui.cpp
# End Source File
# Begin Source File

SOURCE=..\libruby18\libruby18_standalone.def
# End Source File
# Begin Source File

SOURCE=..\exerb\module.cpp
# End Source File
# Begin Source File

SOURCE=..\exerb\module.h
# End Source File
# Begin Source File

SOURCE=..\exerb\resource.h
# End Source File
# Begin Source File

SOURCE=..\exerb\resource.rc
# End Source File
# Begin Source File

SOURCE=..\exerb\utility.cpp
# End Source File
# Begin Source File

SOURCE=..\exerb\utility.h
# End Source File
# End Target
# End Project
