//
//  TopCollectionViewCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/1/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "CommunityCollectionViewCell.h"
#import "ImageAnimationView.h"

@implementation CommunityCollectionViewCell

- (void)awakeFromNib
{
    // Array of images
    self.images = [NSMutableArray array];
    
    [self.images addObject:[UIImage imageNamed:@"Default_120x160"]];
    [self.images addObject:[UIImage imageNamed:@"Default_120x160_1"]];
    [self.images addObject:[UIImage imageNamed:@"E1"]];
    [self.images addObject:[UIImage imageNamed:@"E2"]];
    
    self.imageNamesArray = @[@"Default_120x160",
                             @"Default_120x160_1",
                             @"E1",
                             @"E2"];
    
    self.imageAnimationView = [[ImageAnimationView alloc] initWithFrame:self.contentView.bounds];
    
    [self.contentView addSubview:self.imageAnimationView];
    
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.bounds.origin.x,
                                                              self.contentView.bounds.origin.y + 128,
                                                              self.contentView.bounds.size.width,
                                                               21)];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:10];
    [self.contentView addSubview:self.textLabel];
    
}

- (void)setText:(NSString *)text
{
    if(![_text isEqualToString:text])
    {
        _text = [text copy];
        _textLabel.text = _text;
        
        self.imageAnimationView.imageNamesArray = self.imageNamesArray;
    }
}


@end
