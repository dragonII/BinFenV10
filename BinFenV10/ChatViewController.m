//
//  ChatViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/13/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)initNavigationItem
{
    self.navigationItem.title = @"对话";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
