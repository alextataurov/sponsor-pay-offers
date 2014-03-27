//
//  Offer.m
//  SponsorPayOffers
//
//  Created by Alex Tataurov on 25/03/14.
//  Copyright (c) 2014 Alex Tataurov. All rights reserved.
//

#import "Offer.h"

@implementation Offer

+ (NSArray *)importFromJSON:(NSDictionary *)data
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    if ([data objectForKey:@"offers"]) {
        NSArray *offers = [data objectForKey:@"offers"];
        for (NSDictionary *offerData in offers) {
            Offer *offer = [[Offer alloc] init];
            
            if ([offerData objectForKey:@"title"]) {
                offer.title = [offerData objectForKey:@"title"];
            }
            
            if ([offerData objectForKey:@"teaser"]) {
                offer.teaser = [offerData objectForKey:@"teaser"];
            }
            
            if ([offerData objectForKey:@"thumbnail"]) {
                NSDictionary *offerThumbnailData = [offerData objectForKey:@"thumbnail"];
                
                if ([offerThumbnailData objectForKey:@"hires"]) {
                    offer.thumbnailURL = [offerThumbnailData objectForKey:@"hires"];
                }
            }
            
            if ([offerData objectForKey:@"payout"]) {
                NSNumber *payout = [offerData objectForKey:@"payout"];
                offer.payout = [payout intValue];
            }
            
            [result addObject:offer];
        }
    }
    
    return result;
}

@end