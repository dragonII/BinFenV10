//
//  TabHomeViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/1/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "TabHomeViewController.h"
#import "TopCollectionViewCell.h"

static NSString *CollecionCellIdentifer = @"TopCollectionCellIdentifier";
static NSString *MidCollectionCellIdentifier = @"MiddleCellIdentifier";

static NSInteger TopCollectionTag = 1001;
static NSInteger MiddileCollectionTag = 1002;


@interface TabHomeViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *topCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *middleCollectionView;

@property (strong, nonatomic) NSMutableArray *testDataArray;

@end

@implementation TabHomeViewController

- (void)hideNavigationItem
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)configureCollectionView
{
    [self.topCollectionView registerClass:[TopCollectionViewCell class] forCellWithReuseIdentifier:CollecionCellIdentifer];
    self.topCollectionView.dataSource = self;
    self.topCollectionView.delegate = self;
    UINib *nib = [UINib nibWithNibName:@"TopCollectionViewCell" bundle:nil];
    [self.topCollectionView registerNib:nib forCellWithReuseIdentifier:CollecionCellIdentifer];
    //self.topCollectionView.backgroundColor = [UIColor clearColor];
    
    self.middleCollectionView.dataSource = self;
    self.middleCollectionView.delegate = self;
    UICollectionViewFlowLayout *middleFlowLayout = (UICollectionViewFlowLayout *)self.middleCollectionView.collectionViewLayout;
    middleFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionViewFlowLayout* flowLayout = (UICollectionViewFlowLayout*)self.topCollectionView.collectionViewLayout;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(120, 160);
}

- (void)initTestData
{
    self.testDataArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < 15; i++)
        [self.testDataArray addObject:[NSString stringWithFormat:@"%d", i]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hideNavigationItem];
    
    [self initTestData];
    [self configureCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView.tag == TopCollectionTag)
        return [self.testDataArray count];
    return 30;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == TopCollectionTag)
    {
        TopCollectionViewCell *cell = (TopCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CollecionCellIdentifer forIndexPath:indexPath];
    
        cell.text = [self.testDataArray objectAtIndex:indexPath.row];
        return cell;
    }
    {
        UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:MidCollectionCellIdentifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor yellowColor];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == TopCollectionTag)
    {
        return CGSizeMake(120, 160);
    }
    return CGSizeMake(104, 132);
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

/*
 // Seems useless too
// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}
 */


@end
