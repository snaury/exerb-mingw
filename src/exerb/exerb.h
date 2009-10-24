// $Id: exerb.h,v 1.42 2007/02/26 10:20:44 yuya Exp $

#pragma pack(push, 1)

typedef struct {
	DWORD signature1;
	DWORD signature2;
	union {
		DWORD options;
		struct {
			DWORD kcode:2;
			DWORD reserved:30;
		};
	};
	DWORD offset_of_name_table;
	DWORD offset_of_file_table;
} ARCHIVE_HEADER;

typedef struct {
	DWORD signature;
	WORD  number_of_headers;
	DWORD offset_of_headers;
	DWORD offset_of_pool;
} NAME_TABLE_HEADER;

typedef struct {
	WORD  id;
	DWORD offset_of_name;
} NAME_ENTRY_HEADER;

typedef struct {
	DWORD signature;
	WORD  number_of_headers;
	DWORD offset_of_headers;
	DWORD offset_of_pool;
} FILE_TABLE_HEADER;

typedef struct {
	WORD  id;
	DWORD offset_of_file;
	DWORD size_of_file;
	union {
		BYTE flag_of_file;
		struct {
			BYTE type_of_file:3;
			BYTE flag_no_replace_function:1;
			BYTE flag_reserved:4;
		};
	};
} FILE_ENTRY_HEADER;

#pragma pack(pop)

typedef VALUE (*RUBY_PROC)(...);

#define ARCHIVE_HEADER_SIGNATURE1          0x52455845
#define ARCHIVE_HEADER_SIGNATURE2          0x04000042
#define ARCHIVE_HEADER_OPTIONS_KCODE_NONE  0
#define ARCHIVE_HEADER_OPTIONS_KCODE_EUC   1
#define ARCHIVE_HEADER_OPTIONS_KCODE_SJIS  2
#define ARCHIVE_HEADER_OPTIONS_KCODE_UTF8  3

#define NAME_TABLE_HEADER_SIGNATURE    0x0100544E
#define FILE_TABLE_HEADER_SIGNATURE    0x04005446

#define FILE_ENTRY_HEADER_TYPE_RUBY_SCRIPT       1
#define FILE_ENTRY_HEADER_TYPE_EXTENSION_LIBRARY 2
#define FILE_ENTRY_HEADER_TYPE_DYNAMIC_LIBRARY   3
#define FILE_ENTRY_HEADER_TYPE_RESOURCE_LIBRARY  4
#define FILE_ENTRY_HEADER_TYPE_DATA_BINARY       5
#define FILE_ENTRY_HEADER_TYPE_COMPILED_SCRIPT   6

#ifndef RSTRING_PTR
#define RSTRING_PTR(value) RSTRING(value)->ptr
#endif

#ifndef RSTRING_LEN
#define RSTRING_LEN(value) RSTRING(value)->len
#endif
