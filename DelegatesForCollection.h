//
//  DelegatesForCollection.h
//  BinFenV10
//
//  Created by Wang Long on 2/3/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DelegatesForCollection : NSObject <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

- (void)initTestData;

@end
