//
//  SegmentLoadCommand.m
//  Mach-O Browser
//
//  Created by David Schweinsberg on 1/11/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//

#import "SegmentLoadCommand.h"
#import "Section.h"
#include <mach-o/loader.h>

@implementation SegmentLoadCommand

- (instancetype)initWithData:(nonnull NSData *)aData offset:(NSUInteger)anOffset
{
    self = [super initWithData:aData offset:anOffset];
    if (self)
    {
        if (self.command == LC_SEGMENT)
        {
            struct segment_command *c = (struct segment_command *)(_data.bytes + _offset);
            char buf[17];

            if (c->cmdsize < 24)
            {
                // There isn't enough data in the command to load the segname
                _malformed = YES;
                return self;
            }

            strncpy(buf, c->segname, 16);
            _segName = @(buf);
            
            if (c->cmdsize < sizeof(struct segment_command))
            {
                _malformed = YES;
                return self;
            }

            if (self.swapBytes)
            {
                _vmaddr = CFSwapInt32(c->vmaddr);
                _vmsize = CFSwapInt32(c->vmsize);
                _fileoff = CFSwapInt32(c->fileoff);
                _filesize = CFSwapInt32(c->filesize);
                _maxprot = CFSwapInt32(c->maxprot);
                _initprot = CFSwapInt32(c->initprot);
                _nsects = CFSwapInt32(c->nsects);
                _flags = CFSwapInt32(c->flags);
            }
            else
            {
                _vmaddr = c->vmaddr;
                _vmsize = c->vmsize;
                _fileoff = c->fileoff;
                _filesize = c->filesize;
                _maxprot = c->maxprot;
                _initprot = c->initprot;
                _nsects = c->nsects;
                _flags = c->flags;
            }
            
            // Read sections
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:_nsects];
            for (NSUInteger i = 0; i < _nsects; ++i)
            {
                struct section *sect = ((struct section *)(c + 1) + i);
                uint32_t size = self.swapBytes ? CFSwapInt32(sect->size) : sect->size;
                NSData *sectionData = nil;
                if (size > 0)
                {
                    NSRange range;
                    if (self.swapBytes)
                        range = NSMakeRange(CFSwapInt32(sect->offset), CFSwapInt32(sect->size));
                    else
                        range = NSMakeRange(sect->offset, sect->size);
                    sectionData = [_data subdataWithRange:range];
                }
                Section *section = [[Section alloc] initWithSect:sect
                                                            data:sectionData
                                                       swapBytes:self.swapBytes];
                [array addObject:section];
            }
            _sections = array;
        }
        else if (self.command == LC_SEGMENT_64)
        {
            struct segment_command_64 *c = (struct segment_command_64 *)(_data.bytes + _offset);
            char buf[17];

            if (c->cmdsize < 24)
            {
                // There isn't enough data in the command to load the segname
                _malformed = YES;
                return self;
            }
            
            strncpy(buf, c->segname, 16);
            _segName = @(buf);

            if (c->cmdsize < sizeof(struct segment_command_64))
            {
                _malformed = YES;
                return self;
            }

            if (self.swapBytes)
            {
                _vmaddr = CFSwapInt64(c->vmaddr);
                _vmsize = CFSwapInt64(c->vmsize);
                _fileoff = CFSwapInt64(c->fileoff);
                _filesize = CFSwapInt64(c->filesize);
                _maxprot = CFSwapInt32(c->maxprot);
                _initprot = CFSwapInt32(c->initprot);
                _nsects = CFSwapInt32(c->nsects);
                _flags = CFSwapInt32(c->flags);
            }
            else
            {
                _vmaddr = c->vmaddr;
                _vmsize = c->vmsize;
                _fileoff = c->fileoff;
                _filesize = c->filesize;
                _maxprot = c->maxprot;
                _initprot = c->initprot;
                _nsects = c->nsects;
                _flags = c->flags;
            }
            
            // Read sections
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:_nsects];
            for (NSUInteger i = 0; i < _nsects; ++i)
            {
                struct section_64 *sect = ((struct section_64 *)(c + 1) + i);
                uint64_t size = self.swapBytes ? CFSwapInt64(sect->size) : sect->size;
                NSData *sectionData = nil;
                if (size > 0)
                {
                    NSRange range;
                    if (self.swapBytes)
                        range = NSMakeRange(CFSwapInt32(sect->offset), CFSwapInt64(sect->size));
                    else
                        range = NSMakeRange(sect->offset, sect->size);
                    sectionData = [_data subdataWithRange:range];
                }
                Section *section = [[Section alloc] initWithSect64:sect
                                                              data:sectionData
                                                         swapBytes:self.swapBytes];
                [array addObject:section];
            }
            _sections = array;
        }
    }
    return self;
}


#pragma mark - Properties

- (NSDictionary *)dictionary
{
    uint32_t cmd = self.command;
    if (cmd == LC_SEGMENT || cmd == LC_SEGMENT_64)
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:
                self.segName, @"segname",
                @(_vmaddr), @"vmaddr",
                @(_vmsize), @"vmsize",
                @(_fileoff), @"fileoff",
                @(_filesize), @"filesize",
                @(_maxprot), @"maxprot",
                @(_initprot), @"initprot",
                @(_nsects), @"nsects",
                @(_flags), @"flags",
                nil, nil];
    }
    return super.dictionary;
}

@end
