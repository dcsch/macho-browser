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

@property(readonly) uint32_t magic;

@property(readonly) cpu_type_t cpuType;

@property(readonly) cpu_subtype_t cpuSubtype;

@property(readonly) uint32_t sizeOfCommands;

@property(strong, readonly) NSArray *loadCommands;

- (instancetype)initWithData:(NSData *)objectData NS_DESIGNATED_INITIALIZER;

- (instancetype)init __attribute__((unavailable));

@end
