# Microsoft Developer Studio Generated NMAKE File, Based on libexerb.dsp
!IF "$(CFG)" == ""
CFG=libexerb - Win32 Debug
!MESSAGE 構成が指定されていません。ﾃﾞﾌｫﾙﾄの libexerb - Win32 Debug を設定します。
!ENDIF 

!IF "$(CFG)" != "libexerb - Win32 Release" && "$(CFG)" != "libexerb - Win32 Debug"
!MESSAGE 指定された ﾋﾞﾙﾄﾞ ﾓｰﾄﾞ "$(CFG)" は正しくありません。
!MESSAGE NMAKE の実行時に構成を指定できます
!MESSAGE ｺﾏﾝﾄﾞ ﾗｲﾝ上でﾏｸﾛの設定を定義します。例:
!MESSAGE 
!MESSAGE NMAKE /f "libexerb.mak" CFG="libexerb - Win32 Debug"
!MESSAGE 
!MESSAGE 選択可能なﾋﾞﾙﾄﾞ ﾓｰﾄﾞ:
!MESSAGE 
!MESSAGE "libexerb - Win32 Release" ("Win32 (x86) Dynamic-Link Library" 用)
!MESSAGE "libexerb - Win32 Debug" ("Win32 (x86) Dynamic-Link Library" 用)
!MESSAGE 
!ERROR 無効な構成が指定されています。
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "libexerb - Win32 Release"

OUTDIR=.\lib\release
INTDIR=.\obj\release
# Begin Custom Macros
OutDir=.\lib\release
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\exerb40.dll"

!ELSE 

ALL : "libruby18 - Win32 Release" "$(OUTDIR)\exerb40.dll"

!ENDIF 

!IF "$(RECURSE)" == "1" 
CLEAN :"libruby18 - Win32 ReleaseCLEAN" 
!ELSE 
CLEAN :
!ENDIF 
	-@erase "$(INTDIR)\exerb.obj"
	-@erase "$(INTDIR)\module.obj"
	-@erase "$(INTDIR)\resource.res"
	-@erase "$(INTDIR)\utility.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\exerb40.dll"
	-@erase "$(OUTDIR)\exerb40.exp"
	-@erase "$(OUTDIR)\exerb40.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

"$(INTDIR)" :
    if not exist "$(INTDIR)/$(NULL)" mkdir "$(INTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O1 /I "..\libruby18\src" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "NT" /D "_WIN32" /D "RUBY_EXPORT" /Fp"$(INTDIR)\libexerb.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
RSC_PROJ=/l 0x411 /fo"$(INTDIR)\resource.res" /d "NDEBUG" /d "RUNTIME" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\libexerb.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib wsock32.lib /nologo /dll /incremental:no /pdb:"$(OUTDIR)\exerb40.pdb" /machine:I386 /def:"..\libruby18\libruby18_standalone.def" /out:"$(OUTDIR)\exerb40.dll" /implib:"$(OUTDIR)\exerb40.lib" 
DEF_FILE= \
	"..\libruby18\libruby18_standalone.def"
LINK32_OBJS= \
	"$(INTDIR)\exerb.obj" \
	"$(INTDIR)\module.obj" \
	"$(INTDIR)\utility.obj" \
	"$(INTDIR)\resource.res" \
	"..\libruby18\lib\release\libruby18.lib"

"$(OUTDIR)\exerb40.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

TargetPath=.\lib\release\exerb40.dll
SOURCE="$(InputPath)"
DS_POSTBUILD_DEP=$(INTDIR)\postbld.dep

ALL : $(DS_POSTBUILD_DEP)

# Begin Custom Macros
OutDir=.\lib\release
# End Custom Macros

$(DS_POSTBUILD_DEP) : "libruby18 - Win32 Release" "$(OUTDIR)\exerb40.dll"
   copy .\lib\release\exerb40.dll ..\..\data\exerb
	echo Helper for Post-build step > "$(DS_POSTBUILD_DEP)"

!ELSEIF  "$(CFG)" == "libexerb - Win32 Debug"

OUTDIR=.\lib\debug
INTDIR=.\obj\debug
# Begin Custom Macros
OutDir=.\lib\debug
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\exerb40.dll"

!ELSE 

ALL : "libruby18 - Win32 Debug" "$(OUTDIR)\exerb40.dll"

!ENDIF 

!IF "$(RECURSE)" == "1" 
CLEAN :"libruby18 - Win32 DebugCLEAN" 
!ELSE 
CLEAN :
!ENDIF 
	-@erase "$(INTDIR)\exerb.obj"
	-@erase "$(INTDIR)\module.obj"
	-@erase "$(INTDIR)\resource.res"
	-@erase "$(INTDIR)\utility.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\exerb40.dll"
	-@erase "$(OUTDIR)\exerb40.exp"
	-@erase "$(OUTDIR)\exerb40.ilk"
	-@erase "$(OUTDIR)\exerb40.lib"
	-@erase "$(OUTDIR)\exerb40.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

"$(INTDIR)" :
    if not exist "$(INTDIR)/$(NULL)" mkdir "$(INTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\libruby18\src" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "NT" /D "_WIN32" /D "RUBY_EXPORT" /Fp"$(INTDIR)\libexerb.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
RSC_PROJ=/l 0x411 /fo"$(INTDIR)\resource.res" /d "_DEBUG" /d "RUNTIME" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\libexerb.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib wsock32.lib /nologo /dll /incremental:yes /pdb:"$(OUTDIR)\exerb40.pdb" /debug /machine:I386 /def:"..\libruby18\libruby18_standalone.def" /out:"$(OUTDIR)\exerb40.dll" /implib:"$(OUTDIR)\exerb40.lib" /pdbtype:sept 
DEF_FILE= \
	"..\libruby18\libruby18_standalone.def"
LINK32_OBJS= \
	"$(INTDIR)\exerb.obj" \
	"$(INTDIR)\module.obj" \
	"$(INTDIR)\utility.obj" \
	"$(INTDIR)\resource.res" \
	"..\libruby18\lib\debug\libruby18.lib"

"$(OUTDIR)\exerb40.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("libexerb.dep")
!INCLUDE "libexerb.dep"
!ELSE 
!MESSAGE Warning: cannot find "libexerb.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "libexerb - Win32 Release" || "$(CFG)" == "libexerb - Win32 Debug"

!IF  "$(CFG)" == "libexerb - Win32 Release"

"libruby18 - Win32 Release" : 
   cd "\home\personal\development\sf.jp\exerb\src\libruby18"
   $(MAKE) /$(MAKEFLAGS) /F .\libruby18.mak CFG="libruby18 - Win32 Release" 
   cd "..\libexerb"

"libruby18 - Win32 ReleaseCLEAN" : 
   cd "\home\personal\development\sf.jp\exerb\src\libruby18"
   $(MAKE) /$(MAKEFLAGS) /F .\libruby18.mak CFG="libruby18 - Win32 Release" RECURSE=1 CLEAN 
   cd "..\libexerb"

!ELSEIF  "$(CFG)" == "libexerb - Win32 Debug"

"libruby18 - Win32 Debug" : 
   cd "\home\personal\development\sf.jp\exerb\src\libruby18"
   $(MAKE) /$(MAKEFLAGS) /F .\libruby18.mak CFG="libruby18 - Win32 Debug" 
   cd "..\libexerb"

"libruby18 - Win32 DebugCLEAN" : 
   cd "\home\personal\development\sf.jp\exerb\src\libruby18"
   $(MAKE) /$(MAKEFLAGS) /F .\libruby18.mak CFG="libruby18 - Win32 Debug" RECURSE=1 CLEAN 
   cd "..\libexerb"

!ENDIF 

SOURCE=..\exerb\exerb.cpp

"$(INTDIR)\exerb.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\exerb\module.cpp

"$(INTDIR)\module.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\exerb\resource.rc

!IF  "$(CFG)" == "libexerb - Win32 Release"


"$(INTDIR)\resource.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) /l 0x411 /fo"$(INTDIR)\resource.res" /i "\home\personal\development\sf.jp\exerb\src\exerb" /d "NDEBUG" /d "RUNTIME" $(SOURCE)


!ELSEIF  "$(CFG)" == "libexerb - Win32 Debug"


"$(INTDIR)\resource.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) /l 0x411 /fo"$(INTDIR)\resource.res" /i "\home\personal\development\sf.jp\exerb\src\exerb" /d "_DEBUG" /d "RUNTIME" $(SOURCE)


!ENDIF 

SOURCE=..\exerb\utility.cpp

"$(INTDIR)\utility.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)



!ENDIF 

