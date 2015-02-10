//
//  MessageViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/10/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)initNavigationItem
{
    UIColor *backgroundColor = [UIColor colorWithRed:253/255.0f
                                               green:150/255.0f
                                                blue:93/255.0f
                                               alpha:1.0f];
    self.navigationItem.title = @"消息";
    [self.navigationController.navigationBar setBarTintColor:backgroundColor];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationItem];
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
