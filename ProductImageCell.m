//
//  ProductImageCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/8/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "ProductImageCell.h"

@interface ProductImageCell() <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) NSArray *imageNamesArray;

@end

@implementation ProductImageCell


- (void)awakeFromNib
{
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = YES;
    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:191/255.0f green:191/255.0f blue:191/255.0f alpha:0.8f];
    
    [self initImages];
    [self initItems];
}

- (void)initImages
{
    self.imageNamesArray = @[@"Default_320x200"];
}

- (void)initItems
{
#warning 目前只涵盖屏幕宽度为320，其他宽度的屏幕尺寸待完成
    
    CGFloat x = 0;
    
    CGFloat scrollViewWidth = self.scrollView.bounds.size.width;
    
    CGFloat imageViewWidth = self.scrollView.bounds.size.width;
    CGFloat imageViewHeight = 200.0f;
    
    for(int i = 0; i < [self.imageNamesArray count]; i++)
    {
        //UIView *itemView = [[UIView alloc] init];
        UIImageView *imageView = [[UIImageView alloc] init];
        //itemView.tag = index;
        imageView.frame = CGRectMake(x + (imageViewWidth * i), 0, imageViewWidth, imageViewHeight);
        imageView.image = [UIImage imageNamed:[self.imageNamesArray objectAtIndex:i]];
        
        [self.scrollView addSubview:imageView];
    }
    if([self.imageNamesArray count] <= 1)
        [self.pageControl setHidden:YES];
    
    //int tilesPerPage = columnsPerPage * 2;
    //int numPages = ceilf([self.categoriesListArray count] / (float)tilesPerPage);
    
    self.scrollView.contentSize = CGSizeMake([self.imageNamesArray count] * scrollViewWidth, self.scrollView.frame.size.height);
    
    self.pageControl.numberOfPages = [self.imageNamesArray count];
    self.pageControl.currentPage = 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidScroll");
    CGFloat width = self.scrollView.bounds.size.width;
    int currentPage = (self.scrollView.contentOffset.x + width) / width - 1;
    self.pageControl.currentPage = currentPage;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
