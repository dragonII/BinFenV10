//
//  OrderItemCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/12/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "OrderItemCell.h"

@implementation OrderItemCell

- (void)awakeFromNib
{
    UIView *lineTop = [[UIView alloc] initWithFrame:CGRectMake(16, 42, self.contentView.bounds.size.width - 16, 1)];
    lineTop.backgroundColor = [UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1.0f];
    UIView *lineBottom = [[UIView alloc] initWithFrame:CGRectMake(16, 112, self.contentView.bounds.size.width - 16, 1)];
    lineBottom.backgroundColor = [UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1.0f];
    
    [self.contentView addSubview:lineTop];
    [self.contentView addSubview:lineBottom];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
