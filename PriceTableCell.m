//
//  PriceTableCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/9/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "PriceTableCell.h"

@interface PriceTableCell()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *upLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addToFavoriteImage;

@property (assign, nonatomic) BOOL favoriteAdded;


@end

@implementation PriceTableCell

- (void)addToFavorite:(UITapGestureRecognizer*)sender
{
    if(self.favoriteAdded == NO)
    {
        self.addToFavoriteImage.image = [UIImage imageNamed:@"AddedToFavorite"];
        self.favoriteAdded = YES;
    } else {
        self.addToFavoriteImage.image = [UIImage imageNamed:@"AddToFavorite"];
        self.favoriteAdded = NO;
    }
}

- (void)awakeFromNib
{
    self.favoriteAdded = NO;
    
    [self.addToFavoriteImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addToFavorite:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [self.addToFavoriteImage addGestureRecognizer:tapRecognizer];
    self.priceString = @"0.00";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setPriceString:(NSString *)priceString
{
    if([priceString length] == 0)
    {
        _priceLabel.text = @"暂无售价";
    } else {
        _priceLabel.text = [priceString copy];
    }
}

@end
