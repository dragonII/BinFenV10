//
//  TopCollectionViewCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/1/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "CommunityCollectionViewCell.h"
//#import "LAAnimatedGrid.h"
#import "LTransitionImageView.h"

static AnimationDirection directions[4];

@implementation CommunityCollectionViewCell

- (void)awakeFromNib
{
    //self.imageView.image = [UIImage imageNamed:@"CellPlaceHolder"];
    //self.imageView.image = [UIImage imageNamed:@"ios1"];
    
    
    // Array of images
    self.images = [NSMutableArray array];
    
    [self.images addObject:[UIImage imageNamed:@"Default_120x160"]];
    [self.images addObject:[UIImage imageNamed:@"Default_120x160_1"]];
    
    /*
    // LAAnimatedGrid
    LAAnimatedGrid *laag = [[LAAnimatedGrid alloc] initWithFrame:self.contentView.bounds];
    [laag setArrImages:arrImages];
    [laag setLaagOrientation:LAAGOrientationHorizontal];
    [self.contentView addSubview:laag];
     */
    
    // 使用LTransitionImageView
    self.transitionView = [[LTransitionImageView alloc] initWithFrame:self.contentView.bounds];
    self.transitionView.animationDuration = 2;
    self.transitionView.animationDirection = directions[[self loadRandomNumberInRange:4]];
    self.transitionView.image = [self.images objectAtIndex:[self loadRandomNumberInRange:[self.images count]]];
    [self.contentView addSubview:self.transitionView];
    
    [self transitionAnimations];
    
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.bounds.origin.x,
                                                              self.contentView.bounds.origin.y + 128,
                                                              self.contentView.bounds.size.width,
                                                               21)];
    //label.text = @"Label";
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:10];
    [self.contentView addSubview:self.textLabel];
    
}

- (void)transitionAnimations
{
    [NSTimer scheduledTimerWithTimeInterval:self.transitionView.animationDuration + 1
                                     target:self
                                   selector:@selector(animateImage)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)animateImage
{
    UIImage *image;
    AnimationDirection newDirection;
    
    newDirection = directions[[self loadRandomNumberInRange:4]];
    if(self.transitionView.animationDirection != newDirection)
        self.transitionView.animationDirection = newDirection;
    
    image = [self.images objectAtIndex:[self loadRandomNumberInRange:[self.images count]]];
    
    self.transitionView.image = image;
}

- (int)loadRandomNumberInRange:(int)range
{
    return arc4random() % range;
}

- (void)setText:(NSString *)text
{
    if(![_text isEqualToString:text])
    {
        //NSLog(@"Setting text");
        _text = [text copy];
        _textLabel.text = _text;
    }
}


@end
