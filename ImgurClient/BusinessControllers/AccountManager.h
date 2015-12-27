//
//  AccountManager.h
//  ImgurClient
//
//  Created by Kaustubh on 27/12/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImgurAccount.h"

@interface AccountManager : NSObject


+ (id)sharedInstance;
-(void)getAccountDetailsForAccountName:(NSString*)accName completion:(void(^)(ImgurAccount *account, NSError *error))completionBlock;


@end
