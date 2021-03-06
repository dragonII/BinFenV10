//
//  TabHomeViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/2/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "TabHomeViewController.h"
#import "OTCover.h"
#import "CommunityCollectionViewCell.h"
#import "CommunityTableViewCell.h"

#import "CategoryTableViewCell.h"

#import "ShopsCell.h"

#import "BFPreferenceData.h"

#import "MLKMenuPopover.h"

#import "CommunityViewController.h"

#import "ShopViewController.h"

#import "defs.h"

//#import "DataModel.h"

#import "AFNetworking.h"
#import "AppDelegate.h"
#import "DataModel.h"
#import "DeviceHardware.h"

#import "NetworkLoadingViewController.h"


static NSString *CommunityTableRowCellIdentifier = @"CommunityTableRowCellIdentifier";
static NSString *CategoryTableCellIdentifier = @"CategoryTableCellIdentifier";
static NSString *ShopTableCellIdentifier = @"ShopTableViewCellIdentifier";

static NSString *CommunityCollectionCellIdentifier = @"CommunityCollectionCellIdentifier";

static const NSInteger CommunityTableSectionIndex = 0;
static const NSInteger CategoryTableSectionIndex = 1;
static const NSInteger ShopsTableSectionIndex = 2;
static const NSInteger RefreshSectionIndex = 3;




@interface TabHomeViewController () <UITableViewDataSource, UITableViewDelegate, MLKMenuPopoverDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, OTCoverSegueDelegate, ShopsCellSegueDelegate, NetworkLoadingViewDelegate>

@property (strong, nonatomic) OTCover *otCoverView;

@property (assign, nonatomic) BOOL hideCommunityRowCell;

//@property (strong, nonatomic) DelegatesForCollection *collectionDelegates;

@property (strong, nonatomic) MLKMenuPopover *categoryPopover;

@property (strong, nonatomic) NSArray *communitiesDataList;
@property (strong, nonatomic) NSMutableArray *communitiyIndexArray; //用来记录哪个CollectionCell被选择
//@property (strong, nonatomic) NSArray *categoriesDataList;
//@property (strong, nonatomic) NSArray *shopsDataList;

@property (assign, nonatomic) NSInteger categoryButtonIndex;

@property (strong, nonatomic) NSTimer *timer;

//@property (copy, nonatomic) NSString *selectedCommunityName;
//@property (copy, nonatomic) NSString *selectedCommunityID;
@property (assign, nonatomic) NSInteger selectedCommunityIndex;
@property (assign, nonatomic) NSInteger selectedShopIndex;

@property (assign, nonatomic) NSInteger networkLoadingCounts;

@property (strong, nonatomic) NetworkLoadingViewController *networkLoadingViewController;

@end



@implementation TabHomeViewController

- (void)initCommunitiesData
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //self.testDataArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < 15; i++)
    {
        [array addObject:[NSString stringWithFormat:@"%d", i]];
    }
    self.communitiesDataList = [NSArray arrayWithArray:array];
    self.communitiyIndexArray = [[NSMutableArray alloc] init];
}

- (void)loadCommunitiesData
{
    
}



- (void)initCategoriesData
{
    /*
    self.categoriesDataList = @[@"Cate01",
                                @"Cate02",
                                @"Cate03",
                                @"Cate04",
                                @"Cate05",
                                @"Cate06",
                                @"Cate07",
                                @"Cate08",
                                @"Cate09",
                                @"Cate10",
                                @"Cate11"];
     */
}

- (void)loadingData
{
    /*
    if(self.dataModel.loadShopsFinished == YES &&
       self.dataModel.loadCommunitiesFinished == YES)
     */
    if(self.dataModel.loadCategoriesFailed == NO &&
       self.dataModel.loadShopsFailed == NO &&
       self.dataModel.loadProductsFailed == NO &&
       self.dataModel.loadCommunitiesFailed == NO)
    {
        [self.timer invalidate];
        
        [self.otCoverView.refreshControl endRefreshing];
        [self hideLoadingView];
        
        NSLog(@"Loading Cells");
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:CommunityTableSectionIndex];
        CommunityTableViewCell *cell = (CommunityTableViewCell *)[self.otCoverView.tableView cellForRowAtIndexPath:indexPath];
        [cell.collectionView reloadData];
        
        [self.otCoverView.tableView reloadData];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } else {
        NSLog(@"Reloading Data");
        if(self.networkLoadingCounts >= 4)
        {
            NSLog(@"网络链接失败，请重新加载");
            [self.networkLoadingViewController showErrorView];
            [self.timer invalidate];
            [self.otCoverView.refreshControl endRefreshing];
            return;
        }
        self.networkLoadingCounts++;
        [self.dataModel loadDataModelRemotely];
        return;
    }
}

#pragma - NetworkLoadingViewDelegate
- (void)retryRequest
{
    NSLog(@"Retrying loading all data again");
    [self loadAllDataWithLoadingView:YES];
}

- (void)initShopsData
{
    //[self.dataModel loadDataModelRemotely];
    
    /*
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(int i = 0; i < 51; i++)
    {
        [array addObject:[NSString stringWithFormat:@"ID: %d", i]];
    }
    
    self.shopsDataList = [NSArray arrayWithArray:array];
    [BFPreferenceData saveTestDataArray:array];
     */
}

- (void)loadAllDataWithLoadingView:(BOOL)boolValue
{
    // 由showLoadingView来控制NetworkingLoadingView的显示与否
    if(boolValue == YES)
        [self showLoadingView];
    
    self.dataModel = [[DataModel alloc] init];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self initCommunitiesData];
    [self initCategoriesData];
    [self initShopsData];
    
    self.networkLoadingCounts = 0;
    
    
    [self.dataModel loadDataModelRemotely];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5
                                                  target:self
                                                selector:@selector(loadingData)
                                                userInfo:nil repeats:YES];
    //[self.dataModel loadDataModelLocally];
}

- (void)initCommunityTableRow
{
    UINib *nib = [UINib nibWithNibName:@"CommunityTableViewCell" bundle:nil];
    [self.otCoverView.tableView registerNib:nib forCellReuseIdentifier:CommunityTableRowCellIdentifier];
}

- (void)initCategoryTableRow
{
    [self.otCoverView.tableView registerClass:[CategoryTableViewCell class] forCellReuseIdentifier:CategoryTableCellIdentifier];
}

- (void)initShopsTableRow
{
    UINib *nib = [UINib nibWithNibName:@"ShopsCell" bundle:nil];
    [self.otCoverView.tableView registerNib:nib forCellReuseIdentifier:ShopTableCellIdentifier];
    
    // Batch Index is start from "1"
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:LoadContentBatchIndexKey];
}

- (NSString *)getHeaderImageNameByDevice
{
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    
    switch (generalPlatform)
    {
        case DeviceHardwareGeneralPlatform_iPhone_4:
        case DeviceHardwareGeneralPlatform_iPhone_4S:
        case DeviceHardwareGeneralPlatform_iPhone_5:
        case DeviceHardwareGeneralPlatform_iPhone_5C:
        case DeviceHardwareGeneralPlatform_iPhone_5S:
        {
            return @"Header320.png";
        }

        case DeviceHardwareGeneralPlatform_iPhone_6:
        {
            return @"Header375.png";
        }
        case DeviceHardwareGeneralPlatform_iPhone_6_Plus:
        default:
            // For iphone 6 simulator
            return @"Header414.png";
    }
}


- (void)initViews
{
    NSString *headerImageName = [self getHeaderImageNameByDevice];
    
    //self.otCoverView = [[OTCover alloc] initWithTableViewWithHeaderImage:[UIImage imageNamed:@"Default_170×320"] withOTCoverHeight:170];
    self.otCoverView = [[OTCover alloc] initWithTableViewWithHeaderImage:[UIImage imageNamed:headerImageName] withOTCoverHeight:170];
    
    self.otCoverView.tableView.delegate = self;
    self.otCoverView.tableView.dataSource = self;
    self.otCoverView.segueDelegate = self;
    
    [self.otCoverView.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //[self.otCoverView.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    [self initCommunityTableRow];
    [self initCategoryTableRow];
    [self initShopsTableRow];
    
    [self.view addSubview:self.otCoverView];
}


- (void)hideNavigationItem
{
    self.navigationItem.title = @"首页";
    self.navigationController.navigationBarHidden = YES;
}

- (void)showNavigationItem
{
    self.navigationController.navigationBarHidden = NO;
}

/*
- (void)hideTabBar
{
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}
 */

- (void)showLoadingView
{
    if(self.networkLoadingViewController == nil)
        self.networkLoadingViewController = [[NetworkLoadingViewController alloc] init];

    self.networkLoadingViewController.delegate = self;
    
    [self.networkLoadingViewController showLoadingView];
    
    [self.view addSubview:self.networkLoadingViewController.view];
    [self addChildViewController:self.networkLoadingViewController];
    [self.networkLoadingViewController didMoveToParentViewController:self];
}

- (void)hideLoadingView
{
    [self.networkLoadingViewController willMoveToParentViewController:nil];
    [self.networkLoadingViewController.view removeFromSuperview];
    [self.networkLoadingViewController removeFromParentViewController];
    
    self.networkLoadingViewController = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self loadAllData];
    
    self.hideCommunityRowCell = NO;
    
    //[self hideNavigationItem];
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self initViews];
    
    self.networkLoadingViewController = nil;
    [self loadAllDataWithLoadingView:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/*
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self showNavigationItem];
}
 */
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self showNavigationItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideNavigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UICollectionDelegate, DataSource and Flow
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //return [self.communitiesDataList count];
    return [self.dataModel.communities count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityCollectionViewCell *cell = (CommunityCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CommunityCollectionCellIdentifier forIndexPath:indexPath];
    
    //cell.text = [self.communitiesDataList objectAtIndex:indexPath.row];
    cell.text = [[self.dataModel.communities objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(120, 160);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    // 不清楚设置的为什么的间距，与Apple文档说明不一致
    return 8.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    //水平cell间距
    return 8.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //CommunityCollectionViewCell *cell = (CommunityCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if(![self.communitiyIndexArray containsObject:indexPath])
    {
        [self.communitiyIndexArray addObject:indexPath];
    }

    self.selectedCommunityIndex = indexPath.row;

    [self performSegueWithIdentifier:@"ShowCommunitySegue" sender:self];
}


#pragma TableView delegate, DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (void)configureCollectionViewInCommunityTableCell:(CommunityTableViewCell *)cell
{
    cell.collectionView.delegate = self;
    cell.collectionView.dataSource = self;
    cell.collectionView.backgroundColor = [UIColor clearColor];
    cell.collectionView.showsHorizontalScrollIndicator = NO;
    
    UINib *nib = [UINib nibWithNibName:@"CommunityCollectionViewCell" bundle:nil];
    [cell.collectionView registerNib:nib forCellWithReuseIdentifier:CommunityCollectionCellIdentifier];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)cell.collectionView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(120, 160);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSInteger rowNumber = indexPath.row;
    NSInteger sectionNumber = indexPath.section;
    switch (sectionNumber)
    {
        case CommunityTableSectionIndex:
        {
            CommunityTableViewCell *cell = (CommunityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CommunityTableRowCellIdentifier];
            
            if(cell == nil)
            {
                cell = [[CommunityTableViewCell alloc] init];
            }
            
            [self configureCollectionViewInCommunityTableCell:cell];
            
            if(self.hideCommunityRowCell == YES)
               [cell setHidden:YES];
            
            return cell;
            
            break;
        }
            
        case CategoryTableSectionIndex:
        {
            CategoryTableViewCell *cell = (CategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CategoryTableCellIdentifier];
            if(cell == nil)
            {
                cell = [[CategoryTableViewCell alloc] init];
            }
            
            //cell.categoriesListArray = self.categoriesDataList;
            cell.categoriesListArray = self.dataModel.categories;
            
            return cell;
        }
            
        case ShopsTableSectionIndex:
        {
            ShopsCell *cell = (ShopsCell *)[tableView dequeueReusableCellWithIdentifier:ShopTableCellIdentifier];
            if(cell == nil)
            {
                cell = [[ShopsCell alloc] init];
            }
            
            [cell initShopItemsByCommunityIndex:-1];
            
            cell.segueDelegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
            
        case RefreshSectionIndex:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.text = @"加载更多";
            return cell;
        }
    
        default:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.text = @"Left Cells";
            return cell;
        }
    }
}

- (CGFloat)getHeightOfItemRow
{
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    
    switch (generalPlatform)
    {
        case DeviceHardwareGeneralPlatform_iPhone_4:
        case DeviceHardwareGeneralPlatform_iPhone_4S:
        case DeviceHardwareGeneralPlatform_iPhone_5:
        case DeviceHardwareGeneralPlatform_iPhone_5C:
        case DeviceHardwareGeneralPlatform_iPhone_5S:
        {
            return 208 + 10;
            break;
        }

        case DeviceHardwareGeneralPlatform_iPhone_6:
        {
            return 246 + 10;
            break;
        }
            
        case DeviceHardwareGeneralPlatform_iPhone_6_Plus:
        default:
            // For iphone 6 plus simulator
            return 274 + 10;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sectionNumber = indexPath.section;
    CGFloat heightOfItemInShopsCell = [self getHeightOfItemRow];
    
    switch (sectionNumber)
    {
        case CommunityTableSectionIndex:
            if(self.hideCommunityRowCell == YES)
                return 0.0f;
            else
                return 184.0f;
            
        case CategoryTableSectionIndex:
            return 214.0f;
            
        case ShopsTableSectionIndex:
        {
            NSInteger batchIndex = [[NSUserDefaults standardUserDefaults] integerForKey:LoadContentBatchIndexKey];
            if([self.dataModel.shops count] == 0)
            {
                return 0;
            }
            
            if([self.dataModel.shops count] >= batchIndex * TotalItemsPerBatch)
            {
                return batchIndex * TotalRowsPerBatch * heightOfItemInShopsCell;
            }
            else // 0 < count < batchIndex * TotalItemsPerBatch
            {
                NSInteger totalRows = ([self.dataModel.shops count] - 1) / 2 + 1;
                return totalRows * heightOfItemInShopsCell;
            }
        }
            
        default:
            return 60.0f;
            break;
    }
}

- (void)loadNextBatchShops
{
    //NSArray *array = [BFPreferenceData loadTestDataArray];
    NSInteger batchIndex = [[NSUserDefaults standardUserDefaults] integerForKey:LoadContentBatchIndexKey];

    //if(batchIndex * TotalItemsPerBatch < [array count])
    if((batchIndex * TotalItemsPerBatch) < [self.dataModel.shops count])
    {
        batchIndex++;
        [[NSUserDefaults standardUserDefaults] setInteger:batchIndex forKey:LoadContentBatchIndexKey];
        NSLog(@"batchIndex in load...: %ld", (long)batchIndex);
        [self.otCoverView.tableView reloadData];
    } else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:RefreshSectionIndex];
        UITableViewCell *cell = [self.otCoverView.tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.text = @"没有更多了";
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == RefreshSectionIndex)
    {
        [self loadNextBatchShops];
    }
}


- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [self.categoryPopover dismissMenuPopover];
    NSLog(@"Category selected, %ld", (long)selectedIndex);
}

- (void)scrollToTopOfShopsSection
{
    // 检测ShopsSection的Header是否已经被置顶
    if(self.otCoverView.tableView.contentOffset.y < 504)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:ShopsTableSectionIndex];
        [self.otCoverView.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}


- (void)showCategoryPopover:(id)sender
{
    CGFloat buttonHeight = 36.0f;
    CGFloat topImageViewHeight = 64.0f;
    CGFloat buttonWidth = 106.0f;
    
    CGFloat itemWidth = self.view.bounds.size.width - 10;
    CGFloat itemHeight;
    
    CGRect popoverFrame;
    
    // Hide already showing popover
    if(self.categoryPopover)
    {
        [self.categoryPopover dismissMenuPopover];
    }
    
    switch (self.categoryButtonIndex)
    {
        case 0:  // 区域选择
        {
            NSArray *array = @[@"福田", @"罗湖", @"南山", @"龙岗"];
            popoverFrame  = CGRectMake(5 + (buttonWidth * self.categoryButtonIndex),
                                         topImageViewHeight + buttonHeight,
                                         itemWidth,
                                         44 * [array count]);// Only display 7 lines most
            self.categoryPopover = [[MLKMenuPopover alloc] initWithFrame:popoverFrame menuItems:array];
            break;
        }
        case 1:  // 分类选择
        {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for(int i = 0; i < [self.dataModel.categories count]; i++)
            {
                [array addObject:[[self.dataModel.categories objectAtIndex:i] objectForKey:CategoryNameKey]];
            }
            if([self.dataModel.categories count] >= 7)
                itemHeight = 44 * 7;
            else
                itemHeight = 44 * [array count];
            popoverFrame = CGRectMake(5 + (buttonWidth * self.categoryButtonIndex), topImageViewHeight + buttonHeight,
                                      itemWidth, itemHeight);
            self.categoryPopover = [[MLKMenuPopover alloc] initWithFrame:popoverFrame menuItems:array];
            break;
        }
            
        case 2:  // 排序方式选择
        {
            NSArray *array = @[@"发布时间"];
            popoverFrame = CGRectMake(5 + (buttonWidth * self.categoryButtonIndex), topImageViewHeight + buttonHeight,
                                      itemWidth, 44 * [array count]);
            self.categoryPopover = [[MLKMenuPopover alloc] initWithFrame:popoverFrame menuItems:array];
            break;
        }
            
        default:
            break;
    }
    
    //self.categoryPopover = [[MLKMenuPopover alloc] initWithFrame:popoverFrame menuItems:self.categoriesDataList];
    //self.categoryPopover = [[MLKMenuPopover alloc] initWithFrame:popoverFrame menuItems:@[@"1", @"2", @"3"]];
    self.categoryPopover.menuPopoverDelegate = self;
    [self.categoryPopover showInView:self.view];
}

- (void)categoryButtonClicked:(UIButton *)sender
{
    self.categoryButtonIndex = sender.tag - 101;
    [self scrollToTopOfShopsSection];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(showCategoryPopover:) userInfo:nil repeats:NO];
}

- (CGFloat)getItemWidthByDevice
{
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    
    switch (generalPlatform)
    {
        case DeviceHardwareGeneralPlatform_iPhone_4:
        case DeviceHardwareGeneralPlatform_iPhone_4S:
        case DeviceHardwareGeneralPlatform_iPhone_5:
        case DeviceHardwareGeneralPlatform_iPhone_5C:
        case DeviceHardwareGeneralPlatform_iPhone_5S:
        {
            return 106.0f;
            break;
        }
            
        case DeviceHardwareGeneralPlatform_iPhone_6:
            return 124.0f;
            
        case DeviceHardwareGeneralPlatform_iPhone_6_Plus:
        {
            return 138.0f;
            break;
        }
            
        default:
            NSLog(@"Width: %f", self.view.bounds.size.width);
            return 138.0f;
            break;
    }
}

- (void)setButtonTitleColor:(UIButton *)button
{
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIColor *buttonColor = [UIColor colorWithRed:255/255.0f
                                           green:255/255.0f
                                            blue:255/255.0f
                                           alpha:1.0f];
    if(section == ShopsTableSectionIndex)
    {
        //CGFloat buttonWidth = 106.0f;
        CGFloat buttonWidth = [self getItemWidthByDevice];
    
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 36)];
        //imageView.backgroundColor = [UIColor lightGrayColor];
    
        [imageView setUserInteractionEnabled:YES];
    
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(imageView.frame.origin.x,
                                                                 imageView.frame.origin.y,
                                                                  buttonWidth, 36)];
        button1.tag = 101;
        button1.backgroundColor = buttonColor;
        [self setButtonTitleColor:button1];
        [button1 addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button1 setTitle:@"区域" forState:UIControlStateNormal];
        [button1 setTitle:@"区域" forState:UIControlStateSelected];
        [button1.titleLabel setFont:[UIFont systemFontOfSize:15]];
        button1.layer.borderWidth = 0.5f;
        button1.layer.borderColor = [UIColor colorWithRed:227/255.0f green:227/255.0f blue:227/255.0f alpha:1.0f].CGColor;
    
        UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + buttonWidth + 1,
                                                                  imageView.frame.origin.y,
                                                                   buttonWidth, 36)];
        button2.tag = 102;
        button2.backgroundColor = buttonColor;
        [self setButtonTitleColor:button2];
        [button2 addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button2 setTitle:@"分类" forState:UIControlStateNormal];
        [button2 setTitle:@"分类" forState:UIControlStateSelected];
        [button2.titleLabel setFont:[UIFont systemFontOfSize:15]];
        button2.layer.borderWidth = 0.5f;
        button2.layer.borderColor = [UIColor colorWithRed:227/255.0f green:227/255.0f blue:227/255.0f alpha:1.0f].CGColor;
        
        UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + (buttonWidth + 1) * 2,
                                                                  imageView.frame.origin.y,
                                                                   buttonWidth + 1, 36)];
        button3.tag = 103;
        button3.backgroundColor = buttonColor;
        [self setButtonTitleColor:button3];
        [button3 addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button3 setTitle:@"排序" forState:UIControlStateNormal];
        [button3 setTitle:@"排序" forState:UIControlStateSelected];
        [button3.titleLabel setFont:[UIFont systemFontOfSize:15]];
    
        [imageView addSubview:button1];
        [imageView addSubview:button2];
        [imageView addSubview:button3];
    
        return imageView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == ShopsTableSectionIndex)
        return 36.0f;
    else
        return 0;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowCommunitySegue"])
    {
        CommunityViewController *communityVC = (CommunityViewController *)segue.destinationViewController;
        communityVC.communityIndex = self.selectedCommunityIndex;
        communityVC.hidesBottomBarWhenPushed = YES;
        communityVC.categoriesListArray = self.dataModel.categories;
    }
    if([segue.identifier isEqualToString:@"ShowShopSegueFromTabHome"])
    {
        ShopViewController *shopVC = (ShopViewController *)segue.destinationViewController;
        shopVC.hidesBottomBarWhenPushed = YES;
        shopVC.selectedShopIndex = self.selectedShopIndex;
    }
}

#pragma OTCoverSegueDelegate

- (void)searchClickedInView:(OTCover *)view
{
    [self performSegueWithIdentifier:@"SelectCommunitySegue" sender:self];
}

- (void)refreshData
{
    NSLog(@"Refreshing by pulling");
    [self loadAllDataWithLoadingView:NO];
}

#pragma unwind segue

- (IBAction)unwindToTabHome:(UIStoryboardSegue *)segue
{
    
}

#pragma SegueDelegate for ShopsAndProductsCell

- (void)shopItemClickedInCell:(ShopsCell *)cell
{
    self.selectedShopIndex = cell.selectedShopIndex;
    [self performSegueWithIdentifier:@"ShowShopSegueFromTabHome" sender:self];
}


@end
