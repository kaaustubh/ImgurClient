//
//  AccountManager.m
//  ImgurClient
//
//  Created by Kaustubh on 27/12/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import "AccountManager.h"
#import "HTTPManager.h"

#define kFetchAccountURL @"https://api.imgur.com/3/account/%@"
//Redundant, need to add this in global constants
#define kClientID       @"b5bf2800c00cd80"

@implementation AccountManager


+ (id)sharedInstance
{
    static AccountManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(void)getAccountDetailsForAccountName:(NSString*)accName completion:(void(^)(ImgurAccount *account, NSError *error))completionBlock
{
    NSString *url=[NSString stringWithFormat:kFetchAccountURL, accName];
    HTTPManager *sharedInstance=[HTTPManager sharedInstance];
    [sharedInstance sendRequestForURL:url withAuthToken:kClientID Success:^(NSData *data)
     {
         ImgurAccount *newAcc=[self getAccountFromData:data];
     }Failure:^(NSError * error)
     {
         if (completionBlock)
         {
             completionBlock(nil, error);
         }
     }];
}


-(ImgurAccount *)getAccountFromData:(NSData*)data
{
    ImgurAccount *newAccount;
    NSError *e = nil;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
    
    return newAccount;
}

@end
