//
//  HexFormatter.m
//  Mach-O Browser
//
//  Created by David Schweinsberg on 5/11/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//

#import "HexFormatter.h"

@interface HexFormatter (Private)

//- (NSNumber *)numberFromHexString:(NSString *)string;

@end


@implementation HexFormatter

- (id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}


- (NSString *)stringForObjectValue:(id)obj
{
    if ([obj isKindOfClass:[NSString class]])
    {
        return [NSString stringWithFormat:@"0x%@", obj];
    }
    else if ([obj isKindOfClass:[NSNumber class]])
    {
        NSNumber *number = obj;
        return [NSString stringWithFormat:@"0x%08x", number.intValue];
    }
    return nil;
}

- (BOOL)getObjectValue:(id *)obj
             forString:(NSString *)string
      errorDescription:(NSString **)errorString
{
//    *obj = [self numberFromHexString:string];
    return (*obj) ? YES : NO;
}

/*
- (NSNumber *)numberFromHexString:(NSString *)string
{
    // Trim string to only valid characters
    NSRange range = [string rangeOfCharactersFromSet:hexDigitCharSet];
    NSString *hexString = [string substringWithRange:range];
    if (!hexString)
        return nil;
    
    // Calculate the value
    NSUInteger value = 0;
    NSUInteger factor = 1;
    NSInteger i;
    for (i = [hexString length] - 1; i >= 0; --i)
    {
        unichar c = [hexString characterAtIndex:i];
        if (L'0' <= c && c <= L'9')
            value += (c - L'0') * factor;
        else if (L'a' <= c && c <= L'f')
            value += (c - L'a' + 10) * factor;
        else if (L'A' <= c && c <= L'F')
            value += (c - L'A' + 10) * factor;
        factor *= 16;
    }
    return [NSNumber numberWithUnsignedInt:value];
    return nil;
}
*/
@end
