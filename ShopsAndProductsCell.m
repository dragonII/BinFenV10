//
//  ThirdTableViewCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/4/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "ShopsAndProductsCell.h"
#import "BFPreferenceData.h"
#import "DataModel.h"
#import "AppDelegate.h"
#import "UIKit+AFNetworking.h"

#import "defs.h"

@implementation ShopsAndProductsCell

- (void)awakeFromNib
{
    //self.dataModel = [[DataModel alloc] init];
    //[self.dataModel loadDataModelLocally];
    
    //NSLog(@"XYZ %@", self.dataModel.shops);
    
    //[self initItems];
}

- (void)itemClicked:(UITapGestureRecognizer*)sender
{
    UIView *view = (UIView *)sender.view;
    //self.shopID = [NSString stringWithFormat:@"ShopID_%ld", (view.tag - 2000)];
    NSInteger shopIndex = view.tag - 2000;
    //self.shopID = [[self.dataModel.shops objectAtIndex:shopIndex] copy];
    self.shopID = [[[self.dataModel.shops objectAtIndex:shopIndex] objectForKey:@"ID"] copy];
    NSLog(@"xx%@", self.shopID);
    if([self.segueDelegate respondsToSelector:@selector(itemClickedInCell:)])
    {
        [self.segueDelegate performSelector:@selector(itemClickedInCell:) withObject:self];
    }
}

- (void)initShopItemsByCommunityIndex:(int)communityIndex
{
    if(communityIndex < 0)
    {
        //[self loadAllShops];
        [self loadAllShops];
    } else {
        [self loadShopsByCommunity:communityIndex];
    }
    
    [self showingShopsInView];
}

- (void)loadAllShops
{
    self.dataModel = [[DataModel alloc] init];
    [self.dataModel loadDataModelLocally];
    
    self.shops = [NSMutableArray arrayWithArray:self.dataModel.shops];
    
    //NSLog(@"self.shops (ALL): %@", self.shops);
}

- (void)loadShopsByCommunity:(int)comminityIndex
{
    self.dataModel = [[DataModel alloc] init];
    [self.dataModel loadDataModelLocally];
    
    NSString *communityID = [[self.dataModel.communities objectAtIndex:comminityIndex] objectForKey:@"ID"];
    self.shops = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [self.dataModel.shops count]; i++)
    {
        NSString *communityIDInShop = [[self.dataModel.shops objectAtIndex:i] objectForKey:@"community"];
        if([communityIDInShop isEqualToString:communityID])
        {
            [self.shops addObject:[self.dataModel.shops objectAtIndex:i]];
        }
    }
    
    //NSLog(@"self.shops (ID): %@", self.shops);
}

//- (void)initShopItems:(int)communityIndex
- (void)showingShopsInView
{
#warning 目前只涵盖屏幕宽度为320，其他宽度的屏幕尺寸待完成
    
    //self.dataModel = [[DataModel alloc] init];
    //[self.dataModel loadDataModelLocally];
    
    NSInteger batchIndex = [[NSUserDefaults standardUserDefaults] integerForKey:LoadContentBatchIndexKey];
    NSLog(@"batchIndex#: %ld", (long)batchIndex);
    
    CGFloat itemWidth = 142.0f;
    CGFloat itemHeight = 208.0f;
    
    CGFloat y = 10;
    //CGFloat extraSpace = 0.0f;
    
    CGFloat imageViewWidth = 142.0f;
    CGFloat imageViewHeight = 142.0f;
    
    int index = 2000;
    NSInteger maxIndex = 0;
    int row = 0;
    int column = 0;
    
    //if([self.dataModel.shops count] >= batchIndex * TotalItemsPerBatch)
    if([self.shops count] >= batchIndex * TotalItemsPerBatch)
        maxIndex = batchIndex * TotalItemsPerBatch;
    else
        //maxIndex = [self.dataModel.shops count];
        maxIndex = [self.shops count];
    
    for(int i = 0; i < maxIndex; i++)
    {
        UIView *itemView = [[UIView alloc] init];
        itemView.frame = CGRectMake(column * (itemWidth + 12) + 12, y, itemWidth, itemHeight);
        itemView.layer.borderColor = [UIColor blackColor].CGColor;
        itemView.layer.borderWidth = 0.5;
        itemView.tag = index;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClicked:)];
        //tapGesture.delegate = self;
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [itemView addGestureRecognizer:tapGesture];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        
        imageView.frame = CGRectMake(itemView.bounds.origin.x, itemView.bounds.origin.y, imageViewWidth, imageViewHeight);
        label.frame = CGRectMake(itemView.bounds.origin.x, itemView.bounds.origin.y + imageViewHeight, itemView.bounds.size.width, itemHeight - imageViewHeight);
        //label.text = [[self.dataModel.shops objectAtIndex:i] objectForKey:@"name"];
        label.text = [[self.shops objectAtIndex:i] objectForKey:@"name"];
        label.textAlignment = NSTextAlignmentCenter;
        
        //http://stackoverflow.com/questions/9907100/issues-with-setting-some-different-font-for-uilabel
        label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:10];
        
        //NSString *imageURLString = [[self.dataModel.shops objectAtIndex:i] objectForKey:@"image"];
        NSString *imageURLString = [[self.shops objectAtIndex:i] objectForKey:@"image"];
        [imageView setImageWithURL:[NSURL URLWithString:imageURLString] placeholderImage:[UIImage imageNamed:@"Default_142x142"]];
        
        
        [itemView addSubview:imageView];
        [itemView addSubview:label];
        [self.contentView addSubview:itemView];
        
        index++;
        column++;
        if(column == 2)
        {
            column = 0;
            row++;
            y += itemHeight + 10;
        }
    }
}

- (void)initProductItems
{
#warning 目前只涵盖屏幕宽度为320，其他宽度的屏幕尺寸待完成
    
    self.dataModel = [[DataModel alloc] init];
    [self.dataModel loadDataModelLocally];
    
    NSInteger batchIndex = [[NSUserDefaults standardUserDefaults] integerForKey:LoadContentBatchIndexKey];
    NSLog(@"batchIndex#: %ld", (long)batchIndex);
    
    CGFloat itemWidth = 142.0f;
    CGFloat itemHeight = 208.0f;
    
    CGFloat y = 10;
    //CGFloat extraSpace = 0.0f;
    
    CGFloat imageViewWidth = 142.0f;
    CGFloat imageViewHeight = 142.0f;
    
    int index = 2000;
    NSInteger maxIndex = 0;
    int row = 0;
    int column = 0;
    
    if([self.dataModel.shops count] >= batchIndex * TotalItemsPerBatch)
        maxIndex = batchIndex * TotalItemsPerBatch;
    else
        maxIndex = [self.dataModel.shops count];
    
    for(int i = 0; i < maxIndex; i++)
    {
        UIView *itemView = [[UIView alloc] init];
        itemView.frame = CGRectMake(column * (itemWidth + 12) + 12, y, itemWidth, itemHeight);
        itemView.layer.borderColor = [UIColor blackColor].CGColor;
        itemView.layer.borderWidth = 0.5;
        itemView.tag = index;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClicked:)];
        //tapGesture.delegate = self;
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [itemView addGestureRecognizer:tapGesture];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        
        imageView.frame = CGRectMake(itemView.bounds.origin.x, itemView.bounds.origin.y, imageViewWidth, imageViewHeight);
        label.frame = CGRectMake(itemView.bounds.origin.x, itemView.bounds.origin.y + imageViewHeight, itemView.bounds.size.width, itemHeight - imageViewHeight);
        label.text = [[self.dataModel.shops objectAtIndex:i] objectForKey:@"name"];
        label.textAlignment = NSTextAlignmentCenter;
        
        //http://stackoverflow.com/questions/9907100/issues-with-setting-some-different-font-for-uilabel
        label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:10];
        
        NSString *imageURLString = [[self.dataModel.shops objectAtIndex:i] objectForKey:@"image"];
        [imageView setImageWithURL:[NSURL URLWithString:imageURLString] placeholderImage:[UIImage imageNamed:@"Default_142x142"]];
        
        
        [itemView addSubview:imageView];
        [itemView addSubview:label];
        [self.contentView addSubview:itemView];
        
        index++;
        column++;
        if(column == 2)
        {
            column = 0;
            row++;
            y += itemHeight + 10;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
