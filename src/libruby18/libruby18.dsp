# Microsoft Developer Studio Project File - Name="libruby18" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** 編集しないでください **

# TARGTYPE "Win32 (x86) Static Library" 0x0104

CFG=libruby18 - Win32 Debug
!MESSAGE これは有効なﾒｲｸﾌｧｲﾙではありません。 このﾌﾟﾛｼﾞｪｸﾄをﾋﾞﾙﾄﾞするためには NMAKE を使用してください。
!MESSAGE [ﾒｲｸﾌｧｲﾙのｴｸｽﾎﾟｰﾄ] ｺﾏﾝﾄﾞを使用して実行してください
!MESSAGE 
!MESSAGE NMAKE /f "libruby18.mak".
!MESSAGE 
!MESSAGE NMAKE の実行時に構成を指定できます
!MESSAGE ｺﾏﾝﾄﾞ ﾗｲﾝ上でﾏｸﾛの設定を定義します。例:
!MESSAGE 
!MESSAGE NMAKE /f "libruby18.mak" CFG="libruby18 - Win32 Debug"
!MESSAGE 
!MESSAGE 選択可能なﾋﾞﾙﾄﾞ ﾓｰﾄﾞ:
!MESSAGE 
!MESSAGE "libruby18 - Win32 Release" ("Win32 (x86) Static Library" 用)
!MESSAGE "libruby18 - Win32 Debug" ("Win32 (x86) Static Library" 用)
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "libruby18 - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "lib\release"
# PROP Intermediate_Dir "obj\release"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_MBCS" /D "_LIB" /YX /FD /c
# ADD CPP /nologo /MD /w /W0 /GX /O1 /I "src" /D "WIN32" /D "NDEBUG" /D "_MBCS" /D "_LIB" /D "NT" /D "_WIN32" /D "RUBY_EXPORT" /YX /FD /c
# ADD BASE RSC /l 0x411 /d "NDEBUG"
# ADD RSC /l 0x411 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ELSEIF  "$(CFG)" == "libruby18 - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "lib\debug"
# PROP Intermediate_Dir "obj\debug"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_MBCS" /D "_LIB" /YX /FD /GZ /c
# ADD CPP /nologo /MDd /w /W0 /Gm /GX /ZI /Od /I "src" /D "WIN32" /D "_DEBUG" /D "_MBCS" /D "_LIB" /D "NT" /D "_WIN32" /D "RUBY_EXPORT" /YX /FD /GZ /c
# ADD BASE RSC /l 0x411 /d "_DEBUG"
# ADD RSC /l 0x411 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ENDIF 

# Begin Target

# Name "libruby18 - Win32 Release"
# Name "libruby18 - Win32 Debug"
# Begin Group "missing"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\src\missing\acosh.c
# End Source File
# Begin Source File

SOURCE=.\src\missing\crypt.c
# End Source File
# Begin Source File

SOURCE=.\src\missing\erf.c
# End Source File
# Begin Source File

SOURCE=.\src\missing\file.h
# End Source File
# Begin Source File

SOURCE=.\src\missing\finite.c
# End Source File
# Begin Source File

SOURCE=.\src\missing\isinf.c
# End Source File
# Begin Source File

SOURCE=.\src\missing\isnan.c
# End Source File
# End Group
# Begin Group "win32"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\src\win32\dir.h
# End Source File
# Begin Source File

SOURCE=.\src\win32\win32.c
# End Source File
# Begin Source File

SOURCE=.\src\win32\win32.h
# End Source File
# End Group
# Begin Source File

SOURCE=.\src\array.c
# End Source File
# Begin Source File

SOURCE=.\src\bignum.c
# End Source File
# Begin Source File

SOURCE=.\src\class.c
# End Source File
# Begin Source File

SOURCE=.\src\compar.c
# End Source File
# Begin Source File

SOURCE=.\src\config.h
# End Source File
# Begin Source File

SOURCE=.\src\defines.h
# End Source File
# Begin Source File

SOURCE=.\src\dir.c
# End Source File
# Begin Source File

SOURCE=.\src\dln.c
# End Source File
# Begin Source File

SOURCE=.\src\dln.h
# End Source File
# Begin Source File

SOURCE=.\src\dmyext.c
# End Source File
# Begin Source File

SOURCE=.\src\enum.c
# End Source File
# Begin Source File

SOURCE=.\src\env.h
# End Source File
# Begin Source File

SOURCE=.\src\error.c
# End Source File
# Begin Source File

SOURCE=.\src\eval.c
# PROP Exclude_From_Build 1
# End Source File
# Begin Source File

SOURCE=.\src\eval_exerb.c
# End Source File
# Begin Source File

SOURCE=.\src\file.c
# End Source File
# Begin Source File

SOURCE=.\src\gc.c
# End Source File
# Begin Source File

SOURCE=.\src\hash.c
# End Source File
# Begin Source File

SOURCE=.\src\inits.c
# End Source File
# Begin Source File

SOURCE=.\src\intern.h
# End Source File
# Begin Source File

SOURCE=.\src\io.c
# End Source File
# Begin Source File

SOURCE=.\src\lex.c
# PROP Exclude_From_Build 1
# End Source File
# Begin Source File

SOURCE=.\src\marshal.c
# End Source File
# Begin Source File

SOURCE=.\src\math.c
# End Source File
# Begin Source File

SOURCE=.\src\missing.h
# End Source File
# Begin Source File

SOURCE=.\src\node.h
# End Source File
# Begin Source File

SOURCE=.\src\numeric.c
# End Source File
# Begin Source File

SOURCE=.\src\object.c
# End Source File
# Begin Source File

SOURCE=.\src\pack.c
# End Source File
# Begin Source File

SOURCE=.\src\parse.c
# End Source File
# Begin Source File

SOURCE=.\src\prec.c
# End Source File
# Begin Source File

SOURCE=.\src\process.c
# End Source File
# Begin Source File

SOURCE=.\src\random.c
# End Source File
# Begin Source File

SOURCE=.\src\range.c
# End Source File
# Begin Source File

SOURCE=.\src\re.c
# End Source File
# Begin Source File

SOURCE=.\src\re.h
# End Source File
# Begin Source File

SOURCE=.\src\regex.c
# End Source File
# Begin Source File

SOURCE=.\src\regex.h
# End Source File
# Begin Source File

SOURCE=.\src\ruby.c
# End Source File
# Begin Source File

SOURCE=.\src\ruby.h
# End Source File
# Begin Source File

SOURCE=.\src\rubyio.h
# End Source File
# Begin Source File

SOURCE=.\src\rubysig.h
# End Source File
# Begin Source File

SOURCE=.\src\signal.c
# End Source File
# Begin Source File

SOURCE=.\src\sprintf.c
# End Source File
# Begin Source File

SOURCE=.\src\st.c
# End Source File
# Begin Source File

SOURCE=.\src\st.h
# End Source File
# Begin Source File

SOURCE=.\src\string.c
# End Source File
# Begin Source File

SOURCE=.\src\struct.c
# End Source File
# Begin Source File

SOURCE=.\src\time.c
# End Source File
# Begin Source File

SOURCE=.\src\util.c
# End Source File
# Begin Source File

SOURCE=.\src\util.h
# End Source File
# Begin Source File

SOURCE=.\src\variable.c
# End Source File
# Begin Source File

SOURCE=.\src\version.c
# End Source File
# Begin Source File

SOURCE=.\src\version.h
# End Source File
# End Target
# End Project
