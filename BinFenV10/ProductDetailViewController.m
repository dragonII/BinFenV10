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
#import "CommentTableViewCell.h"

static NSString *ProductImageCellIdentifier = @"ProductImageCell";
static NSString *ProductPriceCellIdentifier = @"ProductPriceCell";
static NSString *ProductDescriptionIdentifier = @"ProductDescription";
static NSString *SeperatorIdentifier = @"Seperator";
static NSString *CommentCellIdentifier = @"CommentCell";

static const NSInteger SectionBasicInfo = 0;
static const NSInteger SectionComments = 1;

static const NSInteger ProductImageCellIndex = 0;
static const NSInteger ProductPriceCellIndex = 1;
static const NSInteger ProductDescriptionCellIndex = 2;
static const NSInteger SeperatorCellIndex = 3;

@interface ProductDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *addToCartButton;
@property (strong, nonatomic) UILabel *quantityInCartLabel;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UIButton *orderButton;

@property (strong, nonatomic) NSArray *commentArray;

@end

@implementation ProductDetailViewController

- (IBAction)addToCartClicked:(UIButton *)sender
{
    UIButton *button = sender;
    [button setSelected:YES];
    [self performSelector:@selector(addingToCart:) withObject:button afterDelay:0.2f];
}

- (void)addingToCart:(UIButton *)button
{
    int quantity = [self.quantityInCartLabel.text intValue];
    quantity++;
    [self.quantityInCartLabel setText:[NSString stringWithFormat:@"%d", quantity]];
    [button setSelected:NO];
}

- (IBAction)orderClicked:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"ShowOrderDetailSegue" sender:self];
}

- (void)initBottomView
{
    CGRect mainFrame = self.view.bounds;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, mainFrame.size.height - 44, mainFrame.size.width, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    self.addToCartButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 7, 34, 30)];
    [self.addToCartButton setBackgroundImage:[UIImage imageNamed:@"AddToCart"] forState:UIControlStateNormal];
    [self.addToCartButton setBackgroundImage:[UIImage imageNamed:@"AddToCartSelected"] forState:UIControlStateSelected];
    [self.addToCartButton addTarget:self action:@selector(addToCartClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.addToCartButton];
    
    self.quantityInCartLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 16, 35, 12)];
    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
    self.quantityInCartLabel.font = font;
    self.quantityInCartLabel.textColor = [UIColor redColor];
    self.quantityInCartLabel.text = @"0";
    [bottomView addSubview:self.quantityInCartLabel];
    
    self.shareButton = [[UIButton alloc] initWithFrame:CGRectMake(98, 12, 20, 20)];
    [self.shareButton setBackgroundImage:[UIImage imageNamed:@"Share"] forState:UIControlStateNormal];
    [bottomView addSubview:self.shareButton];
    
    CGFloat orderButtonWidth = 80.0f;
    CGFloat orderButtonHeight = 30.0f;
    CGRect orderButtonFrame = CGRectMake(bottomView.bounds.size.width - orderButtonWidth - 16,
                                         7,
                                         orderButtonWidth, orderButtonHeight);
    self.orderButton = [[UIButton alloc] initWithFrame:orderButtonFrame];
    [self.orderButton setTitle:@"去下单" forState:UIControlStateNormal];
    self.orderButton.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"OrderButtonBG"]];
    [self.orderButton addTarget:self action:@selector(orderClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.orderButton];
    
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
    
    [self.tableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:CommentCellIdentifier];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.top = 20;
    [self.tableView setContentInset:insets];
     
    [self.view addSubview:self.tableView];
}


- (void)initProductData
{
    self.commentArray = @[
                          @{@"user":@"1234", @"comment":@"jdifjidbhj"},
                          @{@"user":@"ffff", @"comment":@"HelloWorld"},
                          @{@"user":@"gggg", @"comment":@"Hello World!"},
                          @{@"user":@"234", @"comment":@"中文评论字符"},
                          @{@"user":@"TestUser", @"comment":@"Is there a good way to adjust the size of a UITextView to conform to its content? Say for instance I have a UITextView that contains one line of text:\nIs there a good way in Cocoa Touch to get the rect that will hold all of the lines in the text view so that I can adjust the parent view accordingly?\nAs another example, look at the Notes field for events in the Calendar application--note how the cell (and the UITextView it contains) expands to hold all lines of text in the notes string."}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"商品详情";
    //self.productImageView.image = [UIImage imageNamed:@"Image-320x200"];
    
    [self initTableView];
    [self initBottomView];
    
    [self initProductData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableView Delegate, DataSource

// 含有2个Section，商品基本信息和用户评论信息，当无评论时，section隐藏
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//Image, Price, Description, Seperator, Comments (0 or N)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == SectionBasicInfo)
    {
        return 4;
    }
    //具体评论信息数目根据来自服务器的信息为准，从0到N
    if(section == SectionComments)
    {
        //NSLog(@"Comment count: %d", [self.commentArray count]);
        return [self.commentArray count];
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == SectionBasicInfo)
    {
        switch (indexPath.row)
        {
            case ProductImageCellIndex: //ProductImageCell
            {
                ProductImageCell *cell = (ProductImageCell *)[tableView dequeueReusableCellWithIdentifier:ProductImageCellIdentifier];
                if(cell == nil)
                {
                    cell = [[ProductImageCell alloc] init];
                }
                return cell;
            }
            case ProductPriceCellIndex:
            {
                PriceTableCell *cell = (PriceTableCell *)[tableView dequeueReusableCellWithIdentifier:ProductPriceCellIdentifier];
                if(cell == nil)
                {
                    cell = [[PriceTableCell alloc] init];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            case ProductDescriptionCellIndex:
            {
                DescriptionTableCell *cell = (DescriptionTableCell *)[tableView dequeueReusableCellWithIdentifier:ProductDescriptionIdentifier];
                if(cell == nil)
                {
                    cell = [[DescriptionTableCell alloc] init];
                }
                return cell;
            }
            case SeperatorCellIndex:
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
    } else // section == SectionComment
    {
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier];
        NSString *commentText = [[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"comment"];
        NSString *commentUser = [[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"user"];
        
        [cell setCommentText:commentText];
        [cell setCommentUser:commentUser];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == SectionBasicInfo)
    {
        switch (indexPath.row)
        {
            case ProductImageCellIndex:
                return 200.0f;
            
            case ProductPriceCellIndex:
                return 28.0f;
            
            case ProductDescriptionCellIndex:
                return 92.0f;
            
            case SeperatorCellIndex:
                return 12.0f;
            
            default:
                return 0.0f;
        }
    } else
    {
        NSString *commentText = [[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"comment"];
        CGSize textSize = [CommentTableViewCell sizeOfTextViewForText:commentText];

        //NSLog(@"Height: %f, width: %f", textSize.height + 40, textSize.width);
        return textSize.height + 40;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == SectionComments)
    {
        UIView *headerBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 28)];
        headerBackgroundView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(headerBackgroundView.frame.origin.x + 16,
                                                              headerBackgroundView.frame.origin.y,
                                                              headerBackgroundView.frame.size.width - 16,
                                                               headerBackgroundView.frame.size.height)];
        label.text = @"评论";
        [headerBackgroundView addSubview:label];
        return headerBackgroundView;
    } else
    {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == SectionComments)
        return 28.0f;
    else
        return 0.0f;
}

@end