//
//  OrderListViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/12/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderItemCell.h"

static NSString *OrderItemCellIdentifier = @"OrderItemCell";

@interface OrderListViewController () <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *needPayImage;
@property (weak, nonatomic) IBOutlet UILabel *needPayLabel;

@property (weak, nonatomic) IBOutlet UIImageView *paidImage;
@property (weak, nonatomic) IBOutlet UILabel *paidLabel;

@property (weak, nonatomic) IBOutlet UIImageView *historyImage;
@property (weak, nonatomic) IBOutlet UILabel *historyLabel;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *orderListArray;

@end


@implementation OrderListViewController

- (void)initOrderListArray
{
    self.orderListArray = [[NSMutableArray alloc] init];
    [self.orderListArray addObject:@"Order1"];
    [self.orderListArray addObject:@"订单2"];
    [self.orderListArray addObject:@"订单3"];
}

- (void)initTableView
{
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    // table上方的订单类型选择区域高度为95: 12 ＋ 44 ＋ 8 ＋ 21 ＋ 10
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 95,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height - navigationBarHeight - 95 - 20)];
    
    
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Remove the separator lines for emtpy cells
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footerView;
    
    UINib *nib = [UINib nibWithNibName:@"OrderItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:OrderItemCellIdentifier];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initOrderListArray];
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView DataSource, Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.orderListArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderItemCell *cell = (OrderItemCell *)[tableView dequeueReusableCellWithIdentifier:OrderItemCellIdentifier];
    if(cell == nil)
        cell = [[OrderItemCell alloc] init];
    
    return cell;
}


@end
