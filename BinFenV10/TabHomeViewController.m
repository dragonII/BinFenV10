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

#import "defs.h"

@interface TabHomeViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) OTCover *otCoverView;

@property (strong, nonatomic) NSMutableArray *testDataArray;

@end



@implementation TabHomeViewController

- (void)initTopTableRow
{
    [self.otCoverView.tableView registerClass:[TopTableViewCell class] forCellReuseIdentifier:TopTableRowCellIdentifier];
    UINib *nib = [UINib nibWithNibName:@"TopTableViewCell" bundle:nil];
    [self.otCoverView.tableView registerNib:nib forCellReuseIdentifier:TopTableRowCellIdentifier];
}

- (void)initViews
{
    self.otCoverView = [[OTCover alloc] initWithTableViewWithHeaderImage:[UIImage imageNamed:@"HeaderPlaceHolder"] withOTCoverHeight:170];
    
    self.otCoverView.tableView.delegate = self;
    self.otCoverView.tableView.dataSource = self;
    
    [self initTopTableRow];
    
    [self.view addSubview:self.otCoverView];
}


- (void)hideNavigationItem
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)initTestData
{
    self.testDataArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < 15; i++)
        [self.testDataArray addObject:[NSString stringWithFormat:@"%d", i]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hideNavigationItem];
    
    [self initTestData];
    
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (void)configureCollectionViewInTopTableCell:(TopTableViewCell *)cell
{
    //cell.
    cell.collectionView.delegate = self;
    cell.collectionView.dataSource = self;
    cell.collectionView.backgroundColor = [UIColor whiteColor];
    
    [cell.collectionView registerClass:[TopCollectionViewCell class] forCellWithReuseIdentifier:TopCollectionCellIdentifier];
    UINib *nib = [UINib nibWithNibName:@"TopCollectionViewCell" bundle:nil];
    [cell.collectionView registerNib:nib forCellWithReuseIdentifier:TopCollectionCellIdentifier];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)cell.collectionView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(120, 160);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowNumber = indexPath.row;
    switch (rowNumber)
    {
        case TopTableRowIndex:
        {
            TopTableViewCell *cell = (TopTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TopTableRowCellIdentifier];
            
            [self configureCollectionViewInTopTableCell:cell];
            
            return cell;
            
            break;
        }
            
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowNumber = indexPath.row;
    switch (rowNumber)
    {
        case TopTableRowIndex:
            return 184.0f;
            break;
            
        default:
            return 60.0f;
            break;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.testDataArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TopCollectionViewCell *cell = (TopCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:TopCollectionCellIdentifier forIndexPath:indexPath];
    
    cell.text = [self.testDataArray objectAtIndex:indexPath.row];
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


@end
