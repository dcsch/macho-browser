//
//  MachObject.m
//  Mach-O Browser
//
//  Created by David Schweinsberg on 29/10/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//

#import "MachObject.h"
#import "LoadCommand.h"

@implementation MachObject {
  NSData *_data;
  BOOL _swapBytes;
}

- (instancetype)initWithData:(NSData *)objectData {
  self = [super init];
  if (self) {
    _data = objectData;

    uint32_t m = self.magic;
    if (m == MH_CIGAM || m == MH_CIGAM_64)
      _swapBytes = YES;
    else
      _swapBytes = NO;

    // Scan through all the load commands
    NSMutableArray *commands = [NSMutableArray array];
    NSUInteger offset;
    if (m == MH_MAGIC_64 || m == MH_CIGAM_64)
      offset = sizeof(struct mach_header_64);
    else
      offset = sizeof(struct mach_header);
    int32_t sizeofcmds = self.sizeOfCommands;
    while (sizeofcmds > 0) {
      LoadCommand *loadCommand =
          [LoadCommand loadCommandWithData:_data offset:offset];
      [commands addObject:loadCommand];

      NSLog(@"cmd: %u, cmdsize: %u", loadCommand.command,
            loadCommand.commandSize);

      offset += loadCommand.commandSize;
      sizeofcmds -= loadCommand.commandSize;
    }
    _loadCommands = commands;
  }
  return self;
}

- (NSString *)description {
  NSString *cpuString;
  cpu_type_t ct = self.cpuType;
  switch (ct) {
  case CPU_TYPE_VAX:
    cpuString = @"vax";
    break;
  case CPU_TYPE_MC680x0:
    cpuString = @"mc680x0";
    break;
  case CPU_TYPE_I386:
    cpuString = @"i386";
    break;
  case CPU_TYPE_X86_64:
    cpuString = @"x86_64";
    break;
  case CPU_TYPE_MC98000:
    cpuString = @"mc98000";
    break;
  case CPU_TYPE_HPPA:
    cpuString = @"hppa";
    break;
  case CPU_TYPE_ARM:
    cpuString = @"arm";
    break;
  case CPU_TYPE_ARM64:
    cpuString = @"arm64";
    break;
  case CPU_TYPE_MC88000:
    cpuString = @"mc88000";
    break;
  case CPU_TYPE_SPARC:
    cpuString = @"sparc";
    break;
  case CPU_TYPE_I860:
    cpuString = @"i860";
    break;
  case CPU_TYPE_POWERPC:
    cpuString = @"ppc";
    break;
  case CPU_TYPE_POWERPC64:
    cpuString = @"ppc64";
    break;
  default:
    cpuString = [NSString stringWithFormat:@"%x", self.cpuType];
    break;
  }
  return [NSString stringWithFormat:@"CPU Type: %@, CPU Subtype: %x", cpuString,
                                    self.cpuSubtype];
}

#pragma mark - Properties

- (uint32_t)magic {
  struct mach_header *header = (struct mach_header *)_data.bytes;
  return header->magic;
}

- (cpu_type_t)cpuType {
  struct mach_header *header = (struct mach_header *)_data.bytes;
  if (_swapBytes)
    return CFSwapInt32(header->cputype);
  else
    return header->cputype;
}

- (cpu_subtype_t)cpuSubtype {
  struct mach_header *header = (struct mach_header *)_data.bytes;
  if (_swapBytes)
    return CFSwapInt32(header->cpusubtype);
  else
    return header->cpusubtype;
}

- (uint32_t)sizeOfCommands {
  struct mach_header *header = (struct mach_header *)_data.bytes;
  if (_swapBytes)
    return CFSwapInt32(header->sizeofcmds);
  else
    return header->sizeofcmds;
}

@end
