//
//  MiddleTableViewCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/3/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "CategoryTableViewCell.h"

@implementation CategoryTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:191/255.0f green:191/255.0f blue:191/255.0f alpha:0.8f];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidScroll");
    CGFloat width = self.scrollView.bounds.size.width;
    int currentPage = (self.scrollView.contentOffset.x + width) / width - 1;
    self.pageControl.currentPage = currentPage;
}

- (void)setCategoriesListArray:(NSArray *)categoriesListArray
{
    if(![_categoriesListArray isEqualToArray:categoriesListArray])
    {
        _categoriesListArray = [NSArray arrayWithArray:categoriesListArray];
        [self initItems];
    }
}


- (void)itemClicked:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    NSLog(@"%ld", (long)view.tag);
}

- (void)initItems
{
#warning 目前只涵盖屏幕宽度为320，其他宽度的屏幕尺寸待完成

    int columnsPerPage = 4;
    CGFloat itemWidth = 80.0f;
    CGFloat itemHeight = 80.0f;

    CGFloat x = 0;
    //CGFloat extraSpace = 0.0f;
    
    CGFloat scrollViewWidth = self.scrollView.bounds.size.width;
    
    CGFloat imageViewWidth = 44.0f;
    CGFloat imageViewHeight = 44.0f;
    
    int index = 1000;
    int row = 0;
    int column = 0;
    
    for(NSString *itemString in self.categoriesListArray)
    {
        UIView *itemView = [[UIView alloc] init];
        itemView.tag = index;
        itemView.frame = CGRectMake(x, row * itemHeight, itemWidth, itemHeight);
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClicked:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [itemView addGestureRecognizer:tapGesture];
         
        
        UIImageView *imageView = [[UIImageView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        
        
        imageView.frame = CGRectMake(itemView.bounds.origin.x + 18, itemView.bounds.origin.y + 12, imageViewWidth, imageViewHeight);
        label.frame = CGRectMake(itemView.bounds.origin.x, itemView.bounds.origin.y + 12 + imageViewHeight, itemView.bounds.size.width, itemHeight - imageViewHeight);
        label.text = itemString;
        label.textAlignment = NSTextAlignmentCenter;
        
        //http://stackoverflow.com/questions/9907100/issues-with-setting-some-different-font-for-uilabel
        label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:10];
        
        imageView.image = [UIImage imageNamed:@"ImagePlaceHolder44x44"];
        //imageView.contentMode = UIViewContentModeScaleAspectFill;
        /////
        // Performance
        imageView.layer.cornerRadius = 22.0f;
        imageView.layer.masksToBounds = NO;
        imageView.layer.shouldRasterize = YES;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        /////
        imageView.layer.borderWidth = 1.0f;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.clipsToBounds = YES;
        imageView.alpha = 0.8f;

        
        [itemView addSubview:imageView];
        [itemView addSubview:label];
        [self.scrollView addSubview:itemView];
        
        index++;
        row++;
        if(row == 2)
        {
            row = 0;
            column++;
            x += itemWidth;
            
            if(column == columnsPerPage)
            {
                column = 0;
            }
        }
    }
    
    int tilesPerPage = columnsPerPage * 2;
    int numPages = ceilf([self.categoriesListArray count] / (float)tilesPerPage);
    
    self.scrollView.contentSize = CGSizeMake(numPages * scrollViewWidth, self.scrollView.frame.size.height);
    
    self.pageControl.numberOfPages = numPages;
    self.pageControl.currentPage = 0;
    
    //NSLog(@"ContentSize: %f, %f", self.scrollView.contentSize.width, self.scrollView.contentSize.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
