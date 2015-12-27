//
//  ImgurCell.h
//  ImgurClient
//
//  Created by Kaustubh on 27/12/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImgurCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *secondaryLabel;

@end
