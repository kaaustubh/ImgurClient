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
#import "LMDropdownView.h"
#import "LMMenuCell.h"
#import "ImageDetailsViewController.h"

@interface GalleryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (strong, nonatomic)   LMDropdownView *dropdownView;
@property (weak, nonatomic)     IBOutlet UITableView *menuTableView;
@property (strong, nonatomic)   NSArray *menuItems;
@property (assign)   NSInteger currentTopicTypeIndex;
@property (nonatomic, strong) UIBarButtonItem *sortButton;
@property (assign) NSInteger selectedImageIndex;

@end

@implementation GalleryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _currentTopicTypeIndex=0;
    _selectedImageIndex=-1;
    [self getTopImages];
    
    self.menuItems = @[@"Top", @"Viral"];
    _sortButton = [[UIBarButtonItem alloc] initWithTitle:@"Sort By" style:UIBarButtonItemStylePlain target:self action:@selector(sortByButtonTapped)];
    self.navigationItem.rightBarButtonItem = _sortButton;
    [self.menuTableView setFrame:CGRectMake(0,
                                            0,
                                            CGRectGetWidth(self.view.bounds),
                                            MIN(CGRectGetHeight(self.view.bounds)/2, self.menuItems.count * 50))];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    if (_currentTopicTypeIndex==0)
    {
        self.title=[NSString stringWithFormat:@"Top images for %@", _selectedTopic.topicName];
    }
    else
    {
        self.title=[NSString stringWithFormat:@"Viral images for %@", _selectedTopic.topicName];
    }
}

-(void)getTopImages
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MBProgressHUD HUDForView:self.view] setLabelText:[NSString stringWithFormat:@"Searching images for %@", _selectedTopic.topicName]];
    _sortButton.enabled=false;
    [[TopicsManager sharedInstance] getTopImagesForTopic:_selectedTopic.topicName completion:^(NSMutableArray *arr, NSError *error)
     {
         _sortButton.enabled=true;
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         _imageArr=arr;
         [_tableView reloadData];
         self.title=[NSString stringWithFormat:@"Top images for %@", _selectedTopic.topicName];
     }];
}

-(void)getViralImages
{
    _sortButton.enabled=false;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MBProgressHUD HUDForView:self.view] setLabelText:[NSString stringWithFormat:@"Searching images for %@", _selectedTopic.topicName]];
    [[TopicsManager sharedInstance] getViralImagesForTopic:_selectedTopic.topicName completion:^(NSMutableArray *arr, NSError *error)
     {
         _sortButton.enabled=true;
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         _imageArr=arr;
         [_tableView reloadData];
         self.title=[NSString stringWithFormat:@"Viral images for %@", _selectedTopic.topicName];
     }];
}

#pragma mark - DROPDOWN VIEW

-(void)sortByButtonTapped
{
    [self.menuTableView reloadData];
    if (!self.dropdownView) {
        self.dropdownView = [LMDropdownView dropdownView];
        self.dropdownView.delegate = self;
        
        // Customize Dropdown style
        self.dropdownView.closedScale = 0.85;
        self.dropdownView.blurRadius = 5;
        self.dropdownView.blackMaskAlpha = 0.5;
        self.dropdownView.animationDuration = 0.5;
        self.dropdownView.animationBounceHeight = 20;
        //self.dropdownView.contentBackgroundColor = [UIColor colorWithRed:40.0/255 green:196.0/255 blue:80.0/255 alpha:1];
    }
    
    // Show/hide dropdown view
    if ([self.dropdownView isOpen]) {
        [self.dropdownView hide];
    }
    else {
        [self.dropdownView showFromNavigationController:self.navigationController withContentView:self.menuTableView];
    }
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
    int count=0;
    
    if (tableView== self.menuTableView)
        count=[self.menuItems count];
    else
        count=_imageArr.count;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell;
    if (tableView==self.menuTableView)
    {
        LMMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
        if (!cell) {
            cell = [[LMMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuCell"];
        }
        
        cell.menuItemLabel.text = [self.menuItems objectAtIndex:indexPath.row];
        cell.selectedMarkView.hidden = (indexPath.row != self.currentTopicTypeIndex);
        
        return cell;
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView == _menuTableView)
    {
        if (self.currentTopicTypeIndex!=indexPath.row)
        {
            self.currentTopicTypeIndex = indexPath.row;
            if (self.currentTopicTypeIndex==0)
            {
                [self getTopImages];
            }
            else
            {
                [self getViralImages];
            }
        }
        
        [self.dropdownView hide];
    }
    else
    {
        _selectedImageIndex=indexPath.row;
        [self performSegueWithIdentifier:@"ShowImageSegue" sender:nil];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowImageSegue"])
    {
        ImageDetailsViewController *controller= (ImageDetailsViewController*)[segue destinationViewController];
        controller.image=_imageArr[_selectedImageIndex];
    }
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
    else
    {
        return 46;
    }
    if (height<64) {
        height=64;
    }
    
    return height;
}

@end
