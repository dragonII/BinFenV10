//
//  CommunityForSelectionCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/9/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "CommunityForSelectionCell.h"

@implementation CommunityForSelectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellType:(CommunityCellType)cellType
{
    if(_cellType != cellType)
    {
        _cellType = cellType;
        [_sourceLabel setHidden:_cellType == CommunityCellTypeHistory ];
    }
}

@end
