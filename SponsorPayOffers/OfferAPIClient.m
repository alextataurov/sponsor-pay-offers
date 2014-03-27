//
//  OfferAPIClient.m
//  SponsorPayOffers
//
//  Created by Alex Tataurov on 26/03/14.
//  Copyright (c) 2014 Alex Tataurov. All rights reserved.
//

#import "OfferAPIClient.h"
#import "Offer.h"
#import "NSString+Hash.h"

NSString *const OfferAPIClientErrorDomain = @"com.alextataurov.sponsorpayoffers";

static NSString *const kAPIEndpoint = @"http://api.sponsorpay.com/feed/v1/offers.json";
static NSString *const kAPIDefaultLocale = @"de";
static NSString *const kAPIDefaultFormat = @"json";

@implementation OfferAPIClient {
    NSMutableDictionary *_urlParameters;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Must use initWithAppID:userID:apiKey instead."
                                 userInfo:nil];
}

- (instancetype)initWithAppID:(NSString *)theAppID userID:(NSString *)theUserId apiKey:(NSString *)theApiKey
{
    if (self = [super init]) {
        _urlParameters = [[NSMutableDictionary alloc] init];
        _appID = [theAppID copy];
        _userID = [theUserId copy];
        _apiKey = [theApiKey copy];
    }
    return self;
}

#pragma mark Bulding the Offer API URL

- (void)addParameterForKey:(NSString *)theKey andValue:(NSString *)theValue
{
    NSString *key = [theKey copy];
    NSString *value = [theValue copy];
    _urlParameters[key] = value;
}

- (NSString *)calculateParametersHash
{
    NSArray *sortedKeys = [[_urlParameters allKeys] sortedArrayUsingSelector: @selector(compare:)];
    
    NSMutableString *orderedParameters = [[NSMutableString alloc] init];
    for (NSString *key in sortedKeys) {
        [orderedParameters appendFormat:@"%@=%@&", key, _urlParameters[key]];
    }
    
    [orderedParameters appendString:self.apiKey];
    
    return [orderedParameters sha1];
}

- (NSString *)buildOfferUrlForTimestampDate:(NSDate *)timestampDate
{
    [self addParameterForKey:@"appid" andValue:self.appID];
    [self addParameterForKey:@"uid" andValue:self.userID];
    [self addParameterForKey:@"locale" andValue:kAPIDefaultLocale];
    [self addParameterForKey:@"format" andValue:kAPIDefaultFormat];
    [self addParameterForKey:@"timestamp" andValue:[NSString stringWithFormat:@"%ld", (long)[timestampDate timeIntervalSince1970]]];
    
    NSMutableString *result = [[NSMutableString alloc] init];
    [result appendFormat:@"%@?",kAPIEndpoint];
    
    NSArray *keys = [[_urlParameters allKeys] sortedArrayUsingSelector: @selector(compare:)];
    for (NSString *key in keys) {
        [result appendFormat:@"%@=%@&", key, _urlParameters[key]];
    }
    
    [result appendFormat:@"hashkey=%@", [self calculateParametersHash]];
    
    return result;
}

- (NSString *)buildOfferUrl
{
    return [self buildOfferUrlForTimestampDate:[NSDate date]];
}

#pragma mark Fetching Offers

- (void)fetchOffers:(void (^)(NSArray *offers, NSError *error))completed
{
    NSString *offerUrlString = [self buildOfferUrl];
    NSURL *offerUrl = [[NSURL alloc] initWithString:offerUrlString];
    NSURLRequest *offerRequest = [NSMutableURLRequest requestWithURL:offerUrl
                                                    cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:offerRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error != nil) {
                                   completed(nil, error);
                                   return;
                               }
                               
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                               if (httpResponse.statusCode != 200) {
                                   NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(@"Invalid response code.", @"Invalid response code.") };
                                   NSError *invalidResponseError = [NSError errorWithDomain:OfferAPIClientErrorDomain
                                                                        code:OfferAPIClientInvalidResponseError
                                                                    userInfo:userInfo];
                                   completed(nil, invalidResponseError);
                                   return;
                               }
                               
                               NSDictionary *responseHeaders = [httpResponse allHeaderFields];
                               if (responseHeaders[@"X-Sponsorpay-Response-Signature"]) {
                                   NSString *signature = responseHeaders[@"X-Sponsorpay-Response-Signature"];
                                   
                                   if (![self isResponseValidForData:data andSignature:signature]) {
                                       NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(@"Response signature doesn't match.", @"Response signature doesn't match.") };
                                       NSError *invalidSignatureError = [NSError errorWithDomain:OfferAPIClientErrorDomain
                                                                                           code:OfferAPIClientSignatureNotMatchError
                                                                                       userInfo:userInfo];
                                       completed(nil, invalidSignatureError);
                                       return;
                                   }
                               }
                               
                               NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                               if (error) {
                                   completed(nil, nil);
                               }
                               else {
                                   NSArray *offers = [Offer importFromJSON:dictionary];
                                   completed(offers, nil);
                               }
                           }];
}

- (BOOL)isResponseValidForData:(NSData *)responseData andSignature:(NSString *)signature
{
    NSString *responseDataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSString *responseDataWithApiKey = [NSString stringWithFormat:@"%@%@", responseDataString, self.apiKey];
    NSString *responseDataWithApiKeyHash = [responseDataWithApiKey sha1];
    
    return [signature isEqualToString:responseDataWithApiKeyHash];
}

@end