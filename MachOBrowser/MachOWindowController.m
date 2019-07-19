//
//  MachOWindowController.m
//  Mach-O Browser
//
//  Created by David Schweinsberg on 29/10/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//

#import "MachOWindowController.h"
#import "HexDumpViewController.h"
#import "LoadCommand.h"
#import "SegmentViewController.h"
#import "SymbolTableViewController.h"
#include <mach-o/loader.h>

#define SIMPLELISTVIEW_NIB_NAME @"SimpleListView"
#define SEGMENTVIEW_NIB_NAME @"SegmentView"
#define SYMBOLTABLEVIEW_NIB_NAME @"SymbolTableView"
#define HEXDUMPVIEW_NIB_NAME @"HexDumpView"

#define kMinTableViewSplit 120.0f

@interface MachOWindowController () <NSTableViewDelegate> {
  IBOutlet NSTabView *tabView;
  IBOutlet NSArrayController *arrayController;
  IBOutlet NSArrayController *archArrayController;
  IBOutlet NSTableView *tableView;

  NSViewController *simpleListViewController;
  SegmentViewController *segmentViewController;
  SymbolTableViewController *symbolTableViewController;
  HexDumpViewController *hexDumpViewController;
}

- (IBAction)selectArch:(id)sender;

- (void)addView:(NSView *)newView label:(NSString *)label;
- (void)removeViews;

@end

@implementation MachOWindowController

- (void)awakeFromNib {
  // Load the view controllers
  simpleListViewController =
      [[NSViewController alloc] initWithNibName:SIMPLELISTVIEW_NIB_NAME
                                         bundle:nil];
  segmentViewController =
      [[SegmentViewController alloc] initWithNibName:SEGMENTVIEW_NIB_NAME
                                              bundle:nil];
  symbolTableViewController = [[SymbolTableViewController alloc]
      initWithNibName:SYMBOLTABLEVIEW_NIB_NAME
               bundle:nil];
  hexDumpViewController =
      [[HexDumpViewController alloc] initWithNibName:HEXDUMPVIEW_NIB_NAME
                                              bundle:nil];

  // Set the autosave names
  [self setShouldCascadeWindows:NO];
  [self.window setFrameAutosaveName:[self.document fileURL].path];
  //    [leftRightSplitView setAutosaveName:[NSString
  //    stringWithFormat:@"Vertical %@", library.rootPath]];
  //    [topBottomSplitView setAutosaveName:[NSString
  //    stringWithFormat:@"Horizontal %@", library.rootPath]];
}

#pragma mark - NSTableViewDelegate Methods

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
  [self removeViews];

  if (arrayController.selectedObjects.count > 0) {
    LoadCommand *loadCommand = (arrayController.selectedObjects)[0];

    if (loadCommand.dataAvailable) {
      // Choose which view we're going to use for this load command
      NSViewController *loadCommandViewController;
      NSString *label;
      if (loadCommand.command == LC_SEGMENT ||
          loadCommand.command == LC_SEGMENT_64) {
        loadCommandViewController = segmentViewController;
        label = @"Segment";
      } else if (loadCommand.command == LC_SYMTAB) {
        loadCommandViewController = symbolTableViewController;
        label = @"Symbols";
      } else {
        loadCommandViewController = simpleListViewController;
        label = @"Name-Value";
      }

      // Set the load command as the represented object and make the switch
      loadCommandViewController.representedObject = loadCommand;
      [self addView:loadCommandViewController.view label:label];
    }
    hexDumpViewController.representedObject = loadCommand;
    [self addView:hexDumpViewController.view label:@"Hex"];
  }
}

#pragma mark - NSSplitViewDelegate Methods

// -------------------------------------------------------------------------------
//    splitView:constrainMinCoordinate:
//
//    What you really have to do to set the minimum size of both subviews to
//    kMinOutlineViewSplit points.
// -------------------------------------------------------------------------------
//- (float)splitView:(NSSplitView *)splitView
//constrainMinCoordinate:(float)proposedCoordinate ofSubviewAt:(int)index
//{
//    return proposedCoordinate + kMinTableViewSplit;
//}

////
///-------------------------------------------------------------------------------
////    splitView:constrainMaxCoordinate:
////
///-------------------------------------------------------------------------------
//- (float)splitView:(NSSplitView *)splitView
//constrainMaxCoordinate:(float)proposedCoordinate ofSubviewAt:(int)index
//{
//    return proposedCoordinate - kMinTableViewSplit;
//}

// -------------------------------------------------------------------------------
//    splitView:resizeSubviewsWithOldSize:
//
//    Keep the left split pane from resizing as the user moves the divider line.
// -------------------------------------------------------------------------------
- (void)splitView:(NSSplitView *)sender
    resizeSubviewsWithOldSize:(NSSize)oldSize {
  NSRect newFrame = sender.frame; // get the new size of the whole splitView
  NSView *left = sender.subviews[0];
  NSRect leftFrame = left.frame;
  NSView *right = sender.subviews[1];
  NSRect rightFrame = right.frame;

  CGFloat dividerThickness = sender.dividerThickness;

  leftFrame.size.height = newFrame.size.height;

  rightFrame.size.width =
      newFrame.size.width - leftFrame.size.width - dividerThickness;
  rightFrame.size.height = newFrame.size.height;
  rightFrame.origin.x = leftFrame.size.width + dividerThickness;

  left.frame = leftFrame;
  right.frame = rightFrame;
}

#pragma mark - Actions

- (IBAction)selectArch:(id)sender {
  // Why do we need to do this?  Surely once we select a pop-up menu item,
  // that is what is "selected".  But it would seem not.
  NSPopUpButton *popUpButton = sender;
  [archArrayController setSelectionIndex:popUpButton.indexOfSelectedItem];

  NSLog(@"%@, Selection: %@", sender, arrayController.selection);
}

#pragma mark - Private Methods

- (void)addView:(NSView *)newView label:(NSString *)label {
  NSTabViewItem *item = [[NSTabViewItem alloc] initWithIdentifier:nil];
  item.label = label;
  item.view = newView;
  [tabView addTabViewItem:item];
}

- (void)removeViews {
  for (NSTabViewItem *item in tabView.tabViewItems) {
    [tabView removeTabViewItem:item];
  }
  [tabView
      displayIfNeeded]; // we want the removed views to disappear right away
}

@end
