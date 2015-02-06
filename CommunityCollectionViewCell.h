//
//  TopCollectionViewCell.h
//  BinFenV10
//
//  Created by Wang Long on 2/1/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityCollectionViewCell : UICollectionViewCell <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UILabel *textLabel;

@property (copy, nonatomic) NSString *text;

@end
