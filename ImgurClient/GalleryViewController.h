//
//  GalleryViewController.h
//  ImgurClient
//
//  Created by Kaustubh on 27/12/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImgurImage.h"
#import "Topic.h"

@interface GalleryViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) Topic *selectedTopic;

@end
