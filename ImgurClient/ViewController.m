//
//  ViewController.m
//  ImgurClient
//
//  Created by Kaustubh on 27/12/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import "ViewController.h"
#import "LMDropdownView.h"
#import "LMMenuCell.h"
#import "TopicsManager.h"
#import "MBProgressHUD.h"
#import "Topic.h"

@interface ViewController ()

@property (assign, nonatomic)   NSInteger currentMapTypeIndex;
@property (strong, nonatomic)   LMDropdownView *dropdownView;
@property (weak, nonatomic)     IBOutlet UITableView *menuTableView;
@property (strong, nonatomic)   NSArray *menuItems;
@property (strong, nonatomic)   NSMutableArray *topics;
@property (weak, nonatomic)     IBOutlet UITableView *topicsTableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.menuItems = @[@"Popular", @"Newest"];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Sort By" style:UIBarButtonItemStylePlain target:self action:@selector(sortByButtonTapped)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    [self.menuTableView setFrame:CGRectMake(0,
                                            0,
                                            CGRectGetWidth(self.view.bounds),
                                            MIN(CGRectGetHeight(self.view.bounds)/2, self.menuItems.count * 50))];
    [self getTopics];
    // Do any additional setup after loading the view, typically from a nib.
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        self.dropdownView.contentBackgroundColor = [UIColor colorWithRed:40.0/255 green:196.0/255 blue:80.0/255 alpha:1];
    }
    
    // Show/hide dropdown view
    if ([self.dropdownView isOpen]) {
        [self.dropdownView hide];
    }
    else {
        [self.dropdownView showFromNavigationController:self.navigationController withContentView:self.menuTableView];
    }
}


#pragma mark - TABLE VIEW

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count=0;
    if (tableView== self.menuTableView) {
        count=[self.menuItems count];
    }
    else
        count=self.topics.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell;
    if (tableView==self.menuTableView) {
        LMMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
        if (!cell) {
            cell = [[LMMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuCell"];
        }
        
        cell.menuItemLabel.text = [self.menuItems objectAtIndex:indexPath.row];
        cell.selectedMarkView.hidden = (indexPath.row != self.currentMapTypeIndex);
        
        return cell;
    }
    else
    {
        static NSString *cellID=@"cellId";
        Topic *topic=_topics[indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        cell.textLabel.font=[UIFont systemFontOfSize:16.0f];
        cell.textLabel.text=topic.topicName;
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.font=[UIFont systemFontOfSize:13.0f];
        cell.detailTextLabel.text=topic.topicDescription;
        
        return cell;
    }
    
    return tableViewCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.currentMapTypeIndex = indexPath.row;
    
    [self.dropdownView hide];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height=46;
    if (tableView==self.topicsTableView)
    {
        Topic *topic=_topics[indexPath.row];
        UIFont *font = [UIFont systemFontOfSize:16.0f];
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              font, NSFontAttributeName,
                                              nil];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: topic.topicDescription attributes:attributesDictionary];
        CGRect size=[string boundingRectWithSize:CGSizeMake(300.0f, 999.0f)
                                         options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                         context:nil];
        height=size.size.height + 20;
    }
    
    return height;
}

#pragma mark- API calls

-(void)getTopics
{
    [self showProgressHUDWithTitle:@"Seaching topics..."];
    [[TopicsManager sharedInstance] getTopicsWithCompletion:^(NSMutableArray *arr, NSError *error)
    {
        [self hideProgressHUD];
        if (error)
        {
            
        }
        else
        {
            if (arr.count)
            {
                _topics=arr;
                [_topicsTableView reloadData];
            }
        }
    }];
}

#pragma mark- ProgressHud Functions

- (void)showProgressHUDWithTitle:(NSString*)title
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MBProgressHUD HUDForView:self.view] setLabelText:title];
}
- (void)hideProgressHUD
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


@end
