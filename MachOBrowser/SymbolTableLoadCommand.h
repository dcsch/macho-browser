//
//  SymbolTableLoadCommand.h
//  Mach-O Browser
//
//  Created by David Schweinsberg on 6/11/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//

#import "LoadCommand.h"
#import <Cocoa/Cocoa.h>

@interface SymbolTableLoadCommand : LoadCommand

@property(readonly) NSUInteger symoff;
@property(readonly) NSUInteger nsyms;
@property(readonly) NSUInteger stroff;
@property(readonly) NSUInteger strsize;
@property(strong, readonly) NSArray *symbols;

@end
