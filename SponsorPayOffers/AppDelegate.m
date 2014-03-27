//
//  AppDelegate.m
//  SponsorPayOffers
//
//  Created by Alex Tataurov on 24/03/14.
//  Copyright (c) 2014 Alex Tataurov. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)loadSettingsDefaults
{
    // If settings haven't been set up yet, let's go ahead and set some sensible defaults.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults stringForKey:@"app_id"]) {
        [defaults setValue:@"2070" forKey:@"app_id"];
    }
    
    if (![defaults stringForKey:@"user_id"]) {
        [defaults setValue:@"spiderman" forKey:@"user_id"];
    }
    
    if (![defaults stringForKey:@"api_key"]) {
        [defaults setValue:@"1c915e3b5d42d05136185030892fbb846c278927" forKey:@"api_key"];
    }
    
    [defaults synchronize];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self loadSettingsDefaults];
    
    // Override point for customization after application launch.
    return YES;
}

@end