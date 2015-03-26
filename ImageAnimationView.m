//
//  ImageAnimationView.m
//  BinFenV10
//
//  Created by Wang Long on 3/26/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "ImageAnimationView.h"

@implementation ImageAnimationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:self.imageView];
        
        self.animation = [CATransition animation];
        self.animation.duration = 0.5f;
        self.animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        self.animation.type = kCATransitionPush;
        self.animationSubType = arc4random() % 4;
        self.imageIndex = 0;
    }
    
    return self;
}

- (void)setTimer
{
    [self.animationTimer invalidate];
    
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(startImageAnimation) userInfo:nil repeats:YES];
}

- (void)setImageNamesArray:(NSArray *)imageNamesArray
{
    _imageNamesArray = [NSArray arrayWithArray:imageNamesArray];
    
    self.images = [[NSMutableArray alloc] init];
    
    for(NSString *s in self.imageNamesArray)
    {
        if([s length] != 0)
            [self.images addObject:[UIImage imageNamed:s]];
    }
    
    
    if([self.images count] == 0)
    {
        [self.images addObject:[UIImage imageNamed:@"Default_120x160"]];
        [self.images addObject:[UIImage imageNamed:@"Default_120x160_1"]];
        [self.images addObject:[UIImage imageNamed:@"E1"]];
        [self.images addObject:[UIImage imageNamed:@"E2"]];
    }
    
    self.imageView.image = [self.images objectAtIndex:0];
    
    [self setTimer];
}

- (void)startImageAnimation
{
    switch (self.animationSubType)
    {
        case 0:
            self.animation.subtype = kCATransitionFromTop;
            break;
        case 1:
            self.animation.subtype = kCATransitionFromBottom;
            break;
        case 2:
            self.animation.subtype = kCATransitionFromLeft;
            break;
        case 3:
            self.animation.subtype = kCATransitionFromRight;
            break;
    }
    self.animationSubType++;
    if(self.animationSubType > 3)
    {
        self.animationSubType = 0;
    }
    
    self.imageIndex++;
    if(self.imageIndex >= [self.images count])
    {
        self.imageIndex = 0;
    }
    
    [self.imageView setImage:[self.images objectAtIndex:self.imageIndex]];
    [self.imageView.layer addAnimation:self.animation forKey:@"animation"];
}

@end
