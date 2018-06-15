//
//  SegmentViewController.h
//  Mach-O Browser
//
//  Created by David Schweinsberg on 5/11/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SegmentViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>
{
    IBOutlet NSTextField *vmaddrTextField;
    IBOutlet NSTextField *vmsizeTextField;
    IBOutlet NSTextField *maxprotTextField;
    IBOutlet NSTextField *initprotTextField;
    IBOutlet NSTextField *flagsTextField;
    IBOutlet NSTableView *tableView;
    IBOutlet NSArrayController *arrayController;
    IBOutlet NSTableView *dumpTableView;
}

@end
