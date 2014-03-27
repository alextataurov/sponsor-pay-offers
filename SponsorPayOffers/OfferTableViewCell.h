//
//  OfferTableViewCell.h
//  SponsorPayOffers
//
//  Created by Alex Tataurov on 25/03/14.
//  Copyright (c) 2014 Alex Tataurov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferTableViewCell : UITableViewCell


@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *teaserLabel;
@property (nonatomic, weak) IBOutlet UILabel *payoutLabel;

@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *thumbnailLoadingActivityIndicator;

@end