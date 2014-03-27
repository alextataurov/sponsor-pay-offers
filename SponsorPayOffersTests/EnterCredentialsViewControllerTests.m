//
//  EnterCredentialsViewControllerTests.m
//  SponsorPayOffers
//
//  Created by Alex Tataurov on 25/03/14.
//  Copyright (c) 2014 Alex Tataurov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "XCTestCase+AsyncTesting.h"
#import "EnterCredentialsViewController.h"
#import "OffersViewController.h"

static NSString *const kValidAppId = @"2070";
static NSString *const kValidUserId = @"spiderman";
static NSString *const kValidApiKey = @"1c915e3b5d42d05136185030892fbb846c278927";

@interface EnterCredentialsViewControllerTests : XCTestCase

@end

@implementation EnterCredentialsViewControllerTests

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

- (void)testEmptyAppIDParameter
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EnterCredentialsViewController *enterCredentialsViewController = [storyboard instantiateViewControllerWithIdentifier:@"EnterCredentialsViewController"];
    [enterCredentialsViewController view];
    
    enterCredentialsViewController.appIDTextField.text = @"";
    enterCredentialsViewController.userIDTextField.text = @"test";
    enterCredentialsViewController.apiKeyTextField.text = @"test";
    
    OCMockObject *enterCredentialsViewControllerMock = [OCMockObject partialMockForObject:enterCredentialsViewController];
    [[enterCredentialsViewControllerMock expect] showErrorAlertWithMessage:NSLocalizedString(@"App ID cannot be empty.", @"App ID cannot be empty.")];
    
    [enterCredentialsViewController fetchOffersButtonPressed:nil];
    
    [enterCredentialsViewControllerMock verify];
}

- (void)testEmptyUserIDParameter
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EnterCredentialsViewController *enterCredentialsViewController = [storyboard instantiateViewControllerWithIdentifier:@"EnterCredentialsViewController"];
    [enterCredentialsViewController view];
    
    enterCredentialsViewController.appIDTextField.text = @"test";
    enterCredentialsViewController.userIDTextField.text = @"";
    enterCredentialsViewController.apiKeyTextField.text = @"test";
    
    OCMockObject *enterCredentialsViewControllerMock = [OCMockObject partialMockForObject:enterCredentialsViewController];
    [[enterCredentialsViewControllerMock expect] showErrorAlertWithMessage:NSLocalizedString(@"User ID cannot be empty.", @"User ID cannot be empty.")];
    
    [enterCredentialsViewController fetchOffersButtonPressed:nil];
    
    [enterCredentialsViewControllerMock verify];
}

- (void)testEmptyAPIKeyParameter
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EnterCredentialsViewController *enterCredentialsViewController = [storyboard instantiateViewControllerWithIdentifier:@"EnterCredentialsViewController"];
    [enterCredentialsViewController view];
    
    enterCredentialsViewController.appIDTextField.text = @"test";
    enterCredentialsViewController.userIDTextField.text = @"test";
    enterCredentialsViewController.apiKeyTextField.text = @"";
    
    OCMockObject *enterCredentialsViewControllerMock = [OCMockObject partialMockForObject:enterCredentialsViewController];
    [[enterCredentialsViewControllerMock expect] showErrorAlertWithMessage:NSLocalizedString(@"API Key cannot be empty.", @"API Key cannot be empty.")];
    
    [enterCredentialsViewController fetchOffersButtonPressed:nil];
    
    [enterCredentialsViewControllerMock verify];
}

- (void)testMovingToOffersViewController
{
    id navigationControllerMock = [OCMockObject mockForClass:[UINavigationController class]];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EnterCredentialsViewController *enterCredentialsViewController = [storyboard instantiateViewControllerWithIdentifier:@"EnterCredentialsViewController"];
    [enterCredentialsViewController view];
    
    enterCredentialsViewController.appIDTextField.text = kValidAppId;
    enterCredentialsViewController.userIDTextField.text = kValidUserId;
    enterCredentialsViewController.apiKeyTextField.text = kValidApiKey;
    
    // Credits go to http://www.objc.io/issue-1/testing-view-controllers.html
    
    OCMockObject *enterCredentialsViewControllerMock = [OCMockObject partialMockForObject:enterCredentialsViewController];
    [[[enterCredentialsViewControllerMock stub] andReturn:navigationControllerMock] navigationController];
    
    UIViewController *viewController = [OCMArg checkWithBlock:^BOOL(id obj) {
        if ([obj isKindOfClass:[OffersViewController class]]) {
            [self notify:XCTAsyncTestCaseStatusSucceeded];
        }
        else {
            [self notify:XCTAsyncTestCaseStatusFailed];
        }
        return YES;
    }];
    [[navigationControllerMock expect] pushViewController:viewController animated:YES];
    
    [enterCredentialsViewController fetchOffersButtonPressed:nil];
    
    //[navigationControllerMock verify];
    [enterCredentialsViewControllerMock verify];
    
    [self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:10.0];
}
 
@end