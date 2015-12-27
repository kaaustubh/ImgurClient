//
//  Topic.m
//  ImgurClient
//
//  Created by Kaustubh on 27/12/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import "Topic.h"


#define kID             @"id"
#define kName           @"name"
#define kDescription    @"description"

@implementation Topic

-(id)initWithDictionary:(NSDictionary*)dict
{
    self= [super init];
    if (self)
    {
        _topicId=dict[kID];
        _topicName=dict[kName];
        _topicDescription=dict[kDescription];
    }
    return self;
}

@end
