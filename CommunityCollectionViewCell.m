//
//  TopCollectionViewCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/1/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "CommunityCollectionViewCell.h"
#import "LAAnimatedGrid.h"

@implementation CommunityCollectionViewCell

- (void)awakeFromNib
{
    //self.imageView.image = [UIImage imageNamed:@"CellPlaceHolder"];
    //self.imageView.image = [UIImage imageNamed:@"ios1"];
    
    
    // Array of images
    NSMutableArray *arrImages = [NSMutableArray array];
    
    [arrImages addObject:[UIImage imageNamed:@"Default_120x160"]];
    [arrImages addObject:[UIImage imageNamed:@"Default_120x160_1"]];
    
    
    // LAAnimatedGrid
    LAAnimatedGrid *laag = [[LAAnimatedGrid alloc] initWithFrame:self.contentView.bounds];
    [laag setArrImages:arrImages];
    [laag setLaagOrientation:LAAGOrientationHorizontal];
    // [laag setLaagOrientation:LAAGOrientationVertical];
    // [laag setLaagBorderColor:[UIColor blackColor]];
    // [laag setLaagBackGroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:laag];
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.bounds.origin.x,
                                                              self.contentView.bounds.origin.y + 128,
                                                              self.contentView.bounds.size.width,
                                                               21)];
    //label.text = @"Label";
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:10];
    [self.contentView addSubview:self.textLabel];
    
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
