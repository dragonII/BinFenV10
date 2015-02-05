//
//  CommunityViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/5/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "CommunityViewController.h"
#import "CategoryTableViewCell.h"
#import "ProductTableViewCell.h"
#import "BFPreferenceData.h"
#import "defs.h"

NSString *CategoryCellIdentifier = @"CategoryCellIdentifier";
NSString *ProductCellIdentifier = @"ProductCellIdentifier";

static const int SectionCategory = 0;
static const int SectionCommunity = 1;
static const int SectionLoadMore = 2;

@interface CommunityViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation CommunityViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect mainBounds = [[UIScreen mainScreen] bounds];
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusBarHeight = 20;
    self.tableView = [[UITableView alloc] initWithFrame:mainBounds];
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.top = navigationBarHeight + statusBarHeight;
    self.tableView.contentInset = insets;
    
    [self.view addSubview:self.tableView];
    
    [self initTableRowWithScroll];
    
    self.navigationItem.title = @"社区";
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"Width: %f", self.tableView.bounds.size.width);
    NSLog(@"Width: %f", [UIScreen mainScreen].bounds.size.width);
    NSLog(@"Height: %f", self.tableView.bounds.size.height);
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
            
        case SectionCommunity:
        {
            ProductTableViewCell *cell = (ProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ProductCellIdentifier];
            if(cell == nil)
            {
                cell = [[ProductTableViewCell alloc] init];
            }
            
            [cell initItems];
            
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
    {
        //[self loadNextBatchProducts];
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
        case SectionCommunity:
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
        case SectionLoadMore:
            return 60.0f;
        default:
            return 60.0f;
    }
}

@end
