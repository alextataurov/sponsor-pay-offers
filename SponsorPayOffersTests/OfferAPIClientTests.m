//
//  OfferAPIClientTests.m
//  SponsorPayOffers
//
//  Created by Alex Tataurov on 25/03/14.
//  Copyright (c) 2014 Alex Tataurov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OfferAPIClient.h"
#import "XCTestCase+AsyncTesting.h"

static NSString *const kTestAppId = @"1111";
static NSString *const kTestUserId = @"user";
static NSString *const kTestApiKey = @"aaaaaaabbbbbbbbccccccdddddd";

static NSString *const kValidAppId = @"2070";
static NSString *const kValidUserId = @"spiderman";
static NSString *const kValidApiKey = @"1c915e3b5d42d05136185030892fbb846c278927";

const NSTimeInterval testTimestamp = 1395763268;

@interface OfferAPIClientTests : XCTestCase

@end

@implementation OfferAPIClientTests

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

- (void)testUrlBuildWithNoParameters
{
    OfferAPIClient *offerAPIClient = [[OfferAPIClient alloc] initWithAppID:kTestAppId userID:kTestUserId apiKey:kTestApiKey];
    
    if ([offerAPIClient respondsToSelector:@selector(buildOfferUrlForTimestampDate:)]) {
        NSDate *testTimestampDate = [NSDate dateWithTimeIntervalSince1970:testTimestamp];
        NSString *offerAPIUrl = [offerAPIClient performSelector:@selector(buildOfferUrlForTimestampDate:) withObject:testTimestampDate];
        
        XCTAssertNotNil(offerAPIUrl);
        XCTAssertTrue([offerAPIUrl isEqualToString:@"http://api.sponsorpay.com/feed/v1/offers.json?appid=1111&format=json&locale=de&timestamp=1395763268&uid=user&hashkey=bb62d3288f85bfa429e986331be0ac634353f817"]);
    }
}

- (void)testUrlBuildWithPageParameter
{
    OfferAPIClient *offerAPIClient = [[OfferAPIClient alloc] initWithAppID:kTestAppId userID:kTestUserId apiKey:kTestApiKey];
    [offerAPIClient addParameterForKey:@"page" andValue:@"1"];
    
    if ([offerAPIClient respondsToSelector:@selector(buildOfferUrlForTimestampDate:)]) {
        NSDate *testTimestampDate = [NSDate dateWithTimeIntervalSince1970:testTimestamp];
        NSString *offerAPIUrl = [offerAPIClient performSelector:@selector(buildOfferUrlForTimestampDate:) withObject:testTimestampDate];
        
        XCTAssertNotNil(offerAPIUrl);
        XCTAssertTrue([offerAPIUrl isEqualToString:@"http://api.sponsorpay.com/feed/v1/offers.json?appid=1111&format=json&locale=de&page=1&timestamp=1395763268&uid=user&hashkey=ab646c6cf3799d1a86a87e5679a4662d2adfc6ce"]);
    }
}

- (void)testUrlBuildWithManyParameters
{
    OfferAPIClient *offerAPIClient = [[OfferAPIClient alloc] initWithAppID:kTestAppId userID:kTestUserId apiKey:kTestApiKey];
    [offerAPIClient addParameterForKey:@"page" andValue:@"1"];
    [offerAPIClient addParameterForKey:@"ip" andValue:@"1.1.1.1"];
    [offerAPIClient addParameterForKey:@"pub0" andValue:@"campaign0"];
    [offerAPIClient addParameterForKey:@"device_id" andValue:@"2b6f0cc904d137be2e 1730235f5664094b831186"];
    
    if ([offerAPIClient respondsToSelector:@selector(buildOfferUrlForTimestampDate:)]) {
        NSDate *testTimestampDate = [NSDate dateWithTimeIntervalSince1970:testTimestamp];
        NSString *offerAPIUrl = [offerAPIClient performSelector:@selector(buildOfferUrlForTimestampDate:) withObject:testTimestampDate];
        
        XCTAssertNotNil(offerAPIUrl);
        XCTAssertTrue([offerAPIUrl isEqualToString:@"http://api.sponsorpay.com/feed/v1/offers.json?appid=1111&device_id=2b6f0cc904d137be2e 1730235f5664094b831186&format=json&ip=1.1.1.1&locale=de&page=1&pub0=campaign0&timestamp=1395763268&uid=user&hashkey=bae12c46324cf7aa6fa782716b56509fd198b2ff"]);
    }
}

- (void)testOffersErrorFetching
{
    OfferAPIClient *offerAPIClient = [[OfferAPIClient alloc] initWithAppID:kTestAppId userID:kTestUserId apiKey:kTestApiKey];
    
    [offerAPIClient fetchOffers:^(NSArray *offers, NSError *error) {
        if (error != nil) {
            [self notify:XCTAsyncTestCaseStatusSucceeded];
        }
        else {
            [self notify:XCTAsyncTestCaseStatusFailed];
        }
    }];
    [self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:10.0];
}

- (void)testOffersValidFetching
{
    OfferAPIClient *offerAPIClient = [[OfferAPIClient alloc] initWithAppID:kValidAppId userID:kValidUserId apiKey:kValidApiKey];
    
    [offerAPIClient fetchOffers:^(NSArray *offers, NSError *error) {
        if (error == nil) {
            [self notify:XCTAsyncTestCaseStatusSucceeded];
        }
        else {
            [self notify:XCTAsyncTestCaseStatusFailed];
        }
    }];
    [self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:10.0];
}

@end