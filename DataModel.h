//
//  DataModel.h
//  BinFenV10
//
//  Created by Wang Long on 3/3/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *StoreImageKey = @"image";
static NSString *StoreIDKey = @"ID";
static NSString *StoreNameKey = @"name";
static NSString *StoreSNameKey = @"shortname";
static NSString *StoreTypeKey = @"type";
static NSString *StoreOfCommunityKey = @"community";
static NSString *StoreAddrCountryKey = @"country";
static NSString *StoreAddrProviceKey = @"province";
static NSString *StoreAddrCityKey = @"city";
static NSString *StoreAddrStreetKey = @"street";
static NSString *StoreStatusKey = @"status";

static NSString *CommunityIDKey = @"ID";
static NSString *CommunityNameKey = @"name";
static NSString *CommunityAreaKey = @"area";
static NSString *CommunityDescKey = @"description";
static NSString *CommunityImageKey = @"image";


@class AFHTTPSessionManager;

@class CommunityData;
@class ProductData;
@class ShopData;

@interface DataModel : NSObject

@property (assign, nonatomic) BOOL loadShopsFinished;
@property (assign, nonatomic) BOOL loadCommunitiesFinished;

@property (strong, nonatomic) AFHTTPSessionManager *httpSessionManager;

@property (strong, nonatomic) NSMutableArray *communities;
@property (strong, nonatomic) NSMutableArray *shops;
@property (strong, nonatomic) NSMutableArray *categories;


- (void)loadDataModelLocally;
- (void)loadDataModelRemotely;
- (void)saveDataModel;

@end
