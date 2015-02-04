//
//  DelegatesForCollection.m
//  BinFenV10
//
//  Created by Wang Long on 2/3/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "DelegatesForCollection.h"
#import "TopCollectionViewCell.h"
#import "defs.h"

@interface DelegatesForCollection() 

@property (strong, nonatomic) NSMutableArray *testDataArray;
@property (strong, nonatomic) NSMutableArray *indexPathArray;
@end

@implementation DelegatesForCollection

- (void)initTestData
{
    self.testDataArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < 15; i++)
        [self.testDataArray addObject:[NSString stringWithFormat:@"%d", i]];
    self.indexPathArray = [[NSMutableArray alloc] init];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.testDataArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TopCollectionViewCell *cell = (TopCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:TopCollectionCellIdentifier forIndexPath:indexPath];
    if([self.indexPathArray containsObject:indexPath])
    {
        cell.imageView.image = [UIImage imageNamed:@"120x160_2"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"CellPlaceHolder"];
    }
    cell.text = [self.testDataArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(120, 160);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    // 不清楚设置的为什么的间距，与Apple文档说明不一致
    return 8.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    //水平cell间距
    return 8.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TopCollectionViewCell *cell = (TopCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if([self.indexPathArray containsObject:indexPath])
    {
        //cell.imageView.image = [UIImage imageNamed:@"CellPlaceHolder"];
    } else {
        [self.indexPathArray addObject:indexPath];
        cell.imageView.image = [UIImage imageNamed:@"120x160_2"];
    }
    //NSLog(@"indexArray: %@", self.indexPathArray);
}

@end
