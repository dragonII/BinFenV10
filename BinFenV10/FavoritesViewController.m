//
//  FavoritesViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/12/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "FavoritesViewController.h"
#import "FavoriteCollectionViewCell.h"
#import "ShopViewController.h"

static NSString *FavoriteCellIdentifier = @"FavoriteCell";

@interface FavoritesViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *favoriteListArray;

@end

@implementation FavoritesViewController

- (void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(144, 208);
    
    CGRect collectionFrame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionFrame collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    
    UINib *nib = [UINib nibWithNibName:@"FavoriteCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:FavoriteCellIdentifier];
    
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.view addSubview:self.collectionView];
}

- (void)testCollection
{
    UICollectionViewFlowLayout *myLayout = [[UICollectionViewFlowLayout alloc]init];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame];
    [myLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [myLayout setMinimumInteritemSpacing:0.0f];
    [myLayout setMinimumLineSpacing:0.0f];
    [self.collectionView setCollectionViewLayout:myLayout];
    
    [self.view addSubview:self.collectionView];
}

- (void)loadFavoriteListArrayData
{
    self.favoriteListArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < 13; i++)
        [self.favoriteListArray addObject:[NSString stringWithFormat:@"F%d", i]];
    
}

- (void)initNavigationItem
{
    self.navigationItem.title = @"我的收藏";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationItem];
    
    [self loadFavoriteListArrayData];
    
    [self initCollectionView];
    //[self testCollection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma UICollectionDelegate, DataSource and Flow

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.favoriteListArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FavoriteCollectionViewCell *cell = (FavoriteCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:FavoriteCellIdentifier forIndexPath:indexPath];
    cell.descriptionTextView.text = [self.favoriteListArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(144, 208);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(12, 12, 12, 12);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    // 连续Cell之间的间距
    return 8.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    // 不同Cell行距
    return 12.0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ShowShopSegueFromFavorite" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowShopSegueFromFavorite"])
    {
        ShopViewController *shopVC = (ShopViewController *)segue.destinationViewController;
        shopVC.showShopViewFrom = ShowViewFromOthers;
    }
}

@end
