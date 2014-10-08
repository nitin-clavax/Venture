



//
//  UIViewController+CustomBackButton.m
//  OCL
//
//  Created by Deepak Tomar on 13/08/14.
//  Copyright (c) 2014 Deepak Tomar. All rights reserved.
//

#import "UIViewController+CustomBackButton.h"

@implementation UIViewController (CustomBackButton)


- (void)setUpImageBackButton
{
    
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 12, 20.0f)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barBackButtonItem;
    self.navigationItem.hidesBackButton = YES;
    
}

- (void)popCurrentViewController
{
    [[self view] endEditing:YES];

    [self.navigationController popViewControllerAnimated:YES];
}

@end
