//
//  MachObject.h
//  Mach-O Browser
//
//  Created by David Schweinsberg on 29/10/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <mach-o/loader.h>

@interface MachObject : NSObject
{
    NSData *data;
    BOOL swapBytes;
    NSArray *loadCommands;
}

@property(readonly) uint32_t magic;

@property(readonly) cpu_type_t cpuType;

@property(readonly) cpu_subtype_t cpuSubtype;

@property(readonly) uint32_t sizeOfCommands;

@property(retain, readonly) NSArray *loadCommands;

- (id)initWithData:(NSData *)objectData;

@end
