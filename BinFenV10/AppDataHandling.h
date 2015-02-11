//
//  AppData.h
//  BinFenV10
//
//  Created by Wang Long on 2/11/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *DictPhoneInAddrKey = @"PhoneInAddr";
static NSString *DictAddrInAddrKey = @"AddrInAddr";

@interface AppDataHandling : NSObject

+ (NSArray *)loadDataArray;
+ (void)saveDataArray:(NSArray *)array;

@end
