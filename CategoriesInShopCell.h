//
//  CategoriesInShopCell.h
//  BinFenV10
//
//  Created by Wang Long on 2/12/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoriesInShopCell;

@protocol CategoryItemClickedDelegate <NSObject>

- (void)categoryClickedInCell:(CategoriesInShopCell *)cell;

@end

@interface CategoriesInShopCell : UITableViewCell

@property (weak, nonatomic) id<CategoryItemClickedDelegate> categoryClickedDelegate;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (assign, nonatomic) NSInteger selectedShopIndex;

@property (copy, nonatomic) NSString *selectedCategoryID;

@end
