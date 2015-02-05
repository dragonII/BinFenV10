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

//@property (strong, nonatomic) UIImageView *searchView;

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

- (void)initCollectionDelegates
{
    self.collectionDelegates = [[DelegatesForCollection alloc] init];
    [self.collectionDelegates initTestData];
}

- (void)initTestData
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:215];
    for(int i = 0; i < 51; i++)
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

- (void)button1Clicked:(UIButton *)sender
{
    NSLog(@"button one");
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
