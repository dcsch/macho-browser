//
//  ErrorColorValueTransformer.m
//  Mach-O Browser
//
//  Created by David Schweinsberg on 3/01/10.
//  Copyright 2010 David Schweinsberg. All rights reserved.
//

#import "ErrorColorValueTransformer.h"

@implementation ErrorColorValueTransformer

+ (Class)transformedValueClass
{
    return [NSColor class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    NSNumber *number = value;
    if (number.boolValue == YES)
        return [NSColor redColor];
    else
        return [NSColor controlTextColor];
}

@end
