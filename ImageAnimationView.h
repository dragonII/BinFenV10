//
//  ImageAnimationView.h
//  BinFenV10
//
//  Created by Wang Long on 3/26/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageAnimationView : UIView

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) CATransition *animation;

@property (assign, nonatomic) NSInteger animationSubType;
@property (assign, nonatomic) NSInteger imageIndex;

@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSArray *imageNamesArray;

@property (strong, nonatomic) NSTimer *animationTimer;

@end
