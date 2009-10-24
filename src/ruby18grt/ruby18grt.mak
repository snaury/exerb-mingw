# Microsoft Developer Studio Generated NMAKE File, Based on ruby18grt.dsp
!IF "$(CFG)" == ""
CFG=ruby18grt - Win32 Debug
!MESSAGE 構成が指定されていません。ﾃﾞﾌｫﾙﾄの ruby18grt - Win32 Debug を設定します。
!ENDIF 

!IF "$(CFG)" != "ruby18grt - Win32 Release" && "$(CFG)" != "ruby18grt - Win32 Debug"
!MESSAGE 指定された ﾋﾞﾙﾄﾞ ﾓｰﾄﾞ "$(CFG)" は正しくありません。
!MESSAGE NMAKE の実行時に構成を指定できます
!MESSAGE ｺﾏﾝﾄﾞ ﾗｲﾝ上でﾏｸﾛの設定を定義します。例:
!MESSAGE 
!MESSAGE NMAKE /f "ruby18grt.mak" CFG="ruby18grt - Win32 Debug"
!MESSAGE 
!MESSAGE 選択可能なﾋﾞﾙﾄﾞ ﾓｰﾄﾞ:
!MESSAGE 
!MESSAGE "ruby18grt - Win32 Release" ("Win32 (x86) Application" 用)
!MESSAGE "ruby18grt - Win32 Debug" ("Win32 (x86) Application" 用)
!MESSAGE 
!ERROR 無効な構成が指定されています。
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "ruby18grt - Win32 Release"

OUTDIR=.\bin\release
INTDIR=.\obj\release
# Begin Custom Macros
OutDir=.\bin\release
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\ruby182grt.exc"

!ELSE 

ALL : "libexerb - Win32 Release" "$(OUTDIR)\ruby182grt.exc"

!ENDIF 

!IF "$(RECURSE)" == "1" 
CLEAN :"libexerb - Win32 ReleaseCLEAN" 
!ELSE 
CLEAN :
!ENDIF 
	-@erase "$(INTDIR)\gui.obj"
	-@erase "$(INTDIR)\resource.res"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\ruby182grt.exc"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

"$(INTDIR)" :
    if not exist "$(INTDIR)/$(NULL)" mkdir "$(INTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O1 /I "..\libruby18\src" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "NT" /D "_WIN32" /D "RUBY_EXPORT" /Fp"$(INTDIR)\ruby18grt.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "NDEBUG" /mktyplib203 /win32 
RSC=rc.exe
RSC_PROJ=/l 0x411 /fo"$(INTDIR)\resource.res" /d "NDEBUG" /d "GUI" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\ruby18grt.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\ruby182grt.pdb" /machine:I386 /def:"..\libruby18\libruby18_runtime.def" /out:"$(OUTDIR)\ruby182grt.exc" 
DEF_FILE= \
	"..\libruby18\libruby18_runtime.def"
LINK32_OBJS= \
	"$(INTDIR)\gui.obj" \
	"$(INTDIR)\resource.res" \
	"..\libexerb\lib\release\exerb40.lib"

"$(OUTDIR)\ruby182grt.exc" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

TargetPath=.\bin\release\ruby182grt.exc
SOURCE="$(InputPath)"
DS_POSTBUILD_DEP=$(INTDIR)\postbld.dep

ALL : $(DS_POSTBUILD_DEP)

# Begin Custom Macros
OutDir=.\bin\release
# End Custom Macros

$(DS_POSTBUILD_DEP) : "libexerb - Win32 Release" "$(OUTDIR)\ruby182grt.exc"
   copy .\bin\release\ruby182grt.exc ..\..\data\exerb
	echo Helper for Post-build step > "$(DS_POSTBUILD_DEP)"

!ELSEIF  "$(CFG)" == "ruby18grt - Win32 Debug"

OUTDIR=.\bin\debug
INTDIR=.\obj\debug
# Begin Custom Macros
OutDir=.\bin\debug
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\ruby182grtd.exc"

!ELSE 

ALL : "libexerb - Win32 Debug" "$(OUTDIR)\ruby182grtd.exc"

!ENDIF 

!IF "$(RECURSE)" == "1" 
CLEAN :"libexerb - Win32 DebugCLEAN" 
!ELSE 
CLEAN :
!ENDIF 
	-@erase "$(INTDIR)\gui.obj"
	-@erase "$(INTDIR)\resource.res"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\ruby182grtd.exc"
	-@erase "$(OUTDIR)\ruby182grtd.ilk"
	-@erase "$(OUTDIR)\ruby182grtd.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

"$(INTDIR)" :
    if not exist "$(INTDIR)/$(NULL)" mkdir "$(INTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\libruby18\src" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "NT" /D "_WIN32" /D "RUBY_EXPORT" /Fp"$(INTDIR)\ruby18grt.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /win32 
RSC=rc.exe
RSC_PROJ=/l 0x411 /fo"$(INTDIR)\resource.res" /d "_DEBUG" /d "GUI" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\ruby18grt.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\ruby182grtd.pdb" /debug /machine:I386 /def:"..\libruby18\libruby18_runtime.def" /out:"$(OUTDIR)\ruby182grtd.exc" /pdbtype:sept 
DEF_FILE= \
	"..\libruby18\libruby18_runtime.def"
LINK32_OBJS= \
	"$(INTDIR)\gui.obj" \
	"$(INTDIR)\resource.res" \
	"..\libexerb\lib\debug\exerb40.lib"

"$(OUTDIR)\ruby182grtd.exc" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

TargetPath=.\bin\debug\ruby182grtd.exc
SOURCE="$(InputPath)"
DS_POSTBUILD_DEP=$(INTDIR)\postbld.dep

ALL : $(DS_POSTBUILD_DEP)

# Begin Custom Macros
OutDir=.\bin\debug
# End Custom Macros

$(DS_POSTBUILD_DEP) : "libexerb - Win32 Debug" "$(OUTDIR)\ruby182grtd.exc"
   copy .\bin\debug\ruby182grtd.exc ..\..\data\exerb
	echo Helper for Post-build step > "$(DS_POSTBUILD_DEP)"

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("ruby18grt.dep")
!INCLUDE "ruby18grt.dep"
!ELSE 
!MESSAGE Warning: cannot find "ruby18grt.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "ruby18grt - Win32 Release" || "$(CFG)" == "ruby18grt - Win32 Debug"

!IF  "$(CFG)" == "ruby18grt - Win32 Release"

"libexerb - Win32 Release" : 
   cd "\home\personal\development\sf.jp\exerb\src\libexerb"
   $(MAKE) /$(MAKEFLAGS) /F .\libexerb.mak CFG="libexerb - Win32 Release" 
   cd "..\ruby18grt"

"libexerb - Win32 ReleaseCLEAN" : 
   cd "\home\personal\development\sf.jp\exerb\src\libexerb"
   $(MAKE) /$(MAKEFLAGS) /F .\libexerb.mak CFG="libexerb - Win32 Release" RECURSE=1 CLEAN 
   cd "..\ruby18grt"

!ELSEIF  "$(CFG)" == "ruby18grt - Win32 Debug"

"libexerb - Win32 Debug" : 
   cd "\home\personal\development\sf.jp\exerb\src\libexerb"
   $(MAKE) /$(MAKEFLAGS) /F .\libexerb.mak CFG="libexerb - Win32 Debug" 
   cd "..\ruby18grt"

"libexerb - Win32 DebugCLEAN" : 
   cd "\home\personal\development\sf.jp\exerb\src\libexerb"
   $(MAKE) /$(MAKEFLAGS) /F .\libexerb.mak CFG="libexerb - Win32 Debug" RECURSE=1 CLEAN 
   cd "..\ruby18grt"

!ENDIF 

SOURCE=..\exerb\gui.cpp

"$(INTDIR)\gui.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\exerb\resource.rc

!IF  "$(CFG)" == "ruby18grt - Win32 Release"


"$(INTDIR)\resource.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) /l 0x411 /fo"$(INTDIR)\resource.res" /i "\home\personal\development\sf.jp\exerb\src\exerb" /d "NDEBUG" /d "GUI" $(SOURCE)


!ELSEIF  "$(CFG)" == "ruby18grt - Win32 Debug"


"$(INTDIR)\resource.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) /l 0x411 /fo"$(INTDIR)\resource.res" /i "\home\personal\development\sf.jp\exerb\src\exerb" /d "_DEBUG" /d "GUI" $(SOURCE)


!ENDIF 


!ENDIF 

