//
//  SegmentLoadCommand.h
//  Mach-O Browser
//
//  Created by David Schweinsberg on 1/11/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//

#import "LoadCommand.h"
#import <Cocoa/Cocoa.h>

@interface SegmentLoadCommand : LoadCommand

@property(copy, readonly) NSString *segName;
@property(readonly) uint64_t vmaddr;
@property(readonly) uint64_t vmsize;
@property(readonly) NSUInteger fileoff;
@property(readonly) NSUInteger filesize;
@property(readonly) NSUInteger maxprot;
@property(readonly) NSUInteger initprot;
@property(readonly) NSUInteger nsects;
@property(readonly) NSUInteger flags;
@property(strong, readonly) NSArray *sections;

@end
