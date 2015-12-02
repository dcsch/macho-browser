//
//  Section.m
//  Mach-O Browser
//
//  Created by David Schweinsberg on 1/11/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//

#import "Section.h"

@implementation Section

@synthesize sectName;
@synthesize segName;
@synthesize addr;
@synthesize size;
@synthesize offset;
@synthesize align;
@synthesize reloff;
@synthesize nreloc;
@synthesize flags;
@synthesize reserved1;
@synthesize reserved2;
@synthesize data;

- (id)initWithSect:(struct section*)aSect data:(NSData *)aData swapBytes:(BOOL)swapBytes
{
    self = [super init];
    if (self)
    {
        char buf[17];

        strncpy(buf, aSect->sectname, 16);
        buf[16] = 0;
        sectName = @(buf);

        strncpy(buf, aSect->segname, 16);
        buf[16] = 0;
        segName = @(buf);
        
        if (swapBytes)
        {
            addr = CFSwapInt32(aSect->addr);
            size = CFSwapInt32(aSect->size);
            offset = CFSwapInt32(aSect->offset);
            align = CFSwapInt32(aSect->align);
            reloff = CFSwapInt32(aSect->reloff);
            nreloc = CFSwapInt32(aSect->nreloc);
            flags = CFSwapInt32(aSect->flags);
            reserved1 = CFSwapInt32(aSect->reserved1);
            reserved2 = CFSwapInt32(aSect->reserved2);
        }
        else
        {
            addr = aSect->addr;
            size = aSect->size;
            offset = aSect->offset;
            align = aSect->align;
            reloff = aSect->reloff;
            nreloc = aSect->nreloc;
            flags = aSect->flags;
            reserved1 = aSect->reserved1;
            reserved2 = aSect->reserved2;
        }
        
        data = aData;
    }
    return self;
}

- (id)initWithSect64:(struct section_64*)aSect data:(NSData *)aData swapBytes:(BOOL)swapBytes
{
    self = [super init];
    if (self)
    {
        char buf[17];
        
        strncpy(buf, aSect->sectname, 16);
        buf[16] = 0;
        sectName = @(buf);
        
        strncpy(buf, aSect->segname, 16);
        buf[16] = 0;
        segName = @(buf);
        
        if (swapBytes)
        {
            addr = CFSwapInt64(aSect->addr);
            size = CFSwapInt64(aSect->size);
            offset = CFSwapInt32(aSect->offset);
            align = CFSwapInt32(aSect->align);
            reloff = CFSwapInt32(aSect->reloff);
            nreloc = CFSwapInt32(aSect->nreloc);
            flags = CFSwapInt32(aSect->flags);
            reserved1 = CFSwapInt32(aSect->reserved1);
            reserved2 = CFSwapInt32(aSect->reserved2);
        }
        else
        {
            addr = aSect->addr;
            size = aSect->size;
            offset = aSect->offset;
            align = aSect->align;
            reloff = aSect->reloff;
            nreloc = aSect->nreloc;
            flags = aSect->flags;
            reserved1 = aSect->reserved1;
            reserved2 = aSect->reserved2;
        }
        
        data = aData;
    }
    return self;
}


#pragma mark -
#pragma mark Properties

- (NSString *)hexDump
{
    NSMutableString *buf = [NSMutableString string];
    const unsigned char *bytes = data.bytes;
    NSUInteger length = data.length;
    
    for (NSUInteger i = 0; i < length; i += 16)
    {
        if (i + 16 < length)
        {
            [buf appendFormat:@"%08lx %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n",
             addr + i,
             bytes[i + 0],
             bytes[i + 1],
             bytes[i + 2],
             bytes[i + 3],
             bytes[i + 4],
             bytes[i + 5],
             bytes[i + 6],
             bytes[i + 7],
             bytes[i + 8],
             bytes[i + 9],
             bytes[i + 10],
             bytes[i + 11],
             bytes[i + 12],
             bytes[i + 13],
             bytes[i + 14],
             bytes[i + 15],
             bytes[i + 0] > 31 ? bytes[i + 0] : '.',
             bytes[i + 1] > 31 ? bytes[i + 1] : '.',
             bytes[i + 2] > 31 ? bytes[i + 2] : '.',
             bytes[i + 3] > 31 ? bytes[i + 3] : '.',
             bytes[i + 4] > 31 ? bytes[i + 4] : '.',
             bytes[i + 5] > 31 ? bytes[i + 5] : '.',
             bytes[i + 6] > 31 ? bytes[i + 6] : '.',
             bytes[i + 7] > 31 ? bytes[i + 7] : '.',
             bytes[i + 8] > 31 ? bytes[i + 8] : '.',
             bytes[i + 9] > 31 ? bytes[i + 9] : '.',
             bytes[i + 10] > 31 ? bytes[i + 10] : '.',
             bytes[i + 11] > 31 ? bytes[i + 11] : '.',
             bytes[i + 12] > 31 ? bytes[i + 12] : '.',
             bytes[i + 13] > 31 ? bytes[i + 13] : '.',
             bytes[i + 14] > 31 ? bytes[i + 14] : '.',
             bytes[i + 15] > 31 ? bytes[i + 15] : '.'];
        }
        else
        {
            NSMutableString *hexBuf = [NSMutableString string];
            NSMutableString *charBuf = [NSMutableString string];
            [hexBuf appendFormat:@"%08lx ", addr + i];
            for (NSUInteger j = 0; j < 16; ++j)
            {
                if (i + j < length)
                {
                    [hexBuf appendFormat:@"%02x ", bytes[i + j]];
                    [charBuf appendFormat:@"%c", bytes[i + j] > 31 ? bytes[i + j] : '.'];
                }
                else
                {
                    [hexBuf appendString:@"   "];
                    [charBuf appendString:@" "];
                }
            }
            [buf appendString:hexBuf];
            [buf appendString:charBuf];
        }
    }
    return buf;
}

@end
