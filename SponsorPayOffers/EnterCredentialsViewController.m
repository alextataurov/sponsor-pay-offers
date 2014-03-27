//
//  EnterCredentialsViewController.m
//  SponsorPayOffers
//
//  Created by Alex Tataurov on 24/03/14.
//  Copyright (c) 2014 Alex Tataurov. All rights reserved.
//

#import "EnterCredentialsViewController.h"
#import "NSString+Conveniences.h"
#import "NSString+Hash.h"
#import "Offer.h"
#import "OfferAPIClient.h"
#import "OffersViewController.h"

@interface EnterCredentialsViewController ()

@end

@implementation EnterCredentialsViewController {
    UIGestureRecognizer *_tapper;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.appIDTextField.text = [defaults stringForKey:@"app_id"];
    self.userIDTextField.text = [defaults stringForKey:@"user_id"];
    self.apiKeyTextField.text = [defaults stringForKey:@"api_key"];
    
    // Try to catch single taps over the view in order to hide the keyboard after text editing.
    _tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    _tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:_tapper];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Helpers

- (void)showAlertWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sponsor Pay"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)showErrorAlertWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark Event handlers

- (IBAction)fetchOffersButtonPressed:(id)sender
{
    if ([self.appIDTextField.text isEmpty]) {
        [self showErrorAlertWithMessage:NSLocalizedString(@"App ID cannot be empty.", @"App ID cannot be empty.")];
        return;
    }
    
    if ([self.userIDTextField.text isEmpty]) {
        [self showErrorAlertWithMessage:NSLocalizedString(@"User ID cannot be empty.", @"User ID cannot be empty.")];
        return;
    }
    
    if ([self.apiKeyTextField.text isEmpty]) {
        [self showErrorAlertWithMessage:NSLocalizedString(@"API Key cannot be empty.", @"API Key cannot be empty.")];
        return;
    }
    
    // Prepare mandatory input parameters.
    NSString *appId = [self.appIDTextField.text trim];
    NSString *userId = [self.userIDTextField.text trim];
    NSString *apiKey = [self.apiKeyTextField.text trim];
    
    // Save it in defaults settings in order to use it next time when we launch the app.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:appId forKey:@"app_id"];
    [defaults setValue:userId forKey:@"user_id"];
    [defaults setValue:apiKey forKey:@"api_key"];
    [defaults synchronize];
    
    OfferAPIClient *offerAPIClient = [[OfferAPIClient alloc] initWithAppID:appId userID:userId apiKey:apiKey];
    [offerAPIClient addParameterForKey:@"page" andValue:@"1"];
    
    self.activityIndicator.hidden = NO;
    
    __weak EnterCredentialsViewController *weakSelf = self;
    [offerAPIClient fetchOffers:^(NSArray *offers, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.activityIndicator.hidden = YES;
            
            if (error != nil) {
                if (error.code == OfferAPIClientInvalidResponseError) {
                    NSString *errorMessage = [NSString stringWithFormat:@"%@ %@", error.localizedDescription, NSLocalizedString(@"Please verify your credentials.", @"Please verify your credentials.")];
                    [weakSelf showErrorAlertWithMessage:errorMessage];
                }
                else {
                    [weakSelf showErrorAlertWithMessage:error.localizedDescription];
                }
            }
            else {
                if (offers == nil || offers.count == 0) {
                    [weakSelf showAlertWithMessage:NSLocalizedString(@"No offers found.", @"No offers found.")];
                }
                else {
                    [weakSelf performSegueWithIdentifier:@"ViewOffersSegue" sender:offers];
                }
            }
        });
    }];
}

- (void)handleSingleTap:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ViewOffersSegue"]) {
        OffersViewController *offersViewController = segue.destinationViewController;
        offersViewController.offers = sender;
    }
}

@end