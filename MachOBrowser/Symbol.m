//
//  Symbol.m
//  Mach-O Browser
//
//  Created by David Schweinsberg on 6/11/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//

#import "Symbol.h"


@implementation Symbol

@synthesize name;
@synthesize type;
@synthesize sect;
@synthesize desc;
@synthesize value;

- (instancetype)initWithNlist:(struct nlist *)symbolEntry
        stringTable:(const char *)stringTable
          swapBytes:(BOOL)swapBytes
{
    self = [super init];
    if (self)
    {
        int32_t strx;
        type = symbolEntry->n_type;
        sect = symbolEntry->n_sect;
        if (swapBytes)
        {
            strx = CFSwapInt32(symbolEntry->n_un.n_strx);
            desc = CFSwapInt16(symbolEntry->n_desc);
            value = CFSwapInt32(symbolEntry->n_value);
        }
        else
        {
            strx = symbolEntry->n_un.n_strx;
            desc = symbolEntry->n_desc;
            value = symbolEntry->n_value;
        }
        name = @(stringTable + strx);
    }
    return self;
}

- (instancetype)initWithNlist64:(struct nlist_64 *)symbolEntry
          stringTable:(const char *)stringTable
            swapBytes:(BOOL)swapBytes
{
    self = [super init];
    if (self)
    {
        int32_t strx;
        type = symbolEntry->n_type;
        sect = symbolEntry->n_sect;
        if (swapBytes)
        {
            strx = CFSwapInt32(symbolEntry->n_un.n_strx);
            desc = CFSwapInt16(symbolEntry->n_desc);
            value = CFSwapInt64(symbolEntry->n_value);
        }
        else
        {
            strx = symbolEntry->n_un.n_strx;
            desc = symbolEntry->n_desc;
            value = symbolEntry->n_value;
        }
        name = @(stringTable + strx);
    }
    return self;
}


@end
