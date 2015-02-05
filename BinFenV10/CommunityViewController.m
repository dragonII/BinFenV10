//
//  CommunityViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/5/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "CommunityViewController.h"
#import "SecondTableViewCell.h"
#import "ThirdTableViewCell.h"
#import "BFPreferenceData.h"
#import "defs.h"

NSString *CommunityCellIdentifier = @"CommunityCellIdentifier";
NSString *ProductCellIdentifier = @"ProductCellIdentifier";

@interface CommunityViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation CommunityViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%f", self.navigationController.navigationBar.frame.size.height);
    CGRect mainBounds = [[UIScreen mainScreen] bounds];
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusBarHeight = 20;
    //CGRect tableFrame = CGRectMake(mainBounds.origin.x, mainBounds.origin.y + navigationBarHeight + statusBarHeight, mainBounds.size.width, mainBounds.size.height - 150.0f);//- navigationBarHeight - statusBarHeight);
    //self.tableView.frame = tableFrame;
    //self.tableView.frame = CGRectMake(0, 64, 320, 480 - 64 - 49);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, 480 - 64-49)];
    [self.view addSubview:self.tableView];
    //self.tableView.frame = mainBounds;
    
    //UIEdgeInsets contentInsets = self.tableView.contentInset;
    //contentInsets.bottom = 49.0f;
    //self.tableView.contentInset = contentInsets;
    
    [self initTableRowWithScroll];
    
    self.navigationItem.title = @"TEST";
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
    UINib *nib = [UINib nibWithNibName:@"ComminutyCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CommunityCellIdentifier];
    
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
        //[self initItems];
        //[self initTestItems];
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
        case 0:
        {
            SecondTableViewCell *cell = (SecondTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CommunityCellIdentifier];
            if(cell == nil)
            {
                cell = [[SecondTableViewCell alloc] init];
            }
            
            cell.categoriesListArray = self.categoriesListArray;
            
            return cell;
        }
            
        case 1:
        {
            ThirdTableViewCell *cell = (ThirdTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ProductCellIdentifier];
            if(cell == nil)
            {
                cell = [[ThirdTableViewCell alloc] init];
            }
            
            [cell initItems];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
            
        case 2:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.text = @"Click to Refresh";
            return cell;
        }
            
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sectionNumber = indexPath.section;
    switch (sectionNumber)
    {
        case 0:
            return 214.0f;
            break;
        case 1:
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
                return batchIndex * TotalRowsPerBatch * HeightOfItemInThirdTableCell;
            }
            else // 0 < count < batchIndex * TotalItemsPerBatch
            {
                NSInteger totalRows = ([array count] - 1) / 2 + 1;
                NSLog(@"TotalRows: %ld", (long)totalRows);
                return totalRows * HeightOfItemInThirdTableCell;
            }
        }
        case 2:
            return 60.0f;
        default:
            return 60.0f;
    }
}

@end
