//
//  AppData.m
//  BinFenV10
//
//  Created by Wang Long on 2/11/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "AppDataHandling.h"

@implementation AppDataHandling

+ (NSString *)filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *path = [basePath stringByAppendingPathComponent:@"AppData.plist"];
    return path;
}

+ (NSArray *)loadDataArray
{
    NSArray *array;
    
    NSString *filePath = [self filePath];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        array = [NSArray arrayWithContentsOfFile:filePath];
    } else {
        array = nil;
    }
    return array;
}

+ (void)saveDataArray:(NSArray *)array
{
    NSString *filePath = [self filePath];
    [array writeToFile:filePath atomically:YES];
}

@end
