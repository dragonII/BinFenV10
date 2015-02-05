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
    for (int i = 1; i <= 6; i++)
    {
        [arrImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"ios%d", i]]];
    }
    
    
    // LAAnimatedGrid
    LAAnimatedGrid *laag = [[LAAnimatedGrid alloc] initWithFrame:self.contentView.bounds];
    [laag setArrImages:arrImages];
    [laag setLaagOrientation:LAAGOrientationHorizontal];
    // [laag setLaagOrientation:LAAGOrientationVertical];
    // [laag setLaagBorderColor:[UIColor blackColor]];
    // [laag setLaagBackGroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:laag];
    
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
