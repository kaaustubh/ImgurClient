//
//  ImgurImage.h
//  ImgurClient
//
//  Created by Kaustubh on 27/12/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImgurImage : NSObject

@property (nonatomic, readonly) NSString *imageDescription;
@property (nonatomic, readonly) NSString *imageURL;
@property (nonatomic, readonly) NSString *userName;
@property (nonatomic, readonly) NSDate *postedDate;
//@property (nonatomic, readonly)

-(id)initWithDictionary:(NSDictionary*)dict;

@end
