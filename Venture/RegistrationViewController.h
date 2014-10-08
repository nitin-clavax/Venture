//
//  RegistrationViewController.h
//  Venture
//
//  Created by Deepak Tomar on 26/08/14.
//  Copyright (c) 2014 Deepak Tomar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+animatedGIF.h"


@interface RegistrationViewController : UIViewController<UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameTxtField;
@property (strong, nonatomic) IBOutlet UITextField *numberTxtField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTxtField;
@property (strong, nonatomic) IBOutlet UITextField *countryPhoneCode;

@property (strong, nonatomic) IBOutlet UIScrollView *regScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;

- (IBAction)nextBtnTapped:(id)sender;
- (IBAction)loginBtnTapped:(id)sender;
@end
