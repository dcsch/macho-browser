//
//  HexDumpViewController.m
//  Mach-O Browser
//
//  Created by David Schweinsberg on 10/10/13.
//
//

#import "HexDumpViewController.h"
#import "LoadCommand.h"

@interface HexDumpViewController () <NSTableViewDataSource>

@end

@implementation HexDumpViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
    // Set a fixed-width font for the text dump view
    NSFontManager *fm = [NSFontManager sharedFontManager];
    NSFont *font = [fm fontWithFamily:@"Courier"
                               traits:NSFixedPitchFontMask
                               weight:5
                                 size:12.0];
    NSTableColumn *column = (self.dumpTableView.tableColumns)[0];
    [column.dataCell setFont:font];
    column = (self.dumpTableView.tableColumns)[1];
    [column.dataCell setFont:font];
    column = (self.dumpTableView.tableColumns)[2];
    [column.dataCell setFont:font];
}

#pragma mark - NSTableViewDataSource Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    LoadCommand *loadCommand = self.representedObject;
    NSInteger count = loadCommand.commandSize / 16;
    if (loadCommand.commandSize % 16)
        ++count;
    return count;
}

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
            row:(NSInteger)rowIndex
{
    LoadCommand *loadCommand = self.representedObject;

    if ([aTableColumn.identifier isEqualToString:@"address"])
    {
        return [NSString stringWithFormat:@"%08lx", 16 * rowIndex /*+ section.addr*/];
    }
    else if ([aTableColumn.identifier isEqualToString:@"hex"])
    {
        if (rowIndex < loadCommand.commandSize / 16)
        {
            NSRange range = NSMakeRange(16 * rowIndex, 16);
            NSData *data = [loadCommand.commandData subdataWithRange:range];
            const unsigned char *bytes = data.bytes;
            return [NSString stringWithFormat:@"%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x",
                    bytes[0],
                    bytes[1],
                    bytes[2],
                    bytes[3],
                    bytes[4],
                    bytes[5],
                    bytes[6],
                    bytes[7],
                    bytes[8],
                    bytes[9],
                    bytes[10],
                    bytes[11],
                    bytes[12],
                    bytes[13],
                    bytes[14],
                    bytes[15]];
        }
        else
        {
            NSUInteger length = loadCommand.commandSize % 16;
            if (length == 0)
                length = 16;
            NSRange range = NSMakeRange(16 * rowIndex, length);
            NSData *data = [loadCommand.commandData subdataWithRange:range];
            const unsigned char *bytes = data.bytes;
            NSMutableString *hexBuf = [NSMutableString string];
            for (NSUInteger i = 0; i < 16; ++i)
                if (i < length)
                    [hexBuf appendFormat:@"%02x ", bytes[i]];
                else
                    [hexBuf appendString:@"   "];
            return hexBuf;
        }
    }
    else if ([aTableColumn.identifier isEqualToString:@"char"])
    {
        if (rowIndex < loadCommand.commandSize / 16)
        {
            NSRange range = NSMakeRange(16 * rowIndex, 16);
            NSData *data = [loadCommand.commandData subdataWithRange:range];
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
        }
        else
        {
            NSUInteger length = loadCommand.commandSize % 16;
            if (length == 0)
                length = 16;
            NSRange range = NSMakeRange(16 * rowIndex, length);
            NSData *data = [loadCommand.commandData subdataWithRange:range];
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
