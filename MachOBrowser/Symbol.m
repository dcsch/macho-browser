//
//  Symbol.m
//  Mach-O Browser
//
//  Created by David Schweinsberg on 6/11/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//

#import "Symbol.h"

@implementation Symbol

- (instancetype)initWithNlist:(struct nlist *)symbolEntry
                  stringTable:(const char *)stringTable
                    swapBytes:(BOOL)swapBytes {
  self = [super init];
  if (self) {
    int32_t strx;
    _type = symbolEntry->n_type;
    _sect = symbolEntry->n_sect;
    if (swapBytes) {
      strx = CFSwapInt32(symbolEntry->n_un.n_strx);
      _desc = CFSwapInt16(symbolEntry->n_desc);
      _value = CFSwapInt32(symbolEntry->n_value);
    } else {
      strx = symbolEntry->n_un.n_strx;
      _desc = symbolEntry->n_desc;
      _value = symbolEntry->n_value;
    }
    _name = @(stringTable + strx);
  }
  return self;
}

- (instancetype)initWithNlist64:(struct nlist_64 *)symbolEntry
                    stringTable:(const char *)stringTable
                      swapBytes:(BOOL)swapBytes {
  self = [super init];
  if (self) {
    int32_t strx;
    _type = symbolEntry->n_type;
    _sect = symbolEntry->n_sect;
    if (swapBytes) {
      strx = CFSwapInt32(symbolEntry->n_un.n_strx);
      _desc = CFSwapInt16(symbolEntry->n_desc);
      _value = CFSwapInt64(symbolEntry->n_value);
    } else {
      strx = symbolEntry->n_un.n_strx;
      _desc = symbolEntry->n_desc;
      _value = symbolEntry->n_value;
    }
    _name = @(stringTable + strx);
  }
  return self;
}

@end
