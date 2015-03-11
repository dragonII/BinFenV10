//
//  DataModel.m
//  BinFenV10
//
//  Created by Wang Long on 3/3/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "DataModel.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

static NSString *GarbageString = @"Thread was being aborted.";

static NSString *CommunityArrayKey = @"Communities";
static NSString *ShopArrayKey = @"Shops";
static NSString *CategoryArrayKey = @"Categories";

@interface DataModel ()

@property dispatch_group_t retrieveGroup;

@end

@implementation DataModel

- (id)init
{
    self = [super init];
    if (self)
    {
        self.loadFinished = NO;
        self.httpSessionManager = [AppDelegate sharedHttpSessionManager];
    }
    return self;
}

// Returns the path to DataModel.plist file in the app's Documents directory
- (NSString *)dataModelPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    return [documentDirectory stringByAppendingPathComponent:@"DataModel.plist"];
}

- (NSString *)stringByRemovingControlCharacters: (NSString *)inputString
{
    NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];
    NSRange range = [inputString rangeOfCharacterFromSet:controlChars];
    if (range.location != NSNotFound) {
        NSMutableString *mutable = [NSMutableString stringWithString:inputString];
        while (range.location != NSNotFound) {
            [mutable deleteCharactersInRange:range];
            range = [mutable rangeOfCharacterFromSet:controlChars];
        }
        return mutable;
    }
    return inputString;
}

- (NSArray *)prepareForParse:(id)responseObject
{
    NSString *rawString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    
    NSString *noEscapedString = [self stringByRemovingControlCharacters:rawString];
    
    NSString *cleanString = [noEscapedString stringByReplacingOccurrencesOfString:GarbageString withString:@""];
    cleanString = [cleanString stringByReplacingOccurrencesOfString:@"\'" withString:@"\""];
    NSLog(@"cleanString: %@", cleanString);
    
    NSData *data = [cleanString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if(error)
    {
        NSLog(@"Error: %@", error);
    }
    
    NSArray *outerArray = [json objectForKey:@"data"];
    return outerArray;
}

- (void)parseStoreJson:(id)responseObject
{
    NSArray *outerArray = [self prepareForParse:responseObject];
    self.shops = [[NSMutableArray alloc] init];
    NSMutableDictionary *storeDict;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"URLs" ofType:@"plist"];
    NSArray *urlArray = [NSArray arrayWithContentsOfFile:path];
    NSString *baseURLString = (NSString *)[[urlArray objectAtIndex:0] objectForKey:@"url"];
    
    for(NSArray *innerArray in outerArray)
    {
        storeDict = [[NSMutableDictionary alloc] init];
        
        //[storeDict setObject:[innerArray objectAtIndex:0] forKey:StoreImageKey];
        [storeDict setObject:[baseURLString stringByAppendingPathComponent:[innerArray objectAtIndex:0]] forKey:StoreImageKey];
        [storeDict setObject:[innerArray objectAtIndex:1] forKey:StoreIDKey];
        [storeDict setObject:[innerArray objectAtIndex:2] forKey:StoreNameKey];
        [storeDict setObject:[innerArray objectAtIndex:3] forKey:StoreSNameKey];
        [storeDict setObject:[innerArray objectAtIndex:4] forKey:StoreTypeKey];
        [storeDict setObject:[innerArray objectAtIndex:5] forKey:StoreOfCommunityKey];
        [storeDict setObject:[innerArray objectAtIndex:6] forKey:StoreAddrCountryKey];
        [storeDict setObject:[innerArray objectAtIndex:7] forKey:StoreAddrProviceKey];
        [storeDict setObject:[innerArray objectAtIndex:8] forKey:StoreAddrCityKey];
        [storeDict setObject:[innerArray objectAtIndex:9] forKey:StoreAddrStreetKey];
        [storeDict setObject:[innerArray objectAtIndex:10] forKey:StoreStatusKey];
        
        [self.shops addObject:storeDict];
    }
    
    [self saveDataModel];
}

- (void)loadDataModelRemotely
{
    _retrieveGroup = dispatch_group_create();
    
    // Here we wait for all the requests to finish
    dispatch_group_notify(_retrieveGroup, dispatch_get_main_queue(), ^{
        [self.httpSessionManager GET:@"myinfo/shopinfolist_json.ds"
                          parameters:nil
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 [self parseStoreJson:responseObject];
                                 //dispatch_group_leave(_retrieveGroup);
                                 _loadFinished = YES;
                             }failure:^(NSURLSessionDataTask *task, NSError *error) {
                                 NSLog(@"Error: %@", [error localizedDescription]);
                                 //dispatch_group_leave(_retrieveGroup);
                             }];
    });
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
