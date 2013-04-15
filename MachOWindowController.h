//
//  MachOWindowController.h
//  Mach-O Browser
//
//  Created by David Schweinsberg on 29/10/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SegmentViewController;
@class SymbolTableViewController;

@interface MachOWindowController : NSWindowController <NSTableViewDelegate>
{
    IBOutlet NSView *placeHolderView;
    IBOutlet NSArrayController *arrayController;
    IBOutlet NSArrayController *archArrayController;
    IBOutlet NSTableView *tableView;
    
    NSView *currentView;
    NSViewController *simpleListViewController;
    SegmentViewController *segmentViewController;
    SymbolTableViewController *symbolTableViewController;
}

- (IBAction)selectArch:(id)sender;

@end
