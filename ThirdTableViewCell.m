//
//  ThirdTableViewCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/4/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "ThirdTableViewCell.h"
#import "BFPreferenceData.h"

#import "defs.h"

@implementation ThirdTableViewCell

- (void)awakeFromNib
{
    [self initItems];
}

- (void)itemClicked:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    NSLog(@"%d", view.tag);
}

- (void)initItems
{
#warning 目前只涵盖屏幕宽度为320，其他宽度的屏幕尺寸待完成
    
    NSArray *array = [BFPreferenceData loadTestDataArray];
    int batchIndex = [[NSUserDefaults standardUserDefaults] integerForKey:LoadContentBatchIndexKey];
    NSLog(@"batchIndex#: %d", batchIndex);
    
    CGFloat itemWidth = 142.0f;
    CGFloat itemHeight = 208.0f;
    
    CGFloat y = 10;
    //CGFloat extraSpace = 0.0f;
    
    CGFloat imageViewWidth = 142.0f;
    CGFloat imageViewHeight = 142.0f;
    
    int index = 2000;
    int maxIndex = 0;
    int row = 0;
    int column = 0;
    
    if([array count] >= batchIndex * TotalItemsPerBatch)
        maxIndex = batchIndex * TotalItemsPerBatch;
    else
        maxIndex = [array count];
    
    for(int i = 0; i < maxIndex; i++)
    {
        UIView *itemView = [[UIView alloc] init];
        itemView.frame = CGRectMake(column * (itemWidth + 12) + 12, y, itemWidth, itemHeight);
        itemView.backgroundColor = [UIColor yellowColor];
        itemView.tag = index;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClicked:)];
        //tapGesture.delegate = self;
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [itemView addGestureRecognizer:tapGesture];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        
        imageView.frame = CGRectMake(itemView.bounds.origin.x, itemView.bounds.origin.y, imageViewWidth, imageViewHeight);
        label.frame = CGRectMake(itemView.bounds.origin.x, itemView.bounds.origin.y + imageViewHeight, itemView.bounds.size.width, itemHeight - imageViewHeight);
        label.text = [array objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        
        //http://stackoverflow.com/questions/9907100/issues-with-setting-some-different-font-for-uilabel
        label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:10];
        
        imageView.image = [UIImage imageNamed:@"142x142"];
        
        
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
