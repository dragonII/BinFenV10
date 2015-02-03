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

#import "defs.h"

@interface TabHomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) OTCover *otCoverView;

@property (strong, nonatomic) DelegatesForCollection *collectionDelegates;

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

- (void)initCollectionDelegates
{
    self.collectionDelegates = [[DelegatesForCollection alloc] init];
    [self.collectionDelegates initTestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (void)configureCollectionViewInTopTableCell:(TopTableViewCell *)cell
{
    cell.contentView.backgroundColor = [UIColor lightGrayColor];
    cell.collectionView.delegate = self.collectionDelegates;
    cell.collectionView.dataSource = self.collectionDelegates;
    cell.collectionView.backgroundColor = [UIColor clearColor];
    cell.collectionView.showsHorizontalScrollIndicator = NO;
    
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
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            return cell;
        }
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




@end
