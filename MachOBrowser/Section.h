//
//  Section.h
//  Mach-O Browser
//
//  Created by David Schweinsberg on 1/11/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <mach-o/loader.h>

@interface Section : NSObject

@property(copy, readonly) NSString *sectName;
@property(copy, readonly) NSString *segName;
@property(readonly) NSUInteger addr;
@property(readonly) NSUInteger size;
@property(readonly) NSUInteger offset;
@property(readonly) NSUInteger align;
@property(readonly) NSUInteger reloff;
@property(readonly) NSUInteger nreloc;
@property(readonly) NSUInteger flags;
@property(readonly) NSUInteger reserved1;
@property(readonly) NSUInteger reserved2;
@property(strong, readonly) NSData *data;
@property(copy, readonly) NSString *hexDump;

- (instancetype)initWithSect:(struct section*)aSect data:(NSData *)aData swapBytes:(BOOL)swapBytes NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithSect64:(struct section_64*)aSect data:(NSData *)aData swapBytes:(BOOL)swapBytes NS_DESIGNATED_INITIALIZER;

- (instancetype)init __attribute__((unavailable));

@end
