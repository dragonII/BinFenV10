//
//  FavoriteCollectionViewCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/12/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "FavoriteCollectionViewCell.h"
#import "DeviceHardware.h"

@implementation FavoriteCollectionViewCell

- (CGSize)getImageViewSizeByDevice
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
            size = CGSizeMake(142.0f, 142.0f);
            return size;
        }
            
        case DeviceHardwareGeneralPlatform_iPhone_6:
        {
            size = CGSizeMake(168.0f, 168.0f);
            return size;
        }
            
        case DeviceHardwareGeneralPlatform_iPhone_6_Plus:
        default:
            size = CGSizeMake(188.0f, 188.0f);
            return size;
    }
}

- (CGSize)getTextViewSizeByDevice
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
            size = CGSizeMake(142.0f, 68.0f);
            return size;
        }
            
        case DeviceHardwareGeneralPlatform_iPhone_6:
        {
            size = CGSizeMake(168.0f, 76.0f);
            return size;
        }
            
        case DeviceHardwareGeneralPlatform_iPhone_6_Plus:
        default:
            size = CGSizeMake(188.0f, 84.0f);
            return size;
    }
}

- (void)awakeFromNib
{
    CGSize imageViewSize = [self getImageViewSizeByDevice];
    CGSize textViewSize = [self getTextViewSizeByDevice];
    
    CGRect imageViewFrame = CGRectMake(1, 1, imageViewSize.width, imageViewSize.height);
    CGRect textViewFrame = CGRectMake(1, 1 + imageViewSize.height, textViewSize.width, textViewSize.height);
    
    self.imageView.frame = imageViewFrame;
    self.descriptionTextView.frame = textViewFrame;
}

@end
