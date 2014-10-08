//
//  LoginViewController.h
//  Venture
//
//  Created by Deepak Tomar on 25/08/14.
//  Copyright (c) 2014 Deepak Tomar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+animatedGIF.h"

@interface LoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *userNameTxtField;
@property (strong, nonatomic) IBOutlet UITextField *passTxtField;
@property (strong, nonatomic) IBOutlet UIView *logInForgotBtnsView;
@property (strong, nonatomic) IBOutlet UIScrollView *loginScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
- (IBAction)signInBtnTapped:(id)sender;
- (IBAction)FBSignInBtnTapped:(id)sender;
- (IBAction)forgotPassBtnTapped:(id)sender;
- (IBAction)signUpBtnTapped:(id)sender;
@end
