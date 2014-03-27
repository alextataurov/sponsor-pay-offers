//
//  Offer.h
//  SponsorPayOffers
//
//  Created by Alex Tataurov on 25/03/14.
//  Copyright (c) 2014 Alex Tataurov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Offer : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *teaser;
@property (nonatomic) int payout;
@property (nonatomic, copy) NSString *thumbnailURL;
@property (nonatomic, strong) UIImage *thumbnailImage;

+ (NSArray *)importFromJSON:(NSDictionary *)data;

@end