//
//  NetworkLoadingViewController.m
//  NetworkLoading
//
//  Created by Long Wang on 4/7/15.
//  Copyright (c) 2015 Long Wang. All rights reserved.
//

#import "NetworkLoadingViewController.h"
#import "ActivityLoadingIndicator.h"

@interface NetworkLoadingViewController ()

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation NetworkLoadingViewController

- (void)setupLoadingView
{
    CGFloat windowWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat windowHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat width = 56;
    CGFloat height = 56;
    
    self.loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    self.activityIndicatorView = [[ActivityLoadingIndicator alloc] initWithFrame:CGRectMake((windowWidth - width) / 2, (windowHeight - height) / 2, width, height)];
    //self.activityIndicatorView.backgroundColor = [UIColor grayColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((windowWidth - 213) / 2,
                                                               self.activityIndicatorView.frame.origin.y + height,
                                                               213,
                                                               61)];
    //label.backgroundColor = [UIColor yellowColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    label.textColor = [UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1.0f];
    label.text = @"加载中，请稍候";
    
    [self.loadingView addSubview:self.activityIndicatorView];
    [self.loadingView addSubview:label];
    [self.view addSubview:self.loadingView];
}

- (void)refreshClicked
{
    NSLog(@"Refresh Clicked");
    
    if ([self.delegate respondsToSelector:@selector(retryRequest)])
        [self.delegate retryRequest];
}

- (void)setupErrorView
{
    CGFloat windowWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat windowHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat width = 48;
    CGFloat height = 48;
    
    self.errorView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.errorView.hidden = YES;
    
    UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake((windowWidth - width) / 2,
                                                                        (windowHeight - height) / 2,
                                                                         width, height)];
    [refreshButton setImage:[UIImage imageNamed:@"refresh_button"] forState:UIControlStateNormal];
    [refreshButton setImage:[UIImage imageNamed:@"refresh_button"] forState:UIControlStateSelected];
    [refreshButton addTarget:self action:@selector(refreshClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.errorView addSubview:refreshButton];
    [self.view addSubview:self.errorView];
}

- (void)setupNoContentView
{
    self.noContentView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.noContentView.hidden = YES;
    
    [self.view addSubview:self.noContentView];
}

- (void)setupAllViews
{
    [self setupLoadingView];
    [self setupErrorView];
    [self setupNoContentView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.alpha = 1.0f;
    
    [self setupAllViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.activityIndicatorView startAnimating];
    
    [self.timer invalidate];
    //self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(showErrorView) userInfo:nil repeats:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLoadingView
{
    self.loadingView.hidden = NO;
    self.noContentView.hidden = YES;
    self.errorView.hidden = YES;
    self.activityIndicatorView.color = [UIColor colorWithRed:232/255.0f green:35/255.0f blue:111/255.0f alpha:1.0f];
    [self.activityIndicatorView startAnimating];
    
    [self.timer invalidate];
    //self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(showErrorView) userInfo:nil repeats:NO];
}

- (void)showErrorView
{
    [self.activityIndicatorView stopAnimating];
    [self.timer invalidate];
    
    self.noContentView.hidden = YES;
    self.errorView.hidden = NO;
    self.loadingView.hidden = YES;
}

- (void)showNoContentView
{
    [self.activityIndicatorView stopAnimating];
    [self.timer invalidate];
    
    self.noContentView.hidden = NO;
    self.errorView.hidden = YES;
    self.loadingView.hidden = YES;
}

@end
