//
//  MachOWindowController.m
//  Mach-O Browser
//
//  Created by David Schweinsberg on 29/10/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//

#import "MachOWindowController.h"
#import "LoadCommand.h"
#import "SegmentViewController.h"
#import "SymbolTableViewController.h"
#include <mach-o/loader.h>

#define MACHOWINDOW_NIB_NAME        @"MachOWindow"
#define SIMPLELISTVIEW_NIB_NAME     @"SimpleListView"
#define SEGMENTVIEW_NIB_NAME        @"SegmentView"
#define SYMBOLTABLEVIEW_NIB_NAME    @"SymbolTableView"

#define kMinTableViewSplit          120.0f

@interface MachOWindowController (Private)

- (void)switchToView:(NSView *)newView;
- (void)removeSubview;

@end

@implementation MachOWindowController

- (id)init
{
    self = [super initWithWindowNibName:MACHOWINDOW_NIB_NAME];
    if (self)
    {
    }
    return self;
}

- (void)dealloc
{
    [simpleListViewController release];
    [segmentViewController release];
    [super dealloc];
}

- (void)awakeFromNib
{
	// Load the view controllers
	simpleListViewController = [[NSViewController alloc] initWithNibName:SIMPLELISTVIEW_NIB_NAME
                                                                  bundle:nil];
    segmentViewController = [[SegmentViewController alloc] initWithNibName:SEGMENTVIEW_NIB_NAME
                                                                    bundle:nil];
    symbolTableViewController = [[SymbolTableViewController alloc] initWithNibName:SYMBOLTABLEVIEW_NIB_NAME
                                                                            bundle:nil];
    
    // Set the autosave names
    [self setShouldCascadeWindows:NO];
    [self.window setFrameAutosaveName:[[self.document fileURL] path]];
//    [leftRightSplitView setAutosaveName:[NSString stringWithFormat:@"Vertical %@", library.rootPath]];
//    [topBottomSplitView setAutosaveName:[NSString stringWithFormat:@"Horizontal %@", library.rootPath]];
}

#pragma mark -
#pragma mark NSTableViewDelegate Methods

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    if (arrayController.selectedObjects.count > 0)
    {
        LoadCommand *loadCommand = [arrayController.selectedObjects objectAtIndex:0];
        
        if (loadCommand.dataAvailable)
        {
            // Choose which view we're going to use for this load command
            NSViewController *loadCommandViewController;
            if (loadCommand.command == LC_SEGMENT || loadCommand.command == LC_SEGMENT_64)
                loadCommandViewController = segmentViewController;
            else if (loadCommand.command == LC_SYMTAB)
                loadCommandViewController = symbolTableViewController;
            else
                loadCommandViewController = simpleListViewController;
            
            // Set the load command as the represented object and make the switch
            loadCommandViewController.representedObject = loadCommand;
            [self switchToView:loadCommandViewController.view];
        }
        else
            [self removeSubview];
    }
    else
        [self removeSubview];
}

#pragma mark -
#pragma mark NSSplitViewDelegate Methods

// -------------------------------------------------------------------------------
//	splitView:constrainMinCoordinate:
//
//	What you really have to do to set the minimum size of both subviews to kMinOutlineViewSplit points.
// -------------------------------------------------------------------------------
- (float)splitView:(NSSplitView *)splitView constrainMinCoordinate:(float)proposedCoordinate ofSubviewAt:(int)index
{
	return proposedCoordinate + kMinTableViewSplit;
}

// -------------------------------------------------------------------------------
//	splitView:constrainMaxCoordinate:
// -------------------------------------------------------------------------------
- (float)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(float)proposedCoordinate ofSubviewAt:(int)index
{
	return proposedCoordinate - kMinTableViewSplit;
}

// -------------------------------------------------------------------------------
//	splitView:resizeSubviewsWithOldSize:
//
//	Keep the left split pane from resizing as the user moves the divider line.
// -------------------------------------------------------------------------------
- (void)splitView:(NSSplitView*)sender resizeSubviewsWithOldSize:(NSSize)oldSize
{
	NSRect newFrame = [sender frame]; // get the new size of the whole splitView
	NSView *left = [[sender subviews] objectAtIndex:0];
	NSRect leftFrame = [left frame];
	NSView *right = [[sender subviews] objectAtIndex:1];
	NSRect rightFrame = [right frame];
    
	CGFloat dividerThickness = [sender dividerThickness];
    
	leftFrame.size.height = newFrame.size.height;
    
	rightFrame.size.width = newFrame.size.width - leftFrame.size.width - dividerThickness;
	rightFrame.size.height = newFrame.size.height;
	rightFrame.origin.x = leftFrame.size.width + dividerThickness;
    
	[left setFrame:leftFrame];
	[right setFrame:rightFrame];
}

#pragma mark -
#pragma mark Actions

- (IBAction)selectArch:(id)sender
{
    // Why do we need to do this?  Surely once we select a pop-up menu item,
    // that is what is "selected".  But it would seem not.
    NSPopUpButton *popUpButton = sender;
    [archArrayController setSelectionIndex:popUpButton.indexOfSelectedItem];
    
    NSLog(@"%@, Selection: %@", sender, arrayController.selection);
}

#pragma mark -
#pragma mark Private Methods

- (void)switchToView:(NSView *)newView
{
    if (newView != currentView)
    {
        [self removeSubview];
        [placeHolderView addSubview:newView];
        currentView = newView;
        
        NSRect newBounds;
        newBounds.origin.x = 0;
        newBounds.origin.y = 0;
        newBounds.size.width = [[currentView superview] frame].size.width;
        newBounds.size.height = [[currentView superview] frame].size.height;
        [currentView setFrame:[[currentView superview] frame]];
        
        // make sure our added subview is placed and resizes correctly
        [currentView setFrameOrigin:NSMakePoint(0,0)];
        [currentView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    }
}

- (void)removeSubview
{
	// empty selection
	NSArray *subViews = [placeHolderView subviews];
	if ([subViews count] > 0)
	{
		[[subViews objectAtIndex:0] removeFromSuperview];
	}
    currentView = nil;
	
	[placeHolderView displayIfNeeded];	// we want the removed views to disappear right away
}

@end
