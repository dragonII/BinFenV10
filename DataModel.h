//
//  DataModel.h
//  BinFenV10
//
//  Created by Wang Long on 3/3/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CommunityData;
@class ProductData;
@class ShopData;

@interface DataModel : NSObject

@property (strong, nonatomic) NSMutableArray *communities;
@property (strong, nonatomic) NSMutableArray *shops;
@property (strong, nonatomic) NSMutableArray *categories;


- (void)loadDataModelLocally;
- (void)loadDataModelRemotely;
- (void)saveDataModel;

@end
