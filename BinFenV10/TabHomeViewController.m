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
#import "DelegatesForCollection.h"

#import "SecondTableViewCell.h"
#import "ThirdTableViewCell.h"

#import "BFPreferenceData.h"

#import "defs.h"

@interface TabHomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) OTCover *otCoverView;

@property (assign, nonatomic) BOOL hideTopRowCell;

@property (strong, nonatomic) DelegatesForCollection *collectionDelegates;

@end



@implementation TabHomeViewController

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
    [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:LoadContentBatchIndexKey];
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

- (void)initCollectionDelegates
{
    self.collectionDelegates = [[DelegatesForCollection alloc] init];
    [self.collectionDelegates initTestData];
}

- (void)initTestData
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:215];
    for(int i = 0; i < 15; i++)
    {
        [array addObject:[NSString stringWithFormat:@"ID: %d", i]];
    }
    
    [BFPreferenceData saveTestDataArray:array];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTestData];
    
    self.hideTopRowCell = NO;
    
    [self hideNavigationItem];
    
    [self initCollectionDelegates];
    
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    cell.collectionView.delegate = self.collectionDelegates;
    cell.collectionView.dataSource = self.collectionDelegates;
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
            
            [self configureCollectionViewInTopTableCell:cell];
            
            if(self.hideTopRowCell == YES)
               [cell setHidden:YES];
            
            return cell;
            
            break;
        }
            
        case SecondTableSectionIndex:
        {
            SecondTableViewCell *cell = (SecondTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SecondTableCellIdentifier];
            return cell;
        }
            
        case ThirdTableSectionIndex:
        {
            ThirdTableViewCell *cell = (ThirdTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ThirdTableCellIdentifier];
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
            if([array count] >= 20)
            {
                NSLog(@"TotalRows: 10");
                return 10 * HeightOfItemInThirdTableCell;
            }
            else // 0 < count < 20
            {
                int totalRows = ([array count] - 1) / 2 + 1;
                NSLog(@"TotalRows: %d", totalRows);
                return totalRows * HeightOfItemInThirdTableCell;
            }
        }
            //return 5000;
            
        default:
            return 60.0f;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 36)];
    imageView.backgroundColor = [UIColor lightGrayColor];
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
