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

#import "DeviceHardware.h"

#import "defs.h"

typedef struct
{
    CGSize itemSize;
    CGSize imageSize;
} ItemSizeStruct;

@implementation ShopsAndProductsCell

- (void)awakeFromNib
{
    //self.dataModel = [[DataModel alloc] init];
    //[self.dataModel loadDataModelLocally];
    
    //NSLog(@"XYZ %@", self.dataModel.shops);
    
    //[self initItems];
}

- (void)shopItemClicked:(UITapGestureRecognizer*)sender
{
    UIView *view = (UIView *)sender.view;
    //self.shopID = [NSString stringWithFormat:@"ShopID_%ld", (view.tag - 2000)];
    NSInteger shopIndex = view.tag - 2000;
    self.selectedShopIndex = shopIndex;
    //self.shopID = [[self.dataModel.shops objectAtIndex:shopIndex] copy];
    //self.shopID = [[[self.dataModel.shops objectAtIndex:shopIndex] objectForKey:@"ID"] copy];
    NSLog(@"xx%@", self.shopID);
    if([self.segueDelegate respondsToSelector:@selector(itemClickedInCell:)])
    {
        [self.segueDelegate performSelector:@selector(itemClickedInCell:) withObject:self];
    }
}

- (void)productItemClicked:(UITapGestureRecognizer*)sender
{
    UIView *view = (UIView *)sender.view;
    //self.shopID = [NSString stringWithFormat:@"ShopID_%ld", (view.tag - 2000)];
    NSInteger productIndex = view.tag - 3000;
    //self.selectedProductIndex = productIndex;
    //self.shopID = [[self.dataModel.shops objectAtIndex:shopIndex] copy];
    //self.productID = [[[self.dataModel.shops objectAtIndex:shopIndex] objectForKey:@"ID"] copy];
    self.productID = [[[self.products objectAtIndex:productIndex] objectForKey:@"ID"] copy];
    NSLog(@"xx%@", self.productID);
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


- (ItemSizeStruct)getItemSizeByDevice
{
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    
    CGFloat itemWidth;
    CGFloat itemHeight;
    CGFloat imageWidth;
    CGFloat imageHeight;
    
    ItemSizeStruct itemStruct;
    
    switch (generalPlatform)
    {
        case DeviceHardwareGeneralPlatform_iPhone_4:
        case DeviceHardwareGeneralPlatform_iPhone_4S:
        case DeviceHardwareGeneralPlatform_iPhone_5:
        case DeviceHardwareGeneralPlatform_iPhone_5C:
        case DeviceHardwareGeneralPlatform_iPhone_5S:
        {
            NSLog(@"iphone 4, 4S");
            //return 106.0f;
            itemWidth = 142.0f;
            itemHeight = 208.0f;
            imageWidth = 142.0f;
            imageHeight = 142.0f;
            
            itemStruct.itemSize = CGSizeMake(itemWidth, itemHeight);
            itemStruct.imageSize = CGSizeMake(imageWidth, imageHeight);
            
            return itemStruct;
            break;
        }
            
        case DeviceHardwareGeneralPlatform_iPhone_6:
        case DeviceHardwareGeneralPlatform_iPhone_6_Plus:
        {
            NSLog(@"iphone 6, 6Plus");
            itemWidth = 170.0f;
            itemHeight = 246.0f;
            imageWidth = 170.0f;
            imageHeight = 170.0f;
            
            itemStruct.itemSize = CGSizeMake(itemWidth, itemHeight);
            itemStruct.imageSize = CGSizeMake(imageWidth, imageHeight);
            
            return itemStruct;
            break;
        }
            
        default:
            itemWidth = 170.0f;
            itemHeight = 246.0f;
            imageWidth = 170.0f;
            imageHeight = 170.0f;
            
            itemStruct.itemSize = CGSizeMake(itemWidth, itemHeight);
            itemStruct.imageSize = CGSizeMake(imageWidth, imageHeight);
            
            return itemStruct;
            break;
    }
}

//- (void)initShopItems:(int)communityIndex
- (void)showingShopsInView
{
    //self.dataModel = [[DataModel alloc] init];
    //[self.dataModel loadDataModelLocally];
    
    ItemSizeStruct itemSizeStruct = [self getItemSizeByDevice];
    
    NSInteger batchIndex = [[NSUserDefaults standardUserDefaults] integerForKey:LoadContentBatchIndexKey];
    NSLog(@"batchIndex#: %ld", (long)batchIndex);
    
    //CGFloat itemWidth = 142.0f;
    //CGFloat itemHeight = 208.0f;
    CGFloat itemWidth = itemSizeStruct.itemSize.width;
    CGFloat itemHeight = itemSizeStruct.itemSize.height;
    
    CGFloat y = 10;
    //CGFloat extraSpace = 0.0f;
    
    //CGFloat imageViewWidth = 142.0f;
    //CGFloat imageViewHeight = 142.0f;
    CGFloat imageViewWidth = itemSizeStruct.imageSize.width;
    CGFloat imageViewHeight = itemSizeStruct.imageSize.height;
    
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
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shopItemClicked:)];
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

- (void)initProductItemsByShopIndex:(int)shopIndex
{
    if(shopIndex < 0)
    {
        [self loadAllProducts];
    } else {
        [self loadProductsByShopIndex:shopIndex];
    }
    
    NSLog(@"products: %@", self.products);
    
    [self showingProductsInView];
}

- (void)loadAllProducts
{
    self.dataModel = [[DataModel alloc] init];
    [self.dataModel loadDataModelLocally];
    
    self.products = [NSMutableArray arrayWithArray:self.dataModel.products];
}

- (void)loadProductsByShopIndex:(int)shopIndex
{
    self.dataModel = [[DataModel alloc] init];
    [self.dataModel loadDataModelLocally];
    
    NSLog(@"dataModel.products: %@", self.dataModel.products);
    
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

- (void)showingProductsInView
{
    //self.dataModel = [[DataModel alloc] init];
    //[self.dataModel loadDataModelLocally];
    
    ItemSizeStruct itemSizeStruct = [self getItemSizeByDevice];
    
    NSInteger batchIndex = [[NSUserDefaults standardUserDefaults] integerForKey:LoadContentBatchIndexKey];
    NSLog(@"batchIndex#: %ld", (long)batchIndex);
    
    //CGFloat itemWidth = 142.0f;
    //CGFloat itemHeight = 208.0f;
    CGFloat itemWidth = itemSizeStruct.itemSize.width;
    CGFloat itemHeight = itemSizeStruct.itemSize.height;
    
    CGFloat y = 10;
    //CGFloat extraSpace = 0.0f;
    
    //CGFloat imageViewWidth = 142.0f;
    //CGFloat imageViewHeight = 142.0f;
    CGFloat imageViewWidth = itemSizeStruct.imageSize.width;
    CGFloat imageViewHeight = itemSizeStruct.imageSize.height;
    
    int index = 3000;
    NSInteger maxIndex = 0;
    int row = 0;
    int column = 0;
    
    //if([self.dataModel.shops count] >= batchIndex * TotalItemsPerBatch)
    if([self.products count] >= batchIndex * TotalItemsPerBatch)
        maxIndex = batchIndex * TotalItemsPerBatch;
    else
        //maxIndex = [self.dataModel.shops count];
        maxIndex = [self.products count];
    
    for(int i = 0; i < maxIndex; i++)
    {
        UIView *itemView = [[UIView alloc] init];
        itemView.frame = CGRectMake(column * (itemWidth + 12) + 12, y, itemWidth, itemHeight);
        itemView.layer.borderColor = [UIColor blackColor].CGColor;
        itemView.layer.borderWidth = 0.5;
        itemView.tag = index;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(productItemClicked:)];
        //tapGesture.delegate = self;
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [itemView addGestureRecognizer:tapGesture];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        
        imageView.frame = CGRectMake(itemView.bounds.origin.x, itemView.bounds.origin.y, imageViewWidth, imageViewHeight);
        label.frame = CGRectMake(itemView.bounds.origin.x, itemView.bounds.origin.y + imageViewHeight, itemView.bounds.size.width, itemHeight - imageViewHeight);
        //label.text = [[self.dataModel.shops objectAtIndex:i] objectForKey:@"name"];
        label.text = [[self.products objectAtIndex:i] objectForKey:@"name"];
        label.textAlignment = NSTextAlignmentCenter;
        
        //http://stackoverflow.com/questions/9907100/issues-with-setting-some-different-font-for-uilabel
        label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:10];
        
        //NSString *imageURLString = [[self.dataModel.shops objectAtIndex:i] objectForKey:@"image"];
        NSString *imageURLString = [[self.products objectAtIndex:i] objectForKey:@"image"];
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
