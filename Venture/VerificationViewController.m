//
//  VerificationViewController.m
//  Venture
//
//  Created by Deepak Tomar on 05/09/14.
//  Copyright (c) 2014 Deepak Tomar. All rights reserved.
//

#import "VerificationViewController.h"
#import "LoginViewController.h"
#import "UserInterestsViewController.h"
#import "RegistrationViewController.h"

@interface VerificationViewController ()

@property (strong, nonatomic) IBOutlet UITextField *phoneTxtField;
@property (strong, nonatomic) IBOutlet UITextField *verificationCodeTxtField;
@property (strong, nonatomic) IBOutlet UIImageView *verificationCodeBGImage;
@end

@implementation VerificationViewController
@synthesize completePhoneNumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"background" withExtension:@"gif"];
    self.backgroundImageView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];

    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"● ● ● ●" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }];
    _verificationCodeTxtField.attributedPlaceholder = str;

//    NSArray *phoneNumberArray = [completePhoneNumber componentsSeparatedByString:@"-"];
    NSString *phoneNumber = [completePhoneNumber stringByReplacingOccurrencesOfString:@"-"withString:@" "];
    _phoneTxtField.text = phoneNumber;
    
    
    // keyboard input Accessory View //
    UIView *keyboardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    keyboardView.backgroundColor = [UIColor clearColor];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(19, 2, 47, 40)];
    [loginBtn setTitle:@"Next" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(nextBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    loginBtn.titleLabel.textColor = [UIColor whiteColor];
    
    
    UIButton *NextBtn = [[UIButton alloc] initWithFrame:CGRectMake(247, 2, 53, 40)];
    [NextBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [NextBtn addTarget:self action:@selector(cancelBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    NextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    NextBtn.titleLabel.textColor = [UIColor whiteColor];
    
    
    
    [keyboardView addSubview:NextBtn];
    [keyboardView addSubview:loginBtn];
    
    
    _verificationCodeTxtField.inputAccessoryView = keyboardView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -  UITextFieldDelegate Methods -



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == _verificationCodeTxtField) {
        _verificationCodeBGImage.image = [UIImage imageNamed:@"registration_BG_green.png"];
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
    _verificationCodeBGImage.image = [UIImage imageNamed:@"resend_txtBG.png"];
    
    //    if (textField != self.forgotPassTxtField) {
    //        [loginScrollView setContentOffset:CGPointZero animated:YES];
    //    }
}

#pragma mark -  UIActionSheetDelegate define Methods -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    NSLog(@"%d",buttonIndex);
    NSLog(@"%@",buttonTitle);
    
    if  (buttonIndex == 0) {
        
        //Show the loader
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSURL *URL = [NSURL URLWithString:k_BASE_URL];
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
        
        
        //    NSLog(@" fetch event parameters ---> %@",dict);
        
        NSString *getPath = [NSString stringWithFormat:@"resendsecuritycode/%@",completePhoneNumber];
        
        [manager GET:getPath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
            
            //Hide loader
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"responseObject%@",responseObject);
            
            
            ///-----for key -> "errors" ---- ///
            if([[responseObject objectForKey:@"status"] isEqualToString:@"error"]){
                
                NSMutableString *strTemp=[NSMutableString string];
                
                
                if ([[responseObject objectForKey:@"message"] isKindOfClass:[NSDictionary class]]) {
                    for (NSString *key in [responseObject objectForKey:@"message"]) {
                        
                        if ([[[responseObject objectForKey:@"message"] objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                            
                            for (NSString *descStr in [[responseObject objectForKey:@"message"] objectForKey:key]) {
                                
                                [strTemp appendFormat:@"%@.\n",[[[responseObject objectForKey:@"message"] objectForKey:key] objectForKey:descStr]];
                            }
                        }
                        else if ([[[responseObject objectForKey:@"message"] objectForKey:key] isKindOfClass:[NSString class]])
                        {
                            strTemp = [[responseObject objectForKey:@"message"] objectForKey:key];
                            
                        }
                        
                        
                    }
                }
                else if ([[responseObject objectForKey:@"message"] isKindOfClass:[NSString class]])
                {
                    strTemp = [responseObject objectForKey:@"message"];
                    
                }
                UIAlertView *errorAlert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:strTemp delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [errorAlert show];
                return;
            }
            
            
            if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
            {
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture!" message:@"Please check your SMS Inbox for verification code" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                
                [alert show];
                return ;
                
            }
            
        }
             failure:^(NSURLSessionDataTask *task,NSError *error)
         {
             //Hide loader
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
             [alert show];
         }];
    }
}
- (IBAction)nextBtnTapped:(id)sender {
    [self.view endEditing:YES];
    NSString *securityCodeStr = [_verificationCodeTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if([securityCodeStr length]==0){
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:@"Please enter verification code." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        
        [alert show];
        return;
    }
    
    
    //Show the loader
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSURL *URL = [NSURL URLWithString:k_BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    
    NSDictionary *dict=@{
                         @"phone":completePhoneNumber,
                         @"securityCode" :securityCodeStr
                         };
//    NSLog(@" fetch event parameters ---> %@",dict);
    
    
    
    [manager POST:@"verify" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject){
        
        //Hide loader
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"responseObject%@",responseObject);
        
        
        ///-----for key -> "errors" ---- ///
        if([[responseObject objectForKey:@"status"] isEqualToString:@"error"]){
            
            NSMutableString *strTemp=[NSMutableString string];
            
            
            if ([[responseObject objectForKey:@"message"] isKindOfClass:[NSDictionary class]]) {
                    for (NSString *key in [responseObject objectForKey:@"message"]) {
                        
                        if ([[[responseObject objectForKey:@"message"] objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                            
                            for (NSString *descStr in [[responseObject objectForKey:@"message"] objectForKey:key]) {
                                
                                [strTemp appendFormat:@"%@.\n",[[[responseObject objectForKey:@"message"] objectForKey:key] objectForKey:descStr]];
                            }
                        }
                        else if ([[[responseObject objectForKey:@"message"] objectForKey:key] isKindOfClass:[NSString class]])
                        {
                            strTemp = [[responseObject objectForKey:@"message"] objectForKey:key];
                            
                        }
                        
                        
                    }
                }
                else if ([[responseObject objectForKey:@"message"] isKindOfClass:[NSString class]])
                {
                    strTemp = [responseObject objectForKey:@"message"];
                    
                }
            UIAlertView *errorAlert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:strTemp delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [errorAlert show];
            return;
        }
        
        
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
        {
            
            
            NSUserDefaults *appDefaults=[NSUserDefaults standardUserDefaults];
            [appDefaults setValue:[[responseObject objectForKey:@"user_detail"] objectForKey:@"userName"] forKey:@"userName"];
            [appDefaults setValue:[[responseObject objectForKey:@"user_detail"] objectForKey:@"password_token"] forKey:@"password_token"];
            [appDefaults synchronize];
            
            
            UserInterestsViewController *userInterestsView = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInterestsViewController"];
            
            [self presentViewController:userInterestsView animated:YES completion:nil];
        }
       
    }
          failure:^(NSURLSessionDataTask *task,NSError *error)
     {
         //Hide loader
         [MBProgressHUD hideHUDForView:self.view animated:YES];       
         
         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
         [alert show];
     }];
    

}

- (IBAction)ResendBtnTapped:(id)sender {
     [self.view endEditing:YES];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@""
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Re-send SMS",
                                  nil];
    
    [actionSheet showInView:self.view];


}

- (IBAction)cancelBtnTapped:(id)sender {
    RegistrationViewController *registrationView = (RegistrationViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
    [self presentViewController:registrationView animated:NO completion:nil];

}
@end
