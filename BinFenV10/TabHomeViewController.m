//
//  TabHomeViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/2/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "TabHomeViewController.h"
#import "OTCover.h"
#import "TopCollectionViewCell.h"
#import "TopTableViewCell.h"
//#import "DelegatesForCollection.h"

#import "SecondTableViewCell.h"
#import "ThirdTableViewCell.h"

#import "BFPreferenceData.h"

#import "MLKMenuPopover.h"

#import "defs.h"

@interface TabHomeViewController () <UITableViewDataSource, UITableViewDelegate, MLKMenuPopoverDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) OTCover *otCoverView;

@property (assign, nonatomic) BOOL hideTopRowCell;

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

- (void)initTopTableRow
{
    //[self.otCoverView.tableView registerClass:[TopTableViewCell class] forCellReuseIdentifier:TopTableRowCellIdentifier];
    UINib *nib = [UINib nibWithNibName:@"TopTableViewCell" bundle:nil];
    [self.otCoverView.tableView registerNib:nib forCellReuseIdentifier:TopTableRowCellIdentifier];
}

- (void)initSecondTableRow
{
    //[self.otCoverView.tableView registerClass:[SecondTableViewCell class] forCellReuseIdentifier:SecondTableCellIdentifier];
    UINib *nib = [UINib nibWithNibName:@"SecondTableViewCell" bundle:nil];
    [self.otCoverView.tableView registerNib:nib forCellReuseIdentifier:SecondTableCellIdentifier];
}

- (void)initThirdTableRow
{
    UINib *nib = [UINib nibWithNibName:@"ThirdTableViewCell" bundle:nil];
    [self.otCoverView.tableView registerNib:nib forCellReuseIdentifier:ThirdTableCellIdentifier];
    
    // Batch Index is start from "1"
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:LoadContentBatchIndexKey];
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:CanBeRefreshedKey];
}


- (void)initViews
{
    self.otCoverView = [[OTCover alloc] initWithTableViewWithHeaderImage:[UIImage imageNamed:@"HeaderPlaceHolder"] withOTCoverHeight:170];
    
    self.otCoverView.tableView.delegate = self;
    self.otCoverView.tableView.dataSource = self;
    
    [self.otCoverView.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //[self.otCoverView.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    [self initTopTableRow];
    [self initSecondTableRow];
    [self initThirdTableRow];
    
    [self.view addSubview:self.otCoverView];
}


- (void)hideNavigationItem
{
    self.navigationController.navigationBarHidden = YES;
}

/*
- (void)initTestData
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:215];
    for(int i = 0; i < 51; i++)
    {
        [array addObject:[NSString stringWithFormat:@"ID: %d", i]];
    }
    
    [BFPreferenceData saveTestDataArray:array];
}
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initProductsData];
    [self initCommunitiesData];
    [self initCategoriesData];
    
    self.hideTopRowCell = NO;
    
    [self hideNavigationItem];
    
    //[self initCollectionDelegates];
    
    [self initViews];
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
    TopCollectionViewCell *cell = (TopCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:TopCollectionCellIdentifier forIndexPath:indexPath];
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
    TopCollectionViewCell *cell = (TopCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if([self.communitiyIndexArray containsObject:indexPath])
    {
        //cell.imageView.image = [UIImage imageNamed:@"CellPlaceHolder"];
    } else {
        [self.communitiyIndexArray addObject:indexPath];
        cell.imageView.image = [UIImage imageNamed:@"120x160_2"];
    }
    //NSLog(@"indexArray: %@", self.indexPathArray);
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

- (void)configureCollectionViewInTopTableCell:(TopTableViewCell *)cell
{
    //cell.contentView.backgroundColor = [UIColor lightGrayColor];
    cell.collectionView.delegate = self;//.collectionDelegates;
    cell.collectionView.dataSource = self;//.collectionDelegates;
    cell.collectionView.backgroundColor = [UIColor clearColor];
    cell.collectionView.showsHorizontalScrollIndicator = NO;
    
    //[cell.collectionView registerClass:[TopCollectionViewCell class] forCellWithReuseIdentifier:TopCollectionCellIdentifier];
    UINib *nib = [UINib nibWithNibName:@"TopCollectionViewCell" bundle:nil];
    [cell.collectionView registerNib:nib forCellWithReuseIdentifier:TopCollectionCellIdentifier];
    
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
        case TopTableSectionIndex:
        {
            TopTableViewCell *cell = (TopTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TopTableRowCellIdentifier];
            
            if(cell == nil)
            {
                cell = [[TopTableViewCell alloc] init];
            }
            
            [self configureCollectionViewInTopTableCell:cell];
            
            if(self.hideTopRowCell == YES)
               [cell setHidden:YES];
            
            return cell;
            
            break;
        }
            
        case SecondTableSectionIndex:
        {
            SecondTableViewCell *cell = (SecondTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SecondTableCellIdentifier];
            if(cell == nil)
            {
                cell = [[SecondTableViewCell alloc] init];
            }
            
            cell.categoriesListArray = self.categoriesDataList;
            
            return cell;
        }
            
        case ThirdTableSectionIndex:
        {
            ThirdTableViewCell *cell = (ThirdTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ThirdTableCellIdentifier];
            if(cell == nil)
            {
                cell = [[ThirdTableViewCell alloc] init];
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
        case TopTableSectionIndex:
            if(self.hideTopRowCell == YES)
                return 0.0f;
            else
                return 184.0f;
            
        case SecondTableSectionIndex:
            return 214.0f;
            
        case ThirdTableSectionIndex:
        {
            int batchIndex = [[NSUserDefaults standardUserDefaults] integerForKey:LoadContentBatchIndexKey];
            NSArray *array = [BFPreferenceData loadTestDataArray];
            if(array == nil || [array count] == 0)
            {
                return 0;
            }
            if([array count] >= batchIndex * TotalItemsPerBatch)
            {
                NSLog(@"TotalRows: %d", batchIndex * TotalRowsPerBatch);
                return batchIndex * TotalRowsPerBatch * HeightOfItemInThirdTableCell;
            }
            else // 0 < count < batchIndex * TotalItemsPerBatch
            {
                int totalRows = ([array count] - 1) / 2 + 1;
                NSLog(@"TotalRows: %d", totalRows);
                return totalRows * HeightOfItemInThirdTableCell;
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
    int batchIndex = [[NSUserDefaults standardUserDefaults] integerForKey:LoadContentBatchIndexKey];

    if(batchIndex * TotalItemsPerBatch < [array count])
    {
        batchIndex++;
        [[NSUserDefaults standardUserDefaults] setInteger:batchIndex forKey:LoadContentBatchIndexKey];
        NSLog(@"batchIndex in load...: %d", batchIndex);
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

- (void)thirdSectionClicked:(UITapGestureRecognizer*)sender
{
    NSLog(@"ThirdSection Clicked");
    //UIView *view = sender.view;
    //NSLog(@"%d", view.tag);
}

- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [self.categoryPopover dismissMenuPopover];
    NSLog(@"Category selected");
}

- (void)scrollToTopThirdSection
{
    // 检测ThirdSection的Header是否已经被置顶
    if(self.otCoverView.tableView.contentOffset.y < 504)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:ThirdTableSectionIndex];
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
    [self scrollToTopThirdSection];
    
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
    if(section == ThirdTableSectionIndex)
        return 36.0f;
    else
        return 0;
}


@end
