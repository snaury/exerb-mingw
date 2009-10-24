# Microsoft Developer Studio Generated NMAKE File, Based on ruby18c.dsp
!IF "$(CFG)" == ""
CFG=ruby18c - Win32 Debug
!MESSAGE 構成が指定されていません。ﾃﾞﾌｫﾙﾄの ruby18c - Win32 Debug を設定します。
!ENDIF 

!IF "$(CFG)" != "ruby18c - Win32 Release" && "$(CFG)" != "ruby18c - Win32 Debug"
!MESSAGE 指定された ﾋﾞﾙﾄﾞ ﾓｰﾄﾞ "$(CFG)" は正しくありません。
!MESSAGE NMAKE の実行時に構成を指定できます
!MESSAGE ｺﾏﾝﾄﾞ ﾗｲﾝ上でﾏｸﾛの設定を定義します。例:
!MESSAGE 
!MESSAGE NMAKE /f "ruby18c.mak" CFG="ruby18c - Win32 Debug"
!MESSAGE 
!MESSAGE 選択可能なﾋﾞﾙﾄﾞ ﾓｰﾄﾞ:
!MESSAGE 
!MESSAGE "ruby18c - Win32 Release" ("Win32 (x86) Console Application" 用)
!MESSAGE "ruby18c - Win32 Debug" ("Win32 (x86) Console Application" 用)
!MESSAGE 
!ERROR 無効な構成が指定されています。
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "ruby18c - Win32 Release"

OUTDIR=.\bin\release
INTDIR=.\obj\release
# Begin Custom Macros
OutDir=.\bin\release
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\ruby182c.exc"

!ELSE 

ALL : "libruby18 - Win32 Release" "$(OUTDIR)\ruby182c.exc"

!ENDIF 

!IF "$(RECURSE)" == "1" 
CLEAN :"libruby18 - Win32 ReleaseCLEAN" 
!ELSE 
CLEAN :
!ENDIF 
	-@erase "$(INTDIR)\cui.obj"
	-@erase "$(INTDIR)\exerb.obj"
	-@erase "$(INTDIR)\module.obj"
	-@erase "$(INTDIR)\resource.res"
	-@erase "$(INTDIR)\utility.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\ruby182c.exc"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

"$(INTDIR)" :
    if not exist "$(INTDIR)/$(NULL)" mkdir "$(INTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O1 /I "..\libruby18\src" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /D "NT" /D "_WIN32" /D "RUBY_EXPORT" /Fp"$(INTDIR)\ruby18c.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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

RSC=rc.exe
RSC_PROJ=/l 0x411 /fo"$(INTDIR)\resource.res" /d "NDEBUG" /d "CUI" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\ruby18c.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib wsock32.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\ruby182c.pdb" /machine:I386 /def:"..\libruby18\libruby18_standalone.def" /out:"$(OUTDIR)\ruby182c.exc" 
DEF_FILE= \
	"..\libruby18\libruby18_standalone.def"
LINK32_OBJS= \
	"$(INTDIR)\cui.obj" \
	"$(INTDIR)\exerb.obj" \
	"$(INTDIR)\module.obj" \
	"$(INTDIR)\utility.obj" \
	"$(INTDIR)\resource.res" \
	"..\libruby18\lib\release\libruby18.lib"

"$(OUTDIR)\ruby182c.exc" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

TargetPath=.\bin\release\ruby182c.exc
SOURCE="$(InputPath)"
DS_POSTBUILD_DEP=$(INTDIR)\postbld.dep

ALL : $(DS_POSTBUILD_DEP)

# Begin Custom Macros
OutDir=.\bin\release
# End Custom Macros

$(DS_POSTBUILD_DEP) : "libruby18 - Win32 Release" "$(OUTDIR)\ruby182c.exc"
   copy .\bin\release\ruby182c.exc ..\..\data\exerb
	echo Helper for Post-build step > "$(DS_POSTBUILD_DEP)"

!ELSEIF  "$(CFG)" == "ruby18c - Win32 Debug"

OUTDIR=.\bin\debug
INTDIR=.\obj\debug
# Begin Custom Macros
OutDir=.\bin\debug
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\ruby182cd.exc"

!ELSE 

ALL : "libruby18 - Win32 Debug" "$(OUTDIR)\ruby182cd.exc"

!ENDIF 

!IF "$(RECURSE)" == "1" 
CLEAN :"libruby18 - Win32 DebugCLEAN" 
!ELSE 
CLEAN :
!ENDIF 
	-@erase "$(INTDIR)\cui.obj"
	-@erase "$(INTDIR)\exerb.obj"
	-@erase "$(INTDIR)\module.obj"
	-@erase "$(INTDIR)\resource.res"
	-@erase "$(INTDIR)\utility.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\ruby182cd.exc"
	-@erase "$(OUTDIR)\ruby182cd.ilk"
	-@erase "$(OUTDIR)\ruby182cd.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

"$(INTDIR)" :
    if not exist "$(INTDIR)/$(NULL)" mkdir "$(INTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\libruby18\src" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /D "NT" /D "_WIN32" /D "RUBY_EXPORT" /Fp"$(INTDIR)\ruby18c.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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

RSC=rc.exe
RSC_PROJ=/l 0x411 /fo"$(INTDIR)\resource.res" /d "_DEBUG" /d "CUI" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\ruby18c.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib wsock32.lib /nologo /subsystem:console /incremental:yes /pdb:"$(OUTDIR)\ruby182cd.pdb" /debug /machine:I386 /def:"..\libruby18\libruby18_standalone.def" /out:"$(OUTDIR)\ruby182cd.exc" /pdbtype:sept 
DEF_FILE= \
	"..\libruby18\libruby18_standalone.def"
LINK32_OBJS= \
	"$(INTDIR)\cui.obj" \
	"$(INTDIR)\exerb.obj" \
	"$(INTDIR)\module.obj" \
	"$(INTDIR)\utility.obj" \
	"$(INTDIR)\resource.res" \
	"..\libruby18\lib\debug\libruby18.lib"

"$(OUTDIR)\ruby182cd.exc" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

TargetPath=.\bin\debug\ruby182cd.exc
SOURCE="$(InputPath)"
DS_POSTBUILD_DEP=$(INTDIR)\postbld.dep

ALL : $(DS_POSTBUILD_DEP)

# Begin Custom Macros
OutDir=.\bin\debug
# End Custom Macros

$(DS_POSTBUILD_DEP) : "libruby18 - Win32 Debug" "$(OUTDIR)\ruby182cd.exc"
   copy .\bin\debug\ruby182cd.exc ..\..\data\exerb
	echo Helper for Post-build step > "$(DS_POSTBUILD_DEP)"

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("ruby18c.dep")
!INCLUDE "ruby18c.dep"
!ELSE 
!MESSAGE Warning: cannot find "ruby18c.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "ruby18c - Win32 Release" || "$(CFG)" == "ruby18c - Win32 Debug"

!IF  "$(CFG)" == "ruby18c - Win32 Release"

"libruby18 - Win32 Release" : 
   cd "\home\personal\development\sf.jp\exerb\src\libruby18"
   $(MAKE) /$(MAKEFLAGS) /F .\libruby18.mak CFG="libruby18 - Win32 Release" 
   cd "..\ruby18c"

"libruby18 - Win32 ReleaseCLEAN" : 
   cd "\home\personal\development\sf.jp\exerb\src\libruby18"
   $(MAKE) /$(MAKEFLAGS) /F .\libruby18.mak CFG="libruby18 - Win32 Release" RECURSE=1 CLEAN 
   cd "..\ruby18c"

!ELSEIF  "$(CFG)" == "ruby18c - Win32 Debug"

"libruby18 - Win32 Debug" : 
   cd "\home\personal\development\sf.jp\exerb\src\libruby18"
   $(MAKE) /$(MAKEFLAGS) /F .\libruby18.mak CFG="libruby18 - Win32 Debug" 
   cd "..\ruby18c"

"libruby18 - Win32 DebugCLEAN" : 
   cd "\home\personal\development\sf.jp\exerb\src\libruby18"
   $(MAKE) /$(MAKEFLAGS) /F .\libruby18.mak CFG="libruby18 - Win32 Debug" RECURSE=1 CLEAN 
   cd "..\ruby18c"

!ENDIF 

SOURCE=..\exerb\cui.cpp

"$(INTDIR)\cui.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\exerb\exerb.cpp

"$(INTDIR)\exerb.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\exerb\module.cpp

"$(INTDIR)\module.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\exerb\resource.rc

!IF  "$(CFG)" == "ruby18c - Win32 Release"


"$(INTDIR)\resource.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) /l 0x411 /fo"$(INTDIR)\resource.res" /i "\home\personal\development\sf.jp\exerb\src\exerb" /d "NDEBUG" /d "CUI" $(SOURCE)


!ELSEIF  "$(CFG)" == "ruby18c - Win32 Debug"


"$(INTDIR)\resource.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) /l 0x411 /fo"$(INTDIR)\resource.res" /i "\home\personal\development\sf.jp\exerb\src\exerb" /d "_DEBUG" /d "CUI" $(SOURCE)


!ENDIF 

SOURCE=..\exerb\utility.cpp

"$(INTDIR)\utility.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)



!ENDIF 

