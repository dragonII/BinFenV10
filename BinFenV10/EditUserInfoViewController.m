//
//  EditUserInfoViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/11/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "EditUserInfoViewController.h"
#import "AppData.h"

@interface EditUserInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *saveButton;

@end

@implementation EditUserInfoViewController

- (void)saveButtonClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initTableView
{
    CGRect tableFrame;

    switch (self.editUserInfoType)
    {
        case EditUserNameInfo:
        case EditUserPhoneNum:
            tableFrame = CGRectMake(0, 0, self.view.bounds.size.width, 44 + 12);
            break;
        
        case EditUserPassword:
            tableFrame = CGRectMake(0, 0, self.view.bounds.size.width, 44 * 2 + 12);
            break;
            
        default:
            tableFrame = CGRectZero;
            break;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:tableFrame];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 288, 36)];
    self.saveButton.center = CGPointMake(CGRectGetMidX(self.view.bounds), tableFrame.size.height + 20 + 36/2);
    [self.saveButton setBackgroundImage:[UIImage imageNamed:@"SaveButtonBG"] forState:UIControlStateNormal];
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.saveButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.saveButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  UITableView DataSource, Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.editUserInfoType)
    {
        case EditUserNameInfo:
        case EditUserPhoneNum:
            return 1;
           
        case EditUserPassword:
            return 2;
            
        default:
            return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 12)];
    view.backgroundColor = [UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1.0f];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    return cell;
}

@end
