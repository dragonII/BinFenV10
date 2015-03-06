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

typedef enum
{
    ProductCartCellSection = 0,
    AddressCartCellSection,
    PaymentCartCellSection,
    CommentCartCellSection
} CartSectionIndexType;

@interface ShoppingCartViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *sortCartItemArray;

@end

@implementation ShoppingCartViewController

- (void)initTableView
{
    self.view.backgroundColor = [UIColor colorWithRed:225/255.0f
                                                green:225/255.0f
                                                 blue:225/255.0f
                                                alpha:1.0f];
    
    CGRect tableViewFrame;
    
    CGFloat bottomViewHeight = 49.0f;
    
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
                                            self.view.bounds.size.height - navigationBarHeight - statusBarHeight -bottomViewHeight);
            } else {
                tableViewFrame = CGRectMake(0, 0,
                                            self.view.bounds.size.width,
                                            self.view.bounds.size.height - bottomViewHeight - statusBarHeight - 49 + 8);
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
    self.tableView.backgroundColor = [UIColor colorWithRed:225/255.0f
                                                     green:225/255.0f
                                                      blue:225/255.0f
                                                     alpha:1.0f];
    
    // Remove the separator lines for emtpy cells
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footerView;
    
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

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    if(generalPlatform == DeviceHardwareGeneralPlatform_iPhone_6 || generalPlatform == DeviceHardwareGeneralPlatform_iPhone_6_Plus)
    {
        return;
    }
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    NSLog(@"kbheight: %f", kbSize.height);
    UIEdgeInsets contentInsets;
    if(self.showShoppingCartViewFrom == ShowViewFromHome)
    {
        contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
    } else {
        contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
    }
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    if(generalPlatform == DeviceHardwareGeneralPlatform_iPhone_6 || generalPlatform == DeviceHardwareGeneralPlatform_iPhone_6_Plus)
    {
        return;
    }
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

- (void)loadShoppingCartItems
{
    NSDictionary *dict1 = @{@"productName":@"a",
                           @"price":@"38.5",
                           @"quantity":@"1",
                           @"description":@"a description",
                           @"shop":@"id1"};
    NSDictionary *dict2 = @{@"productName":@"ab",
                           @"price":@"318",
                           @"quantity":@"2",
                           @"description":@"ab description",
                           @"shop":@"id1"};
    NSDictionary *dict3 = @{@"productName":@"abc",
                           @"price":@"28",
                           @"quantity":@"9",
                           @"description":@"abc description",
                           @"shop":@"id2"};
    NSDictionary *dict4 = @{@"productName":@"abcd",
                           @"price":@"17",
                           @"quantity":@"7",
                           @"description":@"abcd description",
                           @"shop":@"id2"};
    NSDictionary *dict5 = @{@"productName":@"abcde",
                           @"price":@"28",
                           @"quantity":@"6",
                           @"description":@"abcde description",
                           @"shop":@"id3"};
    NSDictionary *dict6 = @{@"productName":@"abcdef",
                            @"price":@"24",
                            @"quantity":@"11",
                            @"description":@"abcdef description",
                            @"shop":@"id2"};
    NSDictionary *dict7 = @{@"productName":@"abcdefg",
                            @"price":@"23",
                            @"quantity":@"12",
                            @"description":@"abcdefg description",
                            @"shop":@"id3"};
    NSDictionary *dict8 = @{@"productName":@"abcdefgh",
                            @"price":@"42",
                            @"quantity":@"5",
                            @"description":@"abcdefgh description",
                            @"shop":@"id1"};

    
    self.cartItemsArray = @[dict1, dict2, dict3, dict4, dict5, dict6, dict7, dict8];
    self.sortCartItemArray = [[NSMutableArray alloc] init];
    self.shopsArray = [[NSMutableArray alloc] init];
    
    if([self.cartItemsArray count] > 0)
    {
        [self.shopsArray addObject:[[self.cartItemsArray objectAtIndex:0] objectForKey:@"shop"]];
        
        BOOL found;
        NSString *shopID;
        
        for(int i = 0; i < [self.cartItemsArray count]; i++)
        {
            found = NO;
            shopID = [[self.cartItemsArray objectAtIndex:i] objectForKey:@"shop"];
            for(int j = 0; j < [self.shopsArray count]; j++)
            {
                if([shopID isEqualToString:[self.shopsArray objectAtIndex:j]])
                {
                    found = YES;
                    break;
                }
            }
            if(found == NO)
                [self.shopsArray addObject:shopID];
        }
    }
    
    for(int i = 0; i < [self.shopsArray count]; i++)
    {
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        NSString *shopID = [self.shopsArray objectAtIndex:i];
        for(int j = 0; j < [self.cartItemsArray count]; j++)
        {
            if([shopID isEqualToString:[[self.cartItemsArray objectAtIndex:j] objectForKey:@"shop"]])
            {
                [tmpArray addObject:[self.cartItemsArray objectAtIndex:j]];
            }
        }
        [self.sortCartItemArray addObject:tmpArray];
    }
    
    NSLog(@"cartItem: %@", self.cartItemsArray);
    NSLog(@"shops: %@", self.shopsArray);
    NSLog(@"Sorted: %@", self.sortCartItemArray);
}

- (void)initBottomView
{
    self.submitButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ButtonBGOrange"]];
    self.submitButton.layer.cornerRadius = 5.0f;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"购物车";
    
    [self loadShoppingCartItems];
    
    [self initBottomView];
    
    [self initTableView];
    
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate, DataSource for UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 1;
    if(section == 0)
        return 1;
    else
    {
        // 货品列表和备注信息
        return [[self.sortCartItemArray objectAtIndex:(section - 1)] count] + 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 按照店铺展示，顶部为收货联系信息
    return [self.shopsArray count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 44;
    else
    {
        int index = indexPath.section - 1;
        if(indexPath.row != [[self.sortCartItemArray objectAtIndex:index] count])
            return 125;
        else
        {
            // 备注行
            return 44;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 0;
    
    return 12.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return nil;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 12.0f)];
    headerView.backgroundColor = [UIColor colorWithRed:225/255.0f
                                                 green:225/255.0f
                                                  blue:225/255.0f
                                                 alpha:1.0f];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        TextInfoCartCell *cell = (TextInfoCartCell *)[tableView dequeueReusableCellWithIdentifier:TextInfoCartCellIdentifier];
        if(cell == nil)
            cell = [[TextInfoCartCell alloc] init];
        cell.textInfoTitleLabel.text = @"1234568 地址ABC";
        return cell;
    }
    
    int sectionIndex = (int)indexPath.section - 1;
    NSArray *itemInShopArray = [self.sortCartItemArray objectAtIndex:sectionIndex];
    if(indexPath.row < [itemInShopArray count])
    {
        ProductTableCartCell *cell = (ProductTableCartCell *)[tableView dequeueReusableCellWithIdentifier:ProductCartCellIdentifier];
        if(cell == nil)
            cell = [[ProductTableCartCell alloc] init];
        NSDictionary *infoDict = [[self.sortCartItemArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
        cell.productNameLabel.text = [infoDict objectForKey:@"productName"];
        cell.priceLabel.text = [infoDict objectForKey:@"price"];
        cell.quantityLabel.text = [infoDict objectForKey:@"quantity"];
        return cell;
    } else {
        CommentCartCell *cell = (CommentCartCell *)[tableView dequeueReusableCellWithIdentifier:CommentCartCellIdentifier];
        if(cell == nil)
            cell = [[CommentCartCell alloc] init];
        #warning  通过保存备注信息，在每次调用程序运行到此的时候，先重新加载备注信息，便可以保证备注信息是正确的
        cell.commentTextField.delegate = self;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"Text Return");
    [textField resignFirstResponder];
    return YES;
}

@end
