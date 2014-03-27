//
//  OfferTests.m
//  SponsorPayOffers
//
//  Created by Alex Tataurov on 25/03/14.
//  Copyright (c) 2014 Alex Tataurov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Offer.h"

@interface OfferTests : XCTestCase

@end

@implementation OfferTests

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

- (void)testOffersJSONDataLoading
{
    NSString *fileName = [[NSBundle bundleForClass:[self class]] pathForResource:@"OffersJSONExample" ofType:@"json"];
    NSData *jsonData = [[NSFileManager defaultManager] contentsAtPath:fileName];
    
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    XCTAssertNil(error);
    XCTAssertNotNil(dictionary);
    
    NSArray *offers = [Offer importFromJSON:dictionary];
    XCTAssertNotNil(offers);
    XCTAssertEqual(offers.count, 12);
    
    id firstObject = [offers firstObject];
    NSString *className = [[firstObject class] description];
    XCTAssertTrue([className isEqualToString:@"Offer"]);
    
    Offer *offer = offers[0];
    XCTAssertTrue([offer.title isEqualToString:@"Clean Master - Free Optimizer"]);
    XCTAssertTrue([offer.teaser isEqualToString:@"Herunterladen und STARTEN"]);
    XCTAssertTrue(offer.payout == 9);
    XCTAssertTrue([offer.thumbnailURL isEqualToString:@"http://cdn1.sponsorpay.com/app_icons/3765/big_mobile_icon.png"]);
    XCTAssertNil(offer.thumbnailImage);
}

@end