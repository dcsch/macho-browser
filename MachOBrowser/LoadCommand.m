//
//  LoadCommand.m
//  Mach-O Browser
//
//  Created by David Schweinsberg on 29/10/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//

#import "LoadCommand.h"
#import "SegmentLoadCommand.h"
#import "SymbolTableLoadCommand.h"
#include <mach-o/loader.h>
//#include <mach/i386/thread_status.h>
//#include <mach/arm/thread_status.h>

// struct thread_command has flavor and count commented out.  We only have
// minimal support for this command at the moment.
struct local_thread_command {
    uint32_t    cmd;        /* LC_THREAD or  LC_UNIXTHREAD */
    uint32_t    cmdsize;    /* total size of this command */
    uint32_t flavor;            /*flavor of thread state */
    uint32_t count;            /*count of longs in thread state */
    /* struct XXX_thread_state state   thread state for this flavor */
    /* ... */
};

@interface LoadCommand ()
{
    NSDictionary *dictionary;
}

@end


@implementation LoadCommand

+ (instancetype)loadCommandWithData:(nonnull NSData *)data offset:(NSUInteger)offset
{
    const unsigned char *bytes = data.bytes;
    struct load_command *lc = (struct load_command *)(bytes + offset);
    uint32_t cmd;
    uint32_t m = *(uint32_t *)bytes;
    if (m == MH_CIGAM || m == MH_CIGAM_64)
        cmd = CFSwapInt32(lc->cmd);
    else
        cmd = lc->cmd;

    if (cmd == LC_SEGMENT || cmd == LC_SEGMENT_64)
    {
        return [[SegmentLoadCommand alloc] initWithData:data offset:offset];
    }
    else if (cmd == LC_SYMTAB)
    {
        return [[SymbolTableLoadCommand alloc] initWithData:data offset:offset];
    }
    else
    {
        return [[LoadCommand alloc] initWithData:data offset:offset];
    }
}

- (instancetype)initWithData:(NSData *)aData offset:(NSUInteger)anOffset
{
    self = [super init];
    if (self)
    {
        _data = aData;
        _offset = anOffset;
    }
    return self;
}

#pragma mark - Properties

- (uint32_t)command
{
    struct load_command *lc = (struct load_command *)(_data.bytes + _offset);
    if (self.swapBytes)
        return CFSwapInt32(lc->cmd);
    else
        return lc->cmd;
}

- (NSString *)commandName
{
    uint32_t cmd = self.command;
    switch (cmd)
    {
        case LC_SEGMENT:
            return @"LC_SEGMENT";
        case LC_SYMTAB:
            return @"LC_SYMTAB";
        case LC_SYMSEG:
            return @"LC_SYMSEG";
        case LC_THREAD:
            return @"LC_THREAD";
        case LC_UNIXTHREAD:
            return @"LC_UNIXTHREAD";
        case LC_LOADFVMLIB:
            return @"LC_LOADFVMLIB";
        case LC_IDFVMLIB:
            return @"LC_IDFVMLIB";
        case LC_IDENT:
            return @"LC_IDENT";
        case LC_FVMFILE:
            return @"LC_FVMFILE";
        case LC_PREPAGE:
            return @"LC_PREPAGE";
        case LC_DYSYMTAB:
            return @"LC_DYSYMTAB";
        case LC_LOAD_DYLIB:
            return @"LC_LOAD_DYLIB";
        case LC_ID_DYLIB:
            return @"LC_ID_DYLIB";
        case LC_LOAD_DYLINKER:
            return @"LC_LOAD_DYLINKER";
        case LC_ID_DYLINKER:
            return @"LC_ID_DYLINKER";
        case LC_PREBOUND_DYLIB:
            return @"LC_PREBOUND_DYLIB";
        case LC_ROUTINES:
            return @"LC_ROUTINES";
        case LC_SUB_FRAMEWORK:
            return @"LC_SUB_FRAMEWORK";
        case LC_SUB_UMBRELLA:
            return @"LC_SUB_UMBRELLA";
        case LC_SUB_CLIENT:
            return @"LC_SUB_CLIENT";
        case LC_SUB_LIBRARY:
            return @"LC_SUB_LIBRARY";
        case LC_TWOLEVEL_HINTS:
            return @"LC_TWOLEVEL_HINTS";
        case LC_PREBIND_CKSUM:
            return @"LC_PREBIND_CKSUM";
        case LC_LOAD_WEAK_DYLIB:
            return @"LC_LOAD_WEAK_DYLIB";
        case LC_SEGMENT_64:
            return @"LC_SEGMENT_64";
        case LC_ROUTINES_64:
            return @"LC_ROUTINES_64";
        case LC_UUID:
            return @"LC_UUID";
        case LC_RPATH:
            return @"LC_RPATH";
        case LC_CODE_SIGNATURE:
            return @"LC_CODE_SIGNATURE";
        case LC_SEGMENT_SPLIT_INFO:
            return @"LC_SEGMENT_SPLIT_INFO";
        case LC_REEXPORT_DYLIB:
            return @"LC_REEXPORT_DYLIB";
        case LC_LAZY_LOAD_DYLIB:
            return @"LC_LAZY_LOAD_DYLIB";
        case LC_ENCRYPTION_INFO:
            return @"LC_ENCRYPTION_INFO";
        case LC_DYLD_INFO:
            return @"LC_DYLD_INFO";
        case LC_DYLD_INFO_ONLY:
            return @"LC_DYLD_INFO_ONLY";
        case LC_LOAD_UPWARD_DYLIB: /* load upward dylib */
            return @"LC_LOAD_UPWARD_DYLIB";
        case LC_VERSION_MIN_MACOSX:   /* build for MacOSX min OS version */
            return @"LC_VERSION_MIN_MACOSX";
        case LC_VERSION_MIN_IPHONEOS: /* build for iPhoneOS min OS version */
            return @"LC_VERSION_MIN_IPHONEOS";
        case LC_FUNCTION_STARTS: /* compressed table of function start addresses */
            return @"LC_FUNCTION_STARTS";
        case LC_DYLD_ENVIRONMENT: /* string for dyld to treat like environment variable */
            return @"LC_DYLD_ENVIRONMENT";
        case LC_MAIN: /* replacement for LC_UNIXTHREAD */
            return @"LC_MAIN";
        case LC_DATA_IN_CODE: /* table of non-instructions in __text */
            return @"LC_DATA_IN_CODE";
        case LC_SOURCE_VERSION: /* source version used to build binary */
            return @"LC_SOURCE_VERSION";
        case LC_DYLIB_CODE_SIGN_DRS: /* Code signing DRs copied from linked dylibs */
            return @"LC_DYLIB_CODE_SIGN_DRS";
    }
    return [NSString stringWithFormat:@"0x%x", cmd];
}

- (uint32_t)commandSize
{
    struct load_command *lc = (struct load_command *)(_data.bytes + _offset);
    if (self.swapBytes)
        return CFSwapInt32(lc->cmdsize);
    else
        return lc->cmdsize;
}

- (NSDictionary *)dictionary
{
    uint32_t cmd = self.command;
    if (cmd == LC_UUID)
    {
        struct uuid_command *c = (struct uuid_command *)(_data.bytes + _offset);
        NSString *uuidString = [NSString stringWithFormat:
                                @"%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x",
                                c->uuid[0],
                                c->uuid[1],
                                c->uuid[2],
                                c->uuid[3],
                                c->uuid[4],
                                c->uuid[5],
                                c->uuid[6],
                                c->uuid[7],
                                c->uuid[8],
                                c->uuid[9],
                                c->uuid[10],
                                c->uuid[11],
                                c->uuid[12],
                                c->uuid[13],
                                c->uuid[14],
                                c->uuid[15]];
        return [NSDictionary dictionaryWithObjectsAndKeys:uuidString, @"uuid", nil, nil];
    }
    else if (cmd == LC_RPATH)
    {
        struct rpath_command *c = (struct rpath_command *)(_data.bytes + _offset);
        return @{@"path": [NSString stringWithUTF8String:_data.bytes + _offset + c->path.offset]};
    }
/*
    else if (cmd == LC_SYMTAB)
    {
        struct symtab_command *c = (struct symtab_command *)(data.bytes + offset);
        return [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithUnsignedInteger:c->symoff], @"symoff",
                [NSNumber numberWithUnsignedInteger:c->nsyms], @"nsyms",
                [NSNumber numberWithUnsignedInteger:c->stroff], @"stroff",
                [NSNumber numberWithUnsignedInteger:c->strsize], @"strsize",
                nil, nil];
    }
*/
    else if (cmd == LC_DYSYMTAB)
    {
        struct dysymtab_command *c = (struct dysymtab_command *)(_data.bytes + _offset);
        if (self.swapBytes)
            return [NSDictionary dictionaryWithObjectsAndKeys:
                    @(CFSwapInt32(c->ilocalsym)), @"ilocalsym",
                    @(CFSwapInt32(c->nlocalsym)), @"nlocalsym",
                    @(CFSwapInt32(c->iextdefsym)), @"iextdefsym",
                    @(CFSwapInt32(c->nextdefsym)), @"nextdefsym",
                    @(CFSwapInt32(c->iundefsym)), @"iundefsym",
                    @(CFSwapInt32(c->nundefsym)), @"nundefsym",
                    @(CFSwapInt32(c->tocoff)), @"tocoff",
                    @(CFSwapInt32(c->ntoc)), @"ntoc",
                    @(CFSwapInt32(c->modtaboff)), @"modtaboff",
                    @(CFSwapInt32(c->nmodtab)), @"nmodtab",
                    @(CFSwapInt32(c->extrefsymoff)), @"extrefsymoff",
                    @(CFSwapInt32(c->nextrefsyms)), @"nextrefsyms",
                    @(CFSwapInt32(c->indirectsymoff)), @"indirectsymoff",
                    @(CFSwapInt32(c->nindirectsyms)), @"nindirectsyms",
                    @(CFSwapInt32(c->extreloff)), @"extreloff",
                    @(CFSwapInt32(c->nextrel)), @"nextrel",
                    @(CFSwapInt32(c->locreloff)), @"locreloff",
                    @(CFSwapInt32(c->nlocrel)), @"nlocrel",
                    nil, nil];
        else
            return [NSDictionary dictionaryWithObjectsAndKeys:
                    @(c->ilocalsym), @"ilocalsym",
                    @(c->nlocalsym), @"nlocalsym",
                    @(c->iextdefsym), @"iextdefsym",
                    @(c->nextdefsym), @"nextdefsym",
                    @(c->iundefsym), @"iundefsym",
                    @(c->nundefsym), @"nundefsym",
                    @(c->tocoff), @"tocoff",
                    @(c->ntoc), @"ntoc",
                    @(c->modtaboff), @"modtaboff",
                    @(c->nmodtab), @"nmodtab",
                    @(c->extrefsymoff), @"extrefsymoff",
                    @(c->nextrefsyms), @"nextrefsyms",
                    @(c->indirectsymoff), @"indirectsymoff",
                    @(c->nindirectsyms), @"nindirectsyms",
                    @(c->extreloff), @"extreloff",
                    @(c->nextrel), @"nextrel",
                    @(c->locreloff), @"locreloff",
                    @(c->nlocrel), @"nlocrel",
                    nil, nil];
    }
    else if (cmd == LC_LOAD_DYLIB
             || cmd == LC_LOAD_WEAK_DYLIB
             || cmd == LC_ID_DYLIB)
    {
        struct dylib_command *c = (struct dylib_command *)(_data.bytes + _offset);
        NSString *nameString;
        NSDate *timestampDate;
        NSString *currentVersionString;
        NSString *compatibilityVersionString;
        if (self.swapBytes)
        {
            nameString = [NSString stringWithFormat:@"%s", _data.bytes + _offset + CFSwapInt32(c->dylib.name.offset)];
            timestampDate = [NSDate dateWithTimeIntervalSince1970:CFSwapInt32(c->dylib.timestamp)];
            currentVersionString = [NSString stringWithFormat:
                                    @"%d.%d.%d",
                                    CFSwapInt32(c->dylib.current_version) >> 16,
                                    (CFSwapInt32(c->dylib.current_version) >> 8) & 0xff,
                                    CFSwapInt32(c->dylib.current_version) & 0xff];
            compatibilityVersionString = [NSString stringWithFormat:
                                          @"%d.%d.%d",
                                          CFSwapInt32(c->dylib.compatibility_version) >> 16,
                                          (CFSwapInt32(c->dylib.compatibility_version) >> 8) & 0xff,
                                          CFSwapInt32(c->dylib.compatibility_version) & 0xff];
        }
        else
        {
            nameString = [NSString stringWithFormat:@"%s", _data.bytes + _offset + c->dylib.name.offset];
            timestampDate = [NSDate dateWithTimeIntervalSince1970:c->dylib.timestamp];
            currentVersionString = [NSString stringWithFormat:
                                    @"%d.%d.%d",
                                    c->dylib.current_version >> 16,
                                    (c->dylib.current_version >> 8) & 0xff,
                                    c->dylib.current_version & 0xff];
            compatibilityVersionString = [NSString stringWithFormat:
                                          @"%d.%d.%d",
                                          c->dylib.compatibility_version >> 16,
                                          (c->dylib.compatibility_version >> 8) & 0xff,
                                          c->dylib.compatibility_version & 0xff];
        }
        return [NSDictionary dictionaryWithObjectsAndKeys:
                nameString, @"name",
                timestampDate.description, @"timestamp",
                currentVersionString, @"current version",
                compatibilityVersionString, @"compatibility version",
                nil, nil];
    }
    else if (cmd == LC_LOAD_DYLINKER || cmd == LC_ID_DYLINKER)
    {
        struct dylinker_command *c = (struct dylinker_command *)(_data.bytes + _offset);
        NSString *nameString;
        if (self.swapBytes)
            nameString = [NSString stringWithFormat:@"%s", _data.bytes + _offset + CFSwapInt32(c->name.offset)];
        else
            nameString = [NSString stringWithFormat:@"%s", _data.bytes + _offset + c->name.offset];
        return [NSDictionary dictionaryWithObjectsAndKeys:
                nameString, @"name",
                nil, nil];
    }
    else if (cmd == LC_THREAD || cmd == LC_UNIXTHREAD)
    {
        struct local_thread_command *c = (struct local_thread_command *)(_data.bytes + _offset);
        if (self.swapBytes)
            return [NSDictionary dictionaryWithObjectsAndKeys:
                    @(CFSwapInt32(c->flavor)), @"flavor",
                    @(CFSwapInt32(c->count)), @"count",
                    nil, nil];
        else
            return [NSDictionary dictionaryWithObjectsAndKeys:
                    @(c->flavor), @"flavor",
                    @(c->count), @"count",
                    nil, nil];
    }
    else if (cmd == LC_MAIN)
    {
        struct entry_point_command *c = (struct entry_point_command *)(_data.bytes + _offset);
        uint64_t entryoff;
        uint64_t stacksize;
        if (self.swapBytes)
        {
            entryoff = CFSwapInt64(c->entryoff);
            stacksize = CFSwapInt64(c->stacksize);
        }
        else
        {
            entryoff = c->entryoff;
            stacksize = c->stacksize;
        }
        return @{@"entryoff": @(entryoff),
                 @"stacksize": @(stacksize)};
    }
    else if (cmd == LC_DYLD_INFO || cmd == LC_DYLD_INFO_ONLY)
    {
        struct dyld_info_command *c = (struct dyld_info_command *)(_data.bytes + _offset);
        return @{@"rebase_off": @(c->rebase_off),
                 @"rebase_size": @(c->rebase_size),
                 @"bind_off": @(c->bind_off),
                 @"bind_size": @(c->bind_size),
                 @"weak_bind_off": @(c->weak_bind_off),
                 @"weak_bind_size": @(c->weak_bind_size),
                 @"lazy_bind_off": @(c->lazy_bind_off),
                 @"lazy_bind_size": @(c->lazy_bind_size),
                 @"export_off": @(c->export_off),
                 @"export_size": @(c->export_size)};
    }
    else if (cmd == LC_VERSION_MIN_MACOSX)
    {
        struct version_min_command *c = (struct version_min_command *)(_data.bytes + _offset);
        NSString *version = [NSString stringWithFormat:@"%d.%d.%d",
                             c->version >> 16,
                             (c->version >> 8) & 0xff,
                             c->version & 0xff];
        NSString *sdk = [NSString stringWithFormat:@"%d.%d.%d",
                         c->sdk >> 16,
                         (c->sdk >> 8) & 0xff,
                         c->sdk & 0xff];
        return @{@"version": version,
                 @"sdk": sdk};
    }
    return nil;
}

- (BOOL)swapBytes
{
    uint32_t m = *(uint32_t *)_data.bytes;
    if (m == MH_CIGAM || m == MH_CIGAM_64)
        return YES;
    else
        return NO;
}

- (BOOL)dataAvailable
{
    // Is the load command supported yet?
    // dataAvailable returns NO if unsupported.
    uint32_t cmd = self.command;
    switch (cmd)
    {
        case LC_SEGMENT:
        case LC_SYMTAB:
        //case LC_SYMSEG:
        //case LC_THREAD:
        //case LC_UNIXTHREAD:
        //case LC_LOADFVMLIB:
        //case LC_IDFVMLIB:
        //case LC_IDENT:
        //case LC_FVMFILE:
        //case LC_PREPAGE:
        case LC_DYSYMTAB:
        case LC_LOAD_DYLIB:
        case LC_ID_DYLIB:
        case LC_LOAD_DYLINKER:
        case LC_ID_DYLINKER:
        //case LC_PREBOUND_DYLIB:
        //case LC_ROUTINES:
        //case LC_SUB_FRAMEWORK:
        //case LC_SUB_UMBRELLA:
        //case LC_SUB_CLIENT:
        //case LC_SUB_LIBRARY:
        //case LC_TWOLEVEL_HINTS:
        //case LC_PREBIND_CKSUM:
        case LC_LOAD_WEAK_DYLIB:
        case LC_SEGMENT_64:
        //case LC_ROUTINES_64:
        case LC_UUID:
        case LC_RPATH:
        //case LC_CODE_SIGNATURE:
        //case LC_SEGMENT_SPLIT_INFO:
        //case LC_REEXPORT_DYLIB:
        //case LC_LAZY_LOAD_DYLIB:
        //case LC_ENCRYPTION_INFO:
        case LC_DYLD_INFO:
        case LC_DYLD_INFO_ONLY:
        case LC_VERSION_MIN_MACOSX:
        case LC_MAIN:
            return YES;
    }
    return NO;
}

- (NSData *)commandData
{
    return [_data subdataWithRange:NSMakeRange(_offset, self.commandSize)];
}

@end
