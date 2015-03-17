//
//  FavoriteCollectionCell_New.m
//  BinFenV10
//
//  Created by Wang Long on 3/17/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "FavoriteCollectionCell_New.h"
#import "DeviceHardware.h"

@implementation FavoriteCollectionCell_New

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

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    CGSize imageViewSize = [self getImageViewSizeByDevice];
    CGSize textViewSize = [self getTextViewSizeByDevice];
    
    CGRect imageViewFrame = CGRectMake(1, 1, imageViewSize.width, imageViewSize.height);
    CGRect textViewFrame = CGRectMake(1, 1 + imageViewSize.height, textViewSize.width, textViewSize.height);
    
    self.imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    self.descriptionTextView = [[UITextView alloc] initWithFrame:textViewFrame];
    
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.descriptionTextView];
}

@end
