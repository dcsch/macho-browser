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

@synthesize segName;
@synthesize vmaddr;
@synthesize vmsize;
@synthesize fileoff;
@synthesize filesize;
@synthesize maxprot;
@synthesize initprot;
@synthesize nsects;
@synthesize flags;
@synthesize sections;

- (id)initWithData:(NSData *)aData offset:(NSUInteger)anOffset
{
    // We don't call the superclass initWithData:offset: so we don't
    // infinitely recurse on ourselves
    self = [super init];
    if (self)
    {
        _data = aData;
        _offset = anOffset;

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
            segName = @(buf);
            
            if (c->cmdsize < sizeof(struct segment_command))
            {
                _malformed = YES;
                return self;
            }

            if (self.swapBytes)
            {
                vmaddr = CFSwapInt32(c->vmaddr);
                vmsize = CFSwapInt32(c->vmsize);
                fileoff = CFSwapInt32(c->fileoff);
                filesize = CFSwapInt32(c->filesize);
                maxprot = CFSwapInt32(c->maxprot);
                initprot = CFSwapInt32(c->initprot);
                nsects = CFSwapInt32(c->nsects);
                flags = CFSwapInt32(c->flags);
            }
            else
            {
                vmaddr = c->vmaddr;
                vmsize = c->vmsize;
                fileoff = c->fileoff;
                filesize = c->filesize;
                maxprot = c->maxprot;
                initprot = c->initprot;
                nsects = c->nsects;
                flags = c->flags;
            }
            
            // Read sections
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:nsects];
            for (NSUInteger i = 0; i < nsects; ++i)
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
            sections = array;
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
            segName = @(buf);

            if (c->cmdsize < sizeof(struct segment_command_64))
            {
                _malformed = YES;
                return self;
            }

            if (self.swapBytes)
            {
                vmaddr = CFSwapInt64(c->vmaddr);
                vmsize = CFSwapInt64(c->vmsize);
                fileoff = CFSwapInt64(c->fileoff);
                filesize = CFSwapInt64(c->filesize);
                maxprot = CFSwapInt32(c->maxprot);
                initprot = CFSwapInt32(c->initprot);
                nsects = CFSwapInt32(c->nsects);
                flags = CFSwapInt32(c->flags);
            }
            else
            {
                vmaddr = c->vmaddr;
                vmsize = c->vmsize;
                fileoff = c->fileoff;
                filesize = c->filesize;
                maxprot = c->maxprot;
                initprot = c->initprot;
                nsects = c->nsects;
                flags = c->flags;
            }
            
            // Read sections
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:nsects];
            for (NSUInteger i = 0; i < nsects; ++i)
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
            sections = array;
        }
    }
    return self;
}


#pragma mark -
#pragma mark Properties

- (NSDictionary *)dictionary
{
    uint32_t cmd = self.command;
    if (cmd == LC_SEGMENT || cmd == LC_SEGMENT_64)
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:
                self.segName, @"segname",
                @(vmaddr), @"vmaddr",
                @(vmsize), @"vmsize",
                @(fileoff), @"fileoff",
                @(filesize), @"filesize",
                @(maxprot), @"maxprot",
                @(initprot), @"initprot",
                @(nsects), @"nsects",
                @(flags), @"flags",
                nil, nil];
    }
    return [super dictionary];
}

@end
