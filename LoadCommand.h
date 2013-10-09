//
//  LoadCommand.h
//  Mach-O Browser
//
//  Created by David Schweinsberg on 29/10/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LoadCommand : NSObject
{
    NSData *data;
    NSUInteger offset;
    NSDictionary *dictionary;
    BOOL malformed;
}

@property(readonly) uint32_t command;

@property(copy, readonly) NSString *commandName;

@property(readonly) uint32_t commandSize;

@property(weak, readonly) NSDictionary *dictionary;

@property(readonly) BOOL swapBytes;

@property(readonly) BOOL dataAvailable;

@property(readonly) BOOL malformed;

- (id)initWithData:(NSData *)aData offset:(NSUInteger)anOffset;

@end
