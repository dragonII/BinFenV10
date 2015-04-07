//
//  NetworkLoadingViewController.h
//  NetworkLoading
//
//  Created by Long Wang on 4/7/15.
//  Copyright (c) 2015 Long Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActivityLoadingIndicator;

@protocol NetworkLoadingViewDelegate <NSObject>

-(void)retryRequest;

@end

@interface NetworkLoadingViewController : UIViewController

@property (strong, nonatomic) UIView *loadingView;
@property (strong, nonatomic) UIView *errorView;
@property (strong, nonatomic) UIButton *refreshButton;
@property (strong, nonatomic) ActivityLoadingIndicator *activityIndicatorView;
@property (strong, nonatomic) UIView *noContentView;

@property (weak, nonatomic) id <NetworkLoadingViewDelegate> delegate;

//- (IBAction)retryRequest:(id)sender;

- (void)showLoadingView;
- (void)showNoContentView;
- (void)showErrorView;


@end
