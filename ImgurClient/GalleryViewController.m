//
//  GalleryViewController.m
//  ImgurClient
//
//  Created by Kaustubh on 27/12/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import "GalleryViewController.h"
#import "ImgurCell.h"
#import "TopicsManager.h"
#import "MBProgressHUD.h"

@interface GalleryViewController ()<UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation GalleryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MBProgressHUD HUDForView:self.view] setLabelText:[NSString stringWithFormat:@"Searching images for %@", _selectedTopic.topicName]];
    [[TopicsManager sharedInstance] getTopImagesForTopic:_selectedTopic.topicName completion:^(NSMutableArray *arr, NSError *error)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        _imageArr=arr;
        [_tableView reloadData];
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark- UItableView data source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _imageArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImgurCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImgurCell"];
    if (!cell)
    {
        cell = [[ImgurCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ImgurCell"];
    }
    
    ImgurImage *image=_imageArr[indexPath.row];
    NSString *text=@"";
    if (image.imageDescription.length)
    {
        text=image.imageDescription;
    }
    cell.primaryLabel.text=text;
    text=@"";
    if (image.userName.length)
    {
        text=image.userName;
    }
    cell.secondaryLabel.text=text;
    if (image.imageURL.length)
    {
        [cell.cImageView setURLString:image.imageURL];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height=46;
    if (tableView==self.tableView)
    {
        ImgurImage *image=_imageArr[indexPath.row];
        UIFont *font = [UIFont systemFontOfSize:16.0f];
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              font, NSFontAttributeName,
                                              nil];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: image.imageDescription attributes:attributesDictionary];
        CGRect size=[string boundingRectWithSize:CGSizeMake(300.0f, 999.0f)
                                         options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                         context:nil];
        height=size.size.height + 20;
    }
    if (height<64) {
        height=64;
    }
    
    return height;
}

@end
