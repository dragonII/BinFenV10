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

static const NSInteger NeedPayImageTag = 41;
static const NSInteger PaidImageTag = 42;
static const NSInteger HistoryImageTag = 43;

@interface OrderListViewController () <UITableViewDataSource, UITableViewDelegate, ButtonClickDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *needPayImage;
@property (weak, nonatomic) IBOutlet UILabel *needPayLabel;

@property (weak, nonatomic) IBOutlet UIImageView *paidImage;
@property (weak, nonatomic) IBOutlet UILabel *paidLabel;

@property (weak, nonatomic) IBOutlet UIImageView *historyImage;
@property (weak, nonatomic) IBOutlet UILabel *historyLabel;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *orderListArray;

@property OrderCellType selectedOrderType;

@end


@implementation OrderListViewController

- (void)initOrderListArray
{
    self.orderListArray = [[NSMutableArray alloc] init];
    [self.orderListArray addObject:@"Order1"];
    [self.orderListArray addObject:@"订单2"];
    [self.orderListArray addObject:@"订单3"];
    
    self.selectedOrderType = OrderCellTypeNeedPay;
}

- (void)initTableView
{
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    // table上方的订单类型选择区域高度为95: 12 + 12 ＋ 44 ＋ 8 ＋ 21 ＋ 10
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 95,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height - navigationBarHeight - 12 - 95 - 20)];
    
    
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

- (void)setLabelHightlightedColor:(UILabel *)label
{
    self.needPayLabel.textColor = [UIColor blackColor];
    self.paidLabel.textColor = [UIColor blackColor];
    self.historyLabel.textColor = [UIColor blackColor];
    
    label.textColor = [UIColor colorWithRed:253/255.0f green:155/255.0f blue:90/255.0f alpha:1.0f];
}

- (void)imageTapped:(UIGestureRecognizer *)gestureRecognizer
{
    UIImageView *imageView = (UIImageView *)gestureRecognizer.view;
    switch (imageView.tag)
    {
        case NeedPayImageTag:
            NSLog(@"Need Pay");
            [self setLabelHightlightedColor:self.needPayLabel];
            break;
        
        case PaidImageTag:
            NSLog(@"Paid");
            [self setLabelHightlightedColor:self.paidLabel];
            break;
            
        case HistoryImageTag:
            NSLog(@"History");
            [self setLabelHightlightedColor:self.historyLabel];
            break;
            
        default:
            break;
    }
}

- (void)initImageViewActions
{
    [self addActionInView:self.needPayImage Tag:NeedPayImageTag];
    [self addActionInView:self.paidImage Tag:PaidImageTag];
    [self addActionInView:self.historyImage Tag:HistoryImageTag];
}

- (void)addActionInView:(UIImageView *)imageView Tag:(NSInteger)tag
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    
    imageView.tag = tag;
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:tapGesture];
    
    // Performance
    imageView.layer.cornerRadius = 22.0f;
    imageView.layer.masksToBounds = NO;
    imageView.layer.shouldRasterize = YES;
    imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    /////
    imageView.layer.borderWidth = 1.0f;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.clipsToBounds = YES;
    imageView.alpha = 0.8f;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initOrderListArray];
    
    [self initImageViewActions];
    
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
    
    cell.buttonClickDelegate = self;
    
    return cell;
}

#pragma ButtonClickDelegate

- (void)leftButtonClicked:(OrderItemCell *)cell
{
    NSLog(@"Left Clicked");
}

- (void)rightButtonClicked:(OrderItemCell *)cell
{
    NSLog(@"Right Clicked");
}

@end
