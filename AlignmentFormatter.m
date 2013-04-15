//
//  AlignmentFormatter.m
//  Mach-O Browser
//
//  Created by David Schweinsberg on 5/11/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//

#import "AlignmentFormatter.h"

@implementation AlignmentFormatter

- (NSString *)stringForObjectValue:(id)obj
{
    if ([obj isKindOfClass:[NSString class]])
    {
        return [NSString stringWithFormat:@"0x%@", obj];
    }
    else if ([obj isKindOfClass:[NSNumber class]])
    {
        NSNumber *number = obj;
        return [NSString stringWithFormat:@"2^%d (%d)",
                number.intValue,
                2 << (number.intValue - 1)];
    }
    return nil;
}

@end
