//
//  Topic.h
//  ImgurClient
//
//  Created by Kaustubh on 27/12/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Topic : NSObject

@property (nonatomic, readonly) NSString *topicId;
@property (nonatomic, readonly) NSString *topicName;
@property (nonatomic, readonly) NSString *topicDescription;


-(id)initWithDictionary:(NSDictionary*)dict;

@end
