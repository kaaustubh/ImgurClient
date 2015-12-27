//
//  ImgurImage.m
//  ImgurClient
//
//  Created by Kaustubh on 27/12/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import "ImgurImage.h"

#define kDescription @"title"
#define kURL         @"link"
#define kUserName    @"account_url"
#define kDate        @"datetime"
@implementation ImgurImage

-(id)initWithDictionary:(NSDictionary*)dict
{
    self =[super init];
    if (self)
    {
        _imageDescription=dict[kDescription];
        _imageURL=dict[kURL];
        _userName=dict[kUserName];
        double timerstamp=[dict[kDate] doubleValue];
        _postedDate=[self getDateFromUnixTimeStamp:timerstamp];
    }
    return self;
}


-(NSDate*)getDateFromUnixTimeStamp:(double)timestamp
{
    NSDate *date;
    NSTimeInterval _interval=timestamp;
    date = [NSDate dateWithTimeIntervalSince1970:_interval];
    return date;
}

@end
