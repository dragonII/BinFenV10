//
//  ThirdTableViewCell.h
//  BinFenV10
//
//  Created by Wang Long on 2/4/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShopsAndProductsCell;
@class DataModel;

@protocol ShopsCellSegueDelegate <NSObject>

- (void)itemClickedInCell:(ShopsAndProductsCell *)cell;

@end

@interface ShopsAndProductsCell : UITableViewCell

- (void)initShopItemsByCommunityIndex:(int)communityIndex;
//- (void)initProductItems;
- (void)initProductItemsByShopIndex:(int)shopIndex;

@property (strong, nonatomic) DataModel *dataModel;

@property (copy, nonatomic) NSString *shopID;
@property (strong, nonatomic) NSMutableArray *shops;
@property (copy, nonatomic) NSString *productID;
@property (assign, nonatomic) NSInteger selectedShopIndex;

@property (strong, nonatomic) NSMutableArray *products;

@property (weak, nonatomic) id<ShopsCellSegueDelegate> segueDelegate;

@end
