//
//  TopCollectionViewCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/1/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "TopCollectionViewCell.h"

@implementation TopCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
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
