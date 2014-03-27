//
//  NSString+Conveniences.m
//  SponsorPayOffers
//
//  Created by Alex Tataurov on 25/03/14.
//  Copyright (c) 2014 Alex Tataurov. All rights reserved.
//

#import "NSString+Conveniences.h"

@implementation NSString (Conveniences)

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (BOOL)isEmpty
{
    if (self == nil || self.length == 0) {
        return YES;
    }
    
    if ([self trim].length == 0) {
        return YES;
    }
    
    return NO;
}

@end