//
//  CategoriesInShopCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/12/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "CategoriesInShopCell.h"

@interface CategoriesInShopCell () <UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *categoryListArray;

@end

@implementation CategoriesInShopCell

- (void)loadCategoryListDataArray
{
    self.categoryListArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < 7; i++)
        [self.categoryListArray addObject:[NSString stringWithFormat:@"Cate: %d", i]];
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
    
    //CGFloat extraSpace = 0.0f;
    
    CGFloat scrollViewWidth = self.scrollView.bounds.size.width;
    
    CGFloat imageViewWidth = 44.0f;
    CGFloat imageViewHeight = 44.0f;
    
    int index = 1000;
    int column = 0;
    int x = 0;
    
    for(NSString *itemString in self.categoryListArray)
    {
        UIView *itemView = [[UIView alloc] init];
        itemView.tag = index;
        itemView.frame = CGRectMake(x, 0, itemWidth, itemHeight);
        
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
        
        imageView.image = [UIImage imageNamed:@"Default_44x44"];
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
        //row++;
        column++;
        x += itemWidth;
        if(column == columnsPerPage)
        {
            column = 0;
        }
    }
    
    int tilesPerPage = columnsPerPage;
    int numPages = ceilf([self.categoryListArray count] / (float)tilesPerPage);
    
    self.scrollView.contentSize = CGSizeMake(numPages * scrollViewWidth, self.scrollView.frame.size.height);
    
    self.pageControl.numberOfPages = numPages;
    self.pageControl.currentPage = 0;
}


- (void)awakeFromNib
{
    [self loadCategoryListDataArray];
    
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:191/255.0f green:191/255.0f blue:191/255.0f alpha:0.8f];
    
    [self initItems];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidScroll");
    CGFloat width = self.scrollView.bounds.size.width;
    int currentPage = (self.scrollView.contentOffset.x + width) / width - 1;
    self.pageControl.currentPage = currentPage;
}

@end
