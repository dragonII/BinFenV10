//
//  ProductDetailViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/7/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProductImageCell.h"
#import "PriceTableCell.h"
#import "DescriptionTableCell.h"
#import "SeperatorTableCell.h"

static NSString *ProductImageCellIdentifier = @"ProductImageCell";
static NSString *ProductPriceCellIdentifier = @"ProductPriceCell";
static NSString *ProductDescriptionIdentifier = @"ProductDescription";
static NSString *SeperatorIdentifier = @"Seperator";

@interface ProductDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ProductDetailViewController

- (void)initBottomView
{
    CGRect mainFrame = self.view.bounds;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, mainFrame.size.height - 44, mainFrame.size.width, 44)];
    bottomView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:bottomView];
}

- (void)initTableView
{
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGRect mainFrame = self.view.bounds;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(mainFrame.origin.x,
                                                                  mainFrame.origin.y + navigationBarHeight,
                                                                  mainFrame.size.width,
                                                                   mainFrame.size.height - navigationBarHeight - 44)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"ProductImageCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:ProductImageCellIdentifier];
    
    nib = [UINib nibWithNibName:@"PriceTableCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:ProductPriceCellIdentifier];
    
    nib = [UINib nibWithNibName:@"DescriptionTableCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:ProductDescriptionIdentifier];
    
    nib = [UINib nibWithNibName:@"SeperatorTableCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:SeperatorIdentifier];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.top = 20;
    [self.tableView setContentInset:insets];
     
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"产品";
    //self.productImageView.image = [UIImage imageNamed:@"Image-320x200"];
    
    [self initTableView];
    [self initBottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableView Delegate, DataSource

//Image, Price, Description, Seperator, Comments (0 or N)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //具体评论信息数目根据来自服务器的信息为准，从0到N
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0: //ProductImageCell
        {
            ProductImageCell *cell = (ProductImageCell *)[tableView dequeueReusableCellWithIdentifier:ProductImageCellIdentifier];
            if(cell == nil)
            {
                cell = [[ProductImageCell alloc] init];
            }
            return cell;
        }
        case 1:
        {
            PriceTableCell *cell = (PriceTableCell *)[tableView dequeueReusableCellWithIdentifier:ProductPriceCellIdentifier];
            if(cell == nil)
            {
                cell = [[PriceTableCell alloc] init];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        case 2:
        {
            DescriptionTableCell *cell = (DescriptionTableCell *)[tableView dequeueReusableCellWithIdentifier:ProductDescriptionIdentifier];
            if(cell == nil)
            {
                cell = [[DescriptionTableCell alloc] init];
            }
            return cell;
        }
        case 3:
        {
            SeperatorTableCell *cell = (SeperatorTableCell *)[tableView dequeueReusableCellWithIdentifier:SeperatorIdentifier];
            if(cell == nil)
                cell = [[SeperatorTableCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            
        default:
            return  [[UITableViewCell alloc] init];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            return 200.0f;
            
        case 1:
            return 28.0f;
            
        case 2:
            return 92.0f;
            
        case 3:
            return 12.0f;
            
        default:
            return 44.0f;
    }
}

@end
