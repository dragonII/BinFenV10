//
//  ProductDetailViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/7/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "ProductDetailViewController.h"

@interface ProductDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation ProductDetailViewController

- (void)initBottomView
{
    CGRect mainFrame = self.view.bounds;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, mainFrame.size.height - 44, mainFrame.size.width, mainFrame.size.height)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"产品";
    self.productImageView.image = [UIImage imageNamed:@"Image-320x200"];
    
    [self initBottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
