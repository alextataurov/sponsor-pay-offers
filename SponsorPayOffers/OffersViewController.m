//
//  OffersViewController.m
//  SponsorPayOffers
//
//  Created by Alex Tataurov on 25/03/14.
//  Copyright (c) 2014 Alex Tataurov. All rights reserved.
//

#import "OffersViewController.h"
#import "Offer.h"
#import "OfferTableViewCell.h"

@interface OffersViewController ()

@end

@implementation OffersViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.offers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    [tableView registerNib:[UINib nibWithNibName:@"OfferTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellIdentifier];
    
    OfferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Offer *offer = self.offers[indexPath.row];
    cell.titleLabel.text = offer.title;
    cell.teaserLabel.text = offer.teaser;
    cell.payoutLabel.text = [NSString stringWithFormat:@"%d", offer.payout];
    
    if (offer.thumbnailImage == nil) {
        cell.thumbnailImageView.hidden = YES;
        cell.thumbnailLoadingActivityIndicator.hidden = NO;
        
        NSURL *thumbnailURL = [NSURL URLWithString:offer.thumbnailURL];
        NSURLRequest *thumbnailRequest = [NSURLRequest requestWithURL:thumbnailURL
                                                          cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                      timeoutInterval:15.0];
        
        __weak OffersViewController *weakSelf = self;
        [NSURLConnection sendAsynchronousRequest:thumbnailRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if (error) {
                                       // do nothing
                                   }
                                   else {
                                       offer.thumbnailImage = [UIImage imageWithData:data];
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                       });
                                   }
                               }];
    }
    else {
        cell.thumbnailImageView.image = offer.thumbnailImage;
        
        cell.thumbnailImageView.hidden = NO;
        cell.thumbnailLoadingActivityIndicator.hidden = YES;
    }
    
    return cell;
}

@end