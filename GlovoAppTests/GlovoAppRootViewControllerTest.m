//
//  GlovoAppRootViewControllerTest.m
//  GlovoAppTests
//
//  Created by Josue Hernandez Gonzalez on 31/12/2018.
//  Copyright © 2018 Josue Hernandez Gonzalez. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Expecta/Expecta.h>


#import "GlovoAppRootViewController.h"
#import "GlovoAppRootPresenter.h"

@interface GlovoAppRootViewControllerTest : XCTestCase

@end

@implementation GlovoAppRootViewControllerTest

-(void)testInitWithPresenter
{
    GlovoAppRootPresenter *presenter = [GlovoAppRootPresenter new];
    GlovoAppRootViewController *vc = [[GlovoAppRootViewController alloc] initWithPresenter:presenter];
    
    expect(vc).notTo.beNil();
}


@end
