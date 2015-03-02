//
//  OrderDetailViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/9/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "DeviceHardware.h"
#import "ProductTableCartCell.h"
#import "TextInfoCartCell.h"
#import "CommentCartCell.h"

static NSString *ProductCartCellIdentifier = @"ProductCartCell";
static NSString *TextInfoCartCellIdentifier = @"TextCartCell";
static NSString *CommentCartCellIdentifier = @"CommentCartCell";

@interface ShoppingCartViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ShoppingCartViewController

- (void)initTableView
{
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    CGRect tableViewFrame;
    
    CGFloat bottomViewHeight = 44.0f;
    
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    NSLog(@"generalPlatform: %d", generalPlatform);
    
    switch (generalPlatform)
    {
        case DeviceHardwareGeneralPlatform_iPhone_4:
        case DeviceHardwareGeneralPlatform_iPhone_4S:
        {
            //NSLog(@"iphone 4, 4S");
            CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
            CGFloat statusBarHeight = 20;
            if(self.showShoppingCartViewFrom == ShowViewFromHome)
            {
                tableViewFrame = CGRectMake(0, navigationBarHeight + statusBarHeight,
                                            self.view.bounds.size.width,
                                            self.view.bounds.size.height - navigationBarHeight - statusBarHeight - bottomViewHeight);
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
            tableViewFrame = CGRectMake(0, 0,
                                        self.view.bounds.size.width,
                                        self.view.bounds.size.height - bottomViewHeight);
            break;
        }
            
        default:
            tableViewFrame = CGRectZero;
            break;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nib = [UINib nibWithNibName:@"ProductTableCartCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:ProductCartCellIdentifier];
    
    nib = [UINib nibWithNibName:@"TextInfoCartCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:TextInfoCartCellIdentifier];
    
    nib = [UINib nibWithNibName:@"CommentCartCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CommentCartCellIdentifier];
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"购物车";
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate, DataSource for UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return 112;
    else
        return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        ProductTableCartCell *cell = (ProductTableCartCell *)[tableView dequeueReusableCellWithIdentifier:ProductCartCellIdentifier];
        if(cell == nil)
            cell = [[ProductTableCartCell alloc] init];
        
        return cell;
    }
    
    if(indexPath.row == 1 || indexPath.row == 2)
    {
        TextInfoCartCell *cell = (TextInfoCartCell *)[tableView dequeueReusableCellWithIdentifier:TextInfoCartCellIdentifier];
        if(cell == nil)
            cell = [[TextInfoCartCell alloc] init];
        
        if(indexPath.row == 1)
            cell.textInfoTitleLabel.text = @"收货地址";
        if(indexPath.row == 2)
            cell.textInfoTitleLabel.text = @"支付方式";
        
        return cell;
    }
    
    if(indexPath.row == 3)
    {
        CommentCartCell *cell = (CommentCartCell *)[tableView dequeueReusableCellWithIdentifier:CommentCartCellIdentifier];
        if(cell == nil)
            cell = [[CommentCartCell alloc] init];
        
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}


@end
