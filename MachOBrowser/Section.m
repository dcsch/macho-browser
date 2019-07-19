//
//  Section.m
//  Mach-O Browser
//
//  Created by David Schweinsberg on 1/11/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//

#import "Section.h"

@implementation Section

- (instancetype)initWithSect:(struct section *)aSect
                        data:(NSData *)aData
                   swapBytes:(BOOL)swapBytes {
  self = [super init];
  if (self) {
    char buf[17];

    strncpy(buf, aSect->sectname, 16);
    buf[16] = 0;
    _sectName = @(buf);

    strncpy(buf, aSect->segname, 16);
    buf[16] = 0;
    _segName = @(buf);

    if (swapBytes) {
      _addr = CFSwapInt32(aSect->addr);
      _size = CFSwapInt32(aSect->size);
      _offset = CFSwapInt32(aSect->offset);
      _align = CFSwapInt32(aSect->align);
      _reloff = CFSwapInt32(aSect->reloff);
      _nreloc = CFSwapInt32(aSect->nreloc);
      _flags = CFSwapInt32(aSect->flags);
      _reserved1 = CFSwapInt32(aSect->reserved1);
      _reserved2 = CFSwapInt32(aSect->reserved2);
    } else {
      _addr = aSect->addr;
      _size = aSect->size;
      _offset = aSect->offset;
      _align = aSect->align;
      _reloff = aSect->reloff;
      _nreloc = aSect->nreloc;
      _flags = aSect->flags;
      _reserved1 = aSect->reserved1;
      _reserved2 = aSect->reserved2;
    }

    _data = aData;
  }
  return self;
}

- (instancetype)initWithSect64:(struct section_64 *)aSect
                          data:(NSData *)aData
                     swapBytes:(BOOL)swapBytes {
  self = [super init];
  if (self) {
    char buf[17];

    strncpy(buf, aSect->sectname, 16);
    buf[16] = 0;
    _sectName = @(buf);

    strncpy(buf, aSect->segname, 16);
    buf[16] = 0;
    _segName = @(buf);

    if (swapBytes) {
      _addr = CFSwapInt64(aSect->addr);
      _size = CFSwapInt64(aSect->size);
      _offset = CFSwapInt32(aSect->offset);
      _align = CFSwapInt32(aSect->align);
      _reloff = CFSwapInt32(aSect->reloff);
      _nreloc = CFSwapInt32(aSect->nreloc);
      _flags = CFSwapInt32(aSect->flags);
      _reserved1 = CFSwapInt32(aSect->reserved1);
      _reserved2 = CFSwapInt32(aSect->reserved2);
    } else {
      _addr = aSect->addr;
      _size = aSect->size;
      _offset = aSect->offset;
      _align = aSect->align;
      _reloff = aSect->reloff;
      _nreloc = aSect->nreloc;
      _flags = aSect->flags;
      _reserved1 = aSect->reserved1;
      _reserved2 = aSect->reserved2;
    }

    _data = aData;
  }
  return self;
}

#pragma mark - Properties

- (NSString *)hexDump {
  NSMutableString *buf = [NSMutableString string];
  const unsigned char *bytes = _data.bytes;
  NSUInteger length = _data.length;

  for (NSUInteger i = 0; i < length; i += 16) {
    if (i + 16 < length) {
      [buf appendFormat:@"%08lx %02x %02x %02x %02x %02x %02x %02x %02x %02x "
                        @"%02x %02x %02x %02x %02x %02x %02x "
                        @"%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n",
                        _addr + i, bytes[i + 0], bytes[i + 1], bytes[i + 2],
                        bytes[i + 3], bytes[i + 4], bytes[i + 5], bytes[i + 6],
                        bytes[i + 7], bytes[i + 8], bytes[i + 9], bytes[i + 10],
                        bytes[i + 11], bytes[i + 12], bytes[i + 13],
                        bytes[i + 14], bytes[i + 15],
                        bytes[i + 0] > 31 ? bytes[i + 0] : '.',
                        bytes[i + 1] > 31 ? bytes[i + 1] : '.',
                        bytes[i + 2] > 31 ? bytes[i + 2] : '.',
                        bytes[i + 3] > 31 ? bytes[i + 3] : '.',
                        bytes[i + 4] > 31 ? bytes[i + 4] : '.',
                        bytes[i + 5] > 31 ? bytes[i + 5] : '.',
                        bytes[i + 6] > 31 ? bytes[i + 6] : '.',
                        bytes[i + 7] > 31 ? bytes[i + 7] : '.',
                        bytes[i + 8] > 31 ? bytes[i + 8] : '.',
                        bytes[i + 9] > 31 ? bytes[i + 9] : '.',
                        bytes[i + 10] > 31 ? bytes[i + 10] : '.',
                        bytes[i + 11] > 31 ? bytes[i + 11] : '.',
                        bytes[i + 12] > 31 ? bytes[i + 12] : '.',
                        bytes[i + 13] > 31 ? bytes[i + 13] : '.',
                        bytes[i + 14] > 31 ? bytes[i + 14] : '.',
                        bytes[i + 15] > 31 ? bytes[i + 15] : '.'];
    } else {
      NSMutableString *hexBuf = [NSMutableString string];
      NSMutableString *charBuf = [NSMutableString string];
      [hexBuf appendFormat:@"%08lx ", _addr + i];
      for (NSUInteger j = 0; j < 16; ++j) {
        if (i + j < length) {
          [hexBuf appendFormat:@"%02x ", bytes[i + j]];
          [charBuf appendFormat:@"%c", bytes[i + j] > 31 ? bytes[i + j] : '.'];
        } else {
          [hexBuf appendString:@"   "];
          [charBuf appendString:@" "];
        }
      }
      [buf appendString:hexBuf];
      [buf appendString:charBuf];
    }
  }
  return buf;
}

@end
