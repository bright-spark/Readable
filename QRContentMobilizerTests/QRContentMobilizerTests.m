//
//  QRContentMobilizerTests.m
//  QRContentMobilizerTests
//
//  Created by Wojciech Czekalski on 21.03.2014.
//  Copyright (c) 2014 Wojciech Czekalski. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QRContentMobilizer.h"

@interface QRContentMobilizerTests : XCTestCase

@end

@implementation QRContentMobilizerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRetreivingConfidence {
    dispatch_semaphore_t __block semaphore = dispatch_semaphore_create(0);
    [QRContentMobilizer setToken:@"788167e3f9da3090957d28101bcd40daff668d7c"];
    QRContentMobilizer *contentMobilizer = [[QRContentMobilizer alloc] init];
    [contentMobilizer  mobilizeContentsOfURL:[NSURL URLWithString:@"http://onet.pl"] parser:nil completion:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

@end
