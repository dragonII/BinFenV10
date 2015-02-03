//
//  ThirdTableViewCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/4/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "ThirdTableViewCell.h"
#import "BFPreferenceData.h"

@implementation ThirdTableViewCell

- (void)awakeFromNib
{
    [self initItems];
}


- (void)initItems
{
#warning 目前只涵盖屏幕宽度为320，其他宽度的屏幕尺寸待完成
    
    NSArray *array = [BFPreferenceData loadTestDataArray];
    
    //int columnsPerPage = 4;
    CGFloat itemWidth = 142.0f;
    CGFloat itemHeight = 208.0f;
    
    //CGFloat x = 0;
    CGFloat y = 10;
    //CGFloat extraSpace = 0.0f;
    
    //CGFloat scrollViewWidth = self.scrollView.bounds.size.width;
    
    CGFloat imageViewWidth = 142.0f;
    CGFloat imageViewHeight = 142.0f;
    
    //int index = 0;
    int row = 0;
    int column = 0;
    
    for(NSString *itemString in array)
    {
        UIView *itemView = [[UIView alloc] init];
        itemView.frame = CGRectMake(column * (itemWidth + 12) + 12, y, itemWidth, itemHeight);
        
        UIImageView *imageView = [[UIImageView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        
        imageView.frame = CGRectMake(itemView.bounds.origin.x, itemView.bounds.origin.y, imageViewWidth, imageViewHeight);
        label.frame = CGRectMake(itemView.bounds.origin.x, itemView.bounds.origin.y + imageViewHeight, itemView.bounds.size.width, itemHeight - imageViewHeight);
        label.text = itemString;
        label.textAlignment = NSTextAlignmentCenter;
        
        //http://stackoverflow.com/questions/9907100/issues-with-setting-some-different-font-for-uilabel
        label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:10];
        
        imageView.image = [UIImage imageNamed:@"142x142"];
        
        
        [itemView addSubview:imageView];
        [itemView addSubview:label];
        [self.contentView addSubview:itemView];
        
        //index++;
        //row++;
        column++;
        if(column == 2)
        {
            //row = 0;
            column = 0;
            row++;
            //x += itemWidth;
            y += itemHeight;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
