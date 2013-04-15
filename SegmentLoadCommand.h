//
//  SegmentLoadCommand.h
//  Mach-O Browser
//
//  Created by David Schweinsberg on 1/11/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LoadCommand.h"

@interface SegmentLoadCommand : LoadCommand
{
    NSString *segName;
    uint64_t vmaddr;
    uint64_t vmsize;
    NSUInteger fileoff;
    NSUInteger filesize;
    NSUInteger maxprot;
    NSUInteger initprot;
    NSUInteger nsects;
    NSUInteger flags;
    NSArray *sections;
}

@property(copy, readonly) NSString *segName;
@property(readonly) uint64_t vmaddr;
@property(readonly) uint64_t vmsize;
@property(readonly) NSUInteger fileoff;
@property(readonly) NSUInteger filesize;
@property(readonly) NSUInteger maxprot;
@property(readonly) NSUInteger initprot;
@property(readonly) NSUInteger nsects;
@property(readonly) NSUInteger flags;
@property(retain, readonly) NSArray *sections;

@end
