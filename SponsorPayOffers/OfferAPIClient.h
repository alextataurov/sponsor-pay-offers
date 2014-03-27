//
//  OfferAPIClient.h
//  SponsorPayOffers
//
//  Created by Alex Tataurov on 26/03/14.
//  Copyright (c) 2014 Alex Tataurov. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const OfferAPIClientErrorDomain;

enum {
    OfferAPIClientInvalidResponseError = 1000,
    OfferAPIClientSignatureNotMatchError,
};

@interface OfferAPIClient : NSObject

@property (nonatomic, readonly) NSString *appID;
@property (nonatomic, readonly) NSString *userID;
@property (nonatomic, readonly) NSString *apiKey;

- (instancetype)initWithAppID:(NSString *)appID userID:(NSString *)userId apiKey:(NSString *)apiKey;

- (void)addParameterForKey:(NSString *)key andValue:(NSString *)value;

- (void)fetchOffers:(void (^)(NSArray *offers, NSError *error))completed;

@end