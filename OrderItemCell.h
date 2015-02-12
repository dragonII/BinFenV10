//
//  OrderItemCell.h
//  BinFenV10
//
//  Created by Wang Long on 2/12/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

typedef enum {
    OrderCellTypeNeedPay = 0,
    OrderCellTypePaid,
    OrderCellTypeHistory
} OrderCellType;

#import <UIKit/UIKit.h>

@interface OrderItemCell : UITableViewCell

@property OrderCellType orderCellType;

@end
