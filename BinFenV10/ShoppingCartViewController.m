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
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"购物车";
    
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
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == ProductCartCellSection)
        return 100;
    else
        return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 12.0f)];
    headerView.backgroundColor = [UIColor lightGrayColor];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == ProductCartCellSection)
    {
        ProductTableCartCell *cell = (ProductTableCartCell *)[tableView dequeueReusableCellWithIdentifier:ProductCartCellIdentifier];
        if(cell == nil)
            cell = [[ProductTableCartCell alloc] init];
        
        return cell;
    }
    
    if(indexPath.section == AddressCartCellSection || indexPath.section == PaymentCartCellSection)
    {
        TextInfoCartCell *cell = (TextInfoCartCell *)[tableView dequeueReusableCellWithIdentifier:TextInfoCartCellIdentifier];
        if(cell == nil)
            cell = [[TextInfoCartCell alloc] init];
        
        if(indexPath.section == AddressCartCellSection)
            cell.textInfoTitleLabel.text = @"收货地址";
        if(indexPath.section == PaymentCartCellSection)
            cell.textInfoTitleLabel.text = @"支付方式";
        
        return cell;
    }
    
    if(indexPath.section == CommentCartCellSection)
    {
        CommentCartCell *cell = (CommentCartCell *)[tableView dequeueReusableCellWithIdentifier:CommentCartCellIdentifier];
        if(cell == nil)
            cell = [[CommentCartCell alloc] init];
        
        cell.commentTextField.delegate = self;
        
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
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
