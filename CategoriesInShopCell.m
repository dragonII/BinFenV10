//
//  CategoriesInShopCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/12/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "CategoriesInShopCell.h"
#import "DeviceHardware.h"
#import "DataModel.h"
#import "UIKit+AFNetworking.h"

@interface CategoriesInShopCell () <UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *categoryListArray;

@property (strong, nonatomic) DataModel *dataModel;

@property (strong, nonatomic) NSDictionary *shop;
@property (strong, nonatomic) NSMutableArray *products;
@property (strong, nonatomic) NSMutableArray *categoriesOfProduct;
@property (strong, nonatomic) NSMutableArray *categories;

@end

@implementation CategoriesInShopCell

- (void)itemClicked:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    NSInteger index = view.tag - 1000;
    
    self.selectedCategoryID = [[[self.categories objectAtIndex:index] objectForKey:CategoryIDKey] copy];
    
    if([self.categoryClickedDelegate respondsToSelector:@selector(categoryClickedInCell:)])
    {
        [self.categoryClickedDelegate performSelector:@selector(categoryClickedInCell:) withObject:self];
    }
}

- (CGSize)getItemSizeByDevice
{
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    
    CGSize size;
    
    switch (generalPlatform)
    {
        case DeviceHardwareGeneralPlatform_iPhone_4:
        case DeviceHardwareGeneralPlatform_iPhone_4S:
        case DeviceHardwareGeneralPlatform_iPhone_5:
        case DeviceHardwareGeneralPlatform_iPhone_5C:
        case DeviceHardwareGeneralPlatform_iPhone_5S:
        {
            size = CGSizeMake(80.0f, 80.0f);
            return size;
        }
            
        case DeviceHardwareGeneralPlatform_iPhone_6:
        {
            size = CGSizeMake(24 + 44 + 24, 80.0f);
            return size;
        }
        case DeviceHardwareGeneralPlatform_iPhone_6_Plus:
        default:
            size = CGSizeMake(24 + 44 + 24, 80.0f);
            return size;
    }
}

- (CGFloat)getHorizentalSpace
{
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    
    switch (generalPlatform)
    {
        case DeviceHardwareGeneralPlatform_iPhone_4:
        case DeviceHardwareGeneralPlatform_iPhone_4S:
        case DeviceHardwareGeneralPlatform_iPhone_5:
        case DeviceHardwareGeneralPlatform_iPhone_5C:
        case DeviceHardwareGeneralPlatform_iPhone_5S:
        {
            return 18.0f;
        }
            
        case DeviceHardwareGeneralPlatform_iPhone_6:
        case DeviceHardwareGeneralPlatform_iPhone_6_Plus:
        {
            return 24.0f;
        }
            
            // iPhone 6 simulator
        default:
            return 24.0f;
    }
}

- (CGFloat)getColumnPadding
{
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    
    switch (generalPlatform)
    {
        case DeviceHardwareGeneralPlatform_iPhone_4:
        case DeviceHardwareGeneralPlatform_iPhone_4S:
        case DeviceHardwareGeneralPlatform_iPhone_5:
        case DeviceHardwareGeneralPlatform_iPhone_5C:
        case DeviceHardwareGeneralPlatform_iPhone_5S:
        case DeviceHardwareGeneralPlatform_iPhone_6:
            return 0.0f;
            
        case DeviceHardwareGeneralPlatform_iPhone_6_Plus:
        default:
            return 15.0f;
    }
}


- (void)awakeFromNib
{
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:191/255.0f green:191/255.0f blue:191/255.0f alpha:0.8f];
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

- (void)setSelectedShopIndex:(NSInteger)selectedShopIndex
{
    self.dataModel = [[DataModel alloc] init];
    [self.dataModel loadDataModelLocally];
    
    self.shop = [NSDictionary dictionaryWithDictionary:[self.dataModel.shops objectAtIndex:selectedShopIndex]];
    self.products = [[NSMutableArray alloc] init];
    
    NSString *shopID = [self.shop objectForKey:StoreIDKey];
    
    for(int i = 0; i < [self.dataModel.products count]; i++)
    {
        NSDictionary *dict = [self.dataModel.products objectAtIndex:i];
        if([shopID isEqualToString:[dict objectForKey:ProductShopKey]])
        {
            [self.products addObject:dict];
        }
    }
    
    NSLog(@"%@", self.products);
    
    self.categoriesOfProduct = [[NSMutableArray alloc] init];
    self.categories = [[NSMutableArray alloc] init];
    
    if([self.products count] > 0)
    {
        [self.categoriesOfProduct addObject:[[self.products objectAtIndex:0] objectForKey:ProductCategoryKey]];
        
        for(int i = 1; i < [self.products count]; i++)
        {
            NSString *categoryID = [[self.products objectAtIndex:i] objectForKey:ProductCategoryKey];
            if([self.categoriesOfProduct containsObject:categoryID])
                continue;
            else
                [self.categoriesOfProduct addObject:categoryID];
        }
        
        NSLog(@"categoriesOfProduct: %@", self.categoriesOfProduct);
        for(int i = 0; i < [self.categoriesOfProduct count]; i++)
        {
            NSString *categoryID = [self.categoriesOfProduct objectAtIndex:i];
            for(int j = 0; j < [self.dataModel.categories count]; j++)
            {
                if([categoryID isEqualToString:[[self.dataModel.categories objectAtIndex:j] objectForKey:CategoryIDKey]])
                    [self.categories addObject:[self.dataModel.categories objectAtIndex:j]];
                else
                    continue;
            }
        }
        
        [self drawViewsForCategories:self.categories];
    }
    
}


- (void)drawViewsForCategories:(NSArray *)categories
{
    int columnsPerPage = 4;
    CGFloat itemWidth = [self getItemSizeByDevice].width;  // = 80.0f;
    CGFloat itemHeight = [self getItemSizeByDevice].height; //= 80.0f;
    
    CGFloat startingPoint = [self getHorizentalSpace];
    
    CGFloat scrollViewWidth = self.scrollView.bounds.size.width;
    
    CGFloat imageViewWidth = 44.0f;
    CGFloat imageViewHeight = 44.0f;
    CGFloat colPadding = [self getColumnPadding];
    
    
    int index = 1000;
    int column = 0;
    int x = 0;
    
    //for(NSString *itemString in self.categoryListArray)
    for(int i = 0; i < [categories count]; i++)
    {
        //NSString *itemString = [[categories objectAtIndex:i] objectForKey:CategoryIDKey];
        NSString *itemString = [[categories objectAtIndex:i] objectForKey:CategoryNameKey];
        UIView *itemView = [[UIView alloc] init];
        itemView.tag = index;
        itemView.frame = CGRectMake(x + column * colPadding, 0, itemWidth, itemHeight);
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClicked:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [itemView addGestureRecognizer:tapGesture];
        
        
        UIImageView *imageView = [[UIImageView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        
        
        imageView.frame = CGRectMake(itemView.bounds.origin.x + startingPoint,
                                     itemView.bounds.origin.y + 12,
                                     imageViewWidth, imageViewHeight);
        label.frame = CGRectMake(itemView.bounds.origin.x,
                                 itemView.bounds.origin.y + 12 + imageViewHeight,
                                 itemWidth,
                                 itemHeight - imageViewHeight);
        label.text = itemString;
        label.textAlignment = NSTextAlignmentCenter;
        
        //http://stackoverflow.com/questions/9907100/issues-with-setting-some-different-font-for-uilabel
        label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:10];
        
        //imageView.image = [UIImage imageNamed:@"Default_44x44"];
        NSString *imageURL = [[categories objectAtIndex:i] objectForKey:CategoryImageKey];
        [imageView setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"Default_44x44"]];
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
            x = [UIScreen mainScreen].bounds.size.width;
        }
    }
    
    int tilesPerPage = columnsPerPage;
    int numPages = ceilf([categories count] / (float)tilesPerPage);
    
    self.scrollView.contentSize = CGSizeMake(numPages * scrollViewWidth, self.scrollView.frame.size.height);
    
    self.pageControl.numberOfPages = numPages;
    self.pageControl.currentPage = 0;
    [self.pageControl setHidesForSinglePage:YES];
}


@end
