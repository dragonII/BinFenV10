//
//  CommunityViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/5/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "CommunityViewController.h"
#import "CategoryTableViewCell.h"
#import "ShopsAndProductsCell.h"
#import "BFPreferenceData.h"
#import "MLKMenuPopover.h"
#import "ShopViewController.h"
#import "defs.h"

#import "DeviceHardware.h"

NSString *CategoryCellIdentifier = @"CategoryCellIdentifier";
NSString *ShopsCellIdentifier = @"ShopsCellIdentifier";

static const int SectionCategory = 0;
static const int SectionShops = 1;
static const int SectionLoadMore = 2;

@interface CommunityViewController () <UITableViewDataSource, UITableViewDelegate, MLKMenuPopoverDelegate, ShopsCellSegueDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) MLKMenuPopover *categoryPopover;

@property (assign, nonatomic) NSInteger categoryButtonIndex;

@end

@implementation CommunityViewController

- (void)initTableView
{    
    CGRect tableViewFrame;
    
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    NSLog(@"generalPlatform: %d", generalPlatform);
    
    switch (generalPlatform)
    {
        case DeviceHardwareGeneralPlatform_iPhone_4:
        case DeviceHardwareGeneralPlatform_iPhone_4S:
        {
            NSLog(@"iphone 4, 4S");
            CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
            CGFloat statusBarHeight = 20;
            tableViewFrame = CGRectMake(0, navigationBarHeight + statusBarHeight,
                                        self.view.bounds.size.width,
                                        self.view.bounds.size.height - navigationBarHeight - statusBarHeight);
            break;
        }
        case DeviceHardwareGeneralPlatform_iPhone_5:
        case DeviceHardwareGeneralPlatform_iPhone_5C:
        case DeviceHardwareGeneralPlatform_iPhone_5S:
        case DeviceHardwareGeneralPlatform_iPhone_6:
        case DeviceHardwareGeneralPlatform_iPhone_6_Plus:
        {
            NSLog(@"iphone 5, 6");
            tableViewFrame = CGRectMake(0, 0,
                                        self.view.bounds.size.width,
                                        self.view.bounds.size.height);
            break;
        }
            
        default:
            tableViewFrame = CGRectZero;
            break;
    }
     

    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableView];
    
    [self initTableRowWithScroll];
    
    self.navigationItem.title = @"具体社区名称";
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)initTableRowWithScroll
{
    UINib *nib = [UINib nibWithNibName:@"CategoryCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CategoryCellIdentifier];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCategoriesListArray:(NSArray *)categoriesListArray
{
    if(![_categoriesListArray isEqualToArray:categoriesListArray])
    {
        _categoriesListArray = [NSArray arrayWithArray:categoriesListArray];
    }
}

#pragma UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSInteger sectionNumber = indexPath.section;
    switch (sectionNumber)
    {
        case SectionCategory:
        {
            CategoryTableViewCell *cell = (CategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CategoryCellIdentifier];
            if(cell == nil)
            {
                cell = [[CategoryTableViewCell alloc] init];
            }
            
            cell.categoriesListArray = self.categoriesListArray;
            
            return cell;
        }
            
        case SectionShops:
        {
            ShopsAndProductsCell *cell = (ShopsAndProductsCell *)[tableView dequeueReusableCellWithIdentifier:ShopsCellIdentifier];
            if(cell == nil)
            {
                cell = [[ShopsAndProductsCell alloc] init];
            }
            
            [cell initItems];
            
            cell.segueDelegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
            
        case SectionLoadMore:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.text = @"Click to Refresh";
            return cell;
        }
            
        default:
            return nil;
    }
}

- (void)loadNextBatchShops
{
    NSArray *array = [BFPreferenceData loadTestDataArray];
    NSInteger batchIndex = [[NSUserDefaults standardUserDefaults] integerForKey:LoadContentBatchIndexKey];
    
    if(batchIndex * TotalItemsPerBatch < [array count])
    {
        batchIndex++;
        [[NSUserDefaults standardUserDefaults] setInteger:batchIndex forKey:LoadContentBatchIndexKey];
        NSLog(@"batchIndex in load...: %ld", (long)batchIndex);
        [self.tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
    {
        [self loadNextBatchShops];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sectionNumber = indexPath.section;
    switch (sectionNumber)
    {
        case SectionCategory:
            return 214.0f;
            break;
        case SectionShops:
        {
            NSInteger batchIndex = [[NSUserDefaults standardUserDefaults] integerForKey:LoadContentBatchIndexKey];
            NSArray *array = [BFPreferenceData loadTestDataArray];
            if(array == nil || [array count] == 0)
            {
                return 0;
            }
            if([array count] >= batchIndex * TotalItemsPerBatch)
            {
                //NSLog(@"TotalRows: %ld", batchIndex * TotalRowsPerBatch);
                return batchIndex * TotalRowsPerBatch * HeightOfItemInShopsTableCell;
            }
            else // 0 < count < batchIndex * TotalItemsPerBatch
            {
                NSInteger totalRows = ([array count] - 1) / 2 + 1;
                NSLog(@"TotalRows: %ld", (long)totalRows);
                return totalRows * HeightOfItemInShopsTableCell;
            }
        }
        case SectionLoadMore:
            return 60.0f;
        default:
            return 60.0f;
    }
}

- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [self.categoryPopover dismissMenuPopover];
    NSLog(@"Category selected");
}


- (void)scrollToTopOfShopsSection
{
    // 检测ShopsSection的Header是否已经被置顶
    if(self.tableView.contentOffset.y < 150)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:SectionShops];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)showCategoryPopover:(id)sender
{
    CGFloat buttonHeight = 36.0f;
    CGFloat topImageViewHeight = 64.0f;
    CGFloat buttonWidth = 106.0f;
    
    CGRect popoverFrame = CGRectMake(5 + (buttonWidth * self.categoryButtonIndex),
                                     topImageViewHeight + buttonHeight,
                                     self.view.bounds.size.width - 10,
                                     44 * 7);// Only display 7 lines most
    
    // Hide already showing popover
    if(self.categoryPopover)
    {
        [self.categoryPopover dismissMenuPopover];
    }
    
    self.categoryPopover = [[MLKMenuPopover alloc] initWithFrame:popoverFrame menuItems:self.categoriesListArray];
    self.categoryPopover.menuPopoverDelegate = self;
    [self.categoryPopover showInView:self.view];
}


- (void)categoryButtonClicked:(UIButton *)sender
{
    self.categoryButtonIndex = sender.tag - 201;
    [self scrollToTopOfShopsSection];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(showCategoryPopover:) userInfo:nil repeats:NO];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat buttonWidth = 106.0f;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 36)];
    //imageView.backgroundColor = [UIColor lightGrayColor];
    
    [imageView setUserInteractionEnabled:YES];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(imageView.frame.origin.x,
                                                                   imageView.frame.origin.y,
                                                                   buttonWidth, 36)];
    button1.tag = 201;
    button1.backgroundColor = [UIColor lightGrayColor];
    [button1 addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + buttonWidth + 1,
                                                                   imageView.frame.origin.y,
                                                                   buttonWidth, 36)];
    button2.tag = 202;
    button2.backgroundColor = [UIColor lightGrayColor];
    
    [button2 addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + (buttonWidth + 1) * 2,
                                                                   imageView.frame.origin.y,
                                                                   buttonWidth, 36)];
    button3.tag = 203;
    button3.backgroundColor = [UIColor lightGrayColor];
    [button3 addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [imageView addSubview:button1];
    [imageView addSubview:button2];
    [imageView addSubview:button3];
    
    return imageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == SectionShops)
        return 36.0f;
    else
        return 0;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowShopsSegueFromCommunity"])
    {
        // showShopViewFrom默认值为0，这里可以省略
        //ShopViewController *shopVC = (ShopViewController *)segue.destinationViewController;
        //shopVC.showShopViewFrom = ShowViewFromHome;
    }
}

- (void)itemClickedInCell:(ShopsAndProductsCell *)cell
{
    [self performSegueWithIdentifier:@"ShowShopsSegueFromCommunity" sender:self];
}

@end
