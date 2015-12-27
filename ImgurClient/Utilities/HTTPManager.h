//
//  HTTPManager.h
//  ImgurClient
//
//  Created by Kaustubh on 27/12/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPManager : NSObject

+ (id)sharedInstance;
-(void)sendRequestForURL:(NSString*)urlString withAuthToken:(NSString*)authToken Success:(void(^)(NSData *data))success Failure: (void(^)(NSError *error))failure;

@end
