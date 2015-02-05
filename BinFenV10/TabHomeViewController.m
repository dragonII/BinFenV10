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
#import "ProductTableViewCell.h"

#import "BFPreferenceData.h"

#import "MLKMenuPopover.h"

#import "CommunityViewController.h"

#import "defs.h"



static NSString *CommunityTableRowCellIdentifier = @"CommunityTableRowCellIdentifier";
static NSString *CategoryTableCellIdentifier = @"CategoryTableCellIdentifier";
static NSString *ProductTableCellIdentifier = @"ProductTableViewCellIdentifier";

static NSString *CommunityCollectionCellIdentifier = @"CommunityCollectionCellIdentifier";

static const NSInteger CommunityTableSectionIndex = 0;
static const NSInteger CategoryTableSectionIndex = 1;
static const NSInteger ProductTableSectionIndex = 2;
static const NSInteger RefreshSectionIndex = 3;




@interface TabHomeViewController () <UITableViewDataSource, UITableViewDelegate, MLKMenuPopoverDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) OTCover *otCoverView;

@property (assign, nonatomic) BOOL hideCommunityRowCell;

//@property (strong, nonatomic) DelegatesForCollection *collectionDelegates;

@property (strong, nonatomic) MLKMenuPopover *categoryPopover;

@property (strong, nonatomic) NSArray *communitiesDataList;
@property (strong, nonatomic) NSMutableArray *communitiyIndexArray; //用来记录哪个CollectionCell被选择
@property (strong, nonatomic) NSArray *categoriesDataList;
@property (strong, nonatomic) NSArray *productsDataList;

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

- (void)initCategoriesData
{
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
}

- (void)initProductsData
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(int i = 0; i < 51; i++)
    {
        [array addObject:[NSString stringWithFormat:@"ID: %d", i]];
    }
    
    self.productsDataList = [NSArray arrayWithArray:array];
    [BFPreferenceData saveTestDataArray:array];
}

- (void)loadAllData
{
    [self initCommunitiesData];
    [self initCategoriesData];
    [self initProductsData];
}

- (void)initCommunityTableRow
{
    UINib *nib = [UINib nibWithNibName:@"CommunityTableViewCell" bundle:nil];
    [self.otCoverView.tableView registerNib:nib forCellReuseIdentifier:CommunityTableRowCellIdentifier];
}

- (void)initCategoryTableRow
{
    UINib *nib = [UINib nibWithNibName:@"CategoryTableViewCell" bundle:nil];
    [self.otCoverView.tableView registerNib:nib forCellReuseIdentifier:CategoryTableCellIdentifier];
}

- (void)initProductTableRow
{
    UINib *nib = [UINib nibWithNibName:@"ProductTableViewCell" bundle:nil];
    [self.otCoverView.tableView registerNib:nib forCellReuseIdentifier:ProductTableCellIdentifier];
    
    // Batch Index is start from "1"
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:LoadContentBatchIndexKey];
}


- (void)initViews
{
    self.otCoverView = [[OTCover alloc] initWithTableViewWithHeaderImage:[UIImage imageNamed:@"HeaderPlaceHolder"] withOTCoverHeight:170];
    
    self.otCoverView.tableView.delegate = self;
    self.otCoverView.tableView.dataSource = self;
    
    [self.otCoverView.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //[self.otCoverView.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    [self initCommunityTableRow];
    [self initCategoryTableRow];
    [self initProductTableRow];
    
    [self.view addSubview:self.otCoverView];
}


- (void)hideNavigationItem
{
    //self.navigationController.title = @"首页";
    self.navigationItem.title = @"首页";
    self.navigationController.navigationBarHidden = YES;
}

- (void)showNavigationItem
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)hideTabBar
{
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadAllData];
    
    self.hideCommunityRowCell = NO;
    
    [self hideNavigationItem];
    
    [self initViews];
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
    return [self.communitiesDataList count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityCollectionViewCell *cell = (CommunityCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CommunityCollectionCellIdentifier forIndexPath:indexPath];
    if([self.communitiyIndexArray containsObject:indexPath])
    {
        cell.imageView.image = [UIImage imageNamed:@"120x160_2"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"CellPlaceHolder"];
    }
    cell.text = [self.communitiesDataList objectAtIndex:indexPath.row];
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
    CommunityCollectionViewCell *cell = (CommunityCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if([self.communitiyIndexArray containsObject:indexPath])
    {
        //cell.imageView.image = [UIImage imageNamed:@"CellPlaceHolder"];
    } else {
        [self.communitiyIndexArray addObject:indexPath];
        cell.imageView.image = [UIImage imageNamed:@"120x160_2"];
    }
    
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
    //cell.contentView.backgroundColor = [UIColor lightGrayColor];
    cell.collectionView.delegate = self;//.collectionDelegates;
    cell.collectionView.dataSource = self;//.collectionDelegates;
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
            
            cell.categoriesListArray = self.categoriesDataList;
            
            return cell;
        }
            
        case ProductTableSectionIndex:
        {
            ProductTableViewCell *cell = (ProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ProductTableCellIdentifier];
            if(cell == nil)
            {
                cell = [[ProductTableViewCell alloc] init];
            }
            
            [cell initItems];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
            
        case RefreshSectionIndex:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.text = @"Click to Refresh";
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



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sectionNumber = indexPath.section;
    switch (sectionNumber)
    {
        case CommunityTableSectionIndex:
            if(self.hideCommunityRowCell == YES)
                return 0.0f;
            else
                return 184.0f;
            
        case CategoryTableSectionIndex:
            return 214.0f;
            
        case ProductTableSectionIndex:
        {
            NSInteger batchIndex = [[NSUserDefaults standardUserDefaults] integerForKey:LoadContentBatchIndexKey];
            NSArray *array = [BFPreferenceData loadTestDataArray];
            if(array == nil || [array count] == 0)
            {
                return 0;
            }
            if([array count] >= batchIndex * TotalItemsPerBatch)
            {
                NSLog(@"TotalRows: %d", batchIndex * TotalRowsPerBatch);
                return batchIndex * TotalRowsPerBatch * HeightOfItemInProductTableCell;
            }
            else // 0 < count < batchIndex * TotalItemsPerBatch
            {
                NSInteger totalRows = ([array count] - 1) / 2 + 1;
                NSLog(@"TotalRows: %ld", (long)totalRows);
                return totalRows * HeightOfItemInProductTableCell;
            }
        }
            
        default:
            return 60.0f;
            break;
    }
}

- (void)loadNextBatchProducts
{
    NSArray *array = [BFPreferenceData loadTestDataArray];
    NSInteger batchIndex = [[NSUserDefaults standardUserDefaults] integerForKey:LoadContentBatchIndexKey];

    if(batchIndex * TotalItemsPerBatch < [array count])
    {
        batchIndex++;
        [[NSUserDefaults standardUserDefaults] setInteger:batchIndex forKey:LoadContentBatchIndexKey];
        NSLog(@"batchIndex in load...: %ld", (long)batchIndex);
        [self.otCoverView.tableView reloadData];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == RefreshSectionIndex)
    {
        [self loadNextBatchProducts];
    }
}


- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [self.categoryPopover dismissMenuPopover];
    NSLog(@"Category selected");
}

- (void)scrollToTopOfProductSection
{
    // 检测ProductSection的Header是否已经被置顶
    if(self.otCoverView.tableView.contentOffset.y < 504)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:ProductTableSectionIndex];
        [self.otCoverView.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}


- (void)showCategoryPopover:(id)sender
{
    CGRect popoverFrame = CGRectMake(5, 36 + 64, self.view.bounds.size.width - 10, 44 * 7);// Only display 7 lines most
    // Hide already showing popover
    if(self.categoryPopover)
    {
        [self.categoryPopover dismissMenuPopover];
    }
    
    self.categoryPopover = [[MLKMenuPopover alloc] initWithFrame:popoverFrame menuItems:self.categoriesDataList];
    self.categoryPopover.menuPopoverDelegate = self;
    [self.categoryPopover showInView:self.view];
}

- (void)button1Clicked:(UIButton *)sender
{
    [self scrollToTopOfProductSection];
    
    [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(showCategoryPopover:) userInfo:nil repeats:NO];
}

- (void)button2Clicked:(UIButton *)sender
{
    NSLog(@"button two");
}

- (void)button3Clicked:(UIButton *)sender
{
    NSLog(@"button three");
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
    button1.backgroundColor = [UIColor lightGrayColor];
    [button1 addTarget:self action:@selector(button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + buttonWidth + 1,
                                                                  imageView.frame.origin.y,
                                                                   buttonWidth, 36)];
    button2.backgroundColor = [UIColor lightGrayColor];
    
    [button2 addTarget:self action:@selector(button2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + (buttonWidth + 1) * 2,
                                                                  imageView.frame.origin.y,
                                                                   buttonWidth, 36)];
    button3.backgroundColor = [UIColor lightGrayColor];
    [button3 addTarget:self action:@selector(button3Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [imageView addSubview:button1];
    [imageView addSubview:button2];
    [imageView addSubview:button3];
    
    return imageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == ProductTableSectionIndex)
        return 36.0f;
    else
        return 0;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowCommunitySegue"])
    {
        CommunityViewController *communityVC = (CommunityViewController *)segue.destinationViewController;
        communityVC.hidesBottomBarWhenPushed = YES;
        communityVC.categoriesListArray = self.categoriesDataList;
        [self showNavigationItem];
    }
}

@end
