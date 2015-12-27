//
//  TopicsManager.h
//  ImgurClient
//
//  Created by Kaustubh on 27/12/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicsManager : NSObject

+ (id)sharedInstance;
-(void)getTopicsWithCompletion:(void(^)(NSMutableArray *array, NSError *error))completionBlock;
-(void)getTopImagesForTopic:(NSString*)topicId completion:(void(^)(NSMutableArray *array, NSError *error))completionBlock;
-(void)getViralImagesForTopic:(NSString*)topicId completion:(void(^)(NSMutableArray *array, NSError *error))completionBlock;

@end
