//
//  DataModel.m
//  BinFenV10
//
//  Created by Wang Long on 3/3/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "DataModel.h"

static NSString *CommunityArrayKey = @"Communities";
static NSString *ShopArrayKey = @"Shops";
static NSString *CategoryArrayKey = @"Categories";

@implementation DataModel

// Returns the path to DataModel.plist file in the app's Documents directory
- (NSString *)dataModelPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    return [documentDirectory stringByAppendingPathComponent:@"DataModel.plist"];
}

- (void)loadDataModelRemotely
{
    
}

- (void)loadDataModelLocally
{
    NSString *path = [self dataModelPath];
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        // We store the DataModel in a plist file inside the app's Documents
        // directory. The Data object conforms to the NSCoding protocol,
        // which means that it can "freeze" itself into a data structure that
        // can be saved into a plist file. So can the NSMutableArray that holds
        // these Data objects. We we load the plist back in, the array and
        // its Data "unfreeze" and are restored to their old state.
        
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        self.communities = [unarchiver decodeObjectForKey:CommunityArrayKey];
        self.shops = [unarchiver decodeObjectForKey:ShopArrayKey];
        self.categories = [unarchiver decodeObjectForKey:CategoryArrayKey];
        
        [unarchiver finishDecoding];
    } else {
        self.communities = [[NSMutableArray alloc] init];
        self.shops = [[NSMutableArray alloc] init];
        self.categories = [[NSMutableArray alloc] init];
    }
}

- (void)saveDataModel
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:self.communities forKey:CommunityArrayKey];
    [archiver encodeObject:self.shops forKey:ShopArrayKey];
    [archiver encodeObject:self.categories forKey:CategoryArrayKey];
    
    [archiver finishEncoding];
    
    [data writeToFile:[self dataModelPath] atomically:YES];
}

@end
