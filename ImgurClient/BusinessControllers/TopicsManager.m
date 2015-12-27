//
//  TopicsManager.m
//  ImgurClient
//
//  Created by Kaustubh on 27/12/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import "TopicsManager.h"
#import "HTTPManager.h"
#import "Topic.h"
#import "ImgurImage.h"

#define kClientID       @"b5bf2800c00cd80"
#define kSuccess        @"success"
#define kData           @"data"

#define kImgurTopicsURL @"https://api.imgur.com/3/topics/defaults"
#define kImagesURL      @"https://api.imgur.com/3/topics/%@/%@"

@implementation TopicsManager

+ (id)sharedInstance
{
    static TopicsManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


-(void)getTopicsWithCompletion:(void(^)(NSMutableArray *array, NSError *error))completionBlock
{
    HTTPManager *sharedInstance=[HTTPManager sharedInstance];
    [sharedInstance sendRequestForURL:kImgurTopicsURL withAuthToken:kClientID Success:^(NSData *data)
    {
        NSMutableArray *arr=[self getTopicsFromData:data];
        if (completionBlock)
        {
            completionBlock(arr, nil);
        }
        
    }Failure:^(NSError * error)
    {
        if (completionBlock)
        {
            completionBlock(nil, error);
        }
    }];
}

-(NSMutableArray*)getTopicsFromData:(NSData*)data
{
    NSMutableArray *arr=nil;
    
    NSError *e = nil;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
    if ([[jsonArray objectForKey:kSuccess] integerValue] == 1)
    {
        NSArray *arrOfDict=jsonArray[kData];
        if (arrOfDict.count)
        {
            arr=[NSMutableArray array];
        }
        Topic *newTopic;
        for (NSDictionary *dict in arrOfDict)
        {
            newTopic=[[Topic alloc] initWithDictionary:dict];
            [arr addObject:newTopic];
        }
    }
    
    return arr;
}

-(void)getTopImagesForTopic:(NSString*)topicId completion:(void(^)(NSMutableArray *array, NSError *error))completionBlock
{
    NSString *url=[NSString stringWithFormat:kImagesURL, topicId, @"top" ];
    
    [[HTTPManager sharedInstance] sendRequestForURL:url withAuthToken:kClientID Success:^(NSData *data)
     {
         NSMutableArray *arr=[self getImagesFromData:data];
         if (completionBlock)
         {
             completionBlock(arr, nil);
         }
         
     }Failure:^(NSError * error)
     {
         if (completionBlock)
         {
             completionBlock(nil, error);
         }
     }];
    
}

-(NSMutableArray*)getImagesFromData:(NSData*)data
{
    NSMutableArray *arr=nil;
    
    NSError *e = nil;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
    if ([[jsonArray objectForKey:kSuccess] integerValue] == 1)
    {
        NSArray *arrOfDict=jsonArray[kData];
        ImgurImage *newImage;
        if (arrOfDict.count)
        {
            arr=[NSMutableArray array];
        }
        for (NSDictionary *dict in arrOfDict)
        {
            newImage=[[ImgurImage alloc] initWithDictionary:dict];
            [arr addObject:newImage];
        }
    }
    return arr;
}

@end
