//
//  MachOBrowserTests.m
//  MachOBrowserTests
//
//  Created by David Schweinsberg on 6/19/18.
//

#import "../MachOBrowser/MachObject.h"
#import <XCTest/XCTest.h>

@interface MachOBrowserTests : XCTestCase

@end

@implementation MachOBrowserTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each
  // test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each
  // test method in the class.
  [super tearDown];
}

- (void)testMachObjectLoad {
  NSData *data =
      [NSData dataWithContentsOfURL:NSBundle.mainBundle.executableURL];
  MachObject *mo = [[MachObject alloc] initWithData:data];
  XCTAssertEqual(mo.magic, MH_MAGIC_64);
}

@end
