#include <windows.h>
#include <stdio.h>

void vpak_apply_hooks(HMODULE hModule, const char* szVirtualName);

//////////////////////////////////////////////////////////////////////////////

#define VPAK_MODULE(module) \
  static HMODULE hModule_##module = NULL;

#define VPAK_HOOK(retval, name, args) \
  typedef retval (*type_##name) args; \
  static type_##name orig_##name = NULL; \
  static retval vpak_##name args

#define VPAK_HOOKS_FOR(module) \
  if ((hModule = hModule_##module = LoadLibrary(#module)))

#define VPAK_HOOK_FOR(name) \
  if ((orig_##name = (type_##name)GetProcAddress(hModule, #name))) do { \
    vpak_add_hook(orig_##name, &vpak_##name); \
  } while(0)

VPAK_MODULE(kernel32)

VPAK_HOOK(HANDLE WINAPI, CreateFileA, (LPCSTR lpFileName, DWORD dwDesiredAccess, DWORD dwShareMode, LPSECURITY_ATTRIBUTES lpSecurityAttributes, DWORD dwCreationDisposition, DWORD dwFlagsAndAttributes, HANDLE hTemplateFile))
{
  printf("CreateFileA: '%s'\n", lpFileName);
  if (lstrcmpi(lpFileName, "@:/rbconfig.rb") == 0)
    return orig_CreateFileA("C:/Ruby/lib/ruby/1.8/i386-mingw32/rbconfig.rb", dwDesiredAccess, dwShareMode, lpSecurityAttributes, dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile);
  return orig_CreateFileA(lpFileName, dwDesiredAccess, dwShareMode, lpSecurityAttributes, dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile);
}

VPAK_HOOK(HMODULE WINAPI, LoadLibraryA, (LPCSTR lpFileName))
{
  printf("LoadLibraryA: '%s'\n", lpFileName);
  HMODULE hModule = orig_LoadLibraryA(lpFileName);
  if (hModule)
    vpak_apply_hooks(hModule, lpFileName);
  return hModule;
}

VPAK_HOOK(HMODULE WINAPI, GetModuleHandleA, (LPCSTR lpModuleName))
{
  return orig_GetModuleHandleA(lpModuleName);
}

VPAK_HOOK(DWORD WINAPI, GetFileAttributesA, (LPCSTR lpFileName))
{
  printf("GetFileAttributesA: '%s'\n", lpFileName);
  if (lstrcmpi(lpFileName, "@:\\rbconfig.rb") == 0)
    return FILE_ATTRIBUTE_READONLY;
  return orig_GetFileAttributesA(lpFileName);
}

//////////////////////////////////////////////////////////////////////////////

struct vpak_hook
{
  struct vpak_hook* next;
  void* orig_func;
  void* vpak_func;
} *vpak_hooks = NULL;

void vpak_add_hook(void* orig_func, void* vpak_func)
{
  struct vpak_hook* hook = malloc(sizeof(struct vpak_hook));
  hook->next = vpak_hooks;
  hook->orig_func = orig_func;
  hook->vpak_func = vpak_func;
  vpak_hooks = hook;
}

void* vpak_find_hook(void* orig_func)
{
  struct vpak_hook* hook;
  for (hook = vpak_hooks; hook; hook = hook->next) {
    if (hook->orig_func == orig_func)
      return hook->vpak_func;
  }
  return NULL;
}

//////////////////////////////////////////////////////////////////////////////

struct vpak_known_module {
  struct vpak_known_module* next;
  HMODULE hModule;
  CHAR szVirtualName[MAX_PATH];
} *vpak_known_modules = NULL;

void vpak_add_known_module(HMODULE hModule, const char* szVirtualName)
{
  struct vpak_known_module* ref = malloc(sizeof(struct vpak_known_module));
  ref->next = vpak_known_modules;
  ref->hModule = hModule;
  if (szVirtualName)
    strcpy(ref->szVirtualName, szVirtualName);
  else
    ref->szVirtualName[0] = '\0';
  vpak_known_modules = ref;
}

struct vpak_known_module* vpak_find_known_module(HMODULE hModule)
{
  struct vpak_known_module* ref;
  for (ref = vpak_known_modules; ref; ref = ref->next) {
    if (ref->hModule == hModule)
      return ref;
  }
  return NULL;
}

struct vpak_known_module* vpak_find_known_module_by_name(const char* szVirtualName)
{
  return NULL; /* NOT IMPLEMENTED */
}

//////////////////////////////////////////////////////////////////////////////

DWORD vpak_recursion_protection_count = 0;
HMODULE vpak_recursion_protection[256];

inline int vpak_recursion_detected(HMODULE hModule) {
  unsigned i;
  for (i = 0; i < vpak_recursion_protection_count; ++i)
    if (vpak_recursion_protection[i] == hModule)
      return 1;
  return 0;
}

inline void vpak_recursion_push(HMODULE hModule)
{
  vpak_recursion_protection[vpak_recursion_protection_count++] = hModule;
}

inline void vpak_recursion_pop()
{
  --vpak_recursion_protection_count;
}

//////////////////////////////////////////////////////////////////////////////

void vpak_apply_hooks(HMODULE hModule, const char* szVirtualName)
{
  if (!hModule || vpak_recursion_detected(hModule))
    return;

  const char* pModule = (const char*)hModule;
  PIMAGE_DOS_HEADER dos_header = (PIMAGE_DOS_HEADER)pModule;
  PIMAGE_NT_HEADERS nt_headers = (PIMAGE_NT_HEADERS)(pModule + dos_header->e_lfanew);
  if (nt_headers->OptionalHeader.NumberOfRvaAndSizes <= IMAGE_DIRECTORY_ENTRY_IMPORT)
    return; // no import directory entry
  PIMAGE_DATA_DIRECTORY import_directory = nt_headers->OptionalHeader.DataDirectory + IMAGE_DIRECTORY_ENTRY_IMPORT;
  if (!import_directory->VirtualAddress || !import_directory->Size)
    return; // no imports

  //printf("Module %p(%s): vpak_apply_hooks start\n", hModule, szVirtualName);
  vpak_recursion_push(hModule);
  PIMAGE_IMPORT_DESCRIPTOR import_descriptor;
  for (import_descriptor = (PIMAGE_IMPORT_DESCRIPTOR)(pModule + import_directory->VirtualAddress);
       import_descriptor->Name && import_descriptor->FirstThunk;
       ++import_descriptor)
  {
    const char* name = pModule + import_descriptor->Name;
    HMODULE hImportModule = GetModuleHandle(name);
    if (hImportModule) {
      //printf("Module %p(%s): applying hooks to submodule %p '%s'\n", hModule, szVirtualName, hImportModule, name);
      vpak_apply_hooks(hImportModule, name);
    }
    //printf("Module %p(%s): processing imports from '%s', FirstThunk = %p\n", hModule, szVirtualName, name, import_descriptor->FirstThunk);
    void** p;
    for (p = (void**)(pModule + import_descriptor->FirstThunk); *p; ++p) {
      void* vpak_func = vpak_find_hook(*p);
      if (vpak_func) {
        DWORD dwOldProtect;
        //printf("  ...hooking %p to %p\n", *p, vpak_func);
        if (VirtualProtect(p, sizeof(*p), PAGE_READWRITE, &dwOldProtect)) {
          *p = vpak_func;
          VirtualProtect(p, sizeof(*p), dwOldProtect, &dwOldProtect);
          FlushInstructionCache(NULL, p, sizeof(*p));
        }
      }
    }
  }
  vpak_recursion_pop();
  //printf("Module %p(%s): vpak_apply_hooks done\n", hModule, szVirtualName);
}

//////////////////////////////////////////////////////////////////////////////

void vpak_initialize()
{
  HMODULE hModule;
  VPAK_HOOKS_FOR(kernel32) {
    VPAK_HOOK_FOR(CreateFileA);
    VPAK_HOOK_FOR(LoadLibraryA);
    VPAK_HOOK_FOR(GetModuleHandleA);
    VPAK_HOOK_FOR(GetFileAttributesA);
  }
  vpak_apply_hooks(GetModuleHandle(NULL), NULL);
}
