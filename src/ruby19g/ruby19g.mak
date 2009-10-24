# Microsoft Developer Studio Generated NMAKE File, Based on ruby19g.dsp
!IF "$(CFG)" == ""
CFG=ruby19g - Win32 Debug
!MESSAGE 構成が指定されていません。ﾃﾞﾌｫﾙﾄの ruby19g - Win32 Debug を設定します。
!ENDIF 

!IF "$(CFG)" != "ruby19g - Win32 Release" && "$(CFG)" != "ruby19g - Win32 Debug"
!MESSAGE 指定された ﾋﾞﾙﾄﾞ ﾓｰﾄﾞ "$(CFG)" は正しくありません。
!MESSAGE NMAKE の実行時に構成を指定できます
!MESSAGE ｺﾏﾝﾄﾞ ﾗｲﾝ上でﾏｸﾛの設定を定義します。例:
!MESSAGE 
!MESSAGE NMAKE /f "ruby19g.mak" CFG="ruby19g - Win32 Debug"
!MESSAGE 
!MESSAGE 選択可能なﾋﾞﾙﾄﾞ ﾓｰﾄﾞ:
!MESSAGE 
!MESSAGE "ruby19g - Win32 Release" ("Win32 (x86) Application" 用)
!MESSAGE "ruby19g - Win32 Debug" ("Win32 (x86) Application" 用)
!MESSAGE 
!ERROR 無効な構成が指定されています。
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "ruby19g - Win32 Release"

OUTDIR=.\bin\release
INTDIR=.\obj\release
# Begin Custom Macros
OutDir=.\bin\release
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\ruby192g.exc"

!ELSE 

ALL : "libruby19 - Win32 Release" "$(OUTDIR)\ruby192g.exc"

!ENDIF 

!IF "$(RECURSE)" == "1" 
CLEAN :"libruby19 - Win32 ReleaseCLEAN" 
!ELSE 
CLEAN :
!ENDIF 
	-@erase "$(INTDIR)\exerb.obj"
	-@erase "$(INTDIR)\gui.obj"
	-@erase "$(INTDIR)\module.obj"
	-@erase "$(INTDIR)\resource.res"
	-@erase "$(INTDIR)\utility.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\ruby192g.exc"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

"$(INTDIR)" :
    if not exist "$(INTDIR)/$(NULL)" mkdir "$(INTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O1 /I "..\libruby19\src" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "NT" /D "_WIN32" /D "RUBY_EXPORT" /D "RUBY19" /Fp"$(INTDIR)\ruby19g.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\ruby19g.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib wsock32.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\ruby192g.pdb" /machine:I386 /def:"..\libruby19\libruby19_standalone.def" /out:"$(OUTDIR)\ruby192g.exc" 
DEF_FILE= \
	"..\libruby19\libruby19_standalone.def"
LINK32_OBJS= \
	"$(INTDIR)\exerb.obj" \
	"$(INTDIR)\gui.obj" \
	"$(INTDIR)\module.obj" \
	"$(INTDIR)\utility.obj" \
	"$(INTDIR)\resource.res" \
	"..\libruby19\lib\release\libruby19.lib"

"$(OUTDIR)\ruby192g.exc" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

TargetPath=.\bin\release\ruby192g.exc
SOURCE="$(InputPath)"
DS_POSTBUILD_DEP=$(INTDIR)\postbld.dep

ALL : $(DS_POSTBUILD_DEP)

# Begin Custom Macros
OutDir=.\bin\release
# End Custom Macros

$(DS_POSTBUILD_DEP) : "libruby19 - Win32 Release" "$(OUTDIR)\ruby192g.exc"
   copy .\bin\release\ruby192g.exc ..\..\data\exerb
	echo Helper for Post-build step > "$(DS_POSTBUILD_DEP)"

!ELSEIF  "$(CFG)" == "ruby19g - Win32 Debug"

OUTDIR=.\bin\debug
INTDIR=.\obj\debug
# Begin Custom Macros
OutDir=.\bin\debug
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\ruby192gd.exc"

!ELSE 

ALL : "libruby19 - Win32 Debug" "$(OUTDIR)\ruby192gd.exc"

!ENDIF 

!IF "$(RECURSE)" == "1" 
CLEAN :"libruby19 - Win32 DebugCLEAN" 
!ELSE 
CLEAN :
!ENDIF 
	-@erase "$(INTDIR)\exerb.obj"
	-@erase "$(INTDIR)\gui.obj"
	-@erase "$(INTDIR)\module.obj"
	-@erase "$(INTDIR)\resource.res"
	-@erase "$(INTDIR)\utility.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\ruby192gd.exc"
	-@erase "$(OUTDIR)\ruby192gd.ilk"
	-@erase "$(OUTDIR)\ruby192gd.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

"$(INTDIR)" :
    if not exist "$(INTDIR)/$(NULL)" mkdir "$(INTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\libruby19\src" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "NT" /D "_WIN32" /D "RUBY_EXPORT" /D "RUBY19" /Fp"$(INTDIR)\ruby19g.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\ruby19g.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib wsock32.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\ruby192gd.pdb" /debug /machine:I386 /def:"..\libruby19\libruby19_standalone.def" /out:"$(OUTDIR)\ruby192gd.exc" /pdbtype:sept 
DEF_FILE= \
	"..\libruby19\libruby19_standalone.def"
LINK32_OBJS= \
	"$(INTDIR)\exerb.obj" \
	"$(INTDIR)\gui.obj" \
	"$(INTDIR)\module.obj" \
	"$(INTDIR)\utility.obj" \
	"$(INTDIR)\resource.res" \
	"..\libruby19\lib\debug\libruby19.lib"

"$(OUTDIR)\ruby192gd.exc" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

TargetPath=.\bin\debug\ruby192gd.exc
SOURCE="$(InputPath)"
DS_POSTBUILD_DEP=$(INTDIR)\postbld.dep

ALL : $(DS_POSTBUILD_DEP)

# Begin Custom Macros
OutDir=.\bin\debug
# End Custom Macros

$(DS_POSTBUILD_DEP) : "libruby19 - Win32 Debug" "$(OUTDIR)\ruby192gd.exc"
   copy .\bin\debug\ruby192gd.exc ..\..\data\exerb
	echo Helper for Post-build step > "$(DS_POSTBUILD_DEP)"

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("ruby19g.dep")
!INCLUDE "ruby19g.dep"
!ELSE 
!MESSAGE Warning: cannot find "ruby19g.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "ruby19g - Win32 Release" || "$(CFG)" == "ruby19g - Win32 Debug"

!IF  "$(CFG)" == "ruby19g - Win32 Release"

"libruby19 - Win32 Release" : 
   cd "\home\personal\development\sf.jp\exerb\src\libruby19"
   $(MAKE) /$(MAKEFLAGS) /F .\libruby19.mak CFG="libruby19 - Win32 Release" 
   cd "..\ruby19g"

"libruby19 - Win32 ReleaseCLEAN" : 
   cd "\home\personal\development\sf.jp\exerb\src\libruby19"
   $(MAKE) /$(MAKEFLAGS) /F .\libruby19.mak CFG="libruby19 - Win32 Release" RECURSE=1 CLEAN 
   cd "..\ruby19g"

!ELSEIF  "$(CFG)" == "ruby19g - Win32 Debug"

"libruby19 - Win32 Debug" : 
   cd "\home\personal\development\sf.jp\exerb\src\libruby19"
   $(MAKE) /$(MAKEFLAGS) /F .\libruby19.mak CFG="libruby19 - Win32 Debug" 
   cd "..\ruby19g"

"libruby19 - Win32 DebugCLEAN" : 
   cd "\home\personal\development\sf.jp\exerb\src\libruby19"
   $(MAKE) /$(MAKEFLAGS) /F .\libruby19.mak CFG="libruby19 - Win32 Debug" RECURSE=1 CLEAN 
   cd "..\ruby19g"

!ENDIF 

SOURCE=..\exerb\exerb.cpp

"$(INTDIR)\exerb.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\exerb\gui.cpp

"$(INTDIR)\gui.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\exerb\module.cpp

"$(INTDIR)\module.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\exerb\resource.rc

!IF  "$(CFG)" == "ruby19g - Win32 Release"


"$(INTDIR)\resource.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) /l 0x411 /fo"$(INTDIR)\resource.res" /i "\home\personal\development\sf.jp\exerb\src\exerb" /d "NDEBUG" /d "GUI" $(SOURCE)


!ELSEIF  "$(CFG)" == "ruby19g - Win32 Debug"


"$(INTDIR)\resource.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) /l 0x411 /fo"$(INTDIR)\resource.res" /i "\home\personal\development\sf.jp\exerb\src\exerb" /d "_DEBUG" /d "GUI" $(SOURCE)


!ENDIF 

SOURCE=..\exerb\utility.cpp

"$(INTDIR)\utility.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)



!ENDIF 

