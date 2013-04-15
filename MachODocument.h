//
//  MachODocument.h
//  Mach-O Browser
//
//  Created by David Schweinsberg on 29/10/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//


#import <Cocoa/Cocoa.h>

@interface MachODocument : NSDocument
{
    NSArray *machObjects;
}

@property(retain, readonly) NSArray *machObjects;

@end
