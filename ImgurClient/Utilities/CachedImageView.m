//
//  CachedImageView.m
//  ImgurClient
//
//  Created by Kaustubh on 27/12/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import "CachedImageView.h"
#import "HTTPManager.h"

@interface CachedImageView()

@property (nonatomic, strong )NSString *imageName;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *imageReference;

@end

@implementation CachedImageView

- (id)initWithImageUrlString:(NSString*)urlString
{
    if(self=[super init]){
        if(urlString.length!=0)
        {
            _imageName = [[urlString pathComponents] lastObject];
            _urlString=urlString;
        }
    }
    return self;
}

-(void)setURLString:(NSString*)urlstr
{
    _urlString=urlstr;
    _imageName = [[urlstr pathComponents] lastObject];
    [self loadImage];
}

- (void)saveImage:(NSData *)imageData
{
    UIImage *image=[UIImage imageWithData:imageData];
    NSString *path=[NSString stringWithFormat:@"Documents/%@", _imageName];
    NSString  *imagePath = [NSHomeDirectory() stringByAppendingPathComponent:path];
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    self.image=image;
}

- (void)loadImage
{
    __weak CachedImageView *weakSelf=self;
    NSString *imagePath = [self imagePath];
    
    if(imagePath)
    {
        self.image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    }
    else
    {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.alpha = 1.0;
        activityIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        activityIndicator.hidesWhenStopped = YES;
        [self addSubview:activityIndicator];
        [activityIndicator startAnimating];
        HTTPManager *sharedManager=[HTTPManager sharedInstance];
        if(_imageReference.length>0)
        {
            [sharedManager sendRequestForURL:_urlString withAuthToken:nil Success:^(NSData *data)
             {
                 [weakSelf saveImage:data];
                 [activityIndicator stopAnimating];
             }Failure:^(NSError *error)
             {
                 [activityIndicator stopAnimating];
             }];
        }
    }
}

- (NSString *)imagePath
{
    NSString *path=[NSString stringWithFormat:@"Documents/%@", _imageName];
    NSString  *imagePath = [NSHomeDirectory() stringByAppendingPathComponent:path];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
    
    if (!fileExists) {
        imagePath=nil;
    }
    return imagePath;
}

-(void)setImageReference:(NSString*)reference
{
    _imageReference=reference;
    _imageName=reference;
    [self loadImage];
}



@end
