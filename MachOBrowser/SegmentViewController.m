//
//  SegmentViewController.m
//  Mach-O Browser
//
//  Created by David Schweinsberg on 5/11/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//

#import "SegmentViewController.h"
#import "AlignmentFormatter.h"
#import "HexFormatter.h"
#import "Section.h"

@implementation SegmentViewController

- (void)awakeFromNib {
  // Set the various formatters for data fields
  HexFormatter *hexFormatter = [[HexFormatter alloc] init];
  AlignmentFormatter *alignmentFormatter = [[AlignmentFormatter alloc] init];
  NSTableColumn *column = (tableView.tableColumns)[2];
  [column.dataCell setFormatter:hexFormatter];
  column = (tableView.tableColumns)[3];
  [column.dataCell setFormatter:hexFormatter];
  column = (tableView.tableColumns)[5];
  [column.dataCell setFormatter:alignmentFormatter];
  column = (tableView.tableColumns)[8];
  [column.dataCell setFormatter:hexFormatter];

  vmaddrTextField.formatter = hexFormatter;
  vmsizeTextField.formatter = hexFormatter;
  maxprotTextField.formatter = hexFormatter;
  initprotTextField.formatter = hexFormatter;
  flagsTextField.formatter = hexFormatter;

  // Set a fixed-width font for the text dump view
  NSFontManager *fm = [NSFontManager sharedFontManager];
  NSFont *font = [fm fontWithFamily:@"Courier"
                             traits:NSFixedPitchFontMask
                             weight:5
                               size:12.0];
  column = (dumpTableView.tableColumns)[0];
  [column.dataCell setFont:font];
  column = (dumpTableView.tableColumns)[1];
  [column.dataCell setFont:font];
  column = (dumpTableView.tableColumns)[2];
  [column.dataCell setFont:font];
}

#pragma mark -
#pragma mark NSTableViewDelegate Methods

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
  // Make sure we've scrolled to the top of the content
  NSPoint point = NSMakePoint(0.0, 0.0);
  [dumpTableView scrollPoint:point];

  // Load the new selection text
  NSArray *selection = arrayController.selectedObjects;
  if (selection.count > 0) {
    Section *section = selection[0];
    NSLog(@"Select: %@,%@", section.segName, section.sectName);

  } else {
    //        NSRange range = NSMakeRange(0, dumpTextView.textStorage.length);
    //        [dumpTextView.textStorage deleteCharactersInRange:range];
  }

  [dumpTableView reloadData];
}

#pragma mark -
#pragma mark NSTableViewDataSource Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
  NSArray *selection = arrayController.selectedObjects;
  if (selection.count > 0) {
    Section *section = selection[0];
    NSInteger count = section.size / 16;
    if (section.size % 16)
      ++count;
    return count;
  } else
    return 0;
}

- (id)tableView:(NSTableView *)aTableView
    objectValueForTableColumn:(NSTableColumn *)aTableColumn
                          row:(NSInteger)rowIndex {
  NSArray *selection = arrayController.selectedObjects;
  Section *section = selection[0];

  if ([aTableColumn.identifier isEqualToString:@"address"]) {
    return [NSString stringWithFormat:@"%08lx", 16 * rowIndex + section.addr];
  } else if ([aTableColumn.identifier isEqualToString:@"hex"]) {
    if (rowIndex < section.size / 16) {
      NSRange range = NSMakeRange(16 * rowIndex, 16);
      NSData *data = [section.data subdataWithRange:range];
      const unsigned char *bytes = data.bytes;
      return [NSString
          stringWithFormat:@"%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x "
                           @"%02x %02x %02x %02x %02x %02x",
                           bytes[0], bytes[1], bytes[2], bytes[3], bytes[4],
                           bytes[5], bytes[6], bytes[7], bytes[8], bytes[9],
                           bytes[10], bytes[11], bytes[12], bytes[13],
                           bytes[14], bytes[15]];
    } else {
      NSUInteger length = section.size % 16;
      if (length == 0)
        length = 16;
      NSRange range = NSMakeRange(16 * rowIndex, length);
      NSData *data = [section.data subdataWithRange:range];
      const unsigned char *bytes = data.bytes;
      NSMutableString *hexBuf = [NSMutableString string];
      for (NSUInteger i = 0; i < 16; ++i)
        if (i < length)
          [hexBuf appendFormat:@"%02x ", bytes[i]];
        else
          [hexBuf appendString:@"   "];
      return hexBuf;
    }
  } else if ([aTableColumn.identifier isEqualToString:@"char"]) {
    if (rowIndex < section.size / 16) {
      NSRange range = NSMakeRange(16 * rowIndex, 16);
      NSData *data = [section.data subdataWithRange:range];
      const unsigned char *bytes = data.bytes;
      return [NSString stringWithFormat:@"%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c",
                                        bytes[0] > 31 ? bytes[0] : '.',
                                        bytes[1] > 31 ? bytes[1] : '.',
                                        bytes[2] > 31 ? bytes[2] : '.',
                                        bytes[3] > 31 ? bytes[3] : '.',
                                        bytes[4] > 31 ? bytes[4] : '.',
                                        bytes[5] > 31 ? bytes[5] : '.',
                                        bytes[6] > 31 ? bytes[6] : '.',
                                        bytes[7] > 31 ? bytes[7] : '.',
                                        bytes[8] > 31 ? bytes[8] : '.',
                                        bytes[9] > 31 ? bytes[9] : '.',
                                        bytes[10] > 31 ? bytes[10] : '.',
                                        bytes[11] > 31 ? bytes[11] : '.',
                                        bytes[12] > 31 ? bytes[12] : '.',
                                        bytes[13] > 31 ? bytes[13] : '.',
                                        bytes[14] > 31 ? bytes[14] : '.',
                                        bytes[15] > 31 ? bytes[15] : '.'];
    } else {
      NSUInteger length = section.size % 16;
      if (length == 0)
        length = 16;
      NSRange range = NSMakeRange(16 * rowIndex, length);
      NSData *data = [section.data subdataWithRange:range];
      const unsigned char *bytes = data.bytes;
      NSMutableString *charBuf = [NSMutableString string];
      for (NSUInteger i = 0; i < 16; ++i)
        if (i < length)
          [charBuf appendFormat:@"%c", bytes[i] > 31 ? bytes[i] : '.'];
        else
          [charBuf appendString:@" "];
      return charBuf;
    }
  }
  return nil;
}

@end
