//
//  ShopViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/12/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "ShopViewController.h"
#import "CategoriesInShopCell.h"
#import "ShopsCell.h"
#import "ProductsCell.h"
#import "ProductDetailViewController.h"

#import "DeviceHardware.h"

#import "BFPreferenceData.h"
#import "defs.h"

#import "DataModel.h"

static NSString *CategoryCellIdentifier = @"CategoryCell";
//static NSString *ShopsCellIdentifier = @"ShopsCell";
static NSString *ProductsCellIdentifer = @"ProductsCell";

@interface ShopViewController () <UITableViewDataSource, UITableViewDelegate, ProductsCellSegueDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) DataModel *dataModel;

@property (strong, nonatomic) NSMutableArray *products;

@end

@implementation ShopViewController

- (void)initTableView
{
    CGRect tableViewFrame;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    
    switch (generalPlatform)
    {
        case DeviceHardwareGeneralPlatform_iPhone_4:
        case DeviceHardwareGeneralPlatform_iPhone_4S:
        {
            NSLog(@"iphone 4, 4S");
            CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
            CGFloat statusBarHeight = 20;
            if(self.showShopViewFrom == ShowViewFromHome)
            {
            
                tableViewFrame = CGRectMake(0, navigationBarHeight + statusBarHeight,
                                            self.view.bounds.size.width,
                                            self.view.bounds.size.height - navigationBarHeight - statusBarHeight);
            } else {
                tableViewFrame = self.view.frame;
            }
            
            break;
        }
        case DeviceHardwareGeneralPlatform_iPhone_5:
        case DeviceHardwareGeneralPlatform_iPhone_5C:
        case DeviceHardwareGeneralPlatform_iPhone_5S:
        case DeviceHardwareGeneralPlatform_iPhone_6:
        case DeviceHardwareGeneralPlatform_iPhone_6_Plus:
        {
            NSLog(@"iphone 5, 6");
            /*
            tableViewFrame = CGRectMake(0, 0,
                                        self.view.bounds.size.width,
                                        self.view.bounds.size.height);
             */
            CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
            CGFloat statusBarHeight = 20;
            tableViewFrame = CGRectMake(0, navigationBarHeight + statusBarHeight,
                                        self.view.bounds.size.width,
                                        self.view.bounds.size.height - navigationBarHeight - statusBarHeight);
            break;
        }
            
        default:
            tableViewFrame = CGRectZero;
            break;
    }
    
    //self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nib = [UINib nibWithNibName:@"CategoriesInShopCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CategoryCellIdentifier];
    
    //[self.tableView registerClass:[ShopsAndProductsCell class] forCellReuseIdentifier:ShopsCellIdentifier];
    //[self.tableView registerClass:[ProductsCell class] forCellReuseIdentifier:ProductsCellIdentifer];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataModel = [[DataModel alloc] init];
    [self.dataModel loadDataModelLocally];
    
    //self.navigationItem.title = @"商家店名";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initTableView];
}

- (void)loadProductsByShopIndex:(NSInteger)shopIndex
{
    NSString *shopID = [[self.dataModel.shops objectAtIndex:shopIndex] objectForKey:@"ID"];
    self.products = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [self.dataModel.products count]; i++)
    {
        NSString *shopIDInProducts = [[self.dataModel.products objectAtIndex:i] objectForKey:@"shop"];
        if([shopIDInProducts isEqualToString:shopID])
        {
            [self.products addObject:[self.dataModel.products objectAtIndex:i]];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *shopName = [[self.dataModel.shops objectAtIndex:self.selectedShopIndex] objectForKey:@"name"];
    self.navigationItem.title = shopName;
    
    [self loadProductsByShopIndex:self.selectedShopIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return 110;
    else
    {
        NSInteger batchIndex = [[NSUserDefaults standardUserDefaults] integerForKey:LoadContentBatchIndexKey];
        //NSArray *array = [BFPreferenceData loadTestDataArray];
        //if(array == nil || [array count] == 0)
        if([self.products count] == 0)
        {
            return 0;
        }
        //if([array count] >= batchIndex * TotalItemsPerBatch)
        if([self.products count] >= batchIndex * TotalItemsPerBatch)
        {
            //NSLog(@"TotalRows: %ld", batchIndex * TotalRowsPerBatch);
            return batchIndex * TotalRowsPerBatch * HeightOfItemInShopsTableCell;
        }
        else // 0 < count < batchIndex * TotalItemsPerBatch
        {
            //NSInteger totalRows = ([array count] - 1) / 2 + 1;
            NSInteger totalRows = ([self.products count] - 1) / 2 + 1;
            NSLog(@"TotalRows: %ld", (long)totalRows);
            return totalRows * HeightOfItemInShopsTableCell;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        CategoriesInShopCell *cell = (CategoriesInShopCell *)[tableView dequeueReusableCellWithIdentifier:CategoryCellIdentifier];
        if(cell == nil)
        {
            cell = [[CategoriesInShopCell alloc] init];
        }
        return cell;
    }
    else {
        //ShopsAndProductsCell *cell = (ShopsAndProductsCell *)[tableView dequeueReusableCellWithIdentifier:ShopsCellIdentifier];
        ProductsCell *cell = (ProductsCell *)[tableView dequeueReusableCellWithIdentifier:ProductsCellIdentifer];
        if(cell == nil)
        {
            //cell = [[ShopsAndProductsCell alloc] init];
            cell = [[ProductsCell alloc] init];
        }
        cell.segueDelegate = self;
        //[cell initProductItems];
        [cell initProductItemsByShopIndex:self.selectedShopIndex];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Shop selected");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)itemClickedInCell:(ShopsCell *)cell
{
    NSLog(@"In ShopView");
    [self performSegueWithIdentifier:@"ShowProductSegueFromShop" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowProductSegueFromShop"])
    {
        ProductDetailViewController *productVC = (ProductDetailViewController *)segue.destinationViewController;
        productVC.showProductViewFrom = self.showShopViewFrom;
    }
        
}


@end
