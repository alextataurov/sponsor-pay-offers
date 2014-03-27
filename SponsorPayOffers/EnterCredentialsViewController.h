//
//  EnterCredentialsViewController.h
//  SponsorPayOffers
//
//  Created by Alex Tataurov on 24/03/14.
//  Copyright (c) 2014 Alex Tataurov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterCredentialsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *appIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *userIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *apiKeyTextField;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)fetchOffersButtonPressed:(id)sender;

- (void)showAlertWithMessage:(NSString *)message;
- (void)showErrorAlertWithMessage:(NSString *)message;

@end