//
//  ThirdTableViewCell.h
//  BinFenV10
//
//  Created by Wang Long on 2/4/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShopsTableViewCell;

@protocol ShopsCellSegueDelegate <NSObject>

- (void)itemClickedInCell:(ShopsTableViewCell *)cell;

@end

@interface ShopsTableViewCell : UITableViewCell

- (void)initItems;

@property (weak, nonatomic) id<ShopsCellSegueDelegate> segueDelegate;

@end
