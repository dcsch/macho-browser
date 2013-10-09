//
//  MachODocument.m
//  Mach-O Browser
//
//  Created by David Schweinsberg on 29/10/09.
//  Copyright 2009 David Schweinsberg. All rights reserved.
//

#import "MachODocument.h"
#import "MachOWindowController.h"
#import "MachObject.h"
#include <mach-o/fat.h>

@implementation MachODocument

@synthesize machObjects;

- (id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}


- (void)makeWindowControllers
{
    MachOWindowController *controller = [[MachOWindowController alloc] init];
    [self addWindowController:controller];
}

- (BOOL)readFromData:(NSData *)data
              ofType:(NSString *)typeName
               error:(NSError **)outError
{
    NSMutableArray *objects = [NSMutableArray array];
    const char *bytes = data.bytes;
    uint32_t magic = *(uint32_t *)bytes;
    struct fat_arch *arch = NULL;
    int objectCount;

    if (magic == FAT_MAGIC || magic == FAT_CIGAM)
    {
        // This is a fat binary, so load multiple Mach-O objects
        struct fat_header *header = (struct fat_header *)bytes;
        objectCount = CFSwapInt32BigToHost(header->nfat_arch);
        arch = (struct fat_arch *)(bytes + sizeof(struct fat_header));
    }
    else
        objectCount = 1;
    
    for (int i = 0; i < objectCount; ++i)
    {
        NSData *objectData;
        if (arch)
        {
            // Aquire a data object consisting of a single archtecture
            uint32_t offset = CFSwapInt32BigToHost(arch->offset);
            uint32_t size = CFSwapInt32BigToHost(arch->size);
            magic = *(uint32_t *)(bytes + offset);
            NSRange range = NSMakeRange(offset, size);
            objectData = [data subdataWithRange:range];
        }
        else
            objectData = data;

        if (magic == MH_MAGIC
            || magic == MH_CIGAM
            || magic == MH_MAGIC_64
            || magic == MH_CIGAM_64)
        {
            MachObject *machObject = [[MachObject alloc] initWithData:objectData];
            [objects addObject:machObject];
        }

        if (arch)
            ++arch;
    }
    
    if (objects.count > 0)
    {
        machObjects = objects;
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
