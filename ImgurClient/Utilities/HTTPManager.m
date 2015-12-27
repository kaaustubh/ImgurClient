//
//  HTTPManager.m
//  ImgurClient
//
//  Created by Kaustubh on 27/12/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import "HTTPManager.h"

@implementation HTTPManager



+ (id)sharedInstance
{
    static HTTPManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init
{
    self = [super init];
    return self;
}


-(void)sendRequestForURL:(NSString*)urlString withAuthToken:(NSString*)authToken Success:(void(^)(NSData *data))success Failure: (void(^)(NSError *error))failure
{
    NSString *authValue;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURL *url = [NSURL URLWithString:urlString];
    if (authToken.length)
    {
        authValue = [NSString stringWithFormat:@"Client-ID %@",authToken];
        configuration.HTTPAdditionalHeaders = @{@"Authorization": authValue};
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    [[session dataTaskWithURL:url completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
      {
          if(error && failure)
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  failure(error);
              });
              
          }
          else if(success)
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  success(data);
              });
          }
          
      }] resume];
}


@end
