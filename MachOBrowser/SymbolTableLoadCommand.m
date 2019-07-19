//
//  SymbolTableLoadCommand.m
//  Mach-O Browser
//
//  Created by David Schweinsberg on 6/11/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//

#import "SymbolTableLoadCommand.h"
#import "Symbol.h"
#include <mach-o/loader.h>

@implementation SymbolTableLoadCommand

- (instancetype)initWithData:(nonnull NSData *)aData
                      offset:(NSUInteger)anOffset {
  self = [super initWithData:aData offset:anOffset];
  if (self) {
    // Endianness?  Word-size?
    BOOL sixtyfour;
    const char *bytes = _data.bytes;
    uint32_t m = *(uint32_t *)bytes;
    if (m == MH_MAGIC_64 || m == MH_CIGAM_64)
      sixtyfour = YES;
    else
      sixtyfour = NO;

    // Read symbols
    const char *strTable = bytes + self.stroff;
    NSMutableArray *array =
        [[NSMutableArray alloc] initWithCapacity:self.nsyms];
    for (NSUInteger i = 0; i < self.nsyms; ++i) {
      Symbol *symbol;
      if (sixtyfour) {
        struct nlist_64 *sym = (struct nlist_64 *)(bytes + self.symoff) + i;
        symbol = [[Symbol alloc] initWithNlist64:sym
                                     stringTable:strTable
                                       swapBytes:self.swapBytes];
      } else {
        struct nlist *sym = (struct nlist *)(bytes + self.symoff) + i;
        symbol = [[Symbol alloc] initWithNlist:sym
                                   stringTable:strTable
                                     swapBytes:self.swapBytes];
      }
      [array addObject:symbol];
    }
    _symbols = array;
  }
  return self;
}

#pragma mark - Properties

- (NSUInteger)symoff {
  struct symtab_command *c = (struct symtab_command *)(_data.bytes + _offset);
  if (self.swapBytes)
    return CFSwapInt32(c->symoff);
  else
    return c->symoff;
}

- (NSUInteger)nsyms {
  struct symtab_command *c = (struct symtab_command *)(_data.bytes + _offset);
  if (self.swapBytes)
    return CFSwapInt32(c->nsyms);
  else
    return c->nsyms;
}

- (NSUInteger)stroff {
  struct symtab_command *c = (struct symtab_command *)(_data.bytes + _offset);
  if (self.swapBytes)
    return CFSwapInt32(c->stroff);
  else
    return c->stroff;
}

- (NSUInteger)strsize {
  struct symtab_command *c = (struct symtab_command *)(_data.bytes + _offset);
  if (self.swapBytes)
    return CFSwapInt32(c->strsize);
  else
    return c->strsize;
}

@end
