//
//  ImgurCell.h
//  ImgurClient
//
//  Created by Kaustubh on 27/12/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CachedImageView.h"

@interface ImgurCell : UITableViewCell

@property (nonatomic, weak) IBOutlet CachedImageView *cImageView;
@property (nonatomic, weak) IBOutlet UILabel *primaryLabel;
@property (nonatomic, weak) IBOutlet UILabel *secondaryLabel;

@end
