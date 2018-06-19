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
    NSData *_data;
    NSUInteger _offset;
    BOOL _malformed;
}

@property(readonly) uint32_t command;

@property(nonnull, readonly) NSString *commandName;

@property(readonly) uint32_t commandSize;

@property(nullable, weak, readonly) NSDictionary *dictionary;

@property(readonly) BOOL swapBytes;

@property(readonly) BOOL dataAvailable;

@property(readonly) BOOL malformed;

@property(nonnull, readonly) NSData *commandData;

- (instancetype)initWithData:(nonnull NSData *)aData offset:(NSUInteger)anOffset NS_DESIGNATED_INITIALIZER;

- (instancetype)init __attribute__((unavailable));

+ (instancetype)loadCommandWithData:(nonnull NSData *)data offset:(NSUInteger)offset;

@end
