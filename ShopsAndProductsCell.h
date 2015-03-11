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

- (void)initShopItems;
- (void)initProductItems;

@property (strong, nonatomic) DataModel *dataModel;

@property (copy, nonatomic) NSString *shopID;

@property (weak, nonatomic) id<ShopsCellSegueDelegate> segueDelegate;

@end
