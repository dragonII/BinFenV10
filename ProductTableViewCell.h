//
//  ThirdTableViewCell.h
//  BinFenV10
//
//  Created by Wang Long on 2/4/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductTableViewCell;

@protocol ProductCellSegueDelegate <NSObject>

- (void)itemClickedInCell:(ProductTableViewCell *)cell;

@end

@interface ProductTableViewCell : UITableViewCell

- (void)initItems;

@property (weak, nonatomic) id<ProductCellSegueDelegate> segueDelegate;

@end
