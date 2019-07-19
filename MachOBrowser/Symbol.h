//
//  Symbol.h
//  Mach-O Browser
//
//  Created by David Schweinsberg on 6/11/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <mach-o/nlist.h>

@interface Symbol : NSObject

@property(copy, readonly) NSString *name;
@property(readonly) NSUInteger type;
@property(readonly) NSUInteger sect;
@property(readonly) NSUInteger desc;
@property(readonly) uint64_t value;

- (instancetype)initWithNlist:(struct nlist *)symbolEntry
                  stringTable:(const char *)stringTable
                    swapBytes:(BOOL)swapBytes NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithNlist64:(struct nlist_64 *)symbolEntry
                    stringTable:(const char *)stringTable
                      swapBytes:(BOOL)swapBytes NS_DESIGNATED_INITIALIZER;

- (instancetype)init __attribute__((unavailable));

@end
