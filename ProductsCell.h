//
//  ProductsCell.h
//  BinFenV10
//
//  Created by Wang Long on 3/12/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductsCell;
@class DataModel;

@protocol ProductsCellSegueDelegate <NSObject>

- (void)productItemClickedInCell:(ProductsCell *)cell;

@end

@interface ProductsCell : UITableViewCell

//- (void)initProductItemsByShopIndex:(NSInteger)shopIndex;
- (void)showingProductsInView:(NSArray *)products;

@property (strong, nonatomic) DataModel *dataModel;

@property (copy, nonatomic) NSString *shopID;
@property (strong, nonatomic) NSMutableArray *shops;
@property (copy, nonatomic) NSString *productID;
@property (assign, nonatomic) NSInteger selectedShopIndex;

@property (strong, nonatomic) NSArray *products;

@property (weak, nonatomic) id<ProductsCellSegueDelegate> segueDelegate;

@end
